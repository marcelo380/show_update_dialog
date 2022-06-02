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

Future<VersionModel?> getVersionInfo(String? androidId, String? iOSId, String? iOSAppStoreCountry) async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  if (Platform.isIOS) {
    return _getiOSStoreVersion(packageInfo, iOSId, iOSAppStoreCountry);
  } else if (Platform.isAndroid) {
    return _getAndroidStoreVersion(packageInfo, androidId);
  } else {
    debugPrint('The target platform "${Platform.operatingSystem}" is not yet supported by this package.');
  }
}

/// iOS info is fetched by using the iTunes lookup API, which returns a
/// JSON document.
Future<VersionModel?> _getiOSStoreVersion(PackageInfo packageInfo, String? iOSId, String? iOSAppStoreCountry) async {
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
  return VersionModel(
    localVersion: packageInfo.version,
    storeVersion: jsonObj['results'][0]['version'],
    appStoreLink: jsonObj['results'][0]['trackViewUrl'],
    releaseNotes: jsonObj['results'][0]['releaseNotes'],
  );
}

/// Informações da playstore

Future<VersionModel?> _getAndroidStoreVersion(PackageInfo packageInfo, String? androidId) async {
  final id = androidId ?? packageInfo.packageName;
  final uri = Uri.https("play.google.com", "/store/apps/details", {"id": "$id"});
  final response = await http.get(uri);
  if (response.statusCode != 200) {
    debugPrint('Can\'t find an app in the Play Store with the id: $id');
    return null;
  }
  final document = parse(response.body);

  String storeVersion = '0.0.0';
  String? releaseNotes;

  final additionalInfoElements = document.getElementsByClassName('hAyfc');
  if (additionalInfoElements.isNotEmpty) {
    final versionElement = additionalInfoElements.firstWhere(
      (elm) => elm.querySelector('.BgcNfc')!.text == 'Current Version',
    );
    storeVersion = versionElement.querySelector('.htlgb')!.text;

    final sectionElements = document.getElementsByClassName('W4P4ne');
    final releaseNotesElement = sectionElements.firstWhereOrNull(
      (elm) => elm.querySelector('.wSaTQd')!.text == 'What\'s New',
    );
    releaseNotes = releaseNotesElement?.querySelector('.PHBdkd')?.querySelector('.DWPxHb')?.text;
  } else {
    final scriptElements = document.getElementsByTagName('script');
    final infoScriptElement = scriptElements.firstWhere(
      (elm) => elm.text.contains('key: \'ds:4\''),
    );

    final param = infoScriptElement.text
        .substring(20, infoScriptElement.text.length - 2)
        .replaceAll('key:', '"key":')
        .replaceAll('hash:', '"hash":')
        .replaceAll('data:', '"data":')
        .replaceAll('sideChannel:', '"sideChannel":')
        .replaceAll('\'', '"')
        .replaceAll('owners\"', 'owners');
    final parsed = json.decode(param);
    print(parsed['data']);
    final data = parsed['data'];

    storeVersion = data[1][2][140][0][0][0];
    if (data[1][2][144][1] != null) {
      releaseNotes = data[1][2][144][1][1];
    } else {
      releaseNotes = '';
    }
  }

  return VersionModel(
    localVersion: packageInfo.version,
    storeVersion: storeVersion,
    appStoreLink: uri.toString(),
    releaseNotes: releaseNotes,
  );
}
