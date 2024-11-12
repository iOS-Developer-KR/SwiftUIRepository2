import asyncio
import websockets
import json

clients = set()

async def handle_client(websocket):
    clients.add(websocket)
    client_address = websocket.remote_address
    print(f"[+] 새로운 연결: {client_address}")
    
    try:
        async for message in websocket:
            print(f"[{client_address}] 메시지: {message}")

            # 클라이언트에서 받은 메시지를 JSON으로 파싱
            parsed_message = json.loads(message)
            # parsed_message["sender"] = f"{client_address[0]}:{client_address[1]}"
            message_with_sender = json.dumps(parsed_message)


            # 모든 클라이언트에게 메시지 전송
            await broadcast(message_with_sender, websocket)
    except websockets.ConnectionClosed:
        print(f"[-] 연결 종료: {client_address}")
    finally:
        clients.remove(websocket)

async def broadcast(message, sender_websocket):
    for client in clients:
        if client != sender_websocket:  # 보낸 클라이언트에게는 전송하지 않음
            await client.send(message)

async def start_server():
    server = await websockets.serve(handle_client, "127.0.0.1", 9000)
    print("[*] 웹소켓 서버 시작: ws://127.0.0.1:9000")
    await server.wait_closed()

if __name__ == "__main__":
    asyncio.run(start_server())