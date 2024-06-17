import 'dart:convert';
import 'package:http/http.dart' as http;


//
// IOS端末にPush通知を送信する際には  'content_available': true, を設定し、バックグラウンド時にデータの処理ができるようにする必要がある。
// Firebaseコンソールからはその設定ができないため、スクリプトを準備しました。
//
Future<void> sendNotification(String deviceToken, String title, String body) async {
  // この値はFirebaseコンソールから取得してください(APIキー、認証情報)
  const String serverKey = 'AIzaSyB3OL_mi9JYyOsdmLbFS7bKAkU-PFlWOYY';
  final Uri url = Uri.parse('https://fcm.googleapis.com/fcm/send');

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'key=$serverKey',
  };

  final bodyData = {
    'to': deviceToken,
    'content_available': true,
    'priority': 'high',
    'data': {
      'key1': 'value1',
      'key2': 'value2',
    },
    'notification': {
      'title': title,
      'body': body,
    },
  };

  final response = await http.post(
    url,
    headers: headers,
    body: json.encode(bodyData),
  );

  if (response.statusCode == 200) {
    print('Notification sent successfully');
  } else {
    print('Failed to send notification');
    print(response.body);
  }
}

void main() async {
  // FCMトークン
  const String deviceToken = 'eHQgWKFW7kXws-3vOgHOVj:APA91bFLzW_EWI1JNmQd5DVDnBlUVxiYRAW3y-9r6MU1QzAaNE8BDPtsfxBGdenof-ADOZNa8VrFMAhBSdOqXM2IU4renW3LI5-1IJdgy0Mj5Phkbuavpdhle0l3XkFzpg9jxDk-6Qzs';
  const String title = 'Test Notification';
  const String body = 'This is a test message with content_available set to true.';

  await sendNotification(deviceToken, title, body);
}
