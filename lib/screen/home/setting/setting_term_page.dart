import 'dart:ui';

import 'package:gnu_mot_t/component/basic_text.dart';
import 'package:gnu_mot_t/component/common/height_box.dart';
import 'package:gnu_mot_t/component/common/navigation.dart';
import 'package:gnu_mot_t/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:gnu_mot_t/constant/term_text.dart';

class SettingTermPage extends StatefulWidget {
  const SettingTermPage({super.key});

  @override
  _SettingTermPageState createState() => _SettingTermPageState();
}

class _SettingTermPageState extends State<SettingTermPage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _body;
  }
}

extension on _SettingTermPageState {
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
                    termWidget("이용약관", TermsText.serviceText),
                    termWidget("개인정보처리방침", TermsText.policyText),
                    termWidget("개인정보 공개설정 동의", TermsText.privacyText),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget termWidget(String title, String content){
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
            ),
            height: 240,
            child: SingleChildScrollView(
              child: BasicText(content, 12, 15, FontWeight.w400),
            ),
          ),
          const HeightBox(4),
        ],
      ),
    );
  }
}