import 'package:flutter/material.dart';
import 'package:flutterbase/overlays/settings.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Allergen {
  final String allergen;
  final String level;

  Allergen({required this.allergen, required this.level});

  factory Allergen.fromJson(Map<String, dynamic> json) {
    return Allergen(
        allergen: json['Allergen'],
        level: json['Nivakod']); // Get values for keys 'Allergen' and 'Nivakod'
  }
}

class Product {
  final List<Allergen> allergens;
  final String image;
  final String name;
  final String brand;

  Product({required this.allergens, required this.image, required this.name, required this.brand});

  factory Product.fromJson(Map<String, dynamic> json) {
    var allerrgenerList =
        json['Allergener'] as List; // Get list of all 'Allergener'
    var imageList = json['Bilder'] as List; // Get list of all images
    List<Allergen> allergenList = allerrgenerList
        .map((i) => Allergen.fromJson(i))
        .toList(); // Iterate over list and parse each element
    String image = imageList.first['Lank']; // Get the first image

    return Product(
        allergens: allergenList, image: image, name: json['Hyllkantstext'], brand: json['Varumarke']['Varumarke']);
  }
}

class GetProduct {
  Future<Product?> fetchProduct(String gtin) async {
    Product? product;
    const prependString = 'https://api.dabas.com/DABASService/V2/article/gtin/';
    const appendString = '/JSON?apikey=ad5f6a52-fe61-405e-bbb0-3cf78c60f5f6';

    var url = Uri.parse(
        prependString + gtin.toString() + appendString); // Concatenate full URL
    var response = await http.get(url); // Send request to URL and get response

    if (response.statusCode == 200) {
      // If statusCode indicates succesful response
      var json = convert.jsonDecode(response.body); // Parse to JSON
      product = Product.fromJson(json); // Parse to internal structure
    }
    return product;
  }
}
