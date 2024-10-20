import 'package:app/api/authApi/auth_api_handler.dart';
import 'package:app/controllers/auth_controller.dart';
import 'package:app/pages/common/common_page.dart';
import 'package:app/provider/user/user_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

var codeConfirmController = TextEditingController();

class ConfirmCode extends StatelessWidget {
  const ConfirmCode(
      {super.key,
      required this.email,
      required this.code_id,
      required this.typeAuth});
  final email;
  final code_id;
  final typeAuth;

  @override
  Widget build(BuildContext context) {
    codeConfirmController.text = "";
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
                            "Код",
                            style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey[800]),
                          ),
                          Text(
                            "Код подтверждения",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[800]),
                          ),
                          TextField(
                            controller: codeConfirmController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: '*****',
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () async {
                              var res = await AuthApiServer.confirmCodeByEmail(
                                  email,
                                  code_id,
                                  int.parse(codeConfirmController.text),
                                  typeAuth);
                              if (res.status) {
                                final userProvider =
                                    context.read<UserProvider>();
                                final user =
                                    await AuthController.getInfoCurrentUser();

                                Navigator.pushAndRemoveUntil(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (_) => CommonPage()),
                                    (route) => false);
                              }
                              var snackBar =
                                  SnackBar(content: Text(res.message!));
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
