import 'package:flutter/material.dart';
import 'package:focused/bloc/home_bloc.dart';
import 'package:focused/constants/dimens.dart';
import 'package:focused/pages/log_in_page.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeBloc(),
      child: Consumer<HomeBloc>(
        builder: (context, bloc, child) => Scaffold(
          backgroundColor: Colors.green.shade700,
          appBar: AppBar(
            backgroundColor: Colors.green.shade900,
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LogInPage()));
                },
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1)),
                  child: const Icon(Icons.person),
                ),
              ),
              const SizedBox(
                width: MARGIN_MEDIUM_2x,
              )
            ],
          ),
          body: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'FOCUSED',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: TEXT_HEADING_2X,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: MARGIN_MEDIUM_2x,
                ),
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 10)),
                  width: 300,
                  height: 300,
                  child: (bloc.riveArtboard == null)
                      ? const SizedBox()
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(300),
                          child: Rive(
                            artboard: bloc.riveArtboard!,
                            alignment: Alignment.center,
                          ),
                        ),
                ),
                const SizedBox(
                  height: MARGIN_MEDIUM_2x,
                ),
                Text(
                  bloc.countDown.toString().split('.').first,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: TEXT_HEADING_2X,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: MARGIN_MEDIUM_2x,
                ),
                GestureDetector(
                  onTap: () {
                    bloc.startTimer();
                  },
                  child: Container(
                    width: 300,
                    height: 45,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(MARGIN_MEDIUM_2x)),
                    child: Center(
                      child: Text(
                        (bloc.timer == null) ? 'Start' : "Give Up",
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
