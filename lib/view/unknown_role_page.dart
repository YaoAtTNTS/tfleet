

import 'package:flutter/material.dart';
import 'package:tfleet/view/login_page.dart';

class UnknownRolePage extends StatelessWidget {
  const UnknownRolePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('Unknown Role. Please change another account to login.'),
            ),
            TextButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
                child: const Text('Change Account')),
          ],
        ),
      ),
    );
  }
}
