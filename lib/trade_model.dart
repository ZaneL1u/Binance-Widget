class Trade {
  final double price;
  final double quantity;
  final DateTime time;

  Trade({required this.price, required this.quantity, required this.time});

  factory Trade.fromJson(Map<String, dynamic> json) {
    return Trade(
      price: double.parse(json['p']),
      quantity: double.parse(json['q']),
      time: DateTime.fromMillisecondsSinceEpoch(json['T']),
    );
  }
}
