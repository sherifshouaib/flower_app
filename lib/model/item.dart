class Item {
  String imgPath;
  double price;
  String location;
  String name;
  Item(
      {required this.imgPath,
      required this.name,
      required this.price,
      this.location = "Main branch"});
}

final List<Item> items = [
  Item(
      name: 'product1',
      imgPath: 'assets/images/1.webp',
      price: 12.99,
      location: "Ali shop"),
  Item(name: 'product2', imgPath: 'assets/images/2.webp', price: 12.99),
  Item(name: 'product3', imgPath: 'assets/images/3.webp', price: 12.99),
  Item(name: 'product4', imgPath: 'assets/images/4.webp', price: 12.99),
  Item(name: 'product5', imgPath: 'assets/images/5.webp', price: 12.99),
  Item(name: 'product6', imgPath: 'assets/images/6.webp', price: 12.99),
  Item(name: 'product7', imgPath: 'assets/images/7.webp', price: 12.99),
  Item(name: 'product8', imgPath: 'assets/images/8.webp', price: 12.99),
];
