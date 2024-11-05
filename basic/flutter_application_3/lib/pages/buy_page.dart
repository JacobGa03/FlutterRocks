import 'package:flutter/material.dart';
import 'package:flutter_application_3/components/cart_item.dart';
import 'package:flutter_application_3/models/cart.dart';
import 'package:flutter_application_3/models/shoe.dart';
import 'package:provider/provider.dart';

class BuyPage extends StatefulWidget {
  const BuyPage({super.key});

  @override
  State<BuyPage> createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  // Allow the user to delete a shoe from their cart
  void deleteItemFromCart(Shoe shoe) {
    // Grab the provider (the Cart class) and use it's functionality
    Provider.of<Cart>(context, listen: false).removeFromCart(shoe);
    // Let the user know they've removed it from their cart
    showDialog(
        context: context,
        builder: (context) => const AlertDialog(
              title: Text('Shoe Removed to Cart'),
              content: Text('Feel Free to Add it Back Any Time'),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, value, child) => Column(
        children: [
          const Text('Your Cart'),
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: value.getUserCart().length,
            itemBuilder: (BuildContext context, int index) {
              // Pass the item we are looking at
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CartItem(
                  shoe: value.getUserCart()[index],
                  deleteItem: deleteItemFromCart,
                ),
              );
            },
          ))
        ],
      ),
    );
  }
}
