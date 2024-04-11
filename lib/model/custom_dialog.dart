import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDialog {
  static void sqliteInsertDialog(
      String title, String middleText, BuildContext context) {
    Get.defaultDialog(
      title: title,
      titleStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      middleText: middleText,
      middleTextStyle: const TextStyle(
        fontSize: 16,
      ),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            Get.back();
          },
          child: const Text(
            'OK',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------

  static void sqliteDeleteDialog(
      String title, String middleText, BuildContext context) {
    Get.defaultDialog(
      title: title,
      titleStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      middleText: middleText,
      middleTextStyle: const TextStyle(
        fontSize: 16,
      ),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text(
            'OK',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------

  static void firebaseInsertDialog(
      String title, String middleText, BuildContext context) {
    Get.defaultDialog(
      title: title,
      titleStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      middleText: middleText,
      middleTextStyle: const TextStyle(
        fontSize: 16,
      ),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            Get.back();
          },
          child: const Text(
            'OK',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------

  static void firebaseDeleteDialog(
      String title, String middleText, BuildContext context) {
    Get.defaultDialog(
      title: title,
      titleStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      middleText: middleText,
      middleTextStyle: const TextStyle(
        fontSize: 16,
      ),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text(
            'OK',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
} // End
