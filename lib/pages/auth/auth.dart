import 'package:app/api/authApi/auth_api_handler.dart';
import 'package:app/pages/auth/confirm_code.dart';
import 'package:app/pages/auth/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var emailController = TextEditingController();

class AuthForm extends StatelessWidget {
  const AuthForm({super.key});

  @override
  Widget build(BuildContext context) {
    emailController.text = "";
    return GestureDetector(
      onTap: () {
        //here
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: Colors.grey[50],
          body: SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(blurRadius: 5, color: Colors.black12)
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Войти",
                            style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey[800]),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Email",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[800]),
                          ),
                          TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'example@mail.ru',
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () async {
                              var res = await AuthApiServer.getCodeByEmail(
                                  emailController.text);
                              if (res.status) {
                                Navigator.of(context).push(CupertinoPageRoute(
                                    builder: (context) => ConfirmCode(
                                          email: emailController.text,
                                          code_id: res.codeId,
                                          typeAuth: 0,
                                        )));
                              }
                              if (res.message == "Аккаунт не найден") {
                                Navigator.of(context).push(CupertinoPageRoute(
                                    builder: (context) => RegisterForm(
                                          email: emailController.text,
                                        )));
                                return;
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
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                              "Нажимая продолжить Вы соглашаетесь с политикой Ивана"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
