import 'package:app/api/mainApi/main_api_handler.dart';
import 'package:app/pages/common/common_page.dart';
import 'package:app/themes/custom_colors.dart';
import 'package:app/urls/imageURL.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CreateTicket extends StatefulWidget {
  const CreateTicket({super.key});

  @override
  State<CreateTicket> createState() => _CreateTicketState();
}

class _CreateTicketState extends State<CreateTicket> {
  var data = null;
  var selected = null;
  var selectedSecond = null;
  var selectedThird = null;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (controllerCommonPages.index == 1) {
      MainApiHandler.operationAll().then((val) {
        setState(() {
          print(val.body);
          data = val.body;
        });
      });
    }
    super.didChangeDependencies();
  }

  List<DropdownMenuItem> _itemsFirstDropDown() {
    if (data == null) {
      return [];
    }
    List<DropdownMenuItem> tmp = [];
    for (var element in data['operations']) {
      tmp.add(
          DropdownMenuItem(value: element['id'], child: Text(element['name'])));
    }
    return tmp;
  }

  List<DropdownMenuItem> _itemsSecondDropDown() {
    if (data == null) {
      return [];
    }
    if (selected == null) {
      return [];
    }
    List<DropdownMenuItem> tmp = [];
    for (var element in data['operations']) {
      if (element['id'] == selected) {
        for (var elem in element['subcategories']) {
          tmp.add(
              DropdownMenuItem(value: elem['id'], child: Text(elem['name'])));
        }
      }
    }
    return tmp;
  }

  List<DropdownMenuItem> _itemsThirdDropDown() {
    if (data == {}) {
      return [];
    }
    List<DateTime> dates = [];
    DateTime startTime = DateTime.now();
    startTime = DateTime(
        startTime.year, startTime.month, startTime.day, 8, 0, 0); // Set to 8 AM
    DateTime endTime = DateTime(startTime.year, startTime.month, startTime.day,
        16, 0, 0); // Set to 4 PM

    while (startTime.isBefore(endTime)) {
      dates.add(startTime);
      startTime = startTime.add(const Duration(minutes: 15));
    }
    List<DropdownMenuItem> tmp = [];
    for (var element in dates) {
      tmp.add(DropdownMenuItem(
        child: Text(element.hour.toString().padLeft(2, '0') +
            ":" +
            element.minute.toString().padLeft(2, '0')),
        value: element.toString(),
      ));
    }
    return tmp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Создание брони",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "Тип брони",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            DropdownButton(
                padding: EdgeInsets.symmetric(vertical: 8),
                isExpanded: true,
                items: _itemsFirstDropDown(),
                value: selected,
                onChanged: (val) {
                  setState(() {
                    selected = val;
                    selectedSecond = null;
                  });
                }),
            SizedBox(
              height: 10,
            ),
            Text(
              "Операция",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            DropdownButton(
                padding: EdgeInsets.symmetric(vertical: 8),
                isExpanded: true,
                items: _itemsSecondDropDown(),
                value: selectedSecond,
                onChanged: (val) {
                  setState(() {
                    selectedSecond = val;
                  });
                }),
            SizedBox(
              height: 10,
            ),
            Text(
              "Время брони",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            DropdownButton(
                padding: EdgeInsets.symmetric(vertical: 8),
                isExpanded: true,
                items: _itemsThirdDropDown(),
                value: selectedThird,
                onChanged: (val) {
                  setState(() {
                    selectedThird = val;
                  });
                }),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(),
            ),
            InkWell(
              onTap: () {
                String date = selectedThird;
                date = date.replaceFirst(' ', 'T') + "Z";
                var textVal = "string";
                for (var elem in data['operations']) {
                  for (var element in elem['subcategories']) {
                    if (element['id'] == selectedSecond) {
                      textVal = element['name'];
                      break;
                    }
                  }
                  if (textVal != "string") {
                    break;
                  }
                }
                var dataa = {
                  "uuid": uuid.v4(),
                  "reserved_date": DateTime.now()
                      .add(Duration(days: 1))
                      .toString()
                      .replaceAll(' ', 'T'),
                  "reserved_datetime": date,
                  "operation_id": selectedSecond,
                  "operation_text": textVal,
                  "office_id": 11,
                };

                MainApiHandler.reserveTicket(dataa);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                    color: Theme.of(context)
                        .extension<CustomColors>()!
                        .primaryColor!,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Center(
                  child: Text(
                    "Создать",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
