import 'package:flutter/material.dart';

import '../data/data_provider.dart';
import '../models/android_version_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() =>
      _HomeScreenState(dataProvider: DataProvider());
}

class _HomeScreenState extends State<HomeScreen> {
  final DataProvider dataProvider;
  List<AndroidVersion> parsedData = [];
  List<AndroidVersion> allData = [];

  _HomeScreenState({required this.dataProvider});

  List<AndroidVersion> parseInput(dynamic input) {
    List<AndroidVersion> result = [];
    if (input is List) {
      for (var item in input) {
        if (item is Map) {
          item.forEach((key, value) {
            if (value is Map) {
              result
                  .add(AndroidVersion(id: value['id'], title: value['title']));
            }
          });
        }
        if (item is List) {
          for (var value in item) {
            result.add(AndroidVersion(id: value['id'], title: value['title']));
          }
        }
      }
    }
    return result;
  }

  void parseInputAndSetState(dynamic input) {
    List<AndroidVersion> parsed = parseInput(input);
    setState(() {
      parsedData = parsed;
      allData = parsed;
    });
  }

  List<AndroidVersion> searchById(int id) {
    return allData.where((version) => version.id == id).toList();
  }

  TextEditingController searchController = TextEditingController();
  List<AndroidVersion> searchResults = [];
  bool showSearch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Android Version Search App"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  showSearch = true;
                  searchResults.clear();
                  parseInputAndSetState(dataProvider.input1);
                  searchResults = allData;
                },
                child: const Text("Show All Input-1"),
              ),
              ElevatedButton(
                onPressed: () {
                  showSearch = true;
                  searchResults.clear();
                  parseInputAndSetState(dataProvider.input2);
                  searchResults = allData;
                },
                child: const Text("Show All Input-2"),
              ),
            ],
          ),
          showSearch
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: searchController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Search by Version ID",
                    ),
                    onChanged: (query) {
                      if (query.isEmpty) {
                        setState(() {
                          searchResults = allData;
                        });
                        return;
                      }
                      int id = int.tryParse(query) ?? 0;
                      setState(() {
                        searchResults = searchById(id);
                      });
                    },
                  ),
                )
              : SizedBox(),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final version = searchResults[index];
                return ListTile(
                  title: Text("ID: ${version.id}, Title: ${version.title}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
