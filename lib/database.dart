import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scan_hsmpk/model/modelnotify.dart';

class DataRepository {
  // 1
  final CollectionReference collection = Firestore.instance.collection('products');

  // 2
  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  // 3
  Future<DocumentReference> addProduct(ModelNotify product) async{
    return collection.add(product.toJson());
  }

  // 4
  updateProduct(ModelNotify product) async {
    await collection.document(product.sDocumentReference.documentID).updateData(product.toJson());
  }

}
