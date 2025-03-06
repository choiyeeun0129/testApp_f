import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testApp/bloc/home/mot/mot_bloc.dart';
import 'package:testApp/component/basic_container.dart';
import 'package:testApp/component/basic_text.dart';
import 'package:testApp/component/common/height_box.dart';
import 'package:testApp/component/common/navigation.dart';
import 'package:testApp/component/common/width_box.dart';
import 'package:testApp/component/indicator_widget.dart';
import 'package:testApp/constant/colors.dart';
import 'package:testApp/model/code.dart';
import 'package:testApp/router/app_routes.dart';
import 'package:flutter/material.dart';

class MotPage extends StatefulWidget {
  const MotPage({super.key});

  @override
  _MotPageState createState() => _MotPageState();
}

class _MotPageState extends State<MotPage> with TickerProviderStateMixin {
  final MotBloc _bloc = MotBloc();
  
  _onClickMot(Code code) {
    Map<String, dynamic> args = {
      "name": code.name,
      "type": "BATCH",
      "code": code.code,
    };
    Navigator.pushNamed(context, routeGroupPage, arguments: args);
  }

  @override
  void initState() {
    super.initState();
    _bloc.add(InitMot());
  }

  @override
  Widget build(BuildContext context) {
    return _body;
  }
}

extension on _MotPageState {
  Widget get _body {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: BlocBuilder(
          bloc: _bloc,
          builder: (_, state){
            return Column(
              children: [
                const Navigation(title: "MOT 전체"),
                if(state is MotYet) const Expanded(child: IndicatorWidget()),
                if(state is MotFail) Expanded(child: Center(child: BasicText(state.message, 16, 28, FontWeight.w400))),
                if(state is MotDefault) Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: ListView.separated(
                      itemCount: state.motList.length,
                      itemBuilder: (_, index) => motItem(state.motList[index]),
                      separatorBuilder: (_, index) => const HeightBox(12),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget motItem(Code code) {
    return GestureDetector(
      onTap: () => _onClickMot(code),
      child: BasicContainer(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.account_circle_rounded, size: 48, color: Color(0xff2155A8)),
            const WidthBox(16),
            Expanded(child: BasicText(code.name, 16, 28, FontWeight.w400)),
            const WidthBox(16),
            const Icon(Icons.keyboard_arrow_right_rounded, size: 30, color: AppColors.black),
          ],
        ),
      ),
    );
  }
}