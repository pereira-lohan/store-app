import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData{
  String category;
  String id;
  String title;
  String description;
  double price;
  List images;
  List sizes;

  ProductData.fromDocument(DocumentSnapshot snapshot){
    id = snapshot.documentID;
    title = snapshot.data['title'];
    description = snapshot.data['description'];
    //Forçar ser double, somando 0.0 que aí ele recebe a casa decimal, pois o
    //Firebase salva, 10.0 como 10 (inteiro)
    price = snapshot.data['price'] + 0.0;
    images = snapshot.data['images'];
    sizes = snapshot.data['sizes'];
  }

  Map<String, dynamic> toResumedMap(){
    return {
      'title' : title,
      'description' : description,
      'price' : price
    };
  }
}