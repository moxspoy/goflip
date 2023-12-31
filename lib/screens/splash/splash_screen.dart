import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flip/blocs/user/user_bloc.dart';
import 'package:flip/constants/local_storage.dart';
import 'package:flip/constants/navigation.dart';
import 'package:flip/libraries/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  ConnectivityResult _connectionStatus = ConnectivityResult.mobile;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(_connectionStatus.name);
    if (_connectionStatus == ConnectivityResult.none) {
      return const Text('Error bos');
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          height: 300,
          width: 300,
          child: Lottie.asset('assets/animations/flip_loading_animation.json'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
      if (result != ConnectivityResult.none) {
        // delay 2s, move to other screen
        Future.delayed(const Duration(milliseconds: 500), () async {
          // Navigate to other screen
          String? savedToken =
              await SharedPrefs().getString(LocalStorageConstant().accessToken);
          String token = savedToken ?? '';

          if (token.isNotEmpty) {
            UserState userState = BlocProvider.of<UserBloc>(context).state;
            if (userState is UserDataState) {
              if (userState.name!.isEmpty) {
                context.go(NavigationRouteName.onBoardingName);
                return;
              }
              if (userState.pin! > 0) {
                context.push(
                    '${NavigationRouteName.onBoardingSetupPin}?name=${userState.name}');
                return;
              }
              context.go('${NavigationRouteName.home}?pin=${userState.pin}');
              return;
            }
          }

          context.go(NavigationRouteName.login);
        });
      }
    } on PlatformException catch (_) {
      _connectionStatus = ConnectivityResult.none;
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }
}
