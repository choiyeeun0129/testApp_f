import 'package:gnu_mot_t/component/basic_container.dart';
import 'package:gnu_mot_t/component/basic_text.dart';
import 'package:gnu_mot_t/component/common/height_box.dart';
import 'package:gnu_mot_t/component/common/navigation.dart';
import 'package:gnu_mot_t/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:gnu_mot_t/router/app_routes.dart';

class FindPage extends StatefulWidget {
  const FindPage({super.key});

  @override
  _FindPageState createState() => _FindPageState();
}

class _FindPageState extends State<FindPage> with TickerProviderStateMixin {

  _onClickFindId(){
    Navigator.of(context).pushNamed(routeFindIdPage);
  }

  _onClickFindPw(){
    Navigator.of(context).pushNamed(routeFindPwPage);
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

extension on _FindPageState {
  Widget get _body {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const Navigation(title: "아이디/비밀번호 찾기"),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    const HeightBox(44),
                    GestureDetector(
                      onTap: _onClickFindId,
                      child: const BasicContainer(
                        height: 56,
                        width: double.infinity,
                        alignment: Alignment.center,
                        backgroundColor: Color(0xff2155A8),
                        child: BasicText("아이디 찾기", 16, 20, FontWeight.w500, textColor: Colors.white),
                      ),
                    ),
                    const HeightBox(22),
                    GestureDetector(
                      onTap: _onClickFindPw,
                      child: const BasicContainer(
                        height: 56,
                        width: double.infinity,
                        alignment: Alignment.center,
                        backgroundColor: Color(0xff2155A8),
                        child: BasicText("비밀번호 찾기", 16, 20, FontWeight.w500, textColor: Colors.white),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}