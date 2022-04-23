import 'package:flutter/material.dart';

Widget fondoApp() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset(0.0, 0.6),
          end: FractionalOffset(0.0, 1.0),
          colors: const [
            Color.fromARGB(255, 213, 129, 129),
            Color.fromRGBO(249, 251, 231, 1.0),
          ],
        ),
      ),
    );
  }