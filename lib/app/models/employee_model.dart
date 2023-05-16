class Employee {
  final String id;
  final String name;
  final String role;
  final String? imageUrl;

  Employee(
      {required this.id,
      required this.name,
      required this.role,
      this.imageUrl});

  Employee.fromMap({
    required Map<String, dynamic> map,
  })  : id = map['id'],
        name = map['name'],
        role = map['role'],
        imageUrl = map['image_url'];
}
