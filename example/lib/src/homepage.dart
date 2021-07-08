import 'package:flutter/material.dart';
import 'package:show_update_dialog/main.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title = ''}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    verifyVersion();
  }

  verifyVersion() async {
    final versionCheck = ShowUpdateDialog(
        iOSId: 'br.com.sbsistemas.simplescteapp',
        androidId: 'br.com.sbsistemas.simplescteapp',
        iOSAppStoreCountry: 'BR');

    final VersionModel vs = await versionCheck.fetchVersionInfo();

    int typeDemo = 0; // 0 simples, 1 custom dialog, 2 overide

    switch (typeDemo) {
      case 0:
        versionCheck.showSimplesDialog(context);
        break;
      case 1:
        versionCheck.showCustomDialogUpdate(
          context: context,
          versionStatus: vs,
          buttonColor: Colors.black,
          buttonText: "Update :D",
          title: "Estamos mais novos do que nunca!",
          forceUpdate: true,
        );
        break;
      case 2:
        versionCheck.showCustomDialogUpdate(
          context: context,
          versionStatus: vs,
          buttonText: "Update",
          buttonColor: Colors.green,
          bodyOveride: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.update,
                    size: 150,
                    color: Colors.green,
                  ),
                ],
              ),
              Text(
                "Please update your app",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              Text(
                "Local version: ${vs.localVersion}",
                style: TextStyle(fontSize: 17),
              ),
              Text(
                "Store version: ${vs.storeVersion}",
                style: TextStyle(fontSize: 17),
              ),
              SizedBox(height: 30),
              Text(
                "${vs.releaseNotes}",
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        );

        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
