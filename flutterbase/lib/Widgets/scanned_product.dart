import 'package:flutter/material.dart';
import 'package:flutterbase/Widgets/menu_widget.dart';
import 'package:flutterbase/other/dabas_api.dart';

class ScannedProduct extends StatefulWidget {
  final String gtin;

  ScannedProduct(this.gtin);
  @override
  _ScannedProduct createState() => _ScannedProduct(gtin);
}

class _ScannedProduct extends State<ScannedProduct> {
  final String gtin;

  _ScannedProduct(this.gtin);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAF5E4),
      body: Stack(
        children: [
          FutureBuilder<Product?>(
              future: GetProduct().fetchProduct(gtin),
              builder:
                  (BuildContext context, AsyncSnapshot<Product?> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  final Product? product = snapshot.data;
                  return Center(
                    child: Text('$product.name'),
                  );
                }
              }),
          const menuBar(),
        ],
      ),
    );
  }
}
