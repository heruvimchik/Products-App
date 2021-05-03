import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'cart.dart';
import '../models/http_exception.dart';

class OrderItem {
  final String id;
  final double amont;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amont,
      @required this.products,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> getOrders() async {
    final url =
        'https://flash-chat-a12f4.firebaseio.com/orders/$userId.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data == null) return;
      final List<OrderItem> loadOrder = [];
      data.forEach((orderId, orderData) {
        loadOrder.add(OrderItem(
            id: orderId,
            amont: orderData['amont'],
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['products'] as List<dynamic>)
                .map((item) => CartItem(
                    id: item['id'],
                    price: item['price'],
                    quantity: item['quantity'],
                    title: item['title']))
                .toList()));
      });
      _orders = loadOrder.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    var date = DateTime.now();
    final url =
        'https://flash-chat-a12f4.firebaseio.com/orders/$userId.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'amont': total,
            'dateTime': date.toIso8601String(),
            'products': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'price': cp.price,
                      'quantity': cp.quantity,
                    })
                .toList(),
          },
        ),
      );
      _orders.insert(
          0,
          OrderItem(
              id: json.decode(response.body)['name'],
              amont: total,
              products: cartProducts,
              dateTime: date));
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
