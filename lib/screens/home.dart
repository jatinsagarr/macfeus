import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components.dart';

late AutoDisposeProvider appConfig;
late AutoDisposeFutureProvider toolsData;
late AutoDisposeProvider toolsProvider;
late Provider<JsClass> scriptProvider;

Future<Map<String, dynamic>> waitForData(String Url) async {
  await Future.delayed(const Duration(seconds: 2));
  final Map<String, dynamic> data = {
    "mactest": {
      "title": "Bulk Macs Testing",
      "subtitle":
          "A Tools For Checking A Mac Address Working or Not For Given Provided Stalker Portal."
    },
    "emulator": {
      "title": "STB Emulator",
      "subtitle":
          "A Handy Lite StbEmulator with which you can add Multiple Profile."
    },
    "telegram": {
      "title": "Telegram Channel",
      "subtitle": "750+ Users Already Joined.",
      "link": "https://www.google.com/"
    },
    "website": {
      "title": "Official Website",
      "subtitle": "Check Our Website for any Further Updates.",
      "link": "https://www.google.com/"
    },
    "annoucement": [
      {
        "title": "New Version will Be Launched Soon",
        "message":
            "A Handy Lite StbEmulator with which you can add Multiple Profile."
      },
      {
        "title": "New Version will Be Launched Soon",
        "message":
            "A Handy Lite StbEmulator with which you can add Multiple Profile."
      },
      {
        "title": "New Version will Be Launched Soon",
        "message":
            "A Handy Lite StbEmulator with which you can add Multiple Profile."
      },
      {
        "title": "New Version will Be Launched Soon",
        "message":
            "A Handy Lite StbEmulator with which you can add Multiple Profile."
      },
      {
        "title": "New Version will Be Launched Soon",
        "message":
            "A Handy Lite StbEmulator with which you can add Multiple Profile."
      }
    ]
  };
  return data;
}

class Home extends StatefulWidget {
  final Map<String, dynamic> appConfig;
  final Provider<JsClass> jsProvider;
  const Home({super.key, required this.appConfig, required this.jsProvider});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: Colors.deepPurple,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white),
    );

    scriptProvider = widget.jsProvider;

    appConfig =
        Provider.autoDispose<Map<String, dynamic>>((ref) => widget.appConfig);
    toolsData = FutureProvider.autoDispose<Map<String, dynamic>>(
        (ref) => waitForData(widget.appConfig['api']));

    return SafeArea(
      child: Scaffold(
          backgroundColor: AppData.backgroundColor(context),
          appBar: AppBar(
            title: const Text('MacFeus'),
            centerTitle: true,
          ),
          drawer: Drawer(
            backgroundColor: AppData.backgroundColor(context),
            child: const DrawerItems(),
          ),
          body: Consumer(builder: ((context, ref, child) {
            final config = ref.watch(toolsData);

            return config.when(
                data: (data) {
                  toolsProvider = Provider.autoDispose(((ref) => data));

                  return SingleChildScrollView(
                      child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        AnnouceMent(),
                        SizedBox(height: 10.0),
                        ManageTools(),
                        SizedBox(height: 10.0),
                        SocialMedia()
                      ],
                    ),
                  ));
                },
                error: (error, stackTrace) =>
                    Center(child: Text(error.toString())),
                loading: () => Center(child: CircularProgressIndicator()));
          }))),
    );
  }
}

class DrawerItems extends ConsumerWidget {
  const DrawerItems({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(toolsProvider);

    return SingleChildScrollView(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
              accountName: Text("Macfeus"),
              accountEmail: Text("admin@gmail.com")),
          // SoftCard(
          //     margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
          //     padding: const EdgeInsets.all(0),
          //     borderRadius: BorderRadius.circular(10.0),
          //     child: Material(
          //       color: Colors.transparent,
          //       child: InkWell(
          //         onTap: () {},
          //         borderRadius: BorderRadius.circular(10),
          //         child: Padding(
          //           padding:
          //               const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
          //           child: ListTile(
          //             title: const Text("Home"),
          //             contentPadding: const EdgeInsets.all(0),
          //             horizontalTitleGap: 0,
          //             iconColor: Colors.white,
          //             leading: Container(
          //               padding: const EdgeInsets.all(8),
          //               margin: const EdgeInsets.only(right: 10),
          //               decoration: BoxDecoration(
          //                   color: const Color(0xFF361f61),
          //                   borderRadius: BorderRadius.circular(10)),
          //               child: const Icon(CupertinoIcons.home),
          //             ),
          //             style: ListTileStyle.list,
          //             minVerticalPadding: 0,
          //             subtitle: const Text(
          //               maxLines: 1,
          //               "All Tools Will Be visible here.",
          //               style: TextStyle(overflow: TextOverflow.ellipsis),
          //             ),
          //           ),
          //         ),
          //       ),
          //     )),

          SoftCard(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              padding: const EdgeInsets.all(0),
              borderRadius: BorderRadius.circular(10.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MacTesting(jsProvider: scriptProvider)));
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                    child: ListTile(
                      title: Text("${config['mactest']['title']}"),
                      contentPadding: const EdgeInsets.all(0),
                      horizontalTitleGap: 0,
                      iconColor: Colors.white,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                            color: const Color(0xFF361f61),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(CupertinoIcons.settings_solid),
                      ),
                      style: ListTileStyle.drawer,
                      minVerticalPadding: 0,
                      subtitle: Text(
                        maxLines: 1,
                        "${config['mactest']['subtitle']}",
                        style: TextStyle(overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                ),
              )),

          SoftCard(
              margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
              padding: const EdgeInsets.all(0),
              borderRadius: BorderRadius.circular(10.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                    child: ListTile(
                      title: Text("${config['emulator']['title']}"),
                      contentPadding: const EdgeInsets.all(0),
                      horizontalTitleGap: 0,
                      iconColor: Colors.white,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                            color: const Color(0xFF361f61),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(CupertinoIcons.tv),
                      ),
                      style: ListTileStyle.drawer,
                      minVerticalPadding: 0,
                      subtitle: Text(
                        maxLines: 1,
                        "${config['emulator']['subtitle']}",
                        style: TextStyle(overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                ),
              )),
          const TermConditions()
        ],
      ),
    );
  }
}

class TermConditions extends ConsumerWidget {
  const TermConditions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfig);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Column(
        children: [
          const SoftCard(
              margin: EdgeInsets.all(0),
              padding: EdgeInsets.all(10),
              width: double.maxFinite,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10), topLeft: Radius.circular(10)),
              child: Center(
                child: Text("PAGES",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                        fontSize: 12)),
              )),
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
            decoration: const BoxDecoration(
                color: Color(0xFFf4f0fa),
                border: Border.symmetric(
                    vertical: BorderSide(color: Color(0x33616875), width: 1))),
            child: Column(
              children: [
                const SizedBox(height: 5),
                Material(
                  color: Colors.white,
                  child: InkWell(
                      onTap: () {
                        ShowCustomDialog.articleDialog(context,
                            Text("Privacy Policy"), Text(config['privacy']));
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: const Text("Privacy Policy"),
                      )),
                ),
                const SizedBox(height: 5),
                Material(
                  color: Colors.white,
                  child: InkWell(
                      onTap: () {
                        ShowCustomDialog.articleDialog(context,
                            Text("Term & Conditions"), Text(config['term']));
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: const Text("Term & Conditions"),
                      )),
                ),
                const SizedBox(height: 5),
                Material(
                  color: Colors.white,
                  child: InkWell(
                      onTap: () {
                        ShowCustomDialog.articleDialog(context,
                            Text("Contact Us"), Text(config['contactus']));
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: const Text("Contact Us"),
                      )),
                ),
                const SizedBox(height: 5),
                Material(
                  color: Colors.white,
                  child: InkWell(
                      onTap: () {
                        ShowCustomDialog.articleDialog(
                            context, Text("About Us"), Text(config['aboutus']));
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: const Text("About Us"),
                      )),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
          SoftCard(
              margin: EdgeInsets.all(0),
              padding: EdgeInsets.all(10),
              width: double.maxFinite,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
              child: Text("Version : ${config['version']}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                      fontSize: 12)))
        ],
      ),
    );
  }
}

class AnnouceMent extends ConsumerWidget {
  const AnnouceMent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(toolsProvider);

    return SoftCard(
        margin: const EdgeInsets.all(0.0),
        padding: const EdgeInsets.all(10.0),
        width: double.infinity,
        borderRadius: BorderRadius.circular(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text.rich(TextSpan(
                children: [
                  WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Icon(CupertinoIcons.arrow_uturn_down_circle_fill)),
                  TextSpan(text: "  ANNOUCEMENT")
                ],
                style: TextStyle(
                    color: Colors.deepPurple, fontWeight: FontWeight.bold))),
            const Divider(color: Colors.grey),
            SizedBox(
                height: 200,
                child: ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: 4,
                    itemBuilder: (context, index) => Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 0),
                          decoration: BoxDecoration(
                              color: const Color(0xFFf4f0fa),
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                  color:
                                      const Color.fromRGBO(97, 104, 117, 0.2),
                                  width: 1.0)),
                          child: ListTile(
                            onTap: () {},
                            minVerticalPadding: 0,
                            contentPadding: const EdgeInsets.all(0),
                            style: ListTileStyle.drawer,
                            title: Text(config['annoucement'][index]['title']),
                            subtitle:
                                Text(config['annoucement'][index]['message']),
                          ),
                        )))
          ],
        ));
  }
}

class ManageTools extends ConsumerWidget {
  const ManageTools({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(toolsProvider);

    return PrimaryCard(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(10),
        width: double.maxFinite,
        borderRadius: BorderRadius.circular(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text.rich(
              TextSpan(children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Icon(CupertinoIcons.bolt_circle_fill),
                ),
                TextSpan(text: "  TOOLS"),
              ]),
              style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(
              color: Colors.grey,
            ),
            const SizedBox(height: 10),
            SoftCard(
                margin: const EdgeInsets.all(0),
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                borderRadius: BorderRadius.circular(10.0),
                child: ListTile(
                  title: Text("${config['mactest']['title']}"),
                  contentPadding: const EdgeInsets.all(0),
                  horizontalTitleGap: 0,
                  iconColor: Colors.white,
                  leading: Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        color: const Color(0xFF361f61),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Icon(CupertinoIcons.settings_solid),
                  ),
                  style: ListTileStyle.drawer,
                  trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    MacTesting(jsProvider: scriptProvider)));
                      },
                      child: const Icon(
                        CupertinoIcons.arrow_up_right_square,
                      )),
                  minVerticalPadding: 0,
                  subtitle: Text(
                    maxLines: 2,
                    "${config['mactest']['subtitle']}",
                    style: TextStyle(overflow: TextOverflow.ellipsis),
                  ),
                )),
            const SizedBox(height: 10),
            SoftCard(
                margin: const EdgeInsets.all(0),
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                borderRadius: BorderRadius.circular(10.0),
                child: ListTile(
                  title: Text("${config['emulator']['title']}"),
                  contentPadding: const EdgeInsets.all(0),
                  horizontalTitleGap: 0,
                  iconColor: Colors.white,
                  leading: Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        color: const Color(0xFF361f61),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Icon(CupertinoIcons.tv),
                  ),
                  style: ListTileStyle.drawer,
                  trailing: const ElevatedButton(
                      onPressed: null,
                      child: Icon(
                        CupertinoIcons.arrow_up_right_square,
                      )),
                  minVerticalPadding: 0,
                  subtitle: Text(
                    maxLines: 2,
                    "${config['emulator']['subtitle']}",
                    style: TextStyle(overflow: TextOverflow.ellipsis),
                  ),
                ))
          ],
        ));
  }
}

class SocialMedia extends ConsumerWidget {
  const SocialMedia({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.deepPurple,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppData.backgroundColor(context)),
    );
    final config = ref.watch(toolsProvider);
    final js = ref.watch(scriptProvider);

    return Container(
      child: Column(
        children: [
          const SoftCard(
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.all(5),
            width: double.maxFinite,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10), topLeft: Radius.circular(10)),
            child: Text.rich(TextSpan(
                children: [
                  WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Icon(CupertinoIcons.arrow_down_circle_fill)),
                  TextSpan(text: "  JOIN US")
                ],
                style: TextStyle(
                    color: Colors.deepPurple, fontWeight: FontWeight.bold))),
          ),
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Color(0xFFf4f0fa),
                border: Border.symmetric(
                    vertical: BorderSide(color: Color(0x33616875), width: 1))),
            child: Column(
              children: [
                SoftCard(
                    margin: const EdgeInsets.all(0),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    borderRadius: BorderRadius.circular(10.0),
                    child: ListTile(
                      title: Text("${config['telegram']['title']}"),
                      contentPadding: const EdgeInsets.all(0),
                      horizontalTitleGap: 0,
                      iconColor: Colors.white,
                      leading: Container(
                        padding: const EdgeInsets.all(10.0),
                        margin: const EdgeInsets.only(right: 10),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.telegram_rounded),
                      ),
                      style: ListTileStyle.drawer,
                      trailing: ElevatedButton(
                          onPressed: () {
                            ShowLoading.loadingDialog(context);
                          },
                          child: const Icon(
                            Icons.link,
                          )),
                      minVerticalPadding: 0,
                      subtitle: Text(
                        maxLines: 2,
                        "${config['telegram']['subtitle']}",
                        style: TextStyle(overflow: TextOverflow.ellipsis),
                      ),
                    )),
                const SizedBox(height: 5),
                SoftCard(
                    margin: const EdgeInsets.all(0),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    borderRadius: BorderRadius.circular(10.0),
                    child: ListTile(
                      title: Text("${config['website']['title']}"),
                      contentPadding: const EdgeInsets.all(0),
                      horizontalTitleGap: 0,
                      iconColor: Colors.white,
                      leading: Container(
                        padding: const EdgeInsets.all(10.0),
                        margin: const EdgeInsets.only(right: 10),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.web),
                      ),
                      style: ListTileStyle.drawer,
                      trailing: ElevatedButton(
                          onPressed: () {
                            js.setContext(context);
                            //js.flutterJs.evaluate("test.init();");
                            js.flutterJs.evaluate("message();");
                          },
                          child: const Icon(
                            Icons.link,
                          )),
                      minVerticalPadding: 0,
                      subtitle: Text(
                        maxLines: 2,
                        "${config['website']['subtitle']}",
                        style: TextStyle(overflow: TextOverflow.ellipsis),
                      ),
                    )),
              ],
            ),
          ),
          const SoftCard(
              margin: EdgeInsets.all(0),
              padding: EdgeInsets.all(5),
              width: double.maxFinite,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
              child: SizedBox())
        ],
      ),
    );
  }
}
