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

  bool isAllergensGood(Product? product) {
    return true;
  }

  Widget goodOrBadProduct(Product? product) {
    if (isAllergensGood(product)) {
      return Column(
        children: const [
          Expanded(
              flex: 8,
              child: CircleAvatar(
                backgroundColor: Color.fromARGB(255, 99, 221, 33),
                radius: double.infinity,
                child: Icon(
                  Icons.check,
                  size: 150,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              )
            ),
          Expanded(
              flex: 2,
              child: Center(
                child: Text('This is suitable for your preferences!'),
              )),
        ],
      );
    } else {
      return Column(
        children: const [
          Expanded(
              flex: 8,
              child: CircleAvatar(
                backgroundColor: Color.fromARGB(255, 221, 34, 34),
                radius: double.infinity,
                child: Icon(
                  Icons.close,
                  size: 150,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              )),
          Expanded(
              flex: 2,
              child: Center(
                child: Text('This is NOT suitable for your preferences!'),
              )),
        ],
      );
    }
  }

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
                          return Column(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Container(
                                  width: 300,
                                  padding: const EdgeInsets.all(20),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        width: 3.0,
                                        color: Color(0xFF87A330),
                                      ),
                                    ),
                                  ),
                                  child: goodOrBadProduct(product)
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Text(
                                            'Info about ${product.name}',
                                          ),
                                        )
                                      ),
                                      Expanded(
                                        flex: 9,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 5,
                                              child: CircleAvatar(
                                                radius: double.infinity,
                                                foregroundImage: Image.network(product.image).image,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 5,
                                              child: Text(
                                                '' // TODO: Information text
                                              )
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ),
                              )
                            ],
                          );
                        } else {
                          return AlertDialog(
                            title: const Text('Unknown Barcode'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget>[
                                Text(
                                    "Unforntunelty we couldn't find information about that product"),
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
          const Expanded(flex: 1, child: menuBottomBar())
        ],
      ),
    );
  }
}
