import 'package:flutter/material.dart';
import 'package:flutter_application_3/pages/shop_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
          child: Column(
        children: [
          Image.asset(
            'assets/images/nikelogo.jpg',
            height: 240,
          ),
          const SizedBox(
            height: 48,
          ),
          const Text("Just Do It... Or Something Like That"),
          const SizedBox(
            height: 48,
          ),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black), // Set background color here
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ShopPage()),
              ),
              child: const Text(
                'Wast Money Now',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      )),
    );
  }
}
