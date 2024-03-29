class Animal {
  String name = '';
  String type = '';
  String birthDate = '';
  String height = '';
  String weight = '';
  String? id;

  Animal(
      this.name, this.type, this.birthDate, this.height, this.id, this.weight);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'birthDate': birthDate,
      'height': height,
      'weight': weight,
      'id': id
    };
  }

  @override
  String toString() {
    return "$name, $type, $birthDate, $height, $weight, $id";
  }
}
