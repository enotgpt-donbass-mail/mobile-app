import 'package:app/api/authApi/auth_api_handler.dart';
import 'package:app/pages/auth/confirm_code.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var firstNameController = TextEditingController();
var lastNameController = TextEditingController();
var middleNameController = TextEditingController();
var dateBirthdayController = TextEditingController();

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key, required this.email});
  final String email;
  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

int? gender = 0;

class _RegisterFormState extends State<RegisterForm> {
  @override
  Widget build(BuildContext context) {
    firstNameController.text = "";
    lastNameController.text = "";
    middleNameController.text = "";
    dateBirthdayController.text = "";
    gender = 0;
    return GestureDetector(
      onTap: () {
        //here
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: Colors.grey[50],
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(blurRadius: 5, color: Colors.black12)
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Регистрация",
                                style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey[800]),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextField(
                                controller: lastNameController,
                                textInput: TextInputType.text,
                                hint: "Фамилия",
                                title: "Фамилия",
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomTextField(
                                controller: firstNameController,
                                textInput: TextInputType.text,
                                hint: "Имя",
                                title: "Имя",
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomTextField(
                                controller: middleNameController,
                                textInput: TextInputType.text,
                                hint: "Отчество",
                                title: "Отчество",
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomDateField(
                                controller: dateBirthdayController,
                                textInput: TextInputType.datetime,
                                hint: "01.01.1970",
                                title: "Дата рождения",
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Radio<int>(
                                    value: 0,
                                    groupValue: gender,
                                    onChanged: (int? value) {
                                      setState(() {
                                        gender = value;
                                      });
                                    },
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          gender = 0;
                                        });
                                      },
                                      child: Text("Мужчина")),
                                  Radio<int>(
                                    value: 1,
                                    groupValue: gender,
                                    onChanged: (int? value) {
                                      setState(() {
                                        gender = value;
                                      });
                                    },
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          gender = 1;
                                        });
                                      },
                                      child: Text("Женщина")),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                onTap: () async {
                                  var birthDate =
                                      "${dateBirthdayController.text.split('.')[2]}-${dateBirthdayController.text.split('.')[1]}-${dateBirthdayController.text.split('.')[0]}";

                                  var res =
                                      await AuthApiServer.registerUserByEmail(
                                          firstNameController.text,
                                          lastNameController.text,
                                          middleNameController.text,
                                          birthDate,
                                          gender,
                                          widget.email);
                                  if (res.status) {
                                    Navigator.of(context)
                                        .push(CupertinoPageRoute(
                                            builder: (context) => ConfirmCode(
                                                  email: widget.email,
                                                  code_id: res.codeId,
                                                  typeAuth: 1,
                                                )));
                                  }
                                  var snackBar =
                                      SnackBar(content: Text(res.message));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                },
                                child: Center(
                                  child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Center(child: Text("Продолжить"))),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                  "Нажимая продолжить Вы соглашаетесь с политикой Ивана"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}

class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {super.key,
      required this.controller,
      required this.textInput,
      required this.title,
      required this.hint});
  final TextEditingController controller;
  final TextInputType textInput;
  final String hint;
  final String title;
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800]),
        ),
        TextField(
          onTap: () {},
          controller: widget.controller,
          keyboardType: widget.textInput,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: widget.hint,
          ),
        ),
      ],
    );
  }
}

class CustomDateField extends StatefulWidget {
  const CustomDateField(
      {super.key,
      required this.controller,
      required this.textInput,
      required this.title,
      required this.hint});
  final TextEditingController controller;
  final TextInputType textInput;
  final String hint;
  final String title;
  @override
  State<CustomDateField> createState() => _CustomDateFieldState();
}

class _CustomDateFieldState extends State<CustomDateField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800]),
        ),
        TextField(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(
                    2000), //DateTime.now() - not to allow to choose before today.
                lastDate: DateTime(2101));

            if (pickedDate != null) {
              print(
                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
              String formattedDate =
                  pickedDate.toString().split("-")[2].substring(0, 2) +
                      '.' +
                      pickedDate.toString().split("-")[1] +
                      '.' +
                      pickedDate.toString().split("-")[0];
              widget.controller.text = formattedDate;
              print(
                  formattedDate); //formatted date output using intl package =>  2021-03-16
              //you can implement different kind of Date Format here according to your requirement
            } else {
              print("Date is not selected");
            }
          },
          readOnly: true,
          controller: widget.controller,
          keyboardType: widget.textInput,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: widget.hint,
          ),
        ),
      ],
    );
  }
}
