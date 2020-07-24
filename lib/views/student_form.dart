import 'package:flutter/material.dart';
import 'package:student_mjm/models/student.dart';
import 'package:student_mjm/services/api_service.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class StudentForm extends StatefulWidget {
  Student student;

  StudentForm({ this.student });

  @override
  _StudentFormState createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  ApiService _apiService = ApiService();

  bool _isLoading = false;
  bool _isFieldNameValid;
  bool _isFieldNimValid;
  bool _isFieldCampusValid;
  bool _isFieldFacultyValid;
  bool _isFieldStudyValid;

  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerNim = TextEditingController();
  TextEditingController _controllerCampus = TextEditingController();
  TextEditingController _controllerFaculty = TextEditingController();
  TextEditingController _controllerStudy = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.student != null) {
      _isFieldNameValid = true;
      _controllerName.text = widget.student.name;

      _isFieldNimValid = true;
      _controllerNim.text = widget.student.nim;

      _isFieldCampusValid = true;
      _controllerCampus.text = widget.student.campus;

      _isFieldFacultyValid = true;
      _controllerFaculty.text = widget.student.faculty;

      _isFieldStudyValid = true;
      _controllerStudy.text = widget.student.study;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Add Student"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _controllerName,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Full Name",
                errorText: _isFieldNameValid == null || _isFieldNameValid ? null : 'The field name is required',
              ),
              onChanged: (value) {
                bool isFieldValid = value.trim().isNotEmpty;
                if (isFieldValid != _isFieldNameValid) {
                  setState(() => _isFieldNameValid = isFieldValid);
                }
              }
            ),
            TextField(
              controller: _controllerNim,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "NIM",
                errorText: _isFieldNimValid == null || _isFieldNimValid ? null : 'The field nim is required',
              ),
              onChanged: (value) {
                bool isFieldValid = value.trim().isNotEmpty;
                if (isFieldValid != _isFieldNimValid) {
                  setState(() => _isFieldNimValid = isFieldValid);
                }
              }
            ),
            TextField(
              controller: _controllerCampus,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Campus",
                errorText: _isFieldCampusValid == null || _isFieldCampusValid ? null : 'The field campus is required',
              ),
              onChanged: (value) {
                bool isFieldValid = value.trim().isNotEmpty;
                if (isFieldValid != _isFieldCampusValid) {
                  setState(() => _isFieldCampusValid = isFieldValid);
                }
              }
            ),
            TextField(
              controller: _controllerFaculty,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Faculty",
                errorText: _isFieldFacultyValid == null || _isFieldFacultyValid ? null : 'The field faculty is required',
              ),
              onChanged: (value) {
                bool isFieldValid = value.trim().isNotEmpty;
                if (isFieldValid != _isFieldFacultyValid) {
                  setState(() => _isFieldFacultyValid = isFieldValid);
                }
              }
            ),
            TextField(
              controller: _controllerStudy,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Study",
                errorText: _isFieldStudyValid == null || _isFieldStudyValid ? null : 'The field study is required',
              ),
              onChanged: (value) {
                bool isFieldValid = value.trim().isNotEmpty;
                if (isFieldValid != _isFieldStudyValid) {
                  setState(() => _isFieldStudyValid = isFieldValid);
                }
              }
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: RaisedButton(
                child: Text(
                  "SAVE",
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
                color: Colors.blueAccent,
                onPressed: () {
                  setState(() => _isLoading = true);

                  if (_isFieldNameValid == null || !_isFieldNameValid ||
                      _isFieldNimValid == null || !_isFieldNimValid ||
                      _isFieldCampusValid == null || !_isFieldCampusValid ||
                      _isFieldFacultyValid == null || !_isFieldFacultyValid ||
                      _isFieldStudyValid == null || !_isFieldStudyValid) {
                    _scaffoldState.currentState.showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("The input data is invalid. Please check again."),
                        )
                    );

                    setState(() => _isLoading = false);

                    return;
                  }

                  String name = _controllerName.text.toString();
                  String nim = _controllerNim.text.toString();
                  String campus = _controllerCampus.text.toString();
                  String faculty = _controllerFaculty.text.toString();
                  String study = _controllerStudy.text.toString();

                  Student student = Student(
                    name: name,
                    nim: nim,
                    campus: campus,
                    faculty: faculty,
                    study: study
                  );

                  if (widget.student != null) {
                    student.id = widget.student.id;

                    _apiService.updateStudent(student).then((isSuccess) {
                      setState(() => _isLoading = false);

                      if (isSuccess) {
                        Navigator.pop(_scaffoldState.currentState.context);
                      } else {
                        _scaffoldState.currentState.showSnackBar(
                            SnackBar(
                              content: Text("Failed to save data. Please try again."),
                            )
                        );
                      }
                    }).catchError((onError) {
                      setState(() => _isLoading = false);
                    });
                  } else {
                    _apiService.createStudent(student).then((isSuccess) {
                      setState(() => _isLoading = false);

                      if (isSuccess) {
                        Navigator.pop(_scaffoldState.currentState.context);
                      } else {
                        _scaffoldState.currentState.showSnackBar(
                            SnackBar(
                              content: Text("Failed to save data. Please try again."),
                            )
                        );
                      }
                    }).catchError((onError) {
                      setState(() => _isLoading = false);
                    });
                  }

                  return;
                },
              ),
            )
          ],
        ),
      )
    );
  }
}
