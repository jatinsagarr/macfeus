import 'package:flutter/material.dart';
import 'package:macfeus/components.dart';

class ShowCustomDialog {

  static Future<void> articleDialog(context, Widget text, Widget body) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          children: <Widget>[
            Center(
                child: Column(
              children: [
                SoftCard(
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(5),
                    width: double.maxFinite,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10)),
                    child: Center(
                      child: text,
                    )),
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      color: Color(0xFFf4f0fa),
                      border: Border.symmetric(
                          vertical:
                              BorderSide(color: Color(0x33616875), width: 1))),
                  child: body,
                ),
                SoftCard(
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(5),
                    width: double.maxFinite,
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                    child: Center(
                      child: ElevatedButton(
                          onPressed: () {
                            ShowCustomDialog.closeCustomDialog(context);
                          },
                          style: const ButtonStyle(
                              padding: MaterialStatePropertyAll(
                                  EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 60))),
                          child: const Text("Close")),
                    ))
              ],
            ))
          ],
        );
      },
    );
  }

  static Future<void> errorDialog(context, Widget text) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          children: <Widget>[
            Center(
                child: PrimaryCard(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              borderRadius: BorderRadius.circular(10),
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  const Icon(Icons.error, size: 60),
                  const SizedBox(height: 10),
                  text,
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () {
                        closeCustomDialog(context);
                      },
                      child: const Text("Cancel"))
                ],
              )),
            ))
          ],
        );
      },
    );
  }

  static Future<void> agreeDialog(context, Widget text, Function action) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          children: <Widget>[
            Center(
                child: PrimaryCard(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(10),
              borderRadius: BorderRadius.circular(10),
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  text,
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            closeCustomDialog(context);
                          },
                          child: const Text("Cancel")),
                      ElevatedButton(
                          onPressed: () => action(), child: const Text("OK")),
                    ],
                  )
                ],
              )),
            ))
          ],
        );
      },
    );
  }

  static void closeCustomDialog(BuildContext context) {
    try {
      return Navigator.of(context).pop();
    } catch (e) {
      return;
    }
  }
}

class ShowLoading {
  static Future<void> loadingDialog(context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          children: <Widget>[
            Center(
              child: PrimaryCard(
                  margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.all(20),
                  borderRadius: BorderRadius.circular(10),
                  child: const CircularProgressIndicator()),
            )
          ],
        );
      },
    );
  }

  static void closeLoading(BuildContext context) {
    try {
      return Navigator.of(context).pop();
    } catch (e) {
      print(e);
      return;
    }
  }
}
