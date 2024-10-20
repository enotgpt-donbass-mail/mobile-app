import 'package:app/api/authApi/auth_api_handler.dart';
import 'package:app/api/mainApi/main_api_handler.dart';
import 'package:app/controllers/auth_controller.dart';
import 'package:app/pages/auth/auth.dart';
import 'package:app/pages/common/common_page.dart';
import 'package:app/store/secure_storage.dart';
import 'package:app/urls/imageURL.dart';
import 'package:app/provider/user/user_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

bool animEnd = false;
bool fetchEnd = false;

class StartPage extends StatelessWidget {
  StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LogoApp(),
            SizedBox(
              height: 30,
            ),
            TextLogo(),
            SizedBox(
              height: 30,
            ),
            Loader(),
          ],
        ),
      ),
    );
  }
}

class Loader extends StatefulWidget {
  const Loader({super.key});

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;
  Widget? whereToRedir;
  @override
  void initState() {
    super.initState();

    MainApiHandler.getUsersMe();

    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    animation = Tween<double>(begin: 0, end: 50).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutQuad))
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object's value.
        });
      });

    Future.delayed(Duration(milliseconds: 2000), () {
      _controller.forward();
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool started = false;
  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    if (animEnd && userProvider.fetched && !started) {
      started = true;
      Future.delayed(Duration(milliseconds: 500), () {
        Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(
                builder: (context) =>
                    userProvider.user == null ? CommonPage() : CommonPage()),
            (Route<dynamic> route) => false);
      });
    }
    return Center(
        child: Container(
            width: animation.value,
            height: animation.value,
            child: const CircularProgressIndicator(
              strokeWidth: 8,
            )));
  }
}

class TextLogo extends StatefulWidget {
  const TextLogo({super.key});

  @override
  State<TextLogo> createState() => _TextLogoState();
}

class _TextLogoState extends State<TextLogo>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  var whereToRedirect;

  bool fetchEnd = false;
  @override
  void initState() {
    super.initState();
    animEnd = false;
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation = Tween<double>(begin: 0, end: 50)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeOutQuad))
      ..addStatusListener((AnimationStatus status) {
        animEnd = true;
      })
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object's value.
        });
      });
    Future.delayed(Duration(milliseconds: 1000), () {
      controller.forward();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: animation.value,
        child: Text(
          "Почта Донбасса",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
        ));
  }
}

class LogoApp extends StatefulWidget {
  const LogoApp({super.key});

  @override
  State<LogoApp> createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation = Tween<double>(begin: 0, end: 200)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeOutQuad))
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object's value.
        });
      });
    Future.delayed(Duration(milliseconds: 0), () {
      controller.forward();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Image(
        height: animation.value,
        width: animation.value,
        fit: BoxFit.contain,
        image: const AssetImage('assets/images/logo.png'));
  }
}
