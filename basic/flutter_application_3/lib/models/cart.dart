// Handles business logic for the cart
import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/shoe.dart';

class Cart extends ChangeNotifier {
  // List of shoes for sale
  List<Shoe> shoeShop = [
    Shoe(
        name: 'Black and Blue Shoe',
        price: "150.00",
        desc: "A shoe that is black and blue",
        imgPath: 'assets/images/blackblueshoe.jpg'),
    Shoe(
        name: 'Blue Shoe',
        price: "110.00",
        desc: "A shoe that is blue",
        imgPath: 'assets/images/blueshoe.jpg'),
    Shoe(
        name: 'Light Blue Shoe',
        price: "110.00",
        desc: "A shoe that is light blue",
        imgPath: 'assets/images/lightblueshoe.jpg'),
    Shoe(
        name: 'The Orlando Magic',
        price: "110.00",
        desc: "Literally just the Orlando Magic",
        imgPath: 'assets/images/magic.jpg'),
  ];
  // Initially empty at the beginning
  List<Shoe> userCart = [];

  // Get the shoes that are on sale
  List<Shoe> getSaleList() => shoeShop;
  // Get the items that are in the user's cart
  List<Shoe> getUserCart() => userCart;

  // Add to the users cart
  void addToCart(Shoe shoe) {
    userCart.add(shoe);
    notifyListeners();
  }

  // Remove from the users cart
  void removeFromCart(Shoe shoe) {
    userCart.remove(shoe);
    notifyListeners();
  }
}
