import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/shoe.dart';

class ShoeTile extends StatelessWidget {
  void Function(Shoe) addShoeToCart;
  Shoe shoe;
  ShoeTile({super.key, required this.shoe, required this.addShoeToCart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.grey),
      width: 350,
      child: Center(
        child: Column(
          children: [
            ClipRect(child: Image.asset(shoe.imgPath)),
            Text(shoe.name),
            Text(shoe.desc),
            const Spacer(),
            Row(
              children: [
                Text('\$${shoe.price}'),
                const Spacer(),
                GestureDetector(
                  // Add the shoe to the cart
                  onTap: () => addShoeToCart(shoe),
                  child: const Icon(Icons.add),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
