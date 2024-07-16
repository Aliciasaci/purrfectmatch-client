import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/cupertino.dart';

const kWindowsScheme = 'purrfect-match';

final class DynamicLinkHandler {
  DynamicLinkHandler._();

  static final instance = DynamicLinkHandler._();

  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  Future<void> initialize() async {
    // Check initial link if app was in cold state (terminated)
    final appLink = await _appLinks.getInitialLink();
    if (appLink != null) {
      print(' here you can redirect from url as per your need ');
      var uri = Uri.parse(appLink.toString());
      _handleLinkData(uri);
    }

    // Handle link when app is in warm state (front or background)
    _linkSubscription = _appLinks.uriLinkStream.listen((uriValue) {
      print(' you will listen any url updates ');
      print(' here you can redirect from url as per your need ');
      _handleLinkData(uriValue);
    }, onError: (err){
      debugPrint('====>>> error : $err');
    }, onDone: () {
      _linkSubscription?.cancel();
    },);
  }

  /// Handles the link navigation Dynamic Links.
  void _handleLinkData(Uri data) {
    final queryParams = data.queryParameters;
    log(data.toString(), name: 'Dynamic Link Service');
    if (queryParams.isNotEmpty) {
      // Perform navigation as needed.
      // Get required data by [queryParams]
    }
  }
}