import 'package:flutter/services.dart';
import 'package:gnu_mot_t/bloc/splash_bloc.dart';
import 'package:gnu_mot_t/component/common/asset_widget.dart';
import 'package:gnu_mot_t/constant/assets.dart';
import 'package:gnu_mot_t/constant/colors.dart';
import 'package:gnu_mot_t/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final SplashBloc _bloc = SplashBloc();

  @override
  void initState() {
    super.initState();
    _bloc.add(InitSplash());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: _body,
    );
  }
}

extension on _SplashPageState {
  Widget get _body {
    return BlocListener(
      bloc: _bloc,
      listener: (BuildContext _, SplashState state) async {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        if(state is SplashLoginSuccess){
          Navigator.of(context).pushReplacementNamed(routeHomePage);
        } else if(state is SplashNeedLogin){
          Navigator.of(context).pushReplacementNamed(routeLoginPage);
        } else if(state is SplashNeedIdentification){
          Navigator.of(context).pushReplacementNamed(routeIdentificationPage);
        }
      },
      child: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Transform.translate(
                offset: Offset(-5, 0),
                child: AssetWidget(
                  Assets.pbnt_image,
                  width: MediaQuery.of(context).size.width * 0.75,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}