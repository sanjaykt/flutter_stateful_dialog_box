import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Page',
      home: MyDialogBox(),
    );
  }
}

class MyDialogBox extends StatefulWidget {
  @override
  _MyDialogBoxState createState() => _MyDialogBoxState();
}

class _MyDialogBoxState extends State<MyDialogBox> {
  final Controller controller = Controller();
  int count = 0;
  bool runOnce = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dialog Box')),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Text('dialog box controller test..'),
            ),
            Center(
              child: RaisedButton(
                color: Colors.orange,
                child: Text('Show Dialog Box'),
                onPressed: () async {
                  controller.text = 'original text';
                  Future.delayed(Duration(seconds: 1), () {
                    print('future from screen...');
                    controller.updateText('updatedText - screen');
                    controller.setStateOfDialog();
                  });
                  await _buildProgressBar(context, controller);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _buildProgressBar(BuildContext context, Controller controller) async {
    await showDialog(
      context: context,
      builder: (_) {
        return DialogBox(controller);
      },
    );
  }
}

class DialogBox extends StatefulWidget {
  final Controller controller;

  DialogBox(this.controller);

  @override
  _DialogBoxState createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  int count = 0;
  bool runOnce = false;

  @override
  Widget build(BuildContext context) {
    if (!runOnce) {
      Future.delayed(Duration(seconds: 2), () {
        count += 1;
        print('future from dialog box...' + count.toString());
        widget.controller.updateText('updatedText');
        widget.controller.setStateOfDialog();
      });
      runOnce = true;
    }

    widget.controller.setStateOfDialog = () {
      setState(() {});
    };

    return AlertDialog(
      title: Column(
        children: <Widget>[
          Text("Alert Dialog Box"),
          Text('sub text'),
          Text(widget.controller.text),
        ],
      ),
    );
  }
}

class Controller {
  String text;
  Function setStateOfDialog;

  Controller({this.text, this.setStateOfDialog});

  setState() {
    this.setStateOfDialog();
  }

  updateText(updatedText) {
    text = updatedText;
  }
}
