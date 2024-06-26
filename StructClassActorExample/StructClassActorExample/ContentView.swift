//
//  ContentView.swift
//  StructClassActorExample
//
//  Created by Taewon Yoon on 5/17/24.
//

import SwiftUI



struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .onAppear {
            runTest()
        }
    }
}

<<<<<<< HEAD
#Preview {
    ContentView()
}
=======
//#Preview {
//    ContentView()
//}
>>>>>>> dd7221b (updated)

extension ContentView {
    
    private func runTest() {
        print("Test started!")
//        structTest1()
//        printDivider()
//        classTest1()
//        structTest2()
        classTest2()
<<<<<<< HEAD
=======
        printDivider()
        actorTest1()
>>>>>>> dd7221b (updated)
    }
    
    private func printDivider() {
        print("""
        
        - - - - - - - - - - - - - - - - -
        
        """)
    }
    
    private func structTest1() {
        let objectA = MyStruct(title: "Starting title")
        print("ObjectA: ", objectA.title)
        
        print("Pass the values of objectA to objectB")
        var objectB = objectA
        print("ObjectB: ", objectB.title)
        
        objectB.title = "Second title"
        print("ObjectB title changed.")
        
        print("ObjectA: ", objectA.title)
        print("ObjectB: ", objectB.title)
    }
    
    private func classTest1() {
        let objectA = MyClass(title: "Starting title!")
        print("ObjectA: ", objectA.title)
        
        let objectB = objectA
        print("ObjectB: ", objectA.title)
        
        objectB.title = "Second title"
        print("ObjectB title changed.")
        
        print("ObjectA: ", objectA.title)
        print("ObjectB: ", objectB.title)
    }
<<<<<<< HEAD
=======
    
    private func actorTest1() {
        Task {
            let objectA = MyActor(title: "Starting title!")
            await print("ObjectA: ", objectA.title)
            
            let objectB = objectA
            await print("ObjectB: ", objectA.title)
            
            await objectB.updateTitle(newTitle: "Second title")
            print("ObjectB title changed.")
            
            await print("ObjectA: ", objectA.title)
            await print("ObjectB: ", objectB.title)
        }
    }
>>>>>>> dd7221b (updated)
}

struct MyStruct {
    var title: String
}


// Imutable struct
struct CustomStruct {
    let title: String
    
    func updateTitle(newTitle: String) -> CustomStruct {
        CustomStruct(title: newTitle)
    }
}

struct MutatingStruct {
    private(set) var title: String
    
    init(title: String) {
        self.title = title
    }
    
    mutating func updateTitle(newTitle: String) {
        title = newTitle
    }
}

extension ContentView {
    
    private func structTest2() {
        print("structTest2")
        // 왜 var로 만들어야하는가?
        var struct1 = MyStruct(title: "Title1")
        print("Struct1: ", struct1.title)
        struct1.title = "Title2"
        print("Struct1: ", struct1.title)
        
        var struct2 = CustomStruct(title: "Title1")
        print("Struct2: ", struct2.title)
        struct2 = CustomStruct(title: "Title2")
        print("Struct2: ", struct2.title)
        
        var struct3 = struct2.updateTitle(newTitle: "Title1")
        print("struct3: ", struct3.title)
        struct3 = struct3.updateTitle(newTitle: "Title2")
        
        var struct4 = MutatingStruct(title: "Title1")
        print("Struct4: ", struct4.title)
        struct4.updateTitle(newTitle: "Title2")
        print("Struct4: ", struct4.title)
    }
}


class MyClass {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(newTitle: String) {
        title = newTitle
    }
}

<<<<<<< HEAD
=======
actor MyActor {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(newTitle: String) {
        title = newTitle
    }
}

>>>>>>> dd7221b (updated)
extension ContentView {
    
    private func classTest2() {
        print("classTest2")
        
        let class1 = MyClass(title: "Title1")
        print("Class1: ", class1.title)
        class1.title = "Title2"
        print("Class1: ", class1.title)
        
        let class2 = MyClass(title: "Title1")
        print("Class2: ", class2.title)
        class2.title = "Title2"
        print("Class2: ", class2.title)
    }
}
<<<<<<< HEAD
=======

class StructClassActorViewModel: ObservableObject {
    
    @Published var title: String = ""
    
    init() {
        print("ViewModel INIT")
    }
}

struct StructClassActor: View {
    
    @StateObject private var viewModel = StructClassActorViewModel()
    @State var isActive: Bool = false
    
    init(isActive: Bool) {
        self.isActive = isActive
        print("View INIT")
    }
    
    var body: some View {
        Text("Hello World!")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .background()
            .background(isActive ? Color.red : Color.blue)
            .onTapGesture {
                isActive.toggle()
                print("Tapped")
            }
    }
}

#Preview {
    StructClassActor(isActive: false)
}
>>>>>>> dd7221b (updated)
