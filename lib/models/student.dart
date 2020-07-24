import 'dart:convert';

class Student {
  // all attributes in model student
  int id;
  String name;
  String nim;
  String campus;
  String faculty;
  String study;

  // constructor for this model
  Student({ this.id = 0, this.name, this.nim, this.campus, this.faculty, this.study });

  //factory for this model, mapping from json to model Student
  factory Student.fromJson(Map<String, dynamic> data) {
    return Student(
      id: data["id"],
      name: data["name"],
      nim: data["nim"],
      campus: data["campus"],
      faculty: data["faculty"],
      study: data["study"],
    );
  }

  //map this class Student to JSON (Parse to STRING JSON)
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "nim": nim,
      "campus": campus,
      "faculty": faculty,
      "study": study
    };
  }

  //override to string this class to representation name of class
  @override
  String toString() {
    return "Student{id: $id, name: $name, nim: $nim, campus: $campus, faculty: $faculty, study: $study}";
  }
}

//function for helper mapping json to Students (List = Array = Collection)
List<Student> studentFromJson(List data) {
  return List<Student>.from(data.map((item) => Student.fromJson(item)));
}

//function for helper map this student to json
String studentToJson(Student data) {
  return json.encode(data.toJson());
}