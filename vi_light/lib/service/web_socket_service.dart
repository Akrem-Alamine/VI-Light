import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final String url;
  WebSocketChannel? _channel;
  StreamController<String> _messageController = StreamController<String>.broadcast();

  WebSocketService(this.url) {
    _connect();
  }

  void _connect() {
    _channel = WebSocketChannel.connect(Uri.parse(url));
    
    _channel!.stream.listen(
      (response) {
        _messageController.add(response); // Forward the response to the stream
      },
      onError: (error) {
        _messageController.addError(error);
      },
      onDone: () {
        _messageController.close(); // Close the stream when done
      },
      cancelOnError: true,
    );
  }

  Future<String> sendMessage(String message) async {
    Completer<String> completer = Completer<String>();
    
    _messageController.stream.listen((response) {
      if (!completer.isCompleted) {
        completer.complete(response);
      }
    }, onError: (error) {
      if (!completer.isCompleted) {
        completer.completeError(error);
      }
    });
    
    _channel!.sink.add(message);
    return completer.future;
  }

  Stream<String> get messages => _messageController.stream;

  void dispose() {
    _channel?.sink.close();
    _messageController.close();
  }
}
