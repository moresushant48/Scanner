import 'dart:io';

import 'package:local_auth/local_auth.dart';
import 'package:scanner/services/Prefs.dart';

class LocalAuth {
  final _auth = LocalAuthentication();
  bool _isProtectionEnabled = false;

  bool get isProtectionEnabled => _isProtectionEnabled;
  set isProtectionEnabled(bool enabled) => _isProtectionEnabled = enabled;

  bool isAuthenticated = false;

  LocalAuth() {
    prefService.getSharedBool(PrefService.IS_FP_ON).then((value) async {
      if (value) {
        authenticate().then((done) {
          if (!done) {
            exit(0);
          }
        });
      }
    });
  }

  Future<bool> isBiometricAvailable() async {
    return _auth.canCheckBiometrics;
  }

  Future<bool> authenticate() async {
    if (_isProtectionEnabled) {
      try {
        isAuthenticated = await _auth.authenticate(
          localizedReason: 'Authenticate to Access',
          useErrorDialogs: true,
          stickyAuth: true,
        );
      } on Exception catch (e) {
        print(e);
      }
    }
    return isAuthenticated;
  }

  void cancleAuthentication() {
    _auth.stopAuthentication();
  }
}

final localAuth = LocalAuth();
