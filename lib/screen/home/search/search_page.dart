import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gnu_mot_t/bloc/home/search/search_bloc.dart';
import 'package:gnu_mot_t/component/basic/basic_button.dart';
import 'package:gnu_mot_t/component/basic/basic_text_field.dart';
import 'package:gnu_mot_t/component/basic_container.dart';
import 'package:gnu_mot_t/component/basic_text.dart';
import 'package:gnu_mot_t/component/common/height_box.dart';
import 'package:gnu_mot_t/component/common/navigation.dart';
import 'package:gnu_mot_t/component/common/width_box.dart';
import 'package:gnu_mot_t/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:gnu_mot_t/model/code.dart';
import 'package:gnu_mot_t/router/app_routes.dart';
import 'package:gnu_mot_t/util/extensions.dart';
import 'package:gnu_mot_t/api/user/user_service.dart';

import '../../../util/toast_helper.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  final SearchBloc _bloc = SearchBloc();
  final TextEditingController keywordController = TextEditingController();

  _onClearKeyword(){
    keywordController.clear();
    _onChangeText("");
  }

  _onClickBatch(List<Code> batchList){
    if(batchList.isNotEmpty){
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Wrap(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Column(
                  children: [
                    ListView.separated(
                      itemBuilder: (_, index) {
                        var batch = batchList[index];
                        bool isSelected = selectedBatch == batch.code;
                        return codeButton(batch.name, batch.code, isSelected, _onSelectBatch);
                      },
                      separatorBuilder: (_, index) => const SizedBox(height: 10),
                      itemCount: batchList.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                    )
                  ],
                ),
              ),
            ],
          );
        },
      );
    }
  }

  List<String> courseList = [
    "COURSE_1",
    "COURSE_2",
    "COURSE_3",
  ];
  List<String> nameList = [
    "석사과정",
    "석박사통합",
    "박사과정",
  ];
  _onClickCourse(){
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Column(
                children: [
                  ListView.separated(
                    itemBuilder: (_, index) {
                      var course = courseList[index];
                      bool isSelected = selectedCourse == course;
                      return codeButton(nameList[index], course, isSelected, _onSelectCourse);
                    },
                    separatorBuilder: (_, index) => const SizedBox(height: 10),
                    itemCount: courseList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String? selectedBatch;
  _onSelectBatch(String code){
    Navigator.of(context).pop();
    setState(() {
      selectedBatch = code;
    });
  }

  _onClearBatch(){
    setState(() {
      selectedBatch = null;
    });
  }

  String? selectedCourse;
  _onSelectCourse(String code){
    Navigator.of(context).pop();
    setState(() {
      selectedCourse = code;
    });
  }

  _onClearCourse(){
    setState(() {
      selectedCourse = null;
    });
  }

  _onClickSearch() async {
    var keyword = keywordController.text;
    if(keyword.isEmpty && selectedBatch == null && selectedCourse == null) {
      showToast("검색어 입력 혹은 기수나 과정을 선택해주세요");
    } else {
      try {
        final result = await userService.getUserList(
            keyword: keyword,
            courseCode: selectedCourse,
            batchCode: selectedBatch,
            page: 1
        );

        if (result.list.isEmpty) {
          showToast("검색 결과가 없습니다.");
        } else {
          Map<String, dynamic> args = {
            "keyword": keyword,
            "batch": selectedBatch,
            "course": selectedCourse,
          };
          keywordController.clear();
          setState(() {
            selectedBatch = null;
            selectedCourse = null;
          });
          Navigator.pushNamed(context, routeSearchResultPage, arguments: args);
        }
      } catch (e) {
        Fluttertoast.showToast(msg: "검색 중 오류가 발생했습니다: ${e.toString()}");
      }
    }
  }
  String keywordText = "";
  _onChangeText(String text){
    setState(() {
      keywordText = text;
    });
  }

  @override
  void initState() {
    super.initState();
    _bloc.add(InitSearch());
  }

  @override
  Widget build(BuildContext context) {
    return _body;
  }
}

extension on _SearchPageState {
  Widget get _body {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: BlocListener(
          bloc: _bloc,
          listener: (_, SearchState state){
            if(state.message != null){
              Fluttertoast.showToast(msg: state.message!);
            }
          },
          child: BlocBuilder(
            bloc: _bloc,
            builder: (_, SearchState state){
              return Column(
                children: [
                  const Navigation(title: "검색"),
                  const HeightBox(24),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const SizedBox(
                                width: 56,
                                child: BasicText("검색어", 14, 18, FontWeight.w400,
                                    textAlign: TextAlign.center),
                              ),
                              const WidthBox(24),
                              Expanded(
                                child: BasicContainer(
                                  height: 45,
                                  child: BasicTextField(
                                    "이름, 직장 검색",
                                    keywordController,
                                    fontSize: 16,
                                    height: 20,
                                    hintColor: const Color(0xff818080),
                                    onChanged: _onChangeText,
                                  ),
                                ),
                              ),
                              const WidthBox(8),
                              GestureDetector(
                                onTap: _onClearKeyword,
                                child: Icon(Icons.clear, size: 24, color: keywordText.isEmpty ? const Color(0xffa1a1a1) : AppColors.black),
                              )
                            ],
                          ),
                          const HeightBox(32),
                          Row(
                            children: [
                              const SizedBox(
                                width: 56,
                                child: BasicText("기수", 14, 18, FontWeight.w400, textAlign: TextAlign.center),
                              ),
                              const WidthBox(24),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _onClickBatch(state.batchList),
                                  child: BasicContainer(
                                    height: 45,
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    alignment: Alignment.centerLeft,
                                    child: BasicText(selectedBatch?.name ?? "기수를 선택하세요", 16, 20, FontWeight.w400, textColor: selectedBatch == null ? const Color(0xff818080) : AppColors.black),
                                  ),
                                ),
                              ),
                              const WidthBox(8),
                              GestureDetector(
                                onTap: _onClearBatch,
                                child: Icon(Icons.refresh, size: 24, color: selectedBatch == null ? const Color(0xffa1a1a1) : AppColors.black),
                              )
                            ],
                          ),
                          const HeightBox(32),
                          Row(
                            children: [
                              const SizedBox(
                                width: 56,
                                child: BasicText("과정", 14, 18, FontWeight.w400,
                                    textAlign: TextAlign.center),
                              ),
                              const WidthBox(24),
                              Expanded(
                                child: GestureDetector(
                                  onTap: _onClickCourse,
                                  child: BasicContainer(
                                    height: 45,
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    alignment: Alignment.centerLeft,
                                    child: BasicText(selectedCourse?.name ?? "과정을 선택하세요" , 16, 20, FontWeight.w400, textColor: selectedCourse == null ? const Color(0xff818080) : AppColors.black),
                                  ),
                                ),
                              ),
                              const WidthBox(8),
                              GestureDetector(
                                onTap: _onClearCourse,
                                child: Icon(Icons.refresh, size: 24, color: selectedCourse == null ? const Color(0xffa1a1a1) : AppColors.black),
                              )
                            ],
                          ),
                          const HeightBox(32),
                          BasicButton("검색", _onClickSearch),
                          const Spacer(),
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget codeButton(String name, String code, bool isSelected, Function(String) onClick){
    BoxDecoration decoration = isSelected
        ? BoxDecoration(
      color: const Color(0xffEAF1FF),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(width: 1, color: AppColors.primary),
    ) : BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(width: 1, color: const Color(0xffBBCDDA)),
    );
    Color textColor = isSelected ? AppColors.primary : const Color(0xffBBCDDA);
    return GestureDetector(
      onTap: () => onClick.call(code),
      child: Container(
        height: 60,
        decoration: decoration,
        alignment: Alignment.center,
        child: Text(name, style: TextStyle(color: textColor)),
      ),
    );
  }
}
