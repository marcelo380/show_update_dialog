import 'package:flutter/material.dart';

class DefaultUpdatePage extends StatefulWidget {
  String? currentVersion;
  String? storeVersion;
  VoidCallback? storeAction;
  String? releaseNotes;
  String? title;
  String? buttonText;
  Color? buttonColor;

  DefaultUpdatePage(
      {@required this.currentVersion,
      @required this.storeVersion,
      @required this.storeAction,
      @required this.releaseNotes,
      @required this.buttonText,
      @required this.buttonColor,
      @required this.title});

  @override
  _DefaultUpdatePageState createState() => _DefaultUpdatePageState();
}

class _DefaultUpdatePageState extends State<DefaultUpdatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        //mainAxisAlignment: MainAxisAlignment.top,
        children: [
          Container(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "resources/download.png",
                package: 'show_update_dialog',
                height: MediaQuery.of(context).size.width / 1.2,
              ),
            ],
          ),
          Text(
            widget.title!,
            style: TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 2),
          Text(
            widget.releaseNotes!,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 15),
          Text(
            "Versão atual: ${widget.currentVersion}",
            style: TextStyle(fontSize: 15, color: Colors.grey[700]),
          ),
          Text(
            "Versão da loja: ${widget.storeVersion}",
            style: TextStyle(fontSize: 15, color: Colors.grey[700]),
          ),
          SizedBox(
            height: 80,
          ),
        ],
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ButtonUpdate(),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.5,
          ),
        ],
      ),
    );
  }

  Widget ButtonUpdate() => MaterialButton(
        height: 58,
        minWidth: 340,
        shape:
            RoundedRectangleBorder(borderRadius: new BorderRadius.circular(12)),
        onPressed: widget.storeAction,
        child: Text(
          widget.buttonText!,
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        color: widget.buttonColor,
      );
}
