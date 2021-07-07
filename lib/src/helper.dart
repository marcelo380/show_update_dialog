import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:show_update_dialog/src/class/version_status.dart';

Future<VersionStatus?> getVersionStatus(
    String? androidId, String? iOSId, String? iOSAppStoreCountry) async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  if (Platform.isIOS) {
    return _getiOSStoreVersion(packageInfo, iOSId, iOSAppStoreCountry);
  } else if (Platform.isAndroid) {
    return _getAndroidStoreVersion(packageInfo, androidId);
  } else {
    debugPrint(
        'The target platform "${Platform.operatingSystem}" is not yet supported by this package.');
  }
}

/// iOS info is fetched by using the iTunes lookup API, which returns a
/// JSON document.
Future<VersionStatus?> _getiOSStoreVersion(
    PackageInfo packageInfo, String? iOSId, String? iOSAppStoreCountry) async {
  final id = iOSId ?? packageInfo.packageName;
  final parameters = {"bundleId": "$id"};
  if (iOSAppStoreCountry != null) {
    parameters.addAll({"country": iOSAppStoreCountry});
  }
  var uri = Uri.https("itunes.apple.com", "/lookup", parameters);
  final response = await http.get(uri);
  if (response.statusCode != 200) {
    debugPrint('Can\'t find an app in the App Store with the id: $id');
    return null;
  }
  final jsonObj = json.decode(response.body);
  return VersionStatus(
    localVersion: packageInfo.version,
    storeVersion: jsonObj['results'][0]['version'],
    appStoreLink: jsonObj['results'][0]['trackViewUrl'],
    releaseNotes: jsonObj['results'][0]['releaseNotes'],
  );
}

/// Informações da playstore
Future<VersionStatus?> _getAndroidStoreVersion(
    PackageInfo packageInfo, String? androidId) async {
  final id = androidId ?? packageInfo.packageName;
  final uri =
      Uri.https("play.google.com", "/store/apps/details", {"id": "$id"});
  final response = await http.get(uri);
  if (response.statusCode != 200) {
    debugPrint('Can\'t find an app in the Play Store with the id: $id');
    return null;
  }
  final document = parse(response.body);

  final additionalInfoElements = document.getElementsByClassName('hAyfc');
  final versionElement = additionalInfoElements.firstWhere(
    (elm) => elm.querySelector('.BgcNfc')!.text == 'Current Version',
  );
  final storeVersion = versionElement.querySelector('.htlgb')!.text;

  final sectionElements = document.getElementsByClassName('W4P4ne');
  final releaseNotesElement = sectionElements.firstWhereOrNull(
    (elm) => elm.querySelector('.wSaTQd')!.text == 'What\'s New',
  );
  final releaseNotes = releaseNotesElement
      ?.querySelector('.PHBdkd')
      ?.querySelector('.DWPxHb')
      ?.text;

  return VersionStatus(
    localVersion: packageInfo.version,
    storeVersion: storeVersion,
    appStoreLink: uri.toString(),
    releaseNotes: releaseNotes,
  );
}
