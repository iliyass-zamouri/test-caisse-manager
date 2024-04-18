// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  final int? id;
  final String? productName;
  final double? price;
  int? qte;

  Product({
    this.id,
    this.productName,
    this.price,
    this.qte,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        productName: json["product_name"],
        price: json["price"]?.toDouble(),
        qte: json["qte"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_name": productName,
        "price": price,
        "qte": qte,
      };
}
