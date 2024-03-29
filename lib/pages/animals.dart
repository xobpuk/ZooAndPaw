import 'package:first/service/database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'dart:developer';

import '../models/animal.dart';

class Animals extends StatefulWidget {
  const Animals({super.key});

  static const routeName = '/add';

  @override
  State<Animals> createState() => _AnimalsState();
}

class _AnimalsState extends State<Animals> {
  TextEditingController nameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  onTapFunction({required BuildContext context}) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      lastDate: DateTime.now(),
      firstDate: DateTime(2024),
      initialDate: DateTime.now(),
    );
    if (pickedDate == null) return;
    birthDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Добавить животное",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 29.0,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.only(left: 20.0, top: 30.0, right: 20.0),
          child: ListView(
            children: [
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
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите имя';
                    }
                    return null;
                  },
                  controller: nameController,
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
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите тип';
                    }
                    return null;
                  },
                  controller: typeController,
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
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите рост';
                    }
                    return null;
                  },
                  controller: heightController,
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
                child: TextFormField(
                  controller: birthDateController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите дату рождения';
                    }
                    return null;
                  },
                  readOnly: true,
                  onTap: () => onTapFunction(context: context),
                ),
              ),
              const SizedBox(
                height: 18.0,
              ),
              const Text(
                "Вес",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите вес';
                    }
                    return null;
                  },
                  controller: weightController,
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 36),
                child: Center(
                  child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String id = randomAlphaNumeric(10);
                          Animal animalInfo = Animal(
                              nameController.text,
                              typeController.text,
                              birthDateController.text,
                              heightController.text,
                              id,
                              weightController.text);
                          await DatabaseMethods()
                              .addAnimal(animalInfo, id)
                              .then((value) {
                            Fluttertoast.showToast(
                                msg: "Животное успешно добавлено!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            Navigator.pushNamed(context, '/');
                          });
                        }
                      },
                      child: const Text(
                        "Добавить",
                        style: TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.bold),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
