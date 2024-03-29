import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first/service/database_api.dart';

import '../models/animal.dart';

class DatabaseMethods implements DatabaseApi {
  @override
  Future addAnimal(Animal animalInfo, String id) async {
    return await FirebaseFirestore.instance
        .collection("animals")
        .doc(id)
        .set(animalInfo.toMap());
  }

  @override
  Future<Stream<QuerySnapshot>> getAnimals() async {
    return FirebaseFirestore.instance.collection("animals").snapshots();
  }

  @override
  Future updateAnimals(String id, Animal updateInfo) async {
    return await FirebaseFirestore.instance
        .collection("animals")
        .doc(id)
        .update(updateInfo.toMap());
  }

  @override
  Future deleteAnimals(String id) async {
    return await FirebaseFirestore.instance
        .collection("animals")
        .doc(id)
        .delete();
  }
}
