# MCM Project

This repository contains a Go backend and two client applications:

- **client-main** – original Flutter app
- **client-expo** – React Native Expo version

## React Native (Expo) Client

The Expo app lives under `client-expo/`. To run it:

```bash
cd client-expo
npm install        # install dependencies
npx expo start     # start Expo development server
```

The login screen expects the backend to be running at `http://13.115.212.233:8080` (adjust `BASE_URL` in `app/login.tsx` if needed).

## Go Backend

The Go server is located in `server-main/server-main` and requires a MySQL database. See comments in the code for connection details.

```bash
cd server-main/server-main
go mod download
go run .
```

## Flutter Client

The original Flutter app resides in `client-main/client-main`. Run it with:

```bash
cd client-main/client-main
flutter pub get
flutter run
```

Use the same backend URL by editing `lib/api/api_service.dart` if needed.
