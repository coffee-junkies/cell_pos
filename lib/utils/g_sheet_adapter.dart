import 'package:gsheets/gsheets.dart';

class ReceiptSheetApi{
  static const _credentials = r''' 
  {
  "type": "service_account",
  "project_id": "laundrynikristine",
  "private_key_id": "431e736bbde6cd235c4cca329f18d87a65b189be",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDm01MsAY4j+uRa\nht9/ewajZ5OJ080YuvGlcBiXWOB8CBzepVp5lIz1xDHoQwxm5bfDToiZQCM4jNgG\n4ivf0YHE4eSgpuQdy00x5Ug8ecwR11Qr8OuEkTQpLqx5OK9yEx1K/s1ODW/NRDy/\nK/V+BzTo/hQm0dtFPJZ+8vD22BNOAJGUyIZ2t6NVjzr6YIXcty1EYI4HTOX9uKet\nilgMvAvekL7T9omKX41KJFa1J/xPxF1f6RjJ/154pvlxWnhTlu6uWopbvAQOfrS9\nsJndakuzUsrgXilCi6nMbWy3DfERFCKzSlEl1IgnWC9ffJBul28OXexfVBYZrpNi\nYpN0Of37AgMBAAECggEAC5nhFcFJlrxZisU5lBYnqhcevrAdoERmYxVkXwLxXA/U\n/PRcPOe+7UE8QuX6cxd7lL4si7Xsrz8WQm5OnIlSl4XE8GAYRKO++vwrlRfdWPjf\nZZ/5A6jVRsvuO4oiTejxBspnS34jDt2C8hbFrV0JBzwci4DuSidhPFB91OIyQjAZ\nBCktkOQNLWQ7HPxZImlsD+cTIWedGBIlMCMzbxQ2Xb567x6j0M6aGKMulMCB6v52\noiyiTGZxsMhx63y5LHLYaCCuA2m+zmDFc+nhKjSq7HYNvvtg9mP4IQZIKZKQzBxP\noVGyrLRF3TbRtSeb0Hbjeze0hAxsxbGgxBVjlC4iVQKBgQD6gC2MSth6ZhH1ISTd\ncAn3J8EawTnzCt5DBEaqF71WBy65uWFI7cDESa+qlMoVCk4CHlSpKI7GHyG5NtIJ\nxCbvlnZz3qDIYDAHrJ4h9vUrxB7s/HtEb1Djl8twaCnOdcID/64gLIigcranRfho\nBN0N9d8N1ggPx+nEUibk5PVPvQKBgQDr5JJYdF0CxBbcs31So6JH2IdUC2AtiTLf\nE2AHeEe/FKBCt0NGVBL4/STZUDkdfpwD7QmW8Rxj7BQtTxDpD6ZVrTZRk0nf5VCX\n5jWHAqT3BGjEBO8WYJINq6gL1nh9IAIMcKQUma2HwpFR5328PuADbwKtzGnlfGth\nicA1ntJkFwKBgFVMSDY5VjV3hC3gN1lfyUTruImPulfUH5LaZeWNZ99fWr3LLiFT\nNAyiurpvJ9C6TY3THijrspIsD6Ot0x+YN1nl9jfGWyFf/3rdgIs4OIvKoG06HA9V\niEm3aoLANVwkJQiPi49RGsTnyuJypP9miI80ZdukQeJ9xFAhWTUf8ZhRAoGAcr6p\nrVtVDw5hbJPmxzcPrlEWavxpmVzeoQJkuN16UOlwl2Nb1y74V6OTtB3A2qcGryYz\nfvfj7nscyXlnaWcSaySpgn7Z9Y4vaOQzb2wK4JmFeKxJvKHXCc1RHgkCbSMPvAti\n1R53+czcMXIgiFwxTZpHPFFtxZKDDVwbYjnSb5sCgYEAwdSpTwUCEYejXvw0vdgD\ns6IaG1iJ5bHQHNhW9SJlu7TgsWABOBEYKzE1mpZMeZSQn+BcNTHN6crXocitlHq/\nWL68zdg0utlA9juxipUhMXzV2LvTiqQTIfkSPGHljw5BNj9AGH5v0ytFh8GxnHmt\nJmvKMAQeEoP/blD5HbmlJlY=\n-----END PRIVATE KEY-----\n",
  "client_email": "laundrysheet@laundrynikristine.iam.gserviceaccount.com",
  "client_id": "112991762816825834245",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/laundrysheet%40laundrynikristine.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
} 
  ''';
  static const _spreadsheetId = '1GKhxFo__XT7i5vyvgYYOzsyaA4aYTMH36kHSN25Q8eE';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? receiptSheet;

  static Future<bool> init() async {
    try{
      final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
      // get worksheet by its title
      receiptSheet = spreadsheet.worksheetByTitle("Deliveries");
      // create worksheet if it does not exist yet
      receiptSheet ??= await spreadsheet.addWorksheet('Deliveries');
      return true;
    }catch(e){
      return false;
    }
  }

  static Future insert(List<String> rowList) async{
    if(receiptSheet == null) return;
    await receiptSheet!.values.appendRow(rowList);
  }

  static Future insertViaReceipt(List<String> rowList) async{
    if(receiptSheet == null) return false;
    bool isSuccess = await receiptSheet!.values.appendRow(rowList);
    return isSuccess;
  }

}