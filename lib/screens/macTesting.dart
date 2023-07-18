import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:macfeus/components.dart';
import 'package:macfeus/screens/macsLoading.dart';

late Provider<JsClass> scriptProvider;

class MacTesting extends StatefulWidget {
  final Provider<JsClass> jsProvider;
  const MacTesting({super.key, required this.jsProvider});

  @override
  State<MacTesting> createState() => _MacTestingState();
}

class _MacTestingState extends State<MacTesting> {
  final TextEditingController macsCtr = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    macsCtr.dispose();
  }

  @override
  Widget build(BuildContext context) {
    scriptProvider = widget.jsProvider;

    return Scaffold(
      backgroundColor: AppData.backgroundColor(context),
      appBar: AppBar(title: const Text("MacTesting"), centerTitle: true),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PrimaryCard(
                  margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.all(10),
                  width: double.maxFinite,
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                      width: 200, height: 200, child: const SizedBox())),
              const SizedBox(height: 10),
              TextAreaInput(txtCtr: macsCtr),
              const SizedBox(height: 10),
              Consumer(builder: (context, ref, child) {
                return ElevatedButton(
                    style: const ButtonStyle(
                        padding: MaterialStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 5, horizontal: 40))),
                    onPressed: () {
                      submit(context, macsCtr, ref);
                    },
                    child: const Text(
                      "SUBMIT",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ));
              })
            ],
          ),
        ),
      ),
    );
  }
}

void submit(
    BuildContext context, TextEditingController macsCtr, WidgetRef ref) {
  try {
    ShowLoading.loadingDialog(context);

    if (macsCtr.text.isEmpty) {
      ShowMessage.show(context, 400, "Please Enter Required Feild.");
      ShowLoading.closeLoading(context);
      return;
    }

    final config = ref.watch(scriptProvider);
    config.setContext(context);

    String params = encode(macsCtr.text);

    JsEvalResult res =
        config.flutterJs.evaluate('scanner.setPortals(`$params`);');

    if (res.stringResult == "400") {
          return;
    }
    
    final response = jsonDecode(res.stringResult);

    Timer(const Duration(seconds: 2), () {
      ShowLoading.closeLoading(context);

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              MacsLoading(jsProvider: scriptProvider, macsProvider: response)));
    });

    FocusScope.of(context).requestFocus(new FocusNode());
  } catch (e) {
    ShowLoading.closeLoading(context);
    ShowMessage.show(context, 400, "Internal Error Occured");
  }
}
