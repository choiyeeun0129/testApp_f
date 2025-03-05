import 'package:fluttertoast/fluttertoast.dart';
import 'package:gnu_mot_t/bloc/home/search/search_result_bloc.dart';
import 'package:gnu_mot_t/component/basic_text.dart';
import 'package:gnu_mot_t/component/common/asset_widget.dart';
import 'package:gnu_mot_t/component/common/height_box.dart';
import 'package:gnu_mot_t/component/common/navigation.dart';
import 'package:gnu_mot_t/component/common/width_box.dart';
import 'package:gnu_mot_t/constant/assets.dart';
import 'package:gnu_mot_t/constant/colors.dart';
import 'package:gnu_mot_t/model/user.dart';
import 'package:gnu_mot_t/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchResultPage extends StatefulWidget {
  final String? keyword;
  final String? batch;
  final String? course;

  const SearchResultPage(
      {super.key,
        required this.keyword,
        required this.batch,
        required this.course});

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> with TickerProviderStateMixin {
  final SearchResultBloc _bloc = SearchResultBloc();

  _onClickUser(User user) {
    Map<String, dynamic> args = {"user": user};
    Navigator.pushNamed(context, routeProfileOtherPage, arguments: args);
  }

  late ScrollController controller;
  bool isOnLoad = false;

  void _scrollListener() {
    if(!isOnLoad){
      if (controller.position.extentAfter < 500) {
        isOnLoad = true;
        _bloc.add(LoadSearchResult(widget.keyword, widget.batch, widget.course));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _bloc.add(LoadSearchResult(widget.keyword, widget.batch, widget.course));
    controller = ScrollController()..addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return _body;
  }
}

extension on _SearchResultPageState {
  Widget get _body {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: BlocListener(
          bloc: _bloc,
          listener: (_, SearchResultState state) {
            isOnLoad = false;
            if (state.message != null) {
              Fluttertoast.showToast(msg: state.message!);
            }
          },
          child: BlocBuilder(
            bloc: _bloc,
            builder: (_, SearchResultState state) {
              return Column(
                children: [
                  const Navigation(title: "검색 결과"),
                  // 검색어 입력 필드 제거됨
                  if(state.userList.isNotEmpty) Expanded(
                    child: ListView.builder(
                      controller: controller,
                      itemCount: state.userList.length,
                      itemBuilder: (_, index) => userItem(state.userList[index], index),
                    ),
                  ),
                  if(state.userList.isEmpty) const Expanded(child: Center(child: BasicText("검색 결과가 없습니다.", 14, 18, FontWeight.w400, textAlign: TextAlign.center)),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget userItem(User user, int index) {
    Color backgroundColor = index.isEven ? const Color(0xffEBEDFF) : const Color(0xfffffff);
    return GestureDetector(
      onTap: () => _onClickUser(user),
      child: Container(
        height: 94,
        padding: const EdgeInsets.symmetric(horizontal: 28),
        color: backgroundColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(360),
              child: AssetWidget(user.profileImage ?? Assets.ic_account, width: 70, height: 70, fit: BoxFit.cover),
            ),
            const WidthBox(20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BasicText(user.name, 16, 20, FontWeight.w700),
                  const HeightBox(4),
                  if(user.isStudent && user.isPublicDepartment && user.companyName != null) BasicText("${user.companyName}", 12, 10, FontWeight.w400, textColor: const Color(0xff616161)),
                  if(user.isPublicEmail && user.email != null) BasicText(user.email!, 12, 20, FontWeight.w400, textColor: const Color(0xff616161)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}