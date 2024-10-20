import 'package:app/api/authApi/auth_api_handler.dart';
import 'package:app/controllers/auth_controller.dart';
import 'package:app/main.dart';
import 'package:app/pages/common/common_page.dart';
import 'package:app/pages/common/main_page/scan_page/scan_page.dart';
import 'package:app/pages/welcome/start_page.dart';
import 'package:app/provider/user/user_storage.dart';
import 'package:app/store/secure_storage.dart';
import 'package:app/themes/custom_colors.dart';
import 'package:app/urls/imageURL.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void didChangeDependencies() async {
    final userProvider = context.read<UserProvider>();
    if (await AuthController.isAuthroized() && userProvider.fetched == false) {
      final user = await AuthController.getInfoCurrentUser();

      userProvider.setUser(user);
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _Header(),
                SizedBox(
                  height: 10,
                ),
                _LoadStatusBlock(),
                SizedBox(
                  height: 10,
                ),
                _BlocksCommon(),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ));
  }
}

class _LoadStatusBlock extends StatefulWidget {
  const _LoadStatusBlock({super.key});

  @override
  State<_LoadStatusBlock> createState() => __LoadStatusBlockState();
}

class __LoadStatusBlockState extends State<_LoadStatusBlock> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
        flex: 1,
        child: Column(
          children: [
            Expanded(
                child: Container(
              width: double.infinity,
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Image(
                            image: NetworkImage(CustomIMG.logoURL),
                            height: 75,
                            width: 75,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Text(
                            "Отделение Почта Донбасса №1",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w600),
                          ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Выдано",
                                style: TextStyle(fontSize: 24),
                              ),
                              Text(
                                "2034",
                                style: TextStyle(
                                    height: 1,
                                    fontSize: 72,
                                    fontWeight: FontWeight.w800,
                                    color: Theme.of(context)
                                        .extension<CustomColors>()!
                                        .primaryColor),
                              ),
                              Text(
                                "Посылки",
                                style: TextStyle(fontSize: 24),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ))
          ],
        ));
  }
}

class _Header extends StatefulWidget {
  const _Header({super.key});
  @override
  State<_Header> createState() => __HeaderState();
}

class __HeaderState extends State<_Header> {
  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Здравствуйте,',
                style: TextStyle(fontSize: 24, color: Colors.grey[700]),
              ),
              Row(
                children: [
                  Text(
                    userProvider.user == null
                        ? 'Гость!'
                        : userProvider.user!.firstName! + '!',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[900]),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Image(
                    image: NetworkImage(CustomIMG.handShake),
                    height: 30,
                    width: 30,
                  )
                ],
              ),
            ],
          ),
          InkWell(
            onTap: () async {
              controllerCommonPages.index = 3;
            },
            child: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image(
                fit: BoxFit.cover,
                color: userProvider.user == null
                    ? Theme.of(context).extension<CustomColors>()!.iconColor!
                    : null,
                image: NetworkImage(userProvider.user?.image == null
                    ? CustomIMG.profileImg
                    : userProvider.user!.image!),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _BlocksCommon extends StatefulWidget {
  const _BlocksCommon({super.key});

  @override
  State<_BlocksCommon> createState() => __BlocksCommonState();
}

class __BlocksCommonState extends State<_BlocksCommon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:
                    Theme.of(context).extension<CustomColors>()!.primaryColor,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        width: 128,
                        height: 128,
                        image: NetworkImage(
                          CustomIMG.qrCodeIcon,
                        ),
                        color: Colors.white,
                      ),
                      Text(
                        "Сканировать талон",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            height: 1,
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              height: 300,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context)
                            .extension<CustomColors>()!
                            .secondaryColor,
                      ),
                      child: InkWell(
                        onTap: () {
                          controllerCommonPages.index = 1;
                        },
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image(
                                  width: 65,
                                  height: 65,
                                  image: NetworkImage(CustomIMG.createNewIcon),
                                  color: Colors.white,
                                ),
                                Text(
                                  "Создать бронь",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      height: 1,
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context)
                            .extension<CustomColors>()!
                            .iconColor,
                      ),
                      child: InkWell(
                        onTap: () {
                          controllerCommonPages.index = 2;
                        },
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image(
                                  width: 65,
                                  height: 65,
                                  image: NetworkImage(CustomIMG.historyIcon),
                                  color: Colors.white,
                                ),
                                Text(
                                  "Просмотр очереди",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      height: 1,
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
