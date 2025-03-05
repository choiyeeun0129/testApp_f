import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gnu_mot_t/bloc/lobby/identification_bloc.dart';
import 'package:gnu_mot_t/component/basic/basic_text_field.dart';
import 'package:gnu_mot_t/component/basic_container.dart';
import 'package:gnu_mot_t/component/basic_text.dart';
import 'package:gnu_mot_t/component/common/height_box.dart';
import 'package:gnu_mot_t/component/common/width_box.dart';
import 'package:gnu_mot_t/component/indicator_widget.dart';
import 'package:gnu_mot_t/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gnu_mot_t/router/app_routes.dart';

class IdentificationPage extends StatefulWidget {
  const IdentificationPage({super.key});

  @override
  _IdentificationPageState createState() => _IdentificationPageState();
}

class _IdentificationPageState extends State<IdentificationPage> with TickerProviderStateMixin {
  final IdentificationBloc _bloc = IdentificationBloc();

  final TextEditingController textEditingController = TextEditingController();

  _onClickIdentify(){
    var number = textEditingController.text;
    number = number.replaceAll("-", "");
    if(number.length == 11){
      _bloc.add(DoIdentification(number));
    }else {
      Fluttertoast.showToast(msg: "전화번호는 11자리로 입력해주세요.");
    }
  }

  _onListenBloc(BuildContext context, IdentificationState state){
    if(state is IdentificationDefault){
      if(state.message != null){
        Fluttertoast.showToast(msg: state.message!);
      }
    }else if(state is IdentificationNotEnrolled){
      Navigator.of(context).pushNamed(routeTermPage);
    }else if(state is IdentificationActive){
      Navigator.of(context).pushReplacementNamed(routeLoginPage);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _body;
  }
}

extension on _IdentificationPageState {
  Widget get _body {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: BlocListener(
          bloc: _bloc,
          listener: _onListenBloc,
          child: BlocBuilder(
            bloc: _bloc,
            builder: (_, IdentificationState state) {
              return Stack(
                children: [
                  Column(
                    children: [
                      const HeightBox(22),
                      const BasicText("본인인증", 23, 33, FontWeight.w700),
                      const HeightBox(25),
                      const BasicText("본인인증을 위해 휴대전화 번호를 입력하세요", 14, 20, FontWeight.w400),
                      const HeightBox(25),
                      Row(
                        children: [
                          const WidthBox(18),
                          Expanded(
                            child: BasicContainer(
                              height: 56,
                              child: BasicTextField("전화번호를 입력하세요", textEditingController, onChanged: (text) {
                                String filteredText = text.replaceAll(RegExp(r'[^0-9]'), '');

                                if (filteredText.length > 11) {
                                  filteredText = filteredText.substring(0, 11);
                                }
                                textEditingController.text = filteredText;
                                textEditingController.selection = TextSelection.fromPosition(
                                  TextPosition(offset: filteredText.length),
                                );
                              },),
                            ),
                          ),
                          const WidthBox(10),
                          GestureDetector(
                            onTap: _onClickIdentify,
                            child: const BasicContainer(
                              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                              backgroundColor: AppColors.black,
                              child: BasicText("인증요청", 14, 17, FontWeight.w500, textColor: Colors.white),
                            ),
                          ),
                          const WidthBox(18),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                  if(state is IdentificationLoading) const IndicatorWidget(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}