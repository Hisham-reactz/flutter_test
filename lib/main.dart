import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:machinetest/models/data.dart';

import 'models/datum.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Machine Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Filter Options'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String sortSelect = 'Nearest to Me';
  List sortOptions = [
    'Nearest to Me',
    'Trending this Week',
    'Newest Added',
    'Alphabetical',
  ];

  List<Item> data = [
    Item(expandedValue: 'data', headerValue: '1', isExpanded: false),
  ];

  List<Datum>? items = [];
  List<Map>? radioItems = [];

  void setSort(val) {
    setState(() {
      sortSelect = val;
    });
  }

  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/filter.rtf');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async {
    final text = await loadAsset();
    var texter = text.split("\n")[7].split(r'\');
    texter.removeAt(0);
    texter.removeAt(1);
    final rawData = texter.join().replaceAll('f0cf0', '');
    setState(() {
      items = Data.fromJson(rawData).data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back_ios_new),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 24,
            ),
            Wrap(
              spacing: 5,
              runSpacing: 5,
              children: radioItems!
                  .map(
                    (e) => Chip(
                      deleteIcon: const Icon(Icons.close),
                      label: Text(e['name']),
                      onDeleted: () {
                        setState(() {
                          radioItems!.remove(e);
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(
              height: 24,
            ),
            Center(
              child: Column(
                  children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          width: MediaQuery.of(context).size.width / 1.3,
                          color: Colors.white,
                          child: const Text(
                            "Sort By",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ] +
                      sortOptions
                          .map(
                            (e) => Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width / 1.3,
                              color: Colors.white,
                              child: RadioListTile<String>(
                                title: Text(e),
                                activeColor: const Color(0XFF800020),
                                value: e,
                                groupValue: sortSelect,
                                onChanged: (String? value) {
                                  setSort(value);
                                },
                              ),
                            ),
                          )
                          .toList() +
                      [
                        Container(
                          width: MediaQuery.of(context).size.width / 1.3,
                          color: Colors.white,
                          child: _buildPanel(),
                        ),
                      ]),
            ),
          ],
        ),
      ),
    );
  }

  // stores ExpansionPanel state information
  Widget _buildPanel() {
    return ExpansionPanelList(
      key: UniqueKey(),
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          items![index].isExpanded = !isExpanded;
        });
      },
      children: items!.map<ExpansionPanel>((Datum item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            var length = radioItems!
                .where((element) => element['slug'] == item.slug)
                .length
                .toString();
            return ListTile(
              title: Text('${item.name ?? ""} ( $length )'),
            );
          },
          body: Column(
            children: item.taxonomies!.map((e) {
              var selectedItem =
                  radioItems!.where((element) => element['name'] == e.name);
              return Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 1.3,
                color: Colors.white,
                child: RadioListTile<String>(
                  title: Text(e.name ?? ""),
                  activeColor: const Color(0XFF800020),
                  value: e.name ?? "",
                  groupValue: selectedItem.isNotEmpty &&
                          selectedItem.first['name'] == e.name
                      ? e.name
                      : null,
                  onChanged: (String? value) {
                    setState(() {
                      radioItems?.add({
                        'slug': items![items!.indexOf(item)].slug,
                        'name': e.name
                      });
                    });
                  },
                ),
              );
            }).toList(),
          ),
          isExpanded: item.isExpanded ?? false,
        );
      }).toList(),
    );
  }

  List<Item> generateItems(int numberOfItems) {
    return List<Item>.generate(numberOfItems, (int index) {
      return Item(
        headerValue: 'Panel $index',
        expandedValue: 'This is item number $index',
      );
    });
  }
}

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}
