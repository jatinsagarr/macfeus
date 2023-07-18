import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:macfeus/screens/home.dart';
import 'App.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'script.dart';

void main() {
  runApp(const ProviderScope(child: App()));
}

Future<Map<String, dynamic>> waitForData(BuildContext context, FutureProviderRef ref) async {
  await Future.delayed(const Duration(seconds: 1));

  final Map<String, dynamic> data = {
    "version": "1.0.1",
    "aboutus":
        "The About Us page of your website is an essential source of information for all who want to know more about your business",
    "contactus":
        "The About Us page of your website is an essential source of information for all who want to know more about your business",
    "privacy":
        "The About Us page of your website is an essential source of information for all who want to know more about your business",
    "term":
        "The About Us page of your website is an essential source of information for all who want to know more about your business",
    "api": "https://api.app.com/"
  };

  String crypto = await DefaultAssetBundle.of(context).loadString("assets/js/crypto.js");
  ref.watch(scriptProvider).flutterJs.evaluate(crypto);

  String code = await DefaultAssetBundle.of(context).loadString("assets/js/script.js");
  ref.watch(scriptProvider).flutterJs.evaluate(code);


  return data;
}

late FutureProvider configProvider;

final Provider<JsClass> scriptProvider =
    Provider<JsClass>((ref) => new JsClass());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: Colors.deepPurple,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white),
    );

    configProvider = FutureProvider((ref) => waitForData(context, ref));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      darkTheme: AppData.themeDark,
      theme: AppData.themeLight,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Consumer(builder: (context, ref, child) {
            final config = ref.watch(configProvider);
            final js = ref.watch(scriptProvider);
              // DioRequest(
              //       requestData:
              //           "U2FsdGVkX1+YCnW0T7g42Qo/jH36BI0qcIq7zNoQMfysve5h7lG4jV12prg8FVzov2eyzqJQYM1zDazNcIxJe5xjG+zX+GjNToRweq7DShsw0ds4nTI0WFVai2Xh2weXocUe2pnm575CLEDZSgf9PI5p75GSpYwr3UYnpiqiZFYkA8S4VSwies17/pm1F2vcYJPvB1R9QEni9EuhG5bf+BWXIpt3oaFsGR5KGApRFqzzZOrLUVi8MM7+CYhkSaEhmAItpwG0V7fJ9QPgpjK+FrwgLeTMli3Nv0kHksUXf76D1JB12Y6pHEDDNUKAu6pJhGO5p+9fjaI2RvYZBR188julO6+WwZRCq5u6QMpe2V5iQS90rWqiqnbAMU3TOhjrGj7XUx9vK1Q5eezFbymQ806BKDwgGbfLN5c8jdbHQZJ+YAXLlVTcnbbrEeAWGOSNwzotyz5uxUqOe4a8Qwsarb9r/B/mIUqIHyR6dSi21eKzZ8hi4AATGgP08nYm3VeCjG5I0oeNOX9NJ2iMC9hjJC/O4sWyp9snNM5thm3lLK6Cita7wpANXx2xE2oH479r7InSsD6HpFezdUrTozUhcfEbA5AmBzgXPslZ10QFqC9t8CSezuWIFG3VRfmSuTRDHJ8QtzWqSUE2yqGdn+JmO0556flovSnxUsJXddt/Mhqrg2D/LyVNFIeHvxZB3HYF3MXLJR5wm1XtYdznktrLcx/h/iCE72xOmDqMpQddW1nL/E1Ui5Nyhw6sX5ScU0JeR7EcQ1HX51NNq7VoJD31DhocyKzvQ+Zo0G9jJvp5GAQ=",
              //       flutterJs: js.flutterJs).get();
                
            return config.when(
                data: (value) => Builder(builder: (context) {
                      Timer(
                          const Duration(microseconds: 100),
                          () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Home(
                                      appConfig: value,
                                      jsProvider: scriptProvider))));

                      return const CircularProgressIndicator();
                    }),
                error: (error, stackTrace) => Text(error.toString()),
                loading: () => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 150,
                            width: 150,
                            child: Image.asset("assets/images/logo.png")),
                        const SizedBox(height: 10),
                        const Text("MacFeus",
                            style: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                                fontSize: 30)),
                      ],
                    ));
          }))
      ),
    );
  }
}
