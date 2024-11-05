import 'package:flutter/material.dart';
import 'package:flutter_application_3/components/shoe_tile.dart';
import 'package:flutter_application_3/models/cart.dart';
import 'package:flutter_application_3/models/shoe.dart';
import 'package:provider/provider.dart';

class BrowsePage extends StatefulWidget {
  const BrowsePage({super.key});

  @override
  State<BrowsePage> createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  // Add a shoe to the users Cart
  void addShoeToCart(Shoe shoe) {
    Provider.of<Cart>(context, listen: false).addToCart(shoe);
    showDialog(
        context: context,
        builder: (context) => const AlertDialog(
              title: Text('Shoe Added to Cart'),
              content: Text('Check your Cart to See All Items'),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      // Here value represents the Cart class and that allows us to manipulate the data inside of it
      builder: (context, value, child) => Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 25),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("Search"), Icon(Icons.search)],
            ),
          ),
          const Divider(
            height: 25,
          ),
          // Message
          const Center(child: Text("Some Hot Picks, We Think You'll Like")),
          // Hot picks
          // Takes up only the space needed to display the context
          Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: value.getSaleList().length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ShoeTile(
                        shoe: value.getSaleList()[index],
                        // Give the tile the functionality to add items to the users cart
                        addShoeToCart: addShoeToCart,
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}
