library new_version;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:show_update_dialog/src/class/version_status.dart';
import 'package:show_update_dialog/src/helper.dart';
import 'package:show_update_dialog/src/pages/default_update_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowUpdateDialog {
  ///é usado para sobrescrever o id da applestore
  final String? iOSId;

  ///é usado para sobrescrever o nome do aplicativo caso ele esteja com outro nome na playstore.
  final String? androidId;

  /// atenção você precisa definir esse parametro se seu app estiver publicado apenas fora dos EUA
  /// veja a sigla do seu pais em http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
  final String? iOSAppStoreCountry;

  ///dias se usuario clicar relembrar se 0 não exibi relembrar
  final int? rememberInDays;

  ///bloqueia o app até usuario atualizar
  bool? forceUpdate;

  ShowUpdateDialog({
    this.androidId,
    this.iOSId,
    this.iOSAppStoreCountry,
    this.rememberInDays = 0,
    this.forceUpdate = false,
  });

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future fetchVersionInfo() =>
      getVersionInfo(androidId, iOSId, iOSAppStoreCountry);

  void showSimplesDialog(context, {bool forceUpdate = false}) async {
    final VersionModel? versionStatus = await fetchVersionInfo();
    if (versionStatus != null && versionStatus.updateExist) {
      showCustomDialogUpdate(
          context: context,
          versionStatus: versionStatus,
          forceUpdate: forceUpdate);
    }
  }

  void showCustomDialogUpdate({
    required BuildContext context,
    required VersionModel versionStatus,
    String title = 'Mantenha-se atualizado.',
    String buttonText = 'Atualizar',
    Color buttonColor = const Color(0xFF1E88E5),
    bool forceUpdate = false,
    Widget? bodyoverride,
    Widget? overridebottomNavigationBar,
  }) async {
    if (versionStatus != null && versionStatus.updateExist) {
      var route = MaterialPageRoute(
        builder: (context) => DefaultUpdatePage(
          title: title,
          buttonText: buttonText,
          buttonColor: buttonColor,
          currentVersion: versionStatus.localVersion,
          storeVersion: versionStatus.storeVersion,
          releaseNotes: versionStatus.releaseNotes,
          bodyoverride: bodyoverride,
          bottomNavigationBar: overridebottomNavigationBar,
          storeAction: () => _launchAppStore(versionStatus.appStoreLink),
        ),
      );

      if (forceUpdate) {
        Navigator.pushReplacement(
          context,
          route,
        );
      } else {
        Navigator.push(
          context,
          route,
        );
      }
    }
  }

  Future<bool> _rememberIfNecessary() async {
    final SharedPreferences prefs = await _prefs;
    String? rememberDate = prefs.getString('rememberDate');
    DateTime dt = DateTime.parse(rememberDate!);

    if (dt.compareTo(DateTime.now()) > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _setDateRemember(int days) async {
    DateTime newDate = DateTime.now().add(Duration(days: days));
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('rememberDate', "$newDate");
    print("gravou data hoje: ${DateTime.now()} para $newDate");

    return true;
  }

  void _launchAppStore(String appStoreLink) async {
    debugPrint(appStoreLink);
    if (await canLaunch(appStoreLink)) {
      await launch(appStoreLink);
    } else {
      throw 'Não foi possivel abrir o link da loja!';
    }
  }
}
