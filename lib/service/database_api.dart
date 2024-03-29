import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first/models/animal.dart';

abstract interface class DatabaseApi {
  Future<Stream<QuerySnapshot>> getAnimals();

  Future addAnimal(Animal animalInfo, String id);

  Future updateAnimals(String id, Animal updateInfo);

  Future deleteAnimals(String id);
}
