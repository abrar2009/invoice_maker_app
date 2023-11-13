class InvoiceDetail {
  final String name;
  final double price;
  final String type;
  double rate;
  int quantity;
  double discount;

  InvoiceDetail({
    required this.name,
    required this.price,
    required this.type,
    this.rate = 0.0,
    this.quantity = 1,
    this.discount = 0.0,
  });
}