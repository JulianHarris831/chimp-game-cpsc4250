import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> isAutoLogin() async {
  const FlutterSecureStorage storage = FlutterSecureStorage();
  final String? email = await storage.read(key: 'email');
  final String? password = await storage.read(key: 'password');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final int? lastLogin = prefs.getInt('last_login');
  if (lastLogin == null) {
    return false;
  }
  final int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
  final int timeDiffInMinutes = (currentTimestamp - lastLogin) ~/
      60000; // Convert time difference to minutes

  //auto login once every 7 days ()
  if (timeDiffInMinutes <= 10080) {
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email!,
      password: password!,
    );

    // Update the last login timestamp
    await prefs.setInt('last_login', currentTimestamp);

    return true;
  }

  return false;
}
