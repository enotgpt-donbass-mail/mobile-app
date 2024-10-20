import 'package:app/urls/imageURL.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SearchTicket extends StatefulWidget {
  const SearchTicket({super.key});

  @override
  State<SearchTicket> createState() => _SearchTicketState();
}

class _SearchTicketState extends State<SearchTicket> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                  suffixIconConstraints: BoxConstraints(
                    maxWidth: 30,
                    maxHeight: 30,
                  ),
                  suffixIcon: Image.network(
                    CustomIMG.searchIcon,
                  )),
            )
          ],
        ),
      )),
    );
  }
}
