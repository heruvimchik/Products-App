import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  Future<void> toggleFavoriteStatus(String authToken, String userId) async {
    final oldFav = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://flash-chat-a12f4.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken';
    final response = await http.put(url,
        body: json.encode(
          isFavorite,
        ));
    if (response.statusCode >= 400) {
      isFavorite = oldFav;
      notifyListeners();
      throw HttpException('Could not delete prod');
    }
  }
}
