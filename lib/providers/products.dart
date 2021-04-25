import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/http_exception.dart';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  String authToken;
  String userId;

  Products( this._items, this.userId);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favProducts {
    return _items.where((product) => product.isFavorite == true).toList();
  }

  Product findById(String productId) {
    return _items.firstWhere((product) => product.id == productId);
  }

  Future<void> addItem(Product product) async {
    final url =
        'https://flutter-shop-app-8951b.firebaseio.com/products'
        '.json?auth=$authToken';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageurl': product.imageUrl,
            'creatorId': userId,
          }));

      final newProduct = Product(
          title: product.title,
          description: product.description,
          id: json.decode(response.body)['name'],
          imageUrl: product.imageUrl,
          price: product.price);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchProducts([bool filterByUser = false]) async {
    try {
      final List<Product> loadedProducts = [];
      int i=0;
      print('***************  ZZZZZZZZZZZZZZZZ  ACCES FB  ***************');
      FirebaseFirestore.instance
          .collection('products')
          .get()
          .then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
      Product p=new Product(
            id: doc["id"],
            title: doc["title"],
            description: doc["description"],
            price: doc["price"],
            imageUrl: doc["imageUrl"],
            isFavorite : doc["isFavorite"]
        );
      print(' element : $i');
      loadedProducts[i++]=p;
      print(' longueur ::::: $loadedProducts.length');

      })
      });


print(' FB FIN TTTTTTTTTTTTTTTTTTTTT $loadedProducts.length');
      _items = loadedProducts;
      notifyListeners();


    } catch (error) {
      print(error);
    }
  }


  Future<void> ttfetchProducts([bool filterByUser = false]) async {
try{
    final response = await FirebaseFirestore.instance
        .collection("products")
        .get();

    final allData = response.docs.map((doc) => doc.data()).toList();

  //    final extractedData = json.decode(response) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
 //     if (extractedData == null) {
  //      return;
    //  }
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateItem(String id, Product product) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == product.id);
    if (prodIndex >= 0) {
      final url =
          'https://flutter-shop-app-8951b.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageurl': product.imageUrl,
          }));
      _items[prodIndex] = product;
    }

    notifyListeners();
  }

  Future<void> deleteItem(String id) async {
    final url =
        'https://flutter-shop-app-8951b.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex =
        _items.indexWhere((product) => product.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(
      url,
    );

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete Product.');
    }
    existingProduct = null;
  }
}


