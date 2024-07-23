import 'dart:async';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobo_clinic/signup.dart';
import 'signup.dart';
import 'LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double opacity=0.0;
  @override
  void initState() {
    super.initState();
    // Start the fade-in effect after a short delay
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        opacity = 1.0;
      });
    });

   Timer(Duration(seconds: 3),(){
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SignUp()),
     );
   });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                  opacity: opacity,
                  duration: Duration(seconds: 2),
                  child: Image.asset("assets/logo.png")),
              SizedBox(height: 23,),
              AnimatedOpacity(
                  opacity: opacity,
                  duration: Duration(seconds: 2),
                  child: Text("Mobo Clinic",style: GoogleFonts.aBeeZee(textStyle:TextStyle(fontSize: 31)),)),
            ],
          ),
        ),
      ),
    );
  }
}