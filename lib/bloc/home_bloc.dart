import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class HomeBloc extends ChangeNotifier {
  bool isDisposed = false;
  Artboard? riveArtboard;
  SMINumber? progress;

  int totalTreeProgress = 96;

  Duration countDown = const Duration(minutes: 1);
  Timer? timer;
  HomeBloc() {
    createTree();
  }

  void createTree() async {
    await rootBundle.load('assets/tree_demo.riv').then((data) async {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      var ctrl =
          StateMachineController.fromArtboard(artboard, 'State Machine 1');
      if (ctrl != null) {
        artboard.addController(ctrl);
        progress = ctrl.findSMI('input');
        riveArtboard = artboard;
        safeNotifyListeners();
      }
    });
  }

  void startTimer() {
    int totalTimer = countDown.inSeconds;
    double currentProgress = 0;
    double increaseProgress = totalTreeProgress / totalTimer;
    if (timer != null) {
      stopTimer();
    } else {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (countDown.inSeconds > 0) {
          currentProgress += increaseProgress;
          progress?.value = currentProgress;
          print(currentProgress);
          countDown = countDown - const Duration(seconds: 1);
          safeNotifyListeners();
        } else {
          stopTimer();
        }
      });
    }
  }

  void stopTimer() {
    if (timer != null) {
      timer!.cancel();
      timer = null;
      progress?.value = 0;
      countDown = const Duration(minutes: 1);
      safeNotifyListeners();
    }
  }

  void safeNotifyListeners() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }
}
