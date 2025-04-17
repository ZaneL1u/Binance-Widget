import 'package:web_socket_channel/web_socket_channel.dart';

class BinanceService {
  static const _wsUrl = 'wss://stream.binance.com:9443/ws/btcusdt@trade';

  WebSocketChannel connect() {
    return WebSocketChannel.connect(Uri.parse(_wsUrl));
  }
}
