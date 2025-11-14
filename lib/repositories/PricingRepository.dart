class PricingRepository {
  final int quantity;
  final bool isFootlong;

  PricingRepository({
    required this.quantity,
    required this.isFootlong,
  });

  double getTotalPrice() {
    final pricePerSandwich = isFootlong ? 11.0 : 7.0;
    return pricePerSandwich * quantity;
  }
}
