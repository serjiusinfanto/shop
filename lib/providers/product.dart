import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false,
  });
  void _setFavStatus(bool newValue) {
    isFavourite = newValue;
    notifyListeners();
  }

  Future<void> _showAlertBox(BuildContext context) async {
    await showDialog<Null>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("An error occurred!"),
        content: Text("Something went wrong!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Okay"),
          ),
        ],
      ),
    );
  }

  Future<void> toggleFavoriteStatus(
      BuildContext context, String token, String userId) async {
    final oldStatus = isFavourite;
    var _params = {
      'auth': token,
    };
    final url = Uri.https(
        'shop-app-4731d-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/userFavourites/$userId/$id.json',
        _params);
    isFavourite = !isFavourite;
    notifyListeners();
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavourite,
        ),
      );
      if (response.statusCode >= 400) {
        _showAlertBox(context);
        _setFavStatus(oldStatus);
      }
    } catch (error) {
      _showAlertBox(context);
      _setFavStatus(oldStatus);
    }
  }
}
