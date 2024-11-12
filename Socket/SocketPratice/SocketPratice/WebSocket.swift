//
//  WebSocket.swift
//  SocketPratice
//
//  Created by Taewon Yoon on 11/12/24.
//

import Foundation

struct ChatModel: Codable, Identifiable {
    var id: UUID = UUID()
    var sender: String
    var text: String
}

@Observable
class WebSocket {
    
    var webSocket: URLSessionWebSocketTask!
    var chats: [ChatModel] = []
    var id: String = ""
    private var timer: Timer?
    
    func connect() {
        let url = URL(string: "ws://127.0.0.1:9000")!
        let session = URLSession(configuration: .default)
        let webSocketTask = session.webSocketTask(with: url)
        self.webSocket = webSocketTask
        webSocket.resume()
        startPing()
        receiveMessage()
    }
    
    func sendMessage(_ message: String) {
        let chatModel = ChatModel(sender: id, text: message)
        chats.append(chatModel)
        guard let jsonData = try? JSONEncoder().encode(chatModel) else {
            return
        }
        
        let msg = String(data: jsonData, encoding: .utf8)!
        print("메시지 전송했는데" + message)
        let message = URLSessionWebSocketTask.Message.string(msg)
        webSocket.send(message) { error in
            if let error = error {
                print("Error sending message: \(error)")
            } else {
                print("Message sent")
            }
        }
    }
    
    func receiveMessage() {
        DispatchQueue.main.async {
            self.webSocket.receive {result in
                switch result {
                case .failure(let error):
                    print("Error receiving message: \(error)")
                case .success(let message):
                    switch message {
                    case .string(let text):
                        print("Received text: \(text)")
                        if let data = text.data(using: .utf8) {
                            let decoder = JSONDecoder()
                            if let chat = try? decoder.decode(ChatModel.self, from: data) {
                                self.chats.append(chat)
                            }
                        }
                    case .data(let data):
                        print("Received Data: \(data)")
                        
                    @unknown default:
                        break
                    }
                }
                self.receiveMessage()
            }
        }
    }
    
    private func startPing() {
      self.timer?.invalidate()
      self.timer = Timer.scheduledTimer(
        withTimeInterval: 10,
        repeats: true,
        block: { [weak self] _ in self?.ping() }
      )
    }

    private func ping() {
        webSocket?.sendPing { [weak self](error) in
            if let error = error {
                print("Ping failed: \(error)")
            }
            self?.startPing()
        }
    }
}
