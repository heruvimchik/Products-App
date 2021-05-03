import 'package:flutter/material.dart';
import 'package:products_app/providers/cart.dart';
import 'package:provider/provider.dart';

import '../widgets/drawer.dart';
import '../screens/cart_screen.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/products.dart';

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/product-overview';

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavorites = false;
  @override
  void initState() {
    //Future.delayed(Duration.zero).then((_) async {
    //_isLoading = true;
    //Provider.of<Products>(context, listen: false).getProducts().then((_) {
    //  setState(() {
    //    _isLoading = false;
    //  });
    //});
    //});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selected) {
              setState(() {
                if (selected == FilterOptions.Favorites)
                  _showFavorites = true;
                else
                  _showFavorites = false;
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
            icon: Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            builder: (_, card, ch) =>
                Badge(child: ch, value: card.itemCount.toString()),
            child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.pushNamed(context, CartScreen.routeName);
                }),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        builder: (ctx, data) {
          if (data.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (data.error != null) {
              return Center(child: Text('An error'));
            } else {
              return ProductsGrid(_showFavorites);
            }
          }
        },
        future: Provider.of<Products>(context, listen: false).getProducts(),
      ),
    );
  }
}
