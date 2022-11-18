import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mbanking_app/src/widgets/db_provider.dart';

class AuthService {
  static Future<bool> authenticateUser(bool? value) async {
    final LocalAuthentication localAuthentication = LocalAuthentication();

    bool isAuthenticated = false;

    bool isBiometricSupported = await localAuthentication.isDeviceSupported();

    bool canCheckBiometrics = await localAuthentication.canCheckBiometrics;

    if (isBiometricSupported && canCheckBiometrics) {
      try {
        isAuthenticated = await localAuthentication.authenticate(
            localizedReason: 'Scan your fingerprint to authenticate',
            options: const AuthenticationOptions(
                biometricOnly: true,
                stickyAuth: false,
                useErrorDialogs: false));
        if (isAuthenticated == true) {
          DbProvider().saveAuthState(value!);
        } else {}
      } on PlatformException catch (e) {
        if (e.code == auth_error.notEnrolled) {
          // Add handling of no hardware here.
        } else if (e.code == auth_error.lockedOut ||
            e.code == auth_error.permanentlyLockedOut) {
          // ...
        } else {
          // ...
        }
      }
    } else {}
    return isAuthenticated;
  }
}
