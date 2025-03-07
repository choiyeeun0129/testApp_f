import 'dart:developer';
import 'dart:ui';

import 'package:testApp/bloc/lobby/login_bloc.dart';
import 'package:testApp/component/basic/basic_text_field.dart';
import 'package:testApp/component/basic_container.dart';
import 'package:testApp/component/basic_text.dart';
import 'package:testApp/component/common/asset_widget.dart';
import 'package:testApp/component/common/height_box.dart';
import 'package:testApp/component/common/width_box.dart';
import 'package:testApp/constant/assets.dart';
import 'package:testApp/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:testApp/router/app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final LoginBloc _bloc = LoginBloc();
  final TextEditingController idController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  bool enableAutoLogin = false;

  _onClickLogin() {
    var id = idController.text;
    var pw = pwController.text;

    if (id.isNotEmpty && pw.isNotEmpty) {
      _bloc.add(DoLogin(id, pw, enableAutoLogin));
    } else {
      Fluttertoast.showToast(msg: "아이디와 비밀번호를 모두 입력해주세요.");
    }
  }

  _onClickAutoLogin() {
    setState(() {
      enableAutoLogin = !enableAutoLogin;
    });
  }

  _onClickFind() {
    Navigator.of(context).pushNamed(routeFindPage);
  }

  _onListenBloc(BuildContext context, LoginState state) {
    if (state is LoginDefault) {
      if (state.message != null) {
        String errorMessage = state.message!;

        if (errorMessage.contains("Password not match")) {
          Fluttertoast.showToast(msg: "비밀번호가 일치하지 않습니다.");
        } else if (errorMessage.contains("Login Id not exist")) {
          Fluttertoast.showToast(msg: "아이디가 존재하지 않습니다.");
        } else {
          Fluttertoast.showToast(msg: errorMessage);
        }
      }
    } else if (state is LoginDone) {
      Navigator.of(context).pushReplacementNamed(routeHomePage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _body;
  }
}

extension on _LoginPageState {
  Widget get _body {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffffffff),
      body: SafeArea(
        child: BlocListener(
          bloc: _bloc,
          listener: _onListenBloc,
          child: BlocBuilder(
            bloc: _bloc,
            builder: (_, LoginState state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 로고
                    AssetWidget(
                      Assets.pbnt_image,
                      width: MediaQuery.of(context).size.width * 0.70,
                      height: MediaQuery.of(context).size.height * 0.12,
                      fit: BoxFit.contain,
                    ),
                    const HeightBox(50),

                    // 아이디 입력
                    BasicContainer(
                      backgroundColor: const Color(0xffffffff),
                      height: 56,
                      child: BasicTextField(
                        "이메일",
                        idController,
                        fontSize: 16,
                        height: 20,
                        hintColor: const Color(0xff606060),
                      ),
                    ),
                    const HeightBox(15),

                    // 비밀번호 입력
                    BasicContainer(
                      backgroundColor: const Color(0xffffffff),
                      height: 56,
                      child: BasicTextField(
                        "비밀번호",
                        pwController,
                        fontSize: 16,
                        height: 20,
                        hintColor: const Color(0xff606060),
                        isObscure: true,
                      ),
                    ),
                    const HeightBox(10),

                    // 자동 로그인 체크박스
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _onClickAutoLogin,
                          child: Row(
                            children: [
                              Icon(
                                enableAutoLogin
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color: enableAutoLogin
                                    ? Colors.blue
                                    : Colors.grey,
                                size: 20,
                              ),
                              const WidthBox(8),
                              const BasicText(
                                "자동로그인",
                                14,
                                18,
                                FontWeight.w400,
                                textColor: Colors.black87,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const HeightBox(20),

                    // 로그인 버튼
                    GestureDetector(
                      onTap: _onClickLogin,
                      child: BasicContainer(
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: 60,
                        alignment: Alignment.center,
                        backgroundColor: const Color(0xff2155A8),
                        borderRadius: BorderRadius.circular(12),
                        child: const BasicText(
                          "로그인",
                          16,
                          20,
                          FontWeight.w500,
                          textColor: AppColors.white,
                        ),
                      ),
                    ),

                    const HeightBox(20),

                    // 하단 회원가입/아이디 찾기/비밀번호 찾기
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // GestureDetector(
                        //   onTap: () {},
                        //   child: const BasicText(
                        //     "회원가입",
                        //     14,
                        //     20,
                        //     FontWeight.w400,
                        //     textColor: Color(0xff323142),
                        //   ),
                        // ),
                        GestureDetector(
                          onTap: _onClickFind,
                          child: const BasicText(
                            "아이디 찾기",
                            14,
                            20,
                            FontWeight.w400,
                            textColor: Color(0xff323142),
                          ),
                        ),
                        GestureDetector(
                          onTap: _onClickFind,
                          child: const BasicText(
                            "비밀번호 찾기",
                            14,
                            20,
                            FontWeight.w400,
                            textColor: Color(0xff323142),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
