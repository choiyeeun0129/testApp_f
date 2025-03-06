import 'dart:developer';

import 'package:gnu_mot_t/bloc/lobby/find/find_id_bloc.dart';
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
import '../../../util/toast_helper.dart';

class FindIdPage extends StatefulWidget {
  const FindIdPage({super.key});

  @override
  _FindIdPageState createState() => _FindIdPageState();
}

class _FindIdPageState extends State<FindIdPage> with TickerProviderStateMixin {
  final FindIdBloc _bloc = FindIdBloc();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  _onClickFindId(){
    var name = nameController.text;
    var number = numberController.text;
    if(name.isNotEmpty && number.isNotEmpty){
      _bloc.add(DoFindId(name, number));
    }
  }

  _onClickCode(){
    log("_onClickCode");
    var code = nameController.text;
    log("_onClickCode/code: $code");
    if(code.isNotEmpty){
      _bloc.add(CodeFindId(code));
    }
  }

  _onClickRe(){
    _bloc.add(ReFindId());
  }

  _onClickLogin(){
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _onListenBloc(BuildContext context, FindIdState state) async {
    if (state is FindIdDefault) {
      if (state.message != null) {
        // Fluttertoast.showToast(msg: state.message!,gravity: ToastGravity.TOP);   // 사용자를 찾을수 없습니다.
        showToast(state.message!);
        print("state.message!");
      }
    } else if (state is FindIdCode) {
      if (state.message != null) {
        // Fluttertoast.showToast(msg: state.message!,gravity: ToastGravity.TOP);  // 인증번호 오류 메시지 출력
        showToast(state.message!);
      } else {
        nameController.clear();
        numberController.clear();
      }
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

extension on _FindIdPageState {
  Widget get _body {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: BlocListener(
          bloc: _bloc,
          listener: _onListenBloc,
          child: BlocBuilder(
            bloc: _bloc,
            builder: (_, FindIdState state) {
              return Column(
                children: [
                  const Navigation(title: "아이디 찾기"),
                  const HeightBox(24),
                  if(state is FindIdDefault) defaultWidget,
                  if(state is FindIdCode) codeWidget,
                  if(state is FindIdDone) doneWidget(state.id)
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
                const BasicText("이름", 14, 18, FontWeight.w400, textAlign: TextAlign.center),
                const HeightBox(4),
                BasicContainer(
                  height: 56,
                  child: BasicTextField("이름을 입력하세요", nameController, fontSize: 16, height: 20, hintColor: const Color(0xff606060)),
                )
              ],
            ),
            const HeightBox(24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BasicText("휴대폰번호", 14, 18, FontWeight.w400, textAlign: TextAlign.center),
                const HeightBox(4),
                BasicContainer(
                  height: 56,
                  child: BasicTextField("번호를 입력하세요", numberController, fontSize: 16, height: 20, hintColor: const Color(0xff606060),onChanged: (text) {
                    // 숫자만 입력 허용
                    String filteredText = text.replaceAll(RegExp(r'[^0-9]'), '');

                    // 11자리로 길이 제한 (초과 시 자름)
                    if (filteredText.length > 11) {
                      filteredText = filteredText.substring(0, 11);
                    }

                    // 컨트롤러 업데이트 및 커서 위치 유지
                    numberController.text = filteredText;
                    numberController.selection = TextSelection.fromPosition(
                      TextPosition(offset: filteredText.length),
                    );
                  },),
                )
              ],
            ),
            const HeightBox(44),
            BasicButton("인증번호 전송", _onClickFindId),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget get codeWidget {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BasicText("인증번호", 14, 18, FontWeight.w400, textAlign: TextAlign.center),
                const HeightBox(4),
                BasicContainer(
                  height: 56,
                  child: BasicTextField("인증번호 입력", nameController, fontSize: 16, height: 20, hintColor: const Color(0xff606060)),
                ),
              ],
            ),
            const HeightBox(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: BasicButton("확인", _onClickCode),
                ),
                const SizedBox(width: 10), // 버튼 간 간격 조절
                Expanded(
                  child: BasicButton("인증번호 재전송", _onClickRe),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }



  Widget doneWidget(String id) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BasicText("회원님의 아이디입니다.", 14, 18, FontWeight.w400, textAlign: TextAlign.center),
                const HeightBox(4),
                BasicContainer(width: double.infinity, height: 56, alignment: Alignment.center, child: BasicText(id, 14, 18, FontWeight.w500, textAlign: TextAlign.center, textColor: const Color(0xff1DC9A0)))
              ],
            ),
            const HeightBox(22),
            SizedBox(
              width: double.infinity, // 👉 아이디 박스(BasicContainer)와 동일하게!
              child: BasicButton("로그인", _onClickLogin, height: 56), // height도 동일하게!
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}