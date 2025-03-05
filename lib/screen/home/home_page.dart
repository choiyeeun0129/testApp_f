import 'dart:developer';

import 'package:gnu_mot_t/bloc/home/home_bloc.dart';
import 'package:gnu_mot_t/component/basic_container.dart';
import 'package:gnu_mot_t/component/basic_text.dart';
import 'package:gnu_mot_t/component/common/height_box.dart';
import 'package:gnu_mot_t/component/common/width_box.dart';
import 'package:gnu_mot_t/constant/colors.dart';
import 'package:gnu_mot_t/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final HomeBloc _bloc = HomeBloc();

  _onClickLogout() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // 모달 바깥 영역 터치시 닫히지 않도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('로그아웃'),
          content: const Text('로그아웃을 하시겠습니까?'),
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
                _bloc.add(LogoutHome());
              },
            ),
          ],
        );
      },
    );
  }
  _onClickSetting() {
    Navigator.pushNamed(context, routeSettingPage);
  }
  _onClickGroup(String name, String type, String code) {
    Map<String, dynamic> args = {
      "name": name,
      "type": type,
      "code": code,
    };
    Navigator.pushNamed(context, routeGroupPage, arguments: args);
  }
  _onClickMot(){
    Navigator.pushNamed(context, routeMotPage);
  }
  _onClickSearch() {
    Navigator.pushNamed(context, routeSearchPage);
  }
  _onClickProfile() {
    Navigator.pushNamed(context, routeProfileMyPage);
  }

  @override
  void initState() {
    super.initState();
    _bloc.add(InitHome());
  }

  @override
  Widget build(BuildContext context) {
    return _body;
  }
}

extension on _HomePageState {
  Widget get _body {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: BlocBuilder(
          bloc: _bloc,
          builder: (_, state) {
            return Column(
              children: [
                navigation,
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        groupItem("교수진", "ROLE", "ROLE_1"),
                        const HeightBox(12),
                        groupItem("교직원", "ROLE", "ROLE_2"),
                        const HeightBox(12),
                        if(state is HomeDefault && (state.user.batchCode != null)) groupItem(state.user.batchName, "BATCH", state.user.batchCode!),
                        if(state is HomeDefault) const HeightBox(12),
                        GestureDetector(
                          onTap: _onClickMot,
                          child: const BasicContainer(
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.account_circle_rounded, size: 48, color: Color(0xffD8D9D9)),
                                WidthBox(16),
                                Expanded(child: BasicText("MOT 전체", 16, 28, FontWeight.w400)),
                                WidthBox(16),
                                Icon(Icons.keyboard_arrow_right_rounded, size: 30, color: AppColors.black),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                bottom
              ],
            );
          },
        ),
      ),
    );
  }

  Widget get navigation {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const WidthBox(28),
          GestureDetector(
            onTap: _onClickLogout,
            child: Container(
              color: Colors.transparent,
              child: const Icon(Icons.logout_rounded, size: 30, color: AppColors.black),
            ),
          ),
          const Spacer(),
          const BasicText("홈", 24, 35, FontWeight.w700),
          const Spacer(),
          GestureDetector(
            onTap: _onClickSetting,
            child: Container(
              color: Colors.transparent,
              child: const Icon(Icons.settings, size: 30, color: AppColors.black),
            ),
          ),
          const WidthBox(28),
        ],
      ),
    );
  }

  Widget groupItem(String text, String type, String code) {
    return GestureDetector(
      onTap: () => _onClickGroup(text, type, code),
      child: BasicContainer(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.account_circle_rounded, size: 48, color: Color(0xffD8D9D9)),
            const WidthBox(16),
            Expanded(child: BasicText(text, 16, 28, FontWeight.w400)),
            const WidthBox(16),
            const Icon(Icons.keyboard_arrow_right_rounded, size: 30, color: AppColors.black),
          ],
        ),
      ),
    );
  }

  Widget get bottom {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        border: Border(
          top: BorderSide(color: Colors.white, width: 3),
        ),
      ),
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: _onClickSearch,
            child: Container(
              color: Colors.transparent,
              alignment: Alignment.center,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_rounded, size: 32, color: AppColors.black),
                  BasicText("검색", 12, 28, FontWeight.w400),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: _onClickProfile,
            child: Container(
              color: Colors.transparent,
              alignment: Alignment.center,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_outlined, size: 32, color: AppColors.black),
                  BasicText("내 프로필", 12, 28, FontWeight.w400),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
