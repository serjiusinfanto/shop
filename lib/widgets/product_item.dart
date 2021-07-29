import 'package:flutter/material.dart';
import '../providers/auth.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context);
    final authData = Provider.of<Auth>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          ProductDetailScreen.routeName,
          arguments: product.id,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder:
                  AssetImage('lib/assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            leading: Consumer<Product>(
              builder: (ctx, product, _) => IconButton(
                icon: Icon(
                  product.isFavourite ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () => product.toggleFavoriteStatus(
                    context, authData.token, authData.userId),
              ),
            ),
            backgroundColor: Colors.black87,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.add_shopping_cart,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
                final snackBar = SnackBar(
                  content: Text(
                    "Added item to cart!",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: "UNDO",
                    textColor: Theme.of(context).accentColor,
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                );

                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ),
        ),
      ),
    );
  }
}
