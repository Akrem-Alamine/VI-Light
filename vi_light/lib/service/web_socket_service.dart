// lib/web_socket_service.dart
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final String url;
  late WebSocketChannel channel;

  WebSocketService(this.url) {
    channel = WebSocketChannel.connect(Uri.parse(url));
  }

  void send(String message) {
    channel.sink.add(message);
  }

  Stream get stream => channel.stream;

  void close() {
    channel.sink.close();
  }
}
