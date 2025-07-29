import 'package:flutter/material.dart';
import 'package:neginteb/features/login/presentation/provider/auth_provider.dart';
import 'package:provider/provider.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginProvider(),
      child: const LoginScreenContent(),
    );
  }
}

class LoginScreenContent extends StatelessWidget {
  const LoginScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginProvider>(context);

    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!provider.isCodeSent) ...[
                  TextField(
                    controller: provider.mobileController,
                    keyboardType: TextInputType.phone,
                    textAlign: TextAlign.right,
                    decoration: const InputDecoration(labelText: 'شماره موبایل'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: provider.sendMobile,
                    child: const Text('ارسال کد تأیید'),
                  ),
                ] else ...[
                  TextField(
                    controller: provider.codeController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.right,
                    decoration: const InputDecoration(labelText: 'کد فعال‌سازی'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(

                    onPressed: (){
                      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
                      loginProvider.verifyCode(context); // حواست باشه context بدی
                    },
                    child: const Text('تأیید و ورود'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
