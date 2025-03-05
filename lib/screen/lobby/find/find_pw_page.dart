import 'dart:developer';

import 'package:gnu_mot_t/bloc/lobby/find/find_pw_bloc.dart';
import 'package:gnu_mot_t/component/basic/basic_button.dart';
import 'package:gnu_mot_t/component/basic/basic_text_field.dart';
import 'package:gnu_mot_t/component/basic_container.dart';
import 'package:gnu_mot_t/component/basic_text.dart';
import 'package:gnu_mot_t/component/common/height_box.dart';
import 'package:gnu_mot_t/component/common/navigation.dart';
import 'package:gnu_mot_t/component/common/width_box.dart';
import 'package:gnu_mot_t/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gnu_mot_t/router/app_routes.dart';
import 'package:gnu_mot_t/util/toast_helper.dart';

class FindPwPage extends StatefulWidget {
  const FindPwPage({super.key});

  @override
  _FindPwPageState createState() => _FindPwPageState();
}

class _FindPwPageState extends State<FindPwPage> with TickerProviderStateMixin {
  final FindPwBloc _bloc = FindPwBloc();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();

  _onClickFindPw() {
    var name = nameController.text;
    var id = idController.text;
    if (name.isNotEmpty && id.isNotEmpty) {
      log("비밀번호 찾기 요청: name=$name, id=$id, isEmail=$_isEmail");
      _bloc.add(DoFindPw(name, id, _isEmail));
    } else {
      // Fluttertoast.showToast(msg: "이름과 아이디를 입력하세요.");
      showToast("이름과 아이디를 입력하세요.");
    }
  }

  bool _isEmail = false;

  _onClickType(bool isEmail) {
    setState(() {
      _isEmail = isEmail;
    });
  }

  _onListenBloc(BuildContext context, FindPwState state) async {
    if (state is FindPwDefault) {
      if (state.message != null) {
        // Fluttertoast.showToast(msg: state.message!);
        showToast(state.message!);
      }
    } else if (state is FindPwDone) {
      Map<String, dynamic> args = {
        "name": state.name,
        "id": state.id,
        "type": state.type,
      };
      Navigator.pushNamed(context, routeResetPwPage, arguments: args);
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

extension on _FindPwPageState {
  Widget get _body {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: BlocListener(
          bloc: _bloc,
          listener: _onListenBloc,
          child: BlocBuilder(
            bloc: _bloc,
            builder: (_, FindPwState state) {
              return Column(
                children: [
                  const Navigation(title: "비밀번호 찾기"),
                  const HeightBox(24),
                  defaultWidget,
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget get defaultWidget {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BasicText("이름", 14, 18, FontWeight.w400,
                    textAlign: TextAlign.center),
                const HeightBox(4),
                BasicContainer(
                  height: 56,
                  child: BasicTextField("이름을 입력하세요", nameController,
                      fontSize: 16,
                      height: 20,
                      hintColor: const Color(0xff606060)),
                )
              ],
            ),
            const HeightBox(24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BasicText("아이디", 14, 18, FontWeight.w400,
                    textAlign: TextAlign.center),
                const HeightBox(4),
                BasicContainer(
                  height: 56,
                  child: BasicTextField("아이디를 입력하세요", idController,
                      fontSize: 16,
                      height: 20,
                      hintColor: const Color(0xff606060)),
                )
              ],
            ),
            const HeightBox(32),
            typeWidget,
            const HeightBox(40),
            BasicButton("비밀번호 찾기", _onClickFindPw),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget get typeWidget {
    return Column(
      children: [
        const Row(
          children: [
            Icon(Icons.info_outline_rounded, size: 20, color: AppColors.black),
            WidthBox(8),
            BasicText("비밀번호 찾기 방법을 선택하세요.", 14, 18, FontWeight.w500),
            Spacer(),
          ],
        ),
        const HeightBox(12),
        Container(
          height: 70,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.black, width: 1.5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _onClickType(true),
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                          _isEmail
                              ? Icons.radio_button_checked_rounded
                              : Icons.radio_button_off_rounded,
                          size: 20),
                      const WidthBox(8),
                      const BasicText("Email", 20, 29, FontWeight.w400,
                          textColor: Color(0xff2C2C2E)),
                    ],
                  ),
                ),
              ),
              const WidthBox(28),
              GestureDetector(
                onTap: () => _onClickType(false),
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                          _isEmail
                              ? Icons.radio_button_off_rounded
                              : Icons.radio_button_checked_rounded,
                          size: 20),
                      const WidthBox(8),
                      const BasicText("등록된 휴대폰", 20, 29, FontWeight.w400,
                          textColor: Color(0xff2C2C2E)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
