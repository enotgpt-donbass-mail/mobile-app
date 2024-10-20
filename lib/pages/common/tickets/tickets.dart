import 'dart:convert';

import 'package:app/api/mainApi/main_api_handler.dart';
import 'package:app/pages/common/common_page.dart';
import 'package:app/pages/common/create_ticket/create_ticket.dart';
import 'package:app/store/secure_storage.dart';
import 'package:app/themes/custom_colors.dart';
import 'package:app/urls/imageURL.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  var data = null;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (controllerCommonPages.index == 1) {
      secured_storage.read(key: "current_tickets").then((val) {
        print(val);
        if (val == null) {
          setState(() {
            data = {'tickets': []};
          });
        } else {
          setState(() {
            data = json.decode(utf8.decode(utf8.encode(val)));
          });
        }
      });
    }
    super.didChangeDependencies();
  }

  List<Widget> _itemsFirstDropDown() {
    if (data == null) {
      return [];
    }
    List<Widget> tmp = [];
    for (var element in data['tickets']) {
      tmp.add(TicketBlock(
          name: element['reserved']['operation_text'],
          dateTime: element['reserved']['reserved_date'],
          code: element['reserved']['code'].toString(),
          time: element['reserved']['reserved_datetime']
              .toString()
              .split("T")[1]
              .substring(0, 5)));
    }
    return tmp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Image(
          image: NetworkImage(CustomIMG.createNewIcon),
          width: 30,
          color: Theme.of(context).extension<CustomColors>()!.secondaryColor,
        ),
        onPressed: () {
          Navigator.push(
              context, CupertinoPageRoute(builder: (_) => CreateTicket()));
        },
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Ваши брони",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: _itemsFirstDropDown()),
            ),
          )
        ]),
      )),
    );
  }
}

class TicketBlock extends StatelessWidget {
  const TicketBlock({
    super.key,
    required this.dateTime,
    required this.time,
    required this.name,
    required this.code,
  });
  final String dateTime;
  final String time;
  final String name;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700, height: 1),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    code,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  )
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  dateTime,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                )
              ],
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 2,
          color: Colors.grey[200],
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
