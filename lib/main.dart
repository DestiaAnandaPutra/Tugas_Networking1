import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(ModNetworking());
}

class ModNetworking extends StatefulWidget {
  const ModNetworking({Key? key}) : super(key: key);

  @override
  State<ModNetworking> createState() => _ModNetworkingState();
}

class _ModNetworkingState extends State<ModNetworking> {
  List<Map> ta = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    var res = await http.get(
      Uri.parse(
        "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&limit=20",
      ),
    );

    var d = jsonDecode(res.body);

    List<Map> tmp = [];

    for (int i = 0; i < d["features"].length; i++) {
      tmp.add({
        "judul": d["features"][i]["properties"]["title"],
        "isi": d["features"][i]["properties"]["type"],
      });
    }

    setState(() {
      ta = tmp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        appBar: AppBar(title: const Text("Networking")),

        body: ListView.builder(
          itemCount: ta.length,

          itemBuilder: (context, index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(10),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    SizedBox(width: 180, child: Text(ta[index]["judul"])),

                    SizedBox(width: 100, child: Text(ta[index]["isi"])),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
