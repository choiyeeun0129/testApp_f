import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gnu_mot_t/bloc/home/setting/setting_bloc.dart';
import 'package:gnu_mot_t/component/basic_container.dart';
import 'package:gnu_mot_t/component/basic_text.dart';
import 'package:gnu_mot_t/component/common/height_box.dart';
import 'package:gnu_mot_t/component/common/navigation.dart';
import 'package:gnu_mot_t/component/common/width_box.dart';
import 'package:gnu_mot_t/constant/colors.dart';
import 'package:gnu_mot_t/router/app_routes.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> with TickerProviderStateMixin {
  final SettingBloc _bloc = SettingBloc();

  _onClickProfile(){
    Navigator.pushNamed(context, routeProfileMyPage);
  }

  _onClickPrivacy(){
    Navigator.pushNamed(context, routeSettingPrivacyPage);
  }

  _onClickTerm(){
    Navigator.pushNamed(context, routeSettingTermPage);
  }

  _onClickWithdraw(){
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // 모달 바깥 영역 터치시 닫히지 않도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('탈퇴 신청'),
          content: const Text('탈퇴 신청을 하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: const Text('아니오'),
              onPressed: () {
                Navigator.of(context).pop(); // 모달 닫기
              },
            ),
            TextButton(
              child: const Text('예'),
              onPressed: () {
                // '예' 버튼 클릭시 실행할 코드
                Navigator.of(context).pop(); // 모달 닫기
                _bloc.add(WithdrawSetting());
              },
            ),
          ],
        );
      },
    );
  }

  _onListenBloc(BuildContext context, SettingState state) async {
    if(state is SettingDefault){
      if(state.message != null){
        Fluttertoast.showToast(msg: state.message!);
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

extension on _SettingPageState {
  Widget get _body {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: BlocListener(
          bloc: _bloc,
          listener: _onListenBloc,
          child: Column(
            children: [
              const Navigation(title: "설정"),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      settingItem(Icons.manage_accounts_outlined, "프로필 설정", "Change your Account information", _onClickProfile),
                      settingItem(Icons.supervisor_account_outlined, "공개범위 설정", "Privacy Settings", _onClickPrivacy),
                      settingItem(Icons.account_box_outlined, "개인정보처리방침", "Privacy Policy", _onClickTerm),
                      settingItem(Icons.person_outline, "탈퇴신청", "Request for Account Deletion", _onClickWithdraw),
                    ]
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget settingItem(IconData icon, String title, String description, Function onClick) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 28),
      child: GestureDetector(
        onTap: () => onClick.call(),
        child: Container(
          color: Colors.transparent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: AppColors.black),
              const WidthBox(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BasicText(title, 20, 29, FontWeight.w700, textColor: const Color(0xff212121)),
                    const HeightBox(2),
                    BasicText(description, 14, 19, FontWeight.w400, textColor: const Color(0xff737373)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}