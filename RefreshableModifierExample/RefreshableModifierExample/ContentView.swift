//
//  ContentView.swift
//  RefreshableModifierExample
//
//  Created by Taewon Yoon on 6/4/24.
//

import SwiftUI

final class RefreshableDataService {
    
    func getDate() async throws -> [String] {
        try? await Task.sleep(nanoseconds: 3_000_000_000)
        return ["iOS16", "iOS17", "iOS18"].shuffled()
    }
}


@MainActor
final class RefreshableModifierViewModel: ObservableObject {
    @Published private(set) var items: [String] = []
    let manager = RefreshableDataService()
    
    func loadData() async {
        do {
            items = try await manager.getDate()
        } catch {
            print(error)
        }
    }
}

struct ContentView: View {
    
    @StateObject private var viewModel = RefreshableModifierViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach(viewModel.items, id: \.self) { item in
                        Text(item)
                            .font(.headline)
                    }
                }
            }
            .refreshable {
                await viewModel.loadData()
            }
            .navigationTitle("Regreshable")
            .task {
//                print("HI")
//                await viewModel.loadData()
            }
        }
    }
}

#Preview {
    ContentView()
}
