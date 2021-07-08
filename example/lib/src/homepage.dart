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

    versionCheck.showCustomDialogUpdate(
      context: context,
      versionStatus: vs,
    );

    //versão simples de chamar o alerta
    //versionCheck.showSimplesDialog(context);
    // versionCheck.showDialogIfNecessary(context: context, versionStatus: vs);
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
