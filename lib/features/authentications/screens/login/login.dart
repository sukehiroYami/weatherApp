import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/style/spacing_style.dart';
import '../../../personalization/weather/screens/home/home_page.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import 'widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: SpacingStyle.paddingWithAppBarHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// form
            const LoginForm(),

            const SizedBox(height: Sizes.spaceBtwSections),

            // sign in
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.to(() => HomePage()),
                child: const Text(Texts.signIn),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
