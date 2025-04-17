import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'binance_service.dart';
import 'trade_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Binance Ticker',
      theme: ThemeData.dark(),
      home: const TradeWidget(),
    );
  }
}

class TradeWidget extends StatefulWidget {
  const TradeWidget({super.key});

  @override
  _TradeWidgetState createState() => _TradeWidgetState();
}

class _TradeWidgetState extends State<TradeWidget> {
  late final WebSocketChannel _channel;

  @override
  void initState() {
    super.initState();
    _channel = BinanceService().connect();
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[850],
        ),
        child: StreamBuilder(
          stream: _channel.stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error!);
            }

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            try {
              final trade = Trade.fromJson(json.decode(snapshot.data));
              return _buildTradeWidget(trade);
            } catch (e) {
              return _buildErrorWidget(e);
            }
          },
        ),
      ),
    );
  }

  Widget _buildTradeWidget(Trade trade) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('BTC/USDT', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          '\$${_formatNumber(trade.price)}',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Quantity: ${_formatNumber(trade.quantity)}'),
            Text('Time: ${_formatTime(trade.time)}'),
          ],
        ),
      ],
    );
  }

  Widget _buildErrorWidget(dynamic error) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.error, color: Colors.red),
        const SizedBox(height: 8),
        Text(
          'Error: ${error.toString()}',
          style: const TextStyle(color: Colors.red),
        ),
      ],
    );
  }

  String _formatNumber(double num) {
    return NumberFormat("#,##0.00", "en_US").format(num);
  }

  String _formatTime(DateTime time) {
    return DateFormat('HH:mm:ss').format(time);
  }
}
