import 'package:flutter/material.dart';

import '../services/notification_preferences_manager.dart';

void showExplanationDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.95,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            const Text(
              'Get notified!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Stay on top of your trip when better offers or personalized suggestions are found',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 400),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: TextButton(
                    onPressed: () {
                      // Handle "Skip" button press
                    },
                    child: Text('Skip'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      requestPermission();
                      // Handle "I'm in" button press
                    },
                    child: Text("I'm in"),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
