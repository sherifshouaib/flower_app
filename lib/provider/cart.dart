import 'package:e_commerce_app/model/item.dart';
import 'package:flutter/material.dart';

class Cart with ChangeNotifier {
 
 List selectedProducts =[];

int price = 0;

 add(Item product){
  selectedProducts.add(product);
  price +=product.price.round();
    notifyListeners();
 }


 
}
