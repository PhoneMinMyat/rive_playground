import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class LogInBloc extends ChangeNotifier {
  bool isDisposed = false;
  String email = '';
  String? emailError;

  String password = '';
  String? passwordError;
  bool isPasswordShow = false;

  String? passwordApprovedText;

  bool isLogInButtonEnable = false;

  Artboard? riveArtboard;
  SMIBool? check;
  SMINumber? look;
  SMITrigger? success;
  SMITrigger? fail;
  SMIBool? handsup;

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  bool isLoading = false;

  LogInBloc() {
    createAnimation();
    // validateLogInButton();
    emailFocus.addListener(() {
      if (emailFocus.hasFocus) {
        changeHandup(false);
        changeCheck(true);
        changeLook(email.length.toDouble());
        safeNotifyListeners();
      }
    });
    passwordFocus.addListener(() {
      if (passwordFocus.hasFocus) {
        changeHandup(!isPasswordShow);
        changeCheck(true);
        changeLook(password.length.toDouble());
        safeNotifyListeners();
      }
    });
  }

  // ANIMATION

  void createAnimation() async {
    await rootBundle.load('assets/login_character.riv').then((data) async {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      var ctrl =
          StateMachineController.fromArtboard(artboard, 'State Machine 1');
      if (ctrl != null) {
        artboard.addController(ctrl);
        check = ctrl.findSMI('Check');
        look = ctrl.findSMI('Look');
        success = ctrl.findSMI('success');
        fail = ctrl.findSMI('fail');
        handsup = ctrl.findSMI('hands_up');
        riveArtboard = artboard;
        safeNotifyListeners();
      }
    });
  }

  void changeLook(double value) {
    look?.value = value;
    safeNotifyListeners();
  }

  void changeCheck(bool isCheck) {
    check?.value = isCheck;
    safeNotifyListeners();
  }

  void triggerSuccess() {
    if (success != null) {
      success?.fire();
    }
    safeNotifyListeners();
  }

  void triggerFail() {
    if (fail != null) {
      fail?.fire();
    }
    safeNotifyListeners();
  }

  Future<void> changeHandup(bool value) async {
    handsup?.value = value;
    safeNotifyListeners();
  }

  //--------------------------------------------------------------------

  // Email Section
  void changeEmail(String value) {
    email = value;
    emailError = null;
    changeLook(email.length.toDouble());
    validateLogInButton();
  }

  void validateEmail() {
    if (email.isEmpty) {
      emailError = 'Email is Empty';
      safeNotifyListeners();
      return;
    }
    String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    bool isEmailPatternCorrect = email.contains(RegExp(emailPattern));
    if (!isEmailPatternCorrect) {
      emailError = 'Email Pattern is not formatted';
      safeNotifyListeners();
      return;
    } else {
      emailError = null;
    }
  }

  //---------------------------------------------------------------

  // Password Section
  void changePassword(String value) {
    password = value;
    passwordError = null;
    changeLook(password.length.toDouble());
    validateLogInButton();
  }

  void validatePassword() {
    if (password.isEmpty) {
      passwordError = 'Password is empty';
      safeNotifyListeners();
      return;
    }
    if (password == '123456') {
      passwordError = 'Password is too easy';
      safeNotifyListeners();
      return;
    }

    if (password.length < 6) {
      passwordError = 'Password is too short';
      safeNotifyListeners();
      return;
    }

   
  }

  void onTapShowPassword() {
    isPasswordShow = !isPasswordShow;
    if (passwordFocus.hasFocus) {
      changeHandup(!isPasswordShow);
    }
    safeNotifyListeners();
  }

  //---------------------------------------------------------------

  // Log In Button Section

  Future<bool> onTapLogIn() async {
    emailFocus.unfocus();
    passwordFocus.unfocus();

    changeHandup(false);
    isLoading = true;
    safeNotifyListeners();
    await Future.delayed(const Duration(seconds: 2)).then((value) {
      isLoading = false;
      safeNotifyListeners();
    });
    validateEmail();
    validatePassword();
    validateLogInButton();
    if (isLogInButtonEnable) {
      if (email == 'correctemail@gmail.com') {
        triggerSuccess();
        return Future.value(true);
      } else {
        emailError = 'Wrong Email';
        triggerFail();
        return Future.value(false);
      }
    } else {
      triggerFail();

      return Future.value(false);
    }
  }

  void validateLogInButton() {
    isLogInButtonEnable = (emailError == null &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        passwordError == null);
    safeNotifyListeners();
  }

  void safeNotifyListeners() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    isDisposed = true;
    emailFocus.removeListener(() {});
    passwordFocus.removeListener(() {});
    super.dispose();
  }
}
