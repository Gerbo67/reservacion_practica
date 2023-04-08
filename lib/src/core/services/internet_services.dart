import 'dart:io';

class InternetServices {
  InternetServices._();

  static final instance = InternetServices._();

  Future<bool> connected() async {
    try {
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].address.isNotEmpty) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}