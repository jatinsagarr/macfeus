import 'package:flutter/material.dart';

class SoftInput extends StatelessWidget {
  final TextEditingController txtCtr;
  const SoftInput({super.key,required this.txtCtr});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          color: const Color(0xFFFAFBFC),
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: const Color(0xFFD9DBDE))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: const BoxDecoration(
                border: Border(right: BorderSide(color: Color(0xFFD9DBDE)))),
            child: const Center(
              child: Icon(Icons.link),
            ),
          ),
           Expanded(
              child: TextField(
            autofocus: false,
            controller: txtCtr,
            decoration: InputDecoration(
                hintText: "Enter Stalker Portal Url",
                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                contentPadding: EdgeInsets.all(10.0)),
          ))
        ],
      ),
    );
  }
}

class TextAreaInput extends StatelessWidget {
  final TextEditingController txtCtr;
  const TextAreaInput({super.key,required this.txtCtr});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFFFAFBFC),
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: const Color(0xFFD9DBDE))),
      child: TextField(
        minLines: 5,
        maxLines: 5,
        controller: txtCtr,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10.0),
            hintText: "Enter Source Here",
            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide.none)),
      ),
    );
  }
}
