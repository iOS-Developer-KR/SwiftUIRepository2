import socket
import threading
import json

# 클라이언트 리스트를 저장할 리스트
clients = []

# 각 클라이언트로부터 메시지를 받고, 모든 클라이언트에게 메시지를 전송하는 함수
def handle_client(client_socket, addr):
    print(f"[+] 새로운 연결: {addr}")
    clients.append(client_socket)

    try:
        while True:
            message = client_socket.recv(1024)  # 클라이언트로부터 메시지 수신
            if not message:
                break
            print(f"[{addr}] 메시지: {message.decode()}")

            # 보낸 사람의 주소를 포함한 JSON 메시지 생성
            message_with_sender = json.dumps({
                "sender": f"{addr[0]}:{addr[1]}",
                "text": message.decode()
            })

            # 모든 클라이언트에게 메시지 전송
            broadcast(message_with_sender, client_socket)
    except ConnectionResetError:
        print(f"[-] 연결 종료: {addr}")
    finally:
        client_socket.close()
        clients.remove(client_socket)  # 연결이 끊어진 클라이언트 제거
        print(f"[-] 클라이언트 연결 해제: {addr}")

# 메시지를 모든 클라이언트에게 전송하는 함수
def broadcast(message, sender_socket):
    for client in clients:
        if client != sender_socket:  # 보낸 클라이언트에게는 전송하지 않음
            try:
                client.send(message.encode())  # JSON 문자열을 바이트로 인코딩하여 전송
            except:
                client.close()
                clients.remove(client)

# 서버 초기화 및 설정
def start_server():
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.bind(('', 9000))  # 포트 9000에 바인딩
    server.listen(5)  # 최대 5개의 클라이언트 대기
    print("[*] 서버 시작: 포트 9000에서 클라이언트 연결 대기 중...")

    while True:
        client_socket, addr = server.accept()  # 클라이언트 연결 수락
        print(f"[+] 연결된 클라이언트 주소: {addr}")

        # 새로운 스레드를 생성하여 클라이언트 관리
        client_thread = threading.Thread(target=handle_client, args=(client_socket, addr))
        client_thread.start()

if __name__ == "__main__":
    start_server()