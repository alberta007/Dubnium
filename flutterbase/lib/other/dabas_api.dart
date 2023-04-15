import 'package:flutter/material.dart';
import 'package:flutterbase/overlays/settings.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Allergen {
  final String allergen;
  final String level;

  Allergen({required this.allergen, required this.level});

  factory Allergen.fromJson(Map<String, dynamic> json) {
    return Allergen(allergen: json['Allergen'], level: json['Nivakod']);
  }
}

class Product {
  final List<Allergen> allergens;

  Product({required this.allergens});

  factory Product.fromJson(Map<String, dynamic> json) {
    var list = json['Allergener'] as List;
    List<Allergen> allergenList =
        list.map((i) => Allergen.fromJson(i)).toList();

    return Product(allergens: allergenList);
  }
}

class GetProduct {
  Future<Product?> fetchProduct(String gtin) async {
    Product? product;
    const prependString = 'https://api.dabas.com/DABASService/V2/article/gtin/';
    const appendString = '/JSON?apikey=ad5f6a52-fe61-405e-bbb0-3cf78c60f5f6';

    var url = Uri.parse(prependString + gtin.toString() + appendString);
    var response = await http.get(url);
    
    if (response.statusCode == 200) {
      var json = convert.jsonDecode(response.body);
      product = Product.fromJson(json);
    }
    return product;
  }
}
