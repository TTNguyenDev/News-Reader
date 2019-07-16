import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DemoWebView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DemoWebViewState();
  }
  
  class DemoWebViewState extends State<DemoWebView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'DemoWebView',
      theme: ThemeData(primaryColor: Colors.teal),
      home: Scaffold(
        appBar: AppBar(
          title: Text('News content'),
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
        ),
      ),
    );
  }
    
}