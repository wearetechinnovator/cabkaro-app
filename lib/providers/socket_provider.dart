import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:cabkaro/utils/constants.dart' as constant;

class SocketProvider with ChangeNotifier {
  late IO.Socket _socket;
  bool _isConnected = false;

  bool get isConnected => _isConnected;
  IO.Socket get socket => _socket;

  Future<void> connect() async {
    print("socket connect run...");
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('cab-token')!;
    String role = pref.getString("role")!;

    _socket = IO.io(
      constant.socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .disableAutoConnect()
          .build(),
    );

    _socket.connect();

    _socket.onConnect((_) {
      _isConnected = true;
      notifyListeners();
      debugPrint('Connected: ${_socket.id}');

      if (role == "user") {
        _socket.emit("user-connect", "connect");
      } else if (role == "driver") {
        _socket.emit("driver-connect", "connect");
      }
    });

    _socket.onDisconnect((_) {
      _isConnected = false;
      notifyListeners();
      debugPrint('Disconnected');
    });

    _socket.onConnectError((err) {
      debugPrint('Connect Error: $err');
    });
  }

  void emit(String event, dynamic data) {
    if (_isConnected) {
      _socket.emit(event, data);
    } else {
      debugPrint('Socket not connected');
    }
  }

  void listen(String event, Function(dynamic) callback) {
    _socket.on(event, callback);
  }

  void disconnect() {
    _socket.disconnect();
  }
}
