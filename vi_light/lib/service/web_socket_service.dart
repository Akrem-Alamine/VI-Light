import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final String url;
  WebSocketChannel? _channel;
  StreamController<String> _messageController = StreamController<String>.broadcast();
  StreamController<String> _errorController = StreamController<String>.broadcast();

  WebSocketService(this.url) {
    _connect();
  }

  void _connect() {
    _channel = WebSocketChannel.connect(Uri.parse(url));

    _channel!.stream.listen(
      (response) {
        _messageController.add(response); // Forward the response to the message stream
        // Check if the response contains an error
        if (response.startsWith("Error:")) {
          _errorController.add(response); // Forward the error to the error stream
        }
      },
      onError: (error) {
        _errorController.add("Error: $error"); // Send error messages to error stream
      },
      onDone: () {
        _messageController.close(); // Close the message stream when done
        _errorController.close(); // Close the error stream when done
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
  Stream<String> get errorMessages => _errorController.stream; // Expose error messages stream

  void dispose() {
    _channel?.sink.close();
    _messageController.close();
    _errorController.close(); // Close the error stream
  }
}
