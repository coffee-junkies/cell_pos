import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreference {
  static SharedPreferences? _preferences;
  static const _keyUsername = "username";
  static const _keySaveReceiptSetting = "saveSetting";
  static const _keySaveClientSetting = "saveClient";
  static const _keyPrinterName = "printerName";
  static const _keyPrinterMacAddress = "printerMacAddress";

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setUsername(String username) async {
    await _preferences?.setString(_keyUsername, username);
  }

  static Future setSaveReceiptSetting(bool save) async{
    await _preferences?.setBool(_keySaveReceiptSetting, save);
  }

  static Future setClientSetting(bool save) async{
    await _preferences?.setBool(_keySaveClientSetting, save);
  }

  static Future setPrinter({required String printerName, required printerMacAddress})async{
    await _preferences?.setString(_keyPrinterName, printerName);
    await _preferences?.setString(_keyPrinterMacAddress, printerMacAddress);
  }


  static getUsername() => _preferences?.getString(_keyUsername);
  static getSaveSetting() => _preferences?.getBool(_keySaveReceiptSetting);
  static getClientSetting() => _preferences?.getBool(_keySaveClientSetting);
  static getPrinterName() => _preferences?.getString(_keyPrinterName);
  static getPrinterMacAddress() => _preferences?.getString(_keyPrinterMacAddress);
}