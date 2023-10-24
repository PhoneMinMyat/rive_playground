import 'package:flutter/material.dart';
import 'package:focused/bloc/log_in_bloc.dart';
import 'package:focused/constants/dimens.dart';
import 'package:focused/constants/strings.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

class LogInPage extends StatelessWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LogInBloc(),
      child: Consumer<LogInBloc>(
        builder: (context, bloc, child) => Scaffold(
          backgroundColor: const Color(0xffD6E2EA),
          body: Stack(
            children: [
              //  Positioned.fill(child: SizedBox()),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2x),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: double.infinity,
                        height: 300,
                        child: bloc.riveArtboard == null
                            ? const SizedBox()
                            : Rive(artboard: bloc.riveArtboard!)),
                
                    // Email Text Field
                    CustomTextField(
                      labelText: kEmailLabel,
                      hintText: kEmailHint,
                      focusNode: bloc.emailFocus,
                      errorText: bloc.emailError,
                      onChanged: (value) {
                        bloc.changeEmail(value);
                      },
                    ),
                    const SizedBox(
                      height: MARGIN_MEDIUM_2x,
                    ),
                
                    // Password Text Field
                    CustomTextField(
                      labelText: kPasswordLabel,
                      hintText: kPasswordHint,
                      focusNode: bloc.passwordFocus,
                      isPassword: true,
                      isPasswordShow: bloc.isPasswordShow,
                      helperText: bloc.passwordApprovedText,
                      errorText: bloc.passwordError,
                      onChanged: (value) {
                        bloc.changePassword(value);
                      },
                      onTapVisibility: () {
                        bloc.onTapShowPassword();
                      },
                    ),
                    const SizedBox(
                      height: MARGIN_MEDIUM_2x,
                    ),
                
                    // Log in button Text
                    LogInButton(
                      isEnable: bloc.isLogInButtonEnable,
                      onTap: () {
                        bloc.onTapLogIn().then((value) {
                          if (value) {}
                        });
                      },
                    )
                  ],
                ),
              ),
              Visibility(
                visible: bloc.isLoading,
                child: Container(
                  // height: double.infinity,
                  color: Colors.black12,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LogInButton extends StatelessWidget {
  final Function onTap;
  final bool isEnable;
  const LogInButton({
    super.key,
    required this.onTap,
    required this.isEnable,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width: double.infinity,
        height: kButtonHeight,
        decoration: BoxDecoration(
            color: isEnable ? Colors.blueAccent : Colors.grey,
            borderRadius: BorderRadius.circular(kButtonBorderRadius)),
        child: const Center(
          child: Text(
            kLogInBtnText,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final String? errorText;
  final Function(String) onChanged;
  final bool isPassword;
  final bool isPasswordShow;
  final bool isNumber;
  final bool isPhoneNumber;
  final String? helperText;
  final FocusNode focusNode;
  final Function? onTapVisibility;
  const CustomTextField(
      {super.key,
      required this.labelText,
      required this.hintText,
      this.helperText,
      this.errorText,
      required this.onChanged,
      this.isPassword = false,
      this.isPasswordShow = true,
      this.isNumber = false,
      this.isPhoneNumber = false,
      required this.focusNode,
      this.onTapVisibility});

  @override
  Widget build(BuildContext context) {
    const InputBorder kTextFieldNoBorder = InputBorder.none;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kTextFieldBorderRadius)),
      padding: EdgeInsets.only(
          left: MARGIN_MEDIUM_2x,
          right: MARGIN_MEDIUM_2x,
          top: MARGIN_MEDIUM,
          bottom: errorText != null ? MARGIN_MEDIUM_2x : MARGIN_MEDIUM),
      child: TextField(
        obscureText: !isPasswordShow,
        focusNode: focusNode,
        keyboardType: isNumber
            ? TextInputType.number
            : (isPhoneNumber ? TextInputType.phone : null),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            border: kTextFieldNoBorder,
            errorBorder: kTextFieldNoBorder,
            enabledBorder: kTextFieldNoBorder,
            disabledBorder: kTextFieldNoBorder,
            focusedErrorBorder: kTextFieldNoBorder,
            focusedBorder: kTextFieldNoBorder,
            helperText: helperText,
            helperStyle: const TextStyle(color: Colors.black),
            label: Text(labelText),
            labelStyle: const TextStyle(color: Colors.black),
            suffixIcon: (isPassword)
                ? GestureDetector(
                    onTap: () {
                      print('CALL ONTAP');
                      onTapVisibility?.call();
                    },
                    child: Icon((isPasswordShow)
                        ? Icons.visibility_off
                        : Icons.visibility),
                  )
                : null,
            hintText: hintText,
            errorText: errorText),
        onChanged: (value) {
          onChanged(value);
        },
      ),
    );
  }
}
