import 'package:flutter/material.dart';
import 'package:indoor_air_quality_check/pages/signin.dart';
import 'package:indoor_air_quality_check/pages/signup.dart';
import 'package:indoor_air_quality_check/theme/theme.dart';
import 'package:indoor_air_quality_check/widgets/custom_scaffold.dart';
import 'package:indoor_air_quality_check/widgets/welcome_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
              flex: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 40.0,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "AirSense",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 45.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 15,),
                      Text(
                        "Wellness begins with the Air you breathe.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                  // child: RichText(
                  //   textAlign: TextAlign.center,
                  //   text: const TextSpan(
                  //     children: [
                  //       TextSpan(
                  //           text: 'AirSense\n',
                  //           style: TextStyle(
                  //             fontSize: 45.0,
                  //             fontWeight: FontWeight.w600,
                  //           )),
                  //       TextSpan(
                  //           text:
                  //           'Wellness Begins with the Air You Breathe\n',
                  //           style: TextStyle(
                  //             fontSize: 20,
                  //             //height: 10,
                  //           ))
                  //     ],
                  //   ),
                  // ),
                ),
              )),
          Flexible(
            flex: 2,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  const Expanded(
                    child: WelcomeButton(
                      buttonText: 'Sign in',
                      onTap: SignInScreen(),
                      color: Colors.transparent,
                      textColor: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: WelcomeButton(
                      buttonText: 'Sign up',
                      onTap: const SignUpScreen(),
                      color: Colors.white,
                      textColor: lightColorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
