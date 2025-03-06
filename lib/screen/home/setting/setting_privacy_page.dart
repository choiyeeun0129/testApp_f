import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testApp/bloc/home/setting/setting_privacy_bloc.dart';
import 'package:testApp/component/basic_container.dart';
import 'package:testApp/component/basic_text.dart';
import 'package:testApp/component/common/height_box.dart';
import 'package:testApp/component/common/navigation.dart';
import 'package:testApp/component/common/width_box.dart';
import 'package:flutter/material.dart';
import 'package:testApp/constant/colors.dart';

class SettingPrivacyPage extends StatefulWidget {
  const SettingPrivacyPage({super.key});

  @override
  _SettingPrivacyPageState createState() => _SettingPrivacyPageState();
}

class _SettingPrivacyPageState extends State<SettingPrivacyPage> with TickerProviderStateMixin {
  final SettingPrivacyBloc _bloc = SettingPrivacyBloc();

  _onClickMobile() { _bloc.add(MobileSettingPrivacy()); }
  _onClickOfficePhone() { _bloc.add(OfficePhoneSettingPrivacy()); }
  _onClickEmail() { _bloc.add(EmailSettingPrivacy()); }
  _onClickCompany() { _bloc.add(CompanySettingPrivacy()); }
  _onClickBirth() { _bloc.add(BirthSettingPrivacy()); }

  @override
  void initState() {
    super.initState();
    _bloc.add(InitSettingPrivacy());
  }

  @override
  Widget build(BuildContext context) {
    return _body;
  }
}

extension on _SettingPrivacyPageState {

  Widget get _body {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: BlocListener(
          bloc: _bloc,
          listener: (_, state) {},
          child: BlocBuilder(
            bloc: _bloc,
            builder: (_, SettingPrivacyState state) {
              return Column(
                children: [
                  const Navigation(title: "공개범위 설정"),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const BasicText("상대방의 정보조회시, 자신이 공개한 항목만 조회할 수 있습니다.", 12, 17, FontWeight.w400),
                              const HeightBox(23),
                              groupItem("Mobile", state.enableMobile, _onClickMobile),
                              const HeightBox(18),
                              groupItem("Office Phone", state.enableOfficePhone, _onClickOfficePhone),
                              const HeightBox(18),
                              groupItem("Email", state.enableEmail, _onClickEmail),
                              const HeightBox(18),
                              groupItem("직장정보", state.enableCompany, _onClickCompany),
                              const HeightBox(18),
                              groupItem("출생년도", state.enableBirth, _onClickBirth),
                            ]
                        )
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget groupItem(String text, bool value, Function onClick) {
    return BasicContainer(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: BasicText(text, 16, 23, FontWeight.w400)),
          const WidthBox(16),
          Switch(value: value, onChanged: (value) => onClick.call(), inactiveThumbColor: Colors.white, inactiveTrackColor: const Color(0x29787880), )
        ],
      ),
    );
  }
}