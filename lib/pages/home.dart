import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first/models/animal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:first/pages/animals.dart';
import 'package:first/service/database.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/auth/authentication.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  static const routeName = '/';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController nameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  onTapFunction({required BuildContext context, required String date}) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      lastDate: DateTime.now(),
      firstDate: DateTime(2024),
      initialDate: DateFormat('yyyy-MM-dd').parse(date),
    );
    if (pickedDate == null) return;
    birthDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
  }

  Stream? animalList;

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
    Navigator.pushNamed(context, '/auth');
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Успешный выход!')));
  }

  loadAnimals() async {
    animalList = await DatabaseMethods().getAnimals();
    setState(() {});
  }

  @override
  void initState() {
    loadAnimals();
    super.initState();
  }

  Widget _signOutButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: ElevatedButton(onPressed: signOut, child: const Text('Выйти')),
    );
  }

  Widget _allAnimals() {
    return StreamBuilder(
      stream: animalList,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20.0),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Имя: ${ds['name']}",
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                GestureDetector(
                                    onTap: () {
                                      nameController.text = ds['name'];
                                      typeController.text = ds["type"];
                                      heightController.text = ds["height"];
                                      birthDateController.text =
                                          ds["birthDate"];
                                      weightController.text = ds["weight"];
                                      EditAnimal(ds["id"]);
                                    },
                                    child: const MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.orange,
                                      ),
                                    )),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                GestureDetector(
                                    onTap: () async {
                                      await DatabaseMethods()
                                          .deleteAnimals(ds["id"]);
                                      Fluttertoast.showToast(
                                          msg: "Животное успешно удалено!",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    },
                                    child: const MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ))
                              ],
                            ),
                            Text(
                              "Тип:  ${ds["type"]}",
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Рост: ${ds["height"]}",
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Дата рождения: ${ds["birthDate"]}",
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Вес: ${ds["weight"]}",
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                })
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const Text(
              'Зоопарк "Тойота Шевроле"',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 29.0,
                  fontWeight: FontWeight.bold),
            ),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    if (ModalRoute.of(context)?.settings.name != '/') {
                      Navigator.pushNamed((context), '/');
                    }
                  },
                  child: Text('Главная'),
                ),
                TextButton(
                  onPressed: () {
                    if (ModalRoute.of(context)?.settings.name != '/about') {
                      Navigator.pushNamed((context), '/about');
                    }
                  },
                  child: Text('О нас'),
                ),
                TextButton(
                  onPressed: () {
                    if (ModalRoute.of(context)?.settings.name != '/add') {
                      Navigator.pushNamed((context), '/add');
                    }
                  },
                  child: Text('Добавить животное'),
                ),
                _signOutButton()
              ],
            ))
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
        child: Column(
          children: [
            Expanded(child: _allAnimals()),
          ],
        ),
      ),
    );
  }

  Future EditAnimal(String id) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Изменить животное",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 29.0,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 20.0),
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    "Имя",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 15.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),
                  const Text(
                    "Тип",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 15.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: typeController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),
                  const Text(
                    "Рост",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 15.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: heightController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),
                  const Text(
                    "Дата рождения",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 15.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: birthDateController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: birthDateController.text.isEmpty
                              ? 'Нажмите для выбора даты'
                              : birthDateController.text),
                      onTap: () => onTapFunction(
                          context: context, date: birthDateController.text),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    "Вес",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 15.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: weightController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () async {
                            Animal animalInfo = Animal(
                                nameController.text,
                                typeController.text,
                                birthDateController.text,
                                heightController.text,
                                id,
                                weightController.text);
                            await DatabaseMethods()
                                .updateAnimals(id, animalInfo)
                                .then((value) {
                              Navigator.pop(context);
                              Fluttertoast.showToast(
                                  msg: "Животное успешно изменено!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            });
                          },
                          child: const Text("Изменить")),
                    ),
                  )
                ],
              ),
            ),
          ));
}
