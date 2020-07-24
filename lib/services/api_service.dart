import 'dart:convert';

import 'package:http/http.dart';
import 'package:student_mjm/models/student.dart';

class ApiService {

  // 10.0.2.2 is representation localhost computer to localhost emulator
  final baseUrl = 'http://10.0.2.2:8000';
  Client client = Client();

  //this function use for get all student form url /api/student;
  Future<List<Student>> getStudents() async {
    final response = await client.get("$baseUrl/api/student");

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      return studentFromJson(body["data"]);
    }

    return null;
  }

  Future<bool> createStudent(Student student) async {
    Map<String, String> headers = {"content-type" : "application/json"};
    final body = jsonEncode(student.toJson());

    final response = await client.post("$baseUrl/api/student", headers: headers, body: body);

    return response.statusCode == 200;
  }

  Future<bool> updateStudent(Student student) async {
    Map<String, String> headers = {"content-type" : "application/json"};
    final body = jsonEncode(student.toJson());

    final response = await client.put("$baseUrl/api/student/${student.id}", headers: headers, body: body);

    return response.statusCode == 200;
  }

  Future<bool> deleteStudent(Student student) async {
    Map<String, String> headers = {"content-type" : "application/json"};

    final response = await client.delete("$baseUrl/api/student/${student.id}", headers: headers);

    return response.statusCode == 200;
  }
}