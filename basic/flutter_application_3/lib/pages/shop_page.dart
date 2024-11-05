import 'package:flutter/material.dart';
import 'package:flutter_application_3/components/nav_bar.dart';
import 'package:flutter_application_3/pages/browse_page.dart';
import 'package:flutter_application_3/pages/buy_page.dart';
import 'package:flutter_application_3/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  // Determines which tab we've selected
  int _index = 0;
  // Changes the selected screen
  void changeIndex(int index) {
    // Update the selected index
    setState(() => _index = index);
  }

  // Set of pages to navigate between
  final List<Widget> _pages = [const BrowsePage(), const BuyPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavBar(
        onTabChange: (index) => changeIndex(index),
      ),
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Builder(builder: (context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu),
            );
          })),
      // Give it a drawer to open
      drawer: Drawer(
        backgroundColor: Colors.grey[900],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(
              child: Text(
                "Nike Drawer",
                style: TextStyle(color: Colors.white, fontSize: 45),
              ),
            ),
            const Divider(),
            const ListTile(
              title: Text(
                "Home",
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                Icons.home,
                color: Colors.white,
              ),
            ),
            const ListTile(
              title: Text(
                "About",
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                Icons.info,
                color: Colors.white,
              ),
            ),
            ListTile(
              title: const Text(
                "Change Theme",
                style: TextStyle(color: Colors.white),
              ),
              leading: GestureDetector(
                onTap: () => Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme(),
                child: const Icon(
                  Icons.sunny,
                  color: Colors.white,
                ),
              ),
            ),
            const Spacer(),
            const ListTile(
              title: Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                Icons.logout,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
      // Display the selected tab at the bottom of the screen
      body: _pages[_index],
    );
  }
}
