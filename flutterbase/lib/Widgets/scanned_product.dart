import 'package:flutter/material.dart';
import 'package:flutterbase/Widgets/menu_widget.dart';
import 'package:flutterbase/other/dabas_api.dart';

class ScannedProduct extends StatefulWidget {
  final String gtin;

  ScannedProduct(this.gtin);
  @override
  _ScannedProduct createState() => _ScannedProduct(gtin);
}

class _ScannedProduct extends State<ScannedProduct> with TickerProviderStateMixin {
  final String gtin;
  late Future<Product?> product;
  late AnimationController animationController;
  late Animation<double> animation;

  _ScannedProduct(this.gtin);

  bool isAllergensGood(Product? product) {
    return true;
  }

  Widget goodOrBadProduct(Product? product) {
    animationController.forward();
    if (isAllergensGood(product)) {
      return Column(
        children: [
          Expanded(
              flex: 8,
              child: ScaleTransition(
                  scale: animation,
                  child: CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 99, 221, 33),
                    radius: double.infinity,
                    child: Icon(
                      Icons.check,
                      size: 150,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ))),
          Expanded(
              flex: 2,
              child: Center(
                child: Text('This is suitable for your preferences!', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 99, 221, 33), fontWeight: FontWeight.bold)),
              )),
        ],
      );
    } else {
      return Column(
        children: [
          Expanded(
              flex: 8,
              child: ScaleTransition(
                  scale: animation,
                  child: CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 221, 34, 34),
                    radius: double.infinity,
                    child: Icon(
                      Icons.close,
                      size: 150,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ))),
          Expanded(
              flex: 2,
              child: Center(
                child: Text('This is NOT suitable for your preferences!', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 221, 34, 34), fontWeight: FontWeight.bold)),
              )),
        ],
      );
    }
  }

  @override
  void initState() {
    super.initState();
    product = GetProduct().fetchProduct(gtin);

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    animation = CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAF5E4),
      body: Column(
        children: [
          const Expanded(
            flex: 12,
            child: menuTopBar(),
          ),
          Expanded(
            flex: 76,
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
                                    child: goodOrBadProduct(product)),
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
                                                'Info about: ${product.name}',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                              ),
                                            )),
                                        Expanded(
                                          flex: 9,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 5,
                                                child: CircleAvatar(
                                                  radius: double.infinity,
                                                  foregroundImage: product.image == '' ? Image.asset('assets/images/picture-unavailable.png').image : Image.network(product.image).image,
                                                  backgroundColor: Color(0xFF87A330),
                                                ),
                                              ),
                                              Spacer(),
                                              Expanded(
                                                  flex: 6,
                                                  child: Container(
                                                      width: 250,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                'Made by: ',
                                                                textAlign: TextAlign.left,
                                                                style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                              Text(
                                                                'Allergens: ',
                                                                textAlign: TextAlign.left,
                                                                style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                product.allergens.isEmpty ? '${product.brand}' : '${product.brand}',
                                                                textAlign: TextAlign.left,
                                                                style: TextStyle(fontSize: 16),
                                                              ),
                                                              Text(
                                                                product.allergens.isEmpty ? 'none' : '${product.allergens}',
                                                                textAlign: TextAlign.left,
                                                                style: TextStyle(fontSize: 16),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ))),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
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
          const Expanded(flex: 12, child: menuBottomBar())
        ],
      ),
    );
  }
}
