import 'dart:ui';

import 'package:gnu_mot_t/bloc/lobby/register_bloc.dart';
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

import '../../util/toast_helper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with TickerProviderStateMixin {
  final RegisterBloc _bloc = RegisterBloc();
  final TextEditingController idController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController pwAgainController = TextEditingController();

  _onClickRegister(){
    var id = idController.text;
    var pw = pwController.text;
    // var pwAgain = pwController.text;
    var pwAgain = pwAgainController.text;

    // 이메일 형식 검증을 위한 정규표현식
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

    if (id.isEmpty || pw.isEmpty || pwAgain.isEmpty) {
      // 빈 필드가 있는 경우
      // Fluttertoast.showToast(msg: '모든 필드를 입력해주세요');
      showToast("모든 필드를 입력해주세요.");
      return;
    }

    if (!emailRegex.hasMatch(id)) {
      // 이메일 형식이 올바르지 않은 경우
      // Fluttertoast.showToast(msg: '올바른 이메일 형식이 아닙니다');
      showToast("올바른 이메일 형식이 아닙니다.");
      return;
    }

    if (pw.length < 8) {
      showToast("비밀번호를 8자 이상 입력하세요."); // 🔥 비밀번호가 8자 미만일 경우 메시지 표시
      return;
    }

    if (pw != pwAgain) {
      // Fluttertoast.showToast(msg: '비밀번호가 일치하지 않습니다.');
      showToast("비밀번호가 일치하지 않습니다.");
      return;
    }

    // 모든 검증을 통과한 경우
    _bloc.add(DoRegister(id, pw, pwAgain));
  }

  _onListenBloc(BuildContext context, RegisterState state) async {
    if(state is RegisterDefault){
      if(state.message != null){
        // Fluttertoast.showToast(msg: state.message!);
        showToast(state.message!);
      }
    }else if(state is RegisterDone){
      // await Fluttertoast.showToast(msg: "회원가입이 완료되었습니다.").then((_){
      //   Navigator.pushNamedAndRemoveUntil(context, routeLoginPage, (route) => false);
      // });
      showToast("회원가입이 완료되었습니다.");
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushNamedAndRemoveUntil(context, routeLoginPage, (route) => false);
      });
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

extension on _RegisterPageState {
  Widget get _body {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: BlocListener(
          bloc: _bloc,
          listener: _onListenBloc,
          child: BlocBuilder(
            bloc: _bloc,
            builder: (_, RegisterState state) {
              return Column(
                children: [
                  const Navigation(title: "회원가입"),
                  const HeightBox(24),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const SizedBox(
                                width: 56,
                                child: BasicText("아이디", 14, 18, FontWeight.w400, textAlign: TextAlign.center),
                              ),
                              const WidthBox(24),
                              Expanded(child: BasicContainer(height: 56, child: BasicTextField("메일주소를 입력하세요", idController, fontSize: 16, height: 20, hintColor: const Color(0xff606060)))),
                            ],
                          ),
                          const HeightBox(32),
                          Row(
                            children: [
                              const SizedBox(
                                width: 56,
                                child: BasicText("비밀번호", 14, 18, FontWeight.w400, textAlign: TextAlign.center),
                              ),
                              const WidthBox(24),
                              Expanded(child: BasicContainer(height: 56, child: BasicTextField("8자이상 입력하세요", pwController, fontSize: 16, height: 20, hintColor: const Color(0xff606060), isObscure: true,))),
                            ]
                          ),
                          const HeightBox(32),
                          Row(
                            children: [
                              const SizedBox(
                                width: 56,
                                child: BasicText("비밀번호\n재입력", 14, 18, FontWeight.w400, textAlign: TextAlign.center),
                              ),
                              const WidthBox(24),
                              Expanded(child: BasicContainer(height: 56, child: BasicTextField("다시 입력하세요", pwAgainController, fontSize: 16, height: 20, hintColor: const Color(0xff606060), isObscure: true))),
                            ],
                          ),
                          const HeightBox(32),
                          BasicButton("가입", _onClickRegister),
                          const Spacer(),
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}