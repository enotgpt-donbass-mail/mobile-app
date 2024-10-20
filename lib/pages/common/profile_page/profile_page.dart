import 'package:app/controllers/auth_controller.dart';
import 'package:app/main.dart';
import 'package:app/pages/auth/auth.dart';
import 'package:app/pages/common/main_page/scan_page/scan_page.dart';
import 'package:app/provider/user/user_storage.dart';
import 'package:app/themes/custom_colors.dart';
import 'package:app/urls/imageURL.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                _ProfileImages(),
                SizedBox(
                  height: 5,
                ),
                _ProfileName(),
                SizedBox(
                  height: 40,
                ),
                _ProfileBlocks()
              ],
            )),
      ),
    );
  }
}

class _ProfileImages extends StatelessWidget {
  const _ProfileImages({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    return SizedBox(
      height: 220,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
                color:
                    Theme.of(context).extension<CustomColors>()!.secondaryColor,
                borderRadius: BorderRadius.circular(10)),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(100)),
              child: Center(
                child: Container(
                  width: 135,
                  height: 135,
                  clipBehavior: Clip.antiAlias,
                  child: Image(
                    image: NetworkImage(userProvider.user?.image != null
                        ? userProvider.user!.image!
                        : CustomIMG.profileImg),
                    color: userProvider.user?.image != null
                        ? userProvider.user?.image == CustomIMG.profileImg
                            ? Colors.grey[100]
                            : null
                        : null,
                    fit: BoxFit.cover,
                  ),
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .extension<CustomColors>()!
                          .primaryColor,
                      borderRadius: BorderRadius.circular(100)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _ProfileName extends StatelessWidget {
  const _ProfileName({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    return Column(
      children: [
        Text(
          userProvider.user != null
              ? userProvider.user!.firstName! +
                  " " +
                  userProvider.user!.lastName!
              : "Гость",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.grey[800]),
        )
      ],
    );
  }
}

class _ProfileBlocks extends StatefulWidget {
  const _ProfileBlocks({super.key});

  @override
  State<_ProfileBlocks> createState() => _ProfileBlocksState();
}

class _ProfileBlocksState extends State<_ProfileBlocks> {
  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      userProvider.user != null
                          ? _ProfileButton(
                              icon: CustomIMG.qrCodeIcon,
                              text: "Авторизация по QR коду",
                              onTap: () {
                                Navigator.of(context).push(CupertinoPageRoute(
                                    builder: (context) => ScanPage(
                                        snackbarController:
                                            ScaffoldMessenger.of(context))));
                              },
                            )
                          : Container(),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  _ProfileButton(
                    icon: CustomIMG.logOutIcon,
                    text: userProvider.user == null ? "Войти" : "Выйти",
                    color:
                        Theme.of(context).extension<CustomColors>()!.iconColor,
                    onTap: () {
                      userProvider.user == null
                          ? Navigator.pushAndRemoveUntil(
                              navigatorKey.currentContext!,
                              CupertinoPageRoute(builder: (_) => AuthForm()),
                              (route) => false)
                          : AuthController.logOut();
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _ProfileButton extends StatelessWidget {
  const _ProfileButton(
      {super.key,
      required this.icon,
      required this.text,
      required this.onTap,
      this.color});
  final icon;
  final text;
  final onTap;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color != null
            ? color
            : Theme.of(context).extension<CustomColors>()!.secondaryColor,
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image(
                    width: 40,
                    height: 40,
                    image: NetworkImage(icon),
                    color: Colors.white),
                SizedBox(
                  width: 10,
                ),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
