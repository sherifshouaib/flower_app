

class Item{
  String imgPath;
  double price;
String location;
  Item({required this.imgPath,required this.price, this.location = "Main branch"});

}



final List<Item> items =[

Item(imgPath: 'assets/images/1.webp', price: 12.99,location: "Ali shop"),
Item(imgPath: 'assets/images/2.webp', price: 12.99),
Item(imgPath:'assets/images/3.webp' , price: 12.99),
Item(imgPath:'assets/images/4.webp' , price: 12.99),
Item(imgPath: 'assets/images/5.webp', price: 12.99),
Item(imgPath:'assets/images/6.webp' , price: 12.99),
Item(imgPath: 'assets/images/7.webp', price: 12.99),
Item(imgPath: 'assets/images/8.webp', price: 12.99),

];