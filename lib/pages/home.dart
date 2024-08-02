import 'package:e_commerce_app/model/item.dart';
import 'package:e_commerce_app/pages/checkout.dart';
import 'package:e_commerce_app/pages/details_screen.dart';
import 'package:e_commerce_app/pages/profile_page.dart';
import 'package:e_commerce_app/provider/cart.dart';
import 'package:e_commerce_app/widgets/appbar.dart';
import 'package:e_commerce_app/widgets/colors.dart';
import 'package:e_commerce_app/widgets/user_image_from_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final carttt = Provider.of<Cart>(context);
    final userrr = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 22),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 33),
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Details(product: items[index]),
                  ),
                );
              },
              child: GridTile(
                child: Stack(
                  children: [
                    Positioned(
                      top: -3,
                      bottom: -9,
                      right: 0,
                      left: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(55),
                        child: Image.asset(items[index].imgPath),
                      ),
                    ),
                  ],
                ),
                footer: GridTileBar(
                  backgroundColor: Color.fromARGB(66, 73, 127, 110),
                  trailing: IconButton(
                      color: Color.fromARGB(255, 62, 94, 70),
                      onPressed: () {
                        carttt.add(items[index]);
                      },
                      icon: Icon(Icons.add)),
                  leading: Text("\$12.99"),
                  title: Text(
                    "",
                  ),
                ),
              ),
            );
          },
        ),
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      
                        image: AssetImage("assets/images/test.jpg"),
                        fit: BoxFit.cover),
                  ),
                  currentAccountPicture: ImgUser(),

                  accountName: Text('Sherif Shouaib',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                      )),
                  accountEmail: Text(userrr.email!),
                ),
                ListTile(
                    title: Text("Home"),
                    leading: Icon(Icons.home),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(),
                        ),
                      );
                    }),
                ListTile(
                    title: Text("My products"),
                    leading: Icon(Icons.add_shopping_cart),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Checkout(),
                        ),
                      );
                    }),
                ListTile(
                    title: Text("About"),
                    leading: Icon(Icons.help_center),
                    onTap: () {}),
                ListTile(
                    title: Text("Profile Page"),
                    leading: Icon(Icons.person),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage()));
                    }),
                ListTile(
                    title: Text("Logout"),
                    leading: Icon(Icons.exit_to_app),
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                    }),
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 12),
              child: Text("Developed by Ali Hassan © 2024",
                  style: TextStyle(fontSize: 16)),
            )
          ],
        ),
      ),
      appBar: AppBar(
        actions: [
          ProductsAndPrice(),
        ],
        backgroundColor: appbarGreen,
        title: Text('Home'),
      ),
    );
  }
}
