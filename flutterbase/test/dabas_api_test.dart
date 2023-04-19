import 'package:flutterbase/other/dabas_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test if contains nuts', () async {
    String gtin = '07317731505302'; // Product: nuts

    Product? product = await GetProduct().fetchProduct(gtin);

    expect(product!.allergens.isEmpty, false); // List is not empty
    expect(
        product.allergens.first.allergen, 'Nötter'); // List contains 'Nötter'
    expect(
        product.allergens.first.level, 'CONTAINS'); // List contains 'CONTAINS'
    expect(product.image,
        'https://dabas.blob.core.windows.net/media/salta-kvarn/5053hasselntter200g07317731505302.png'); // image exists
    expect(product.name, 'Hasselnötter KRAV');
    expect(product.brand, 'SALTÅ KVARN');
  });

  test('Test if contains nothing', () async {
    String gtin = '07350102401421'; // Product: Water

    Product? product = await GetProduct().fetchProduct(gtin);

    expect(product!.allergens.isEmpty, true); // List is empty
  });
}
