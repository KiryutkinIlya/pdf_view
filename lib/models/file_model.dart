import 'dart:convert';

class FileModel {
  final String path;
  final String name;

  FileModel({required this.path,required this.name});// Метод для десериализации из JSON строки
  factory FileModel.fromStringJson(String jsonString) {
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return FileModel(
      path: jsonMap['path'],
      name: jsonMap['name'],
    );
  }

  // Метод для сериализации в JSON строку
  String toStringJson() {
    final Map<String, dynamic> jsonMap = {
      'path': path,
      'name': name,
    };
    return json.encode(jsonMap);
  }

}