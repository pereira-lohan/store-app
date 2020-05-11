import 'package:applojavirtual/datas/product_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartProduct{
  String cId;
  String category;
  String idProduct;
  int quantity;
  String size;

  ProductData productData;

  CartProduct();

  CartProduct.fromDocument(DocumentSnapshot doc){
    cId = doc.documentID;
    category = doc.data['category'];
    idProduct = doc.data['idProduct'];
    quantity = doc.data['quantity'];
    size = doc.data['size'];
  }

  Map<String, dynamic> toMap(){
    return {
      'category' : category,
      'idProduct' : idProduct,
      'quantity' : quantity,
      'size' : size,
      'product' : productData.toResumedMap()
    };
  }

  String toString(){
    return 'idProduct: $idProduct, category: $category, '
        'quantity: ${quantity.toString()}, size: $size, ';
  }
}