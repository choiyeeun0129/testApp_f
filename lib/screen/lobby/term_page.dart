import 'dart:ui';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:testApp/component/basic/basic_button.dart';
import 'package:testApp/component/basic_text.dart';
import 'package:testApp/component/common/height_box.dart';
import 'package:testApp/component/common/navigation.dart';
import 'package:testApp/component/common/width_box.dart';
import 'package:testApp/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:testApp/constant/term_text.dart';
import 'package:testApp/router/app_routes.dart';

class TermPage extends StatefulWidget {
  const TermPage({super.key});

  @override
  _TermPageState createState() => _TermPageState();
}

class _TermPageState extends State<TermPage> with TickerProviderStateMixin {
  bool agreeService = false;
  bool agreePolicy = false;
  bool agreePrivacy = false;
  _onClickService(){
    setState(() {
      agreeService = !agreeService;
    });
  }
  _onClickPolicy(){
    setState(() {
      agreePolicy = !agreePolicy;
    });
  }
  _onClickPrivacy(){
    setState(() {
      agreePrivacy = !agreePrivacy;
    });
  }

  _onClickAgree(){
    if(agreeService && agreePolicy && agreePrivacy){
      Navigator.of(context).pushNamed(routeRegisterPage);
    }else{
      Fluttertoast.showToast(msg: "약관에 동의해주세요.");
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

extension on _TermPageState {
  Widget get _body {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const Navigation(title: "이용약관동의"),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    termWidget("이용약관", TermsText.serviceText, agreeService, _onClickService),
                    termWidget("개인정보처리방침", TermsText.policyText, agreePolicy, _onClickPolicy),
                    termWidget("개인정보 공개설정 동의", TermsText.privacyText, agreePrivacy, _onClickPrivacy),
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: BasicButton("가입", _onClickAgree),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget termWidget(String title, String content, bool agree, Function onClick){
    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BasicText(title, 14, 18, FontWeight.w400),
          const HeightBox(4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black, width: 1)
            ),
            height: 240,
            child: SingleChildScrollView(
              child: BasicText(content, 12, 15, FontWeight.w400),
            ),
          ),
          const HeightBox(4),
          GestureDetector(
            onTap: () => onClick.call(),
            child: Container(
              color: AppColors.transparent,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(agree ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded, color: const Color(0xff3398FF), size: 20),
                  const WidthBox(8),
                  const BasicText("이용약관에 동의합니다.", 14, 18, FontWeight.w400, textColor: Color(0xff6C6C6C)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}