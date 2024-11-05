import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/shoe.dart';

class CartItem extends StatelessWidget {
  // The shoe to display
  Shoe shoe;
  void Function(Shoe) deleteItem;
  CartItem({super.key, required this.shoe, required this.deleteItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.grey),
      width: double.infinity,
      height: 150,
      child: Center(
        child: Row(
          children: [
            ClipRect(child: Image.asset(shoe.imgPath)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(shoe.name),
                  Text(shoe.desc),
                ],
              ),
            ),
            const Spacer(),
            GestureDetector(
                onTap: () => deleteItem(shoe), child: const Icon(Icons.delete))
          ],
        ),
      ),
    );
  }
}
