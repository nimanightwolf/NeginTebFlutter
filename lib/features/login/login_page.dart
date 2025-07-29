import 'package:flutter/material.dart';
import 'package:neginteb/features/login/presentation/provider/auth_provider.dart';
import 'package:provider/provider.dart';


class LoginPage extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!authProvider.codeSent) ...[
                TextFormField(
                  controller: phoneController,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(labelText: 'شماره موبایل'),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    authProvider.sendSmsCode(phoneController.text, context);
                  },
                  child: Text("ارسال کد"),
                ),
              ] else ...[
                TextFormField(
                  textAlign: TextAlign.right,
                  controller: authProvider.codeController,
                  decoration: InputDecoration(labelText: 'کد تأیید'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    authProvider.verifyCode(context);
                  },
                  child: Text("تأیید کد"),
                ),
              ],
              if (authProvider.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(authProvider.error!,
                      style: TextStyle(color: Colors.red)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
