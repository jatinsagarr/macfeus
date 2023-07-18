import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:dio/dio.dart';
import 'components.dart';

class DioRequest {
  final Dio dio = Dio();

  late JavascriptRuntime flutterJs;
  late String requestData;
  late String url;
  late Map<String, String> requestHeaders;
  late Map<String, dynamic> payLoad;
  late String classObject;
  late String callBack;
  late int timeOut;

  DioRequest({required this.requestData, required this.flutterJs}) {
    try {
      Map<String, dynamic> response = jsonDecode(decode(this.requestData));
      this.requestHeaders = {};
      this.url = decode(response['url']);
      this.requestHeaders = jsonDecode(decode(response['headers']));
      this.payLoad = jsonDecode(decode(response['payload']));
      this.classObject = decode(response['classobject']);
      this.callBack = decode(response['callback']);
      this.timeOut = int.parse(decode(response['timeout']));

      this.requestHeaders =
          this.requestHeaders.map((key, value) => MapEntry(key, decode(value)));
      this.payLoad =
          this.payLoad.map((key, value) => MapEntry(key, decode(value)));
    } catch (e) {
      throwError(e.toString());
    }
  }

  void get() async {
    try {
      Response response = await dio.get(this.url,
          options: Options(
              headers: this.requestHeaders,
              sendTimeout: this.timeOut,
              receiveTimeout: this.timeOut,
              responseType: ResponseType.plain));

     
      Map<String, dynamic> responseHeaders = {};
      response.headers.forEach((name, values) {
        responseHeaders.addAll({name: encode(jsonEncode(values))});
      });

      Map<String, dynamic> result = {
        "body": encode(response.data),
        "headers": encode(jsonEncode(responseHeaders)),
        "statuscode": encode("${response.statusCode}"),
        "statusmessage": encode("${response.statusCode}")
      };

      flutterJs.evaluate(
          '${this.classObject}.${this.callBack}(`${encode(jsonEncode(result))}`);');
    } catch (e) {
      throwError(e.toString());
    }
  }

  void throwError(String error) {
    flutterJs.evaluate('${this.classObject}.error(`${encode(error)}`);');
  }
}

class JsClass {
  late BuildContext context;
  final JavascriptRuntime flutterJs = getJavascriptRuntime();

  JsClass() {
    setChannels();
  }

  void setContext(BuildContext newContext) {
    this.context = newContext;
  }

  void setChannels() {
    this.flutterJs.onMessage("print", (args) {
      print(decode(args['message']));
    });

    this.flutterJs.onMessage("get", (args) {
      new DioRequest(requestData: args['message'], flutterJs: flutterJs).get();
    });

    this.flutterJs.onMessage("loading", (args) {
      ShowLoading.loadingDialog(this.context);
    });

    this.flutterJs.onMessage("closeloading", (args) {
      ShowLoading.closeLoading(this.context);
    });

    this.flutterJs.onMessage("errordialog", (args) {
      ShowCustomDialog.errorDialog(context, Text(decode(args['message'])));
    });

    this.flutterJs.onMessage("snackbar", (args) {
      ShowMessage.show(context, args['type'], args['message']);
    });
  }
}
