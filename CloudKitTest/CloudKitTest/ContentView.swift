//
//  ContentView.swift
//  CloudKitTest
//
//  Created by Taewon Yoon on 10/16/24.
//

import SwiftUI
import CloudKit

class CloudKitPushNotificationViewModel: ObservableObject {
    
    func requestNotificationPermissions() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error {
                print(error.localizedDescription)
            } else if success {
                print("Notification permissions success!")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications() // MainThread에서 실행되어야 한다
                }
            } else {
                print("Notification persmissions failure.")
            }
        }
    }
    
    func subscribeToNotifications() {
        
        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(recordType: "Fruits", predicate: predicate, subscriptionID: "data_added_to_database", options: .firesOnRecordCreation)
        
        let notification = CKSubscription.NotificationInfo()
        notification.title = "There's a new data!"
        notification.alertBody = "Open the app to check new data."
        notification.soundName = "default"
        
        subscription.notificationInfo = notification
        
        CKContainer.default().publicCloudDatabase.save(subscription) { returnedSubscription, returnedError in
            if let error = returnedError {
                print(error)
            } else {
                print("Successfully subscribed to notifications!")
            }
        }
    }
    
    func unsubscribeToNotifications() {
        
        //CKContainer.default().publicCloudDatabase.fetchAllSubscriptions
        
        CKContainer.default().publicCloudDatabase.delete(withSubscriptionID: "data_added_to_database") { returnedID, returnedError in
            if let error = returnedError {
                print(error)
            } else {
                print("Successfully unsubscribed!")
            }
        }
    }
}

struct ContentView: View {
    
//    @Environment(CloudKitUserViewModel.self) var vm
    @StateObject private var vm = CloudKitPushNotificationViewModel()
    
    var body: some View {
        VStack {
            Button ("Request notification permissions") {
                vm.requestNotificationPermissions()
            }
            
            Button ("Subscribe to notifications") {
                vm.subscribeToNotifications()
            }
            
            Button ("unSubscribe to notifications") {
                vm.subscribeToNotifications()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
        .environment(CloudKitUserViewModel())
}
