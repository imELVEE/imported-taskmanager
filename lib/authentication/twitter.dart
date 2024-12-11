// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:twitter_login/twitter_login.dart';

// class TwitterAuth {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   // Twitter login method (v1)
//   Future<UserCredential?> login() async {
//     try {
//       final twitterLogin = TwitterLogin(
//         apiKey: 'GWQKrUpGWf9vVhUm9JbtCLD3M',
//         apiSecretKey: 'Z74WIDg4AdUet4C|KkhaVspujyCYHhiARQelZvZG8ofQy4JG3i',
//         redirectURI: 'example://',  // Ensure this matches what is configured in your Twitter Developer console
//       );

//       final authResult = await twitterLogin.login();
//       switch (authResult.status) {
//         case TwitterLoginStatus.loggedIn:
//           print('====== Login success ======');
//           print(authResult.authToken);
//           print(authResult.authTokenSecret);

//           // Sign in with Firebase using Twitter credentials
//           final twitterAuthCredential = TwitterAuthProvider.credential(
//             accessToken: authResult.authToken!,
//             secret: authResult.authTokenSecret!,
//           );
//           return await _auth.signInWithCredential(twitterAuthCredential);
//         case TwitterLoginStatus.cancelledByUser:
//           print('====== Login cancelled by user ======');
//           return null;
//         case TwitterLoginStatus.error:
//         case null:
//           print('====== Login error ======');
//           return null;
//       }
//     } catch (e) {
//       print('Error during Twitter login: $e');
//       return null;
//     }
//   }

//   // Twitter login method (v2)
//   Future<UserCredential?> loginV2() async {
//     try {
//       final twitterLogin = TwitterLogin(
//         apiKey: 'YOUR_TWITTER_API_KEY',
//         apiSecretKey: 'YOUR_TWITTER_API_SECRET_KEY',
//         redirectURI: 'example://',
//       );

//       final authResult = await twitterLogin.loginV2();
//       switch (authResult.status) {
//         case TwitterLoginStatus.loggedIn:
//           print('====== Login success ======');
//           // Sign in with Firebase using Twitter credentials
//           final twitterAuthCredential = TwitterAuthProvider.credential(
//             accessToken: authResult.authToken!,
//             secret: authResult.authTokenSecret!,
//           );
//           return await _auth.signInWithCredential(twitterAuthCredential);
//         case TwitterLoginStatus.cancelledByUser:
//           print('====== Login cancelled by user ======');
//           return null;
//         case TwitterLoginStatus.error:
//         case null:
//           print('====== Login error ======');
//           return null;
//       }
//     } catch (e) {
//       print('Error during Twitter login: $e');
//       return null;
//     }
//   }

//   // Logout method
//   Future<void> logout() async {
//     await _auth.signOut();
//   }
// }
