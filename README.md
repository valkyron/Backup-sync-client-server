# Backup-sync-client-server

- Flutter app to login (any auth can be used)
- Example flask server holding a backup.zip (timestampped)
- Flask server static link exposed using ngrok
  
Application
- A django server creating backups at regular intervals, multiple phone clients in sync with server.
- Master slave architecture
- Flutter posts notifications
- Authentication for clients using auth0

## Startup

- Get your own ngrok static link from <a href="https://ngrok.com/">here</a>
- paste it in flutter main.dart

Flask server <br>
```
python main.py
```

Flutter
```
flutter emulators --launch <emulator_name>
flutter run
```

