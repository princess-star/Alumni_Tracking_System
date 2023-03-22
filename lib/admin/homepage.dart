import 'package:alumni_tracking_system/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

/*//class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Image(
            image: AssetImage("res/pic/logo.png"),
            width: 150,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut().then((value) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: ((context) => LoginPage())));
                });
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }
}*/

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final LocalAuthentication auth;
  bool _supportState = false;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();

    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() {
            _supportState = isSupported;
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Biometrics Authentication'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (_supportState)
            const Text('This device is supported')
          else
            const Text('This Device is not supported'),

          const Divider(height: 100),
          //get available biometrics type
          ElevatedButton(
            onPressed: _getAvailableBiometrics,
            child: const Text('Get available biometrics'),
          ),
          const Divider(height: 100),
          //Authenticate
          ElevatedButton(
            onPressed: _authenticate,
            child: Text('Authenticate'),
          ),
        ],
      ),
    );
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason:
            'Subscribe or you will never find any stack overflow answer',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      print("Authenticated : $authenticated");
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    print("List of availableBiometrics : $availableBiometrics");

    if (!mounted) {
      return;
    }
    // than we can call setState
  }
}
