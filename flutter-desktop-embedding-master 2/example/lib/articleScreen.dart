import 'dart:convert';

import 'package:example_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'Model/model.dart';

final String APIkey = "4fcd380d9925497ab01b40350b4f7d7d";

Future<List<Article>> fetchArticleBySource(String source) async {
  final response = await http.get(
      'https://newsapi.org/v2/top-headlines?sources=${source}&apiKey=${APIkey}');

  if (response.statusCode == 200) {
    List article = json.decode(response.body)['articles'];
    return article.map((article) => new Article.fromJson(article)).toList();
  } else {
    throw Exception('Failed to load article list');
  }
}

class SourceScreen extends StatefulWidget {
  final Source source;

  SourceScreen({Key key, @required this.source}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SourceScreenState();
}

class SourceScreenState extends State<SourceScreen> {
  var list_articles;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    refreshListArticle();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }

  Future<dynamic> refreshListArticle() async {
    refreshKey.currentState?.show(atTop: false);

    setState(() {
      list_articles = fetchArticleBySource(widget.source.id);
    });
    return null;
  }
}
