import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/repositories/PricingRepository.dart';

void main() {
  test('Calculates correct price for six-inch sandwiches', () {
    final repo = PricingRepository(quantity: 3, isFootlong: false);
    expect(repo.getTotalPrice(), 21.0); // 3 * £7
  });

  test('Calculates correct price for footlong sandwiches', () {
    final repo = PricingRepository(quantity: 2, isFootlong: true);
    expect(repo.getTotalPrice(), 22.0); // 2 * £11
  });

  test('Returns 0.0 when quantity is zero', () {
    final repo = PricingRepository(quantity: 0, isFootlong: true);
    expect(repo.getTotalPrice(), 0.0);
  });
}
