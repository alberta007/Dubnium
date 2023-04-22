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
  late Future<Product?> product;

  _ScannedProduct(this.gtin);

  @override
  void initState() {
    super.initState();
    product = GetProduct().fetchProduct(gtin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAF5E4),
      body: Column(
        children: [
          const Expanded(
            flex: 1,
            child: menuTopBar(),
          ),
          Expanded(
            flex: 8,
            child: Container(
              child: FutureBuilder<Product?>(
                future: product,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.done:
                    default:
                      final Product? product = snapshot.data;
                      if (product != null) {
                        return Center(
                          child: Text('Name: ${product.name}'),
                        );
                      } else {
                        return AlertDialog(
                          title: const Text('Unknown Barcode'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const <Widget>[
                              Text("Unforntunelty we couldn't find information about that product"),
                            ],
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      }
                  }
                }),
            ),
          ),
          const Expanded(
            flex: 1, 
            child: menuBottomBar(),)
          
          
        ],
      ),
    );
  }
}
