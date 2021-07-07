import 'package:flutter/material.dart';

class DefaultUpdatePage extends StatefulWidget {
  String? currentVersion;
  String? storeVersion;
  VoidCallback? storeAction;
  String? releaseNotes;
  DefaultUpdatePage(
      {@required this.currentVersion,
      @required this.storeVersion,
      @required this.storeAction,
      @required this.releaseNotes});

  @override
  _DefaultUpdatePageState createState() => _DefaultUpdatePageState();
}

class _DefaultUpdatePageState extends State<DefaultUpdatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("Versão atual: ${widget.currentVersion}")],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("Versão disponivel: ${widget.storeVersion}")],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(" ${widget.releaseNotes}")],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("---------------------")],
          ),
          RaisedButton(
            child: Text("Atualizar"),
            onPressed: widget.storeAction,
          )
        ],
      ),
    );
  }
}
