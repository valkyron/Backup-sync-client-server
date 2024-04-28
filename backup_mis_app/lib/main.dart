import 'dart:io';
import 'package:backup_mis_app/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:backup_mis_app/services/notif_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:open_file/open_file.dart';
import 'dart:convert'; // Add this line to import the dart:convert library
import 'dart:async'; // Import async package for Timer
// import 'package:flutter_background_service/flutter_background_service.dart';s
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Downloader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String url = 'https://marmot-together-randomly.ngrok-free.app/download_backup';

// 'centralWoolDevelopmentBoard:woolboard_nic_in_mis_backup_tunnel' 

  Future<void> _downloadFile(BuildContext context) async {
  PermissionStatus status = await Permission.notification.request();
  bool hasStoragePermission = await CheckPermission().isStoragePermission();
  if (!status.isGranted) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Notification permission is required.'),
    ));
  } 

  if (!hasStoragePermission) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Storage permission is required.'),
    ));
    return;
  }


  const String username = 'centralWoolDevelopmentBoard';
  const String password = 'woolboard_nic_in_mis_backup_tunnel';

  final String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));

  final Map<String, String> headers = {
    'Authorization': basicAuth,
  };

  final response = await http.get(Uri.parse(url), headers: headers);


    // final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      const String fileName = 'backup.zip'; // You can change the file name if needed
      String path = "";
        if(Platform.isAndroid) {
          path = (await getExternalStorageDirectory())!.path;
          // Directory d = Directory('/storage/emulated/0');
          // if (d.existsSync()) {
          //   Directory(d.path + '/Android/data/com.example.backup_mis_app/files').createSync();
          //   File imgFile = File(d.path + '/Android/data/com.example.backup_mis_app/files/backup.zip');
          //   print('saving to ${imgFile.path}');
          //   imgFile.createSync();
          //   imgFile.writeAsBytes(response.bodyBytes);
          // }
        } else if(Platform.isIOS) {
          path = (await getApplicationDocumentsDirectory()).path;
        }      
      final File file = File('$path/$fileName');
      // print(path);
      await file.writeAsBytes(response.bodyBytes);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Backup synced successfully at $path'),
        // action: SnackBarAction(
        //   label: 'Open',
        //   onPressed: () async {
        //     OpenFile.open(path);
        //     // try {
        //     //   // openDirectory(path);
        //     //   // await OpenFile.open("/storage/emulated/0/Android/data");
        //     // } catch (e) {
        //     //   print('Error opening folder: $e');
        //     //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //     //     content: Text('Error opening folder: $e'),
        //     //   ));
        //     // }
        //   },
        // ),
      ));

      NotificationService().showNotification(
        title: 'Backup File Downloaded!',
        body: "Find your zip file at $path"
      );
      // showNotification('Backup downloaded!', 'Wuhooo');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No response from server'),
      ));
    }
  }

//   void openDirectory(String path) async {
//     try {
//       // Get the external storage directory
//       // String path = (await getExternalStorageDirectory())!.path;
//       // String path = directory.path;

//       // Open the directory
//       await Process.run('xdg-open', [path]);
//     } catch (e) {
      // print('Error opening directory: $e');
//     }
// }


  // void _startBackgroundTask() {
  //   // Schedule a background task to run every 1 hour
  //   FlutterBackgroundService.initialize(onStart);
  //   FlutterBackgroundService.scheduleTask(taskId: 0, delay: Duration(seconds: 1));
  // }

  // void _stopBackgroundTask() {
  //   FlutterBackgroundService.cancelTask(taskId: 0);
  // }

  // void onStart() {
  //   // This function will be executed periodically in the background
  //   _downloadFile(null); // Pass null for context since context isn't available in background
  //   FlutterBackgroundService.scheduleTask(taskId: 0, delay: Duration(hours: 1));
  //   FlutterBackgroundService.sendData(null);
  // }


  // void showNotification(String title, String description) async {
  //   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //       FlutterLocalNotificationsPlugin();

  //   const AndroidInitializationSettings initializationSettingsAndroid =
  //       AndroidInitializationSettings('app_icon');

  //   final InitializationSettings initializationSettings =
  //       InitializationSettings(android: initializationSettingsAndroid);

  //   await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails(
  //     'channel_id', // Change this to a unique value for your app
  //     'channel_name', // Change this to a unique value for your app
  //     // 'channel_description', // Change this to a unique value for your app
  //     importance: Importance.high,
  //     priority: Priority.high,
  //     ticker: 'ticker',
  //   );

  //   const NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);

  //   await flutterLocalNotificationsPlugin.show(
  //     0, // Notification ID, use a unique value for each notification
  //     title,
  //     description,
  //     platformChannelSpecifics,
  //     payload: 'item x',
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Backup'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _downloadFile(context),
              child: const Text('Create and Sync Backup'),
            ),
            // SizedBox(height: 20),
            // Text(
            //   'Find the download here (Android): Android/data/com.example.backup_mis_app/files/backup.zip',
            //   textAlign: TextAlign.center,
            //   style: TextStyle(fontSize: 16),
            // ),
          ],
        ),
      ),
    );
  }
}
