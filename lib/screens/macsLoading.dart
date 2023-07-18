import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:macfeus/components.dart';

class PortalStatus {
  final String url;
  final String mac;
  late String expire;
  late String error;
  late int status;

  PortalStatus(
      {required this.url,
      required this.mac,
      required this.status,
      this.expire = "September 17, 2023",
      this.error = "NOT FOUND"});
}

class StalkerClass extends ChangeNotifier {
  late List<PortalStatus> portalsList;
  late Map<String, dynamic> counted;
  late String portalUrl;
  late List<PortalStatus> lists;
  int index = 0;

  Map<String, dynamic> conutedRow() => counted;

  void setCounter(int total) {
    this.counted = {"total": total, "tested": 0, "working": 0};
  }

  void updateCounter(int tested, int working) {
    Map<String, dynamic> response = {
      "tested": tested,
      "working": working,
      "total": counted['total']
    };

    this.counted = response;
    notifyListeners();
  }

  void init(JsClass config) {
    if (this.index >= this.portalsList.length) {
      notifyListeners();
      return;
    }

    this.portalsList[index] = new PortalStatus(
        url: this.portalsList[index].url,
        mac: this.portalsList[index].mac,
        status: 300);

    config.flutterJs.evaluate(
        'scanner.start(`${this.portalsList[index].url}`,`${this.portalsList[index].mac}`);');
    notifyListeners();
  }

  void startTesting(JsClass config) {
    config.flutterJs.onMessage("scanerror", (args) {
      this.portalsList[index] = new PortalStatus(
          url: this.portalsList[index].url,
          mac: this.portalsList[index].mac,
          error: decode(args['message']),
          status: 400);

      this.updateCounter(this.counted['tested'] + 1, this.counted['working']);

      this.index++;
      this.init(config);
    });

    config.flutterJs.onMessage("scandone", (args) {
      final res = jsonDecode(decode(args['message']));

      this.portalsList[index] = new PortalStatus(
          url: this.portalsList[index].url,
          mac: this.portalsList[index].mac,
          expire: res['exp'],
          status: 200);

      this.updateCounter(
          this.counted['tested'] + 1, this.counted['working'] + 1);

      this.index++;
      this.init(config);
    });

    this.init(config);
  }
}

final ChangeNotifierProvider<StalkerClass> stalkerProvider =
    ChangeNotifierProvider<StalkerClass>((ref) => new StalkerClass());

late Provider<JsClass> scriptProvider;

class MacsLoading extends ConsumerWidget {
  final Provider<JsClass> jsProvider;
  final dynamic macsProvider;
  const MacsLoading(
      {super.key, required this.jsProvider, required this.macsProvider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    scriptProvider = jsProvider;

    final StalkerClass init = ref.read(stalkerProvider);

    ref.read(scriptProvider).setContext(context);

    init.index = 0;

    init.portalsList = [];
    macsProvider.forEach((element) {
      init.portalsList.add(new PortalStatus(
          url: element['portal'], mac: element['mac'], status: 500));
    });

    init.setCounter(ref.read(stalkerProvider).portalsList.length);

    Timer(const Duration(milliseconds: 500), () {
      // ShowLoading.loadingDialog(context);
      ref.read(stalkerProvider).startTesting(ref.read(scriptProvider));
    });

    return Scaffold(
        backgroundColor: AppData.backgroundColor(context),
        appBar: AppBar(),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: PrimaryCard(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.all(0),
            width: double.maxFinite,
            height: double.maxFinite,
            borderRadius: BorderRadius.circular(10),
            child: Column(
              children: [
                PrimaryCard(
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(0),
                    width: double.maxFinite,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [CountedRow()],
                    )),
                Expanded(
                    child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0)),
                        //padding: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(0),
                        child: MacsLists())),
                PrimaryCard(
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(10),
                    width: double.maxFinite,
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                    child: SaveMacs())
              ],
            ),
          ),
        ));
  }
}

class StalkerURL extends ConsumerWidget {
  const StalkerURL({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config =
        ref.watch(stalkerProvider.select((value) => value.portalUrl));

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black12,
          border: Border.all(color: Colors.grey, width: 2)),
      child: Text(config,
          style: TextStyle(color: Colors.black54),
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
    );
  }
}

class CountedRow extends ConsumerWidget {
  const CountedRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(stalkerProvider.select((value) => value.counted));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
              color: Colors.deepPurple[100],
            ),
            child: Center(
              child: Text("TOTAL MACS (${config['tested']}/${config['total']})",
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(10)),
              color: Colors.green[200],
            ),
            child: Center(
              child: Text("WORKING (${config['working']})",
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
          ),
        ),
      ],
    );
  }
}

class SaveMacs extends ConsumerWidget {
  const SaveMacs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(stalkerProvider.select((value) => value.counted));
    int tested = config['tested'];
    int total = config['total'];

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ElevatedButton(
                onPressed: (tested == total) ? () {} : null,
                child: const Text("Save")),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
                onPressed: (tested == total) ? () {} : null,
                child: const Text("Copy")),
          )
        ],
      ),
    );
  }
}

class MacsLists extends ConsumerWidget {
  const MacsLists({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(stalkerProvider.select((value) => value.portalsList));

    return Container(
        child: ListView.builder(
            itemCount: config.length,
            itemBuilder: (context, index) => MacTile(index:index)));
  }
}

class MacTile extends ConsumerWidget {
  final int index;
  const MacTile({super.key, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config =
        ref.watch(stalkerProvider.select((value) => value.portalsList[index]));

    String url = config.url;
    String mac = config.mac;
    String expire = config.expire;
    String error = config.error;
    int status = config.status;

    return SoftCard(
        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        padding: const EdgeInsets.all(0),
        borderRadius: BorderRadius.circular(0.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              child: ListTile(
                title: Text("$mac",
                        style: TextStyle(overflow: TextOverflow.ellipsis,fontSize: 15)),
                contentPadding: const EdgeInsets.all(0),
                horizontalTitleGap: 0,
                iconColor: Colors.white,
                leading: Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.only(right: 10, left: 0),
                  decoration: BoxDecoration(
                      color: const Color(0xFF361f61),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child: Center(
                    widthFactor: 1,
                    child: Text("${index + 1}",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                trailing: (status == 500)
                    ? const SizedBox()
                    : Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(right: 10, left: 10),
                        decoration: BoxDecoration(
                            color: (status == 200)
                                ? Colors.green[700]
                                : (status == 300)
                                    ? Colors.amber[900]
                                    : Colors.red[900],
                            borderRadius: BorderRadius.circular(10)),
                        child: (status == 200)
                            ? const Icon(Icons.check)
                            : (status == 300) ?
                                // SizedBox(
                                //     width: 25,
                                //     height: 25,
                                //     child: CircularProgressIndicator(
                                //         color: Colors.white, strokeWidth: 2.0))
                                const Icon(Icons.circle)
                                : const Icon(Icons.error),
                      ),
                style: ListTileStyle.drawer,
                minVerticalPadding: 0,
                subtitle: Container(
                  margin: const EdgeInsets.only(top: 0),
                  alignment: Alignment.centerLeft,
                  width: double.maxFinite,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        maxLines: 1,
                        "$url",
                        style: TextStyle(overflow: TextOverflow.ellipsis,fontSize: 12),
                      ),

                      

                       Align(
                        alignment: Alignment.centerRight,
                        child: (status == 500)
                        ? Text("")
                        : Text(
                            (status == 200)
                                ? expire
                                : (status == 300)
                                    ? "PLEASE WAIT"
                                    : error,
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                                color: (status == 200)
                                    ? Colors.green[700]
                                    : (status == 300)
                                        ? Colors.amber[900]
                                        : Colors.red[900])),
                       ),
                    ],
                  ),
               
                ),
              ),
            ),
          ),
        ));
  }
}
