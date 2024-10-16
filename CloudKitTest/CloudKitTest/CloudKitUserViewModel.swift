//
//  CloudKitUserViewModel.swift
//  CloudKitTest
//
//  Created by Taewon Yoon on 10/17/24.
//

import SwiftUI
import CloudKit

@Observable
class CloudKitUserViewModel {
    
    var permissionStatus = false
    var isSignedInToiCloud: Bool = false
    var error: String = ""
    var userName: String = ""
    
    init() {
        requestPermission()
        getiCloudStatus()
        fetchiCloudUserRecordID()
    }
    
    private func getiCloudStatus() {
        CKContainer.default().accountStatus { [weak self] returnedStatus, error in
            DispatchQueue.main.async {
                switch returnedStatus {
                case .couldNotDetermine:
                    self?.error = CloudKitError.iCloudAccountNotDetermined.localizedDescription
                    break
                case .available:
                    self?.isSignedInToiCloud = true
                    break
                case .restricted:
                    self?.error = CloudKitError.iCloudAccountRestricted.localizedDescription
                    break
                case .noAccount:
                    self?.error = CloudKitError.iCloudAccoundNotFound.localizedDescription
                    break
                case .temporarilyUnavailable:
                    self?.error = CloudKitError.iCloudAccountTemporarilyUnavailable.localizedDescription
                    break
                default:
                    break
                }
            }
        }
    }
    
    enum CloudKitError: String, LocalizedError {
        case iCloudAccoundNotFound
        case iCloudAccountNotDetermined
        case iCloudAccountRestricted
        case iCloudAccountUnknown
        case iCloudAccountTemporarilyUnavailable
    }
    
    func fetchiCloudUserRecordID() {
        CKContainer.default().fetchUserRecordID { [weak self] returnedUserID, returnedError in
            if let id = returnedUserID {
                self?.discoveriClouduser(id: id)
            }
        }
    }
    
    func discoveriClouduser(id: CKRecord.ID) {
        CKContainer.default().discoverUserIdentity(withUserRecordID: id) { [weak self] returnedIdentity, returedError in
            DispatchQueue.main.async {
                if let name = returnedIdentity?.nameComponents?.givenName {
                    self?.userName = name
                }
            }
        }
    }

    
    func requestPermission() {
        CKContainer.default().requestApplicationPermission([.userDiscoverability]) { [weak self] returnedStatus, returnedError in
            DispatchQueue.main.async {
                if returnedStatus == .granted {
                    self?.permissionStatus = true
                }
            }
        }
    }
}
