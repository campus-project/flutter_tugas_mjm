import 'package:flutter/material.dart';
import 'package:student_mjm/models/student.dart';
import 'package:student_mjm/services/api_service.dart';
import 'package:student_mjm/views/student_form.dart';

class StudentList extends StatefulWidget {
  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  ApiService _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = new ApiService();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: _apiService.getStudents(),
        builder: (BuildContext context, AsyncSnapshot<List<Student>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Whoops, Something wrong."),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<Student> students = snapshot.data;

            return Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    Student student = students[index];

                    return Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "${student.name} (${student.nim})",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text(student.campus),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text("Warning"),
                                              content: Text("Are you sure?"),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text(
                                                    "Yes",
                                                    style: TextStyle(
                                                        color: Colors.red
                                                    )
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    _apiService.deleteStudent(student).then((isSuccess) {
                                                      if (isSuccess) {
                                                        setState(() => {});
                                                        Scaffold.of(this.context).showSnackBar(
                                                            SnackBar(
                                                              content: Text("Success deleted data."),
                                                            )
                                                        );
                                                      } else {
                                                        Scaffold.of(this.context).showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                "Failed to delete data. Please try again.",
                                                                style: TextStyle(
                                                                  color: Colors.red
                                                                ),
                                                              ),
                                                            )
                                                        );
                                                      }
                                                    });
                                                  },
                                                ),
                                                FlatButton(
                                                  child: Text(
                                                    "Cancel",
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                )
                                              ],
                                            );
                                          }
                                        );
                                      },
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) {
                                              return StudentForm(student: student);
                                            })
                                        );
                                      },
                                      child: Text(
                                        "Edit",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ]
                          ),
                        ),
                      ),
                    );
                  },
                itemCount: students.length,
              ),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      )
    );
  }
}
