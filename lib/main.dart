import 'package:awesome_project01/providers/notification_provider.dart';
import 'package:awesome_project01/utils/native_sound.dart';
import 'package:badges/badges.dart' as badges;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

// TODO:iOS、macOS、ウェブ端末でPush通知を受信する場合には、ユーザーに権限を付与する必要があります。
// TODO:アプリを閉じると reverpod が状態を保持しないため、ローカルストレージを使用した処理に変更する。
// ③
// IOS、Androidデバイス共通の処理、アプリがバックグラウンド時にメッセージを受け取る処理
// Android端末の場合はこの処理がなくても通知を受け取ることができるが、細かな処理はできない。
//
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final container = ProviderContainer();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  setupTokenRefreshListener();

  // ④
  // アプリがフォアグラウンド状態にある場合にメッセージを受け取る処理
  //
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    container.read(notificationProvider.notifier).state = true;
    container.read(notificationCounterProvider.notifier).state ++;
    // ⑤
    // 通知音を再生する
    //
    NativeSound.playDefaultNotificationSound();

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  runApp(
      UncontrolledProviderScope(
        container: container,
        child: const MyApp(),
      ),
  );
}

// ①
// この処理は、アプリが初回起動した場合、または新しいFCMトークンが生成された場合に呼び出されます。
// この処理を使用すると従来使用していた、final fcmToken = await FirebaseMessaging.instance.getToken();を使用せずに
// 無駄なgetToken()の呼び出しを避けることができる。
//
void setupTokenRefreshListener() {
  FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
    print('新しいFCMトークン: $fcmToken');
    //  c5H92-5bQiCjjtPdQngjHk:APA91bF9O160F69isR_1GrFL0AoxXEqm36ZdE26LJJnVnRoOPlE8myH9-acfok6IViiBxDY-QlfnKHCHh-xCLi0I9q8YXu0r6QRBjCiIIn7LQfGQeN6Qk2-68t2GEWa0OjKs4
    // TODO: If necessary send token to application server.
  }).onError((err) {
    print('新しいFCMトークンの取得に失敗しました。');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  bool isBadgeVisible = false;

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    print("_handleMessageが起動しました。");
    // if (message.data['type'] == 'chat') {
    //   Navigator.pushNamed(context, '/chat',
    //     arguments: ChatArguments(message),
    //   );
    // }
  }
  @override
  void initState() {
    super.initState();

    // ②
    // 通知をタップしてアプリが開かれた場合の処理を実行する
    // 例えば特定の画面へ遷移する。。など
    //
    setupInteractedMessage();
  }

  int _counter = 0;

  void _incrementCounter() {
    ref.read(notificationCounterProvider.notifier).state --;
    if (ref.watch(notificationCounterProvider) == 0) {
      ref.read(notificationProvider.notifier).state = false;
    }
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      //
      // バッチを表示
      //
      floatingActionButton: badges.Badge(
        badgeContent: Text(ref.watch(notificationCounterProvider).toString(), style: TextStyle(fontSize: 20)),
        position: badges.BadgePosition.topEnd(top: -20, end: 40),
        showBadge: ref.watch(notificationProvider),
        ignorePointer: true,
        badgeStyle: const badges.BadgeStyle(
          borderSide: BorderSide(color: Colors.white, width: 1),
          padding: EdgeInsets.all(9),
        ),
        child: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

//const Icon(Icons.check, color: Colors.white, size: 20),