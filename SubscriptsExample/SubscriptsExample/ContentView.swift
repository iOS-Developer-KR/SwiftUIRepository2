//
//  ContentView.swift
//  SubscriptsExample
//
//  Created by Taewon Yoon on 5/17/24.
//

import SwiftUI

struct MyTestStruct {
    let name: String
}

extension Array {
    
    func getItem(atIndex: Int) -> Element? {
        for (index, element) in self.enumerated() {
            if index == atIndex {
                return element
            }
        }
        return nil
    }
    
}

extension Array where Element == String {
    subscript(value: String) -> Element? {
        self.first(where: { $0 == value })
    }
}

struct Address {
    let street: String
    let city: City
}

struct City {
    let name: String
    let state: String
}

struct Customer {
    let name: String
    let address: Address
    
    subscript(value: String) -> String? {
        switch value {
        case "name":
            return name
        case "address":
            return "\(address.street), \(address.city.name)"
        default:
            return nil
        }
    }
    
    subscript(value: Int) -> String? {
        switch value {
        case 0:
            return name
        case 1:
            return "\(address.street), \(address.city)"
        default:
            return nil
        }
    }
}

struct ContentView: View {
    
    @State private var myArray: [String] = ["one", "two", "three"]
    @State private var selectedItem: String? = nil

    var body: some View {
        VStack {
            ForEach(myArray, id: \.self) { string in
                Text(string)
            }
            
            Text("SELECTED: \(selectedItem ?? "none")")
        }
        .onAppear {
            selectedItem = myArray[0]
            
            let customer = Customer(name: "iOS-Developer", address: Address(street: "Main Street", city: City(name: "New York", state: "New York")))
            
//            selectedItem = customer[keyPath: \.name]
//            selectedItem = customer["name"]
            selectedItem = customer[0]
        }
    }
}

#Preview {
    ContentView()
}
