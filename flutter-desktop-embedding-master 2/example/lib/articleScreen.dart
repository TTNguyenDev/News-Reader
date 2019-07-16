import 'dart:convert';

import 'package:example_flutter/DemoWebView.dart';
import 'package:example_flutter/main.dart';
import 'package:example_flutter/webView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'Model/model.dart';
import 'const.dart';

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

class ArticleScreen extends StatefulWidget {
  final Source source;

  ArticleScreen({Key key, @required this.source}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ArticleScreenState();
}

class ArticleScreenState extends State<ArticleScreen> {
  var list_articles;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    refreshListArticle();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'EDMT NEWS',
        theme: ThemeData(primarySwatch: Colors.teal),
        home: Scaffold(
            appBar: AppBar(
              title: Text('${widget.source.name}'),
              actions: <Widget>[
                new IconButton(
                  icon: new Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
            body: Center(
              child: RefreshIndicator(
                  key: refreshKey,
                  child: FutureBuilder<List<Article>>(
                    future: list_articles,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      } else if (snapshot.hasData) {
                        List<Article> articles = snapshot.data;
                        return ListView(
                            children: articles
                                .map((article) => GestureDetector(
                                      onTap: () {
                                        //Demo webView
                                        Navigator.push(context, new MaterialPageRoute(builder: (context) => new DemoWebView()));
                                        // Navigator.push(context, new MaterialPageRoute(builder: (context) => new WikipediaExplorer()));
                                      },
                                      child: Card(
                                        elevation: 1.0,
                                        color: Colors.white,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 8.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 20.0,
                                                      horizontal: 4.0),
                                              width: 100.0,
                                              height: 100.0,
                                              child: article.urlToImage != null
                                                  ? Image.network(
                                                      article.urlToImage)
                                                  : Image.asset(
                                                      "assets/news.png"),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8.0,
                                                                  top: 20.0,
                                                                  bottom: 10.0),
                                                          child: Text(
                                                            '${article.title}',
                                                            style: TextStyle(
                                                                fontSize: 18.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Text(
                                                      '${article.description}',
                                                      style: TextStyle(
                                                          fontSize: 10.0,
                                                          color: Colors.grey,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 8.0,
                                                            top: 10.0,
                                                            bottom: 10.0),
                                                    child: Text(
                                                      'Published At: ${article.publishedAt}',
                                                      style: TextStyle(
                                                          fontSize: 10.0,
                                                          color: Colors.black38,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ))
                                .toList());
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                  onRefresh: refreshListArticle),
            )));
  }

  Future<dynamic> refreshListArticle() async {
    refreshKey.currentState?.show(atTop: false);

    setState(() {
      list_articles = fetchArticleBySource(widget.source.id);
    });
    return null;
  }
}
