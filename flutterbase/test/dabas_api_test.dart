import 'package:flutterbase/other/dabas_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test if contains nuts', () async {
    String gtin = '07317731505302'; // Product: nuts

    Product? product = await GetProduct().fetchProduct(gtin);

    expect(product!.allergens.isEmpty, false);
    expect(product.allergens.first.allergen, 'Nötter');
    expect(product.allergens.first.level, 'CONTAINS');
  });

  test('Test if contains nothing', () async {
    String gtin = '07350102401421'; // Product: Water

    Product? product = await GetProduct().fetchProduct(gtin);

    expect(product!.allergens.isEmpty, true);
  });
}
