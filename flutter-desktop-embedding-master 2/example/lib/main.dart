// Copyright 2018 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:convert';

import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'Model/model.dart';

final String APIkey = "4fcd380d9925497ab01b40350b4f7d7d";

Future<List<Source>> fetchNewsSource() async {
  final response =
      await http.get('https://newsapi.org/v2/sources?category=business&apiKey=${APIkey}');
  
  if (response.statusCode == 200) {
    List sources = json.decode(response.body)['sources'];
    return sources.map((source) => new Source.fromJson(source)).toList();
  } else {
    throw Exception('Failure to load source list');
  }
}

void main() {
  // See https://github.com/flutter/flutter/wiki/Desktop-shells#target-platform-override
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;

  runApp(new SourceScreen());
}

class SourceScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SourceScreenState();
}

class SourceScreenState extends State<SourceScreen> {
  var list_sources;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshListSource();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EDMT NEWS',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: Scaffold(
        appBar: AppBar(
          title: Text('EDMT News'),
        ),
        body: Center(
          child: RefreshIndicator(
            key: refreshKey,
            child: FutureBuilder<List<Source>>(
              future: list_sources,
              builder: (context, snapshot) {
                if(snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if(snapshot.hasData) {
                  List<Source> sources = snapshot.data;
                  return new ListView(
                    children: sources.map((source) => GestureDetector(
                    onTap: () {
                        //hanlde click -> navigator to details page
                    },
                    child: Card(
                      elevation: 1.0,
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2.0),
                            width: 100.0,
                            height: 140.0,
                            child: Image.asset("assets/news.png"),
                          ),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 20, bottom: 10),
                                        child: Text('${source.name}', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Text('${source.description}', style: TextStyle(color: Colors.grey, fontSize: 12.0, fontWeight: FontWeight.normal),),
                                ),
                                Container(
                                  child: Text('Category: ${source.category}', style: TextStyle(color: Colors.black, fontSize: 14),),
                                )

                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    )).toList()
                  );
                }
                return CircularProgressIndicator();
              },
            ),
          onRefresh: refreshListSource),
          
        ),
      ),
    );
  }

  Future<dynamic> refreshListSource() async {
    refreshKey.currentState?.show(atTop: false);

    setState(() {
      list_sources = fetchNewsSource();
    });
    return null;
  }
}