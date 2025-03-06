import 'package:testApp/bloc/lobby/find/reset_pw_bloc.dart';
import 'package:testApp/component/basic/basic_button.dart';
import 'package:testApp/component/basic/basic_text_field.dart';
import 'package:testApp/component/basic_container.dart';
import 'package:testApp/component/basic_text.dart';
import 'package:testApp/component/common/height_box.dart';
import 'package:testApp/component/common/navigation.dart';
import 'package:testApp/component/common/width_box.dart';
import 'package:testApp/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../util/toast_helper.dart';

class ResetPwPage extends StatefulWidget {
  final String name;
  final String id;
  final String type;
  const ResetPwPage({super.key, required this.name, required this.id, required this.type});

  @override
  _ResetPwPageState createState() => _ResetPwPageState();
}

class _ResetPwPageState extends State<ResetPwPage> with TickerProviderStateMixin {
  final ResetPwBloc _bloc = ResetPwBloc();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController pwAgainController = TextEditingController();

  _onClickRe(){
    _bloc.add(ReResetPw(widget.name, widget.id, widget.type));
    // Fluttertoast.showToast(msg: "인증번호를 재전송하였습니다.");
    showToast("인증번호를 재전송하였습니다.");
  }

  _onClickResetPw(){
    var code = codeController.text;
    var pw = pwController.text;
    var pwAgain = pwAgainController.text;

    if (code.isEmpty) {
      showToast("인증번호를 입력하세요.");
      return;
    }
    if (pw.length < 8) {
      showToast("비밀번호를 8자 이상 입력하세요.");
      return;
    }
    if(code.isNotEmpty && pw.isNotEmpty && pwAgain.isNotEmpty){
      if(pw != pwAgain){
        showToast("비밀번호가 일치하지 않습니다.");
      }else{
        _bloc.add(DoResetPw(widget.name, widget.id, code, pw));
      }
    }
  }

  _onClickLogin(){
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  _onListenBloc(BuildContext context, ResetPwState state) async {
    if(state is ResetPwDefault){
      if(state.message != null){
        showToast("인증번호가 일치하지 않습니다.");
      }
    }else if(state is ResetPwDone){
      showToast("비밀번호가 재설정되었습니다.");
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

extension on _ResetPwPageState {
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
            builder: (_, ResetPwState state) {
              return Column(
                children: [
                  const Navigation(title: "비밀번호 재설정"),
                  const HeightBox(24),
                  state is ResetPwDone ? doneWidget : defaultWidget,
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
                const BasicText("인증번호", 14, 18, FontWeight.w400, textAlign: TextAlign.center),
                const HeightBox(4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: BasicContainer(height: 56, child: BasicTextField("인증번호를 입력하세요", codeController, fontSize: 16, height: 20, hintColor: const Color(0xff606060)))),
                    const WidthBox(8),
                    BasicButton(width: 84, "재전송", _onClickRe),
                  ],
                )
              ],
            ),
            const HeightBox(24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BasicText("새 비밀번호 입력", 14, 18, FontWeight.w400, textAlign: TextAlign.center),
                const HeightBox(4),
                BasicContainer(height: 56, child: BasicTextField("8자이상 입력하세요", pwController, fontSize: 16, height: 20, hintColor: const Color(0xff606060), isObscure: true))
              ],
            ),
            const HeightBox(24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BasicText("새 비밀번호 확인", 14, 18, FontWeight.w400, textAlign: TextAlign.center),
                const HeightBox(4),
                BasicContainer(height: 56, child: BasicTextField("비밀번호를 재입력하세요", pwAgainController, fontSize: 16, height: 20, hintColor: const Color(0xff606060), isObscure: true))
              ],
            ),
            const HeightBox(44),
            BasicButton("확인", _onClickResetPw),
          ],
        ),
      ),
    );
  }

  Widget get doneWidget {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const BasicText("비밀번호가 재설정되었습니다", 14, 18, FontWeight.w400, textAlign: TextAlign.center),
            const HeightBox(44),
            BasicButton("로그인", _onClickLogin),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}