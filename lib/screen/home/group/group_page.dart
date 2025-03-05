import 'package:gnu_mot_t/bloc/home/group/group_bloc.dart';
import 'package:gnu_mot_t/component/basic_container.dart';
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
import 'package:url_launcher/url_launcher.dart';

import '../../../util/toast_helper.dart';

class GroupPage extends StatefulWidget {
  final String name;
  final String type;
  final String code;

  const GroupPage(
      {super.key, required this.name, required this.type, required this.code});

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> with TickerProviderStateMixin {
  final GroupBloc _bloc = GroupBloc();

  List<User> selectedUserList = [];
  _onClickUser(User user, bool isSelectable) {
    if(isOnSelectText || isOnSelectMail){
      if(isSelectable){
        int index = selectedUserList.indexWhere((selectedUser) => selectedUser.id == user.id);
        if(index == -1){
          setState(() {
            selectedUserList.add(user);
          });
        }else{
          setState(() {
            selectedUserList.removeAt(index);
          });
        }
      }
    }else{
      Map<String, dynamic> args = {"user": user};
      Navigator.pushNamed(context, routeProfileOtherPage, arguments: args);
    }
  }

  _onClearCheck(){
    setState(() {
      selectedUserList = [];
      isOnSelectText = false;
      isOnSelectMail = false;
    });
  }

  _onDoneCheck() async {
    if(selectedUserList.isNotEmpty){
      if(isOnSelectText){
        await _onSendText(selectedUserList);
      }else if(isOnSelectMail){
        await _onSendMail(selectedUserList);
      }
      _onClearCheck();
    }else{
      // Fluttertoast.showToast(msg: "대상을 선택해주세요.");
      showToast("대상을 선택해주세요.");
    }
  }

  _onClickHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  bool isOnSelectText = false;
  _onClickText(List<User> userList) async {
    if(isOnSelectText == false && isOnSelectMail == false){
      setState(() {
        isOnSelectText = true;
      });
    }
  }

  _onSendText(List<User> userList) async {
    List<String> phoneNumbers = userList
        .where((user) => (user.isPublicMobile && (user.mobileNumber != null)))
        .map((user) => user.mobileNumber!)
        .toList();

    final List<String> numbers =
    phoneNumbers.map((number) => number.replaceAll('-', '')).toList();

    final String separator =
    Theme.of(context).platform == TargetPlatform.iOS ? ',' : ';';
    final String joinedNumbers = numbers.join(separator);

    Uri smsUri;

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      // ✅ iOS용 수정
      smsUri = Uri(
        scheme: 'sms',
        path: '',
        queryParameters: {'addresses': joinedNumbers},
      );
    } else {
      // ✅ Android용
      smsUri = Uri(
        scheme: 'sms',
        path: joinedNumbers,
      );
    }

    try {
      if (await canLaunchUrl(smsUri)) {
        bool? shouldSend = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('단체 문자 보내기'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('다음 연락처로 문자를 보내시겠습니까?'),
                const SizedBox(height: 8),
                ...phoneNumbers.map((number) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text('• $number'),
                )),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('확인'),
              ),
            ],
          ),
        );

        if (shouldSend == true) {
          await launchUrl(smsUri);
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('문자를 보낼 수 없습니다.')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류가 발생했습니다: $e')),
        );
      }
    }
  }

  bool isOnSelectMail = false;
  _onClickMail(List<User> userList) async {
    if(isOnSelectText == false && isOnSelectMail == false){
      setState(() {
        isOnSelectMail = true;
      });
    }
  }
  _onSendMail(List<User> userList) async {
    // 이메일 주소들을 쉼표로 구분
    List<String> recipients = userList.where((user) => (user.isPublicEmail && (user.email != null))).map((user) => user.email!).toList();
    final String recipientsStr = recipients.join(',');


    // final Uri emailUri = Uri(
    //   scheme: 'mailto',
    //   path: recipientsStr,
    //   queryParameters: {
    //   },
    // );

    final Uri emailUri = Uri.parse("mailto:$recipientsStr");


    print("📧 단체 메일 보내기 시도: ${emailUri.toString()}");

    try {
      bool? shouldSend = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('단체 메일 보내기'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('다음 주소로 메일을 보내시겠습니까?'),
              const SizedBox(height: 8),
              Text('• ${recipients.join(', ')}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('확인'),
            ),
          ],
        ),
      );

      if (shouldSend == true) {
        if (await canLaunchUrl(emailUri)) {
          debugPrint("✅ 메일 앱 실행 가능");
          await launchUrl(emailUri, mode: LaunchMode.externalApplication);
        } else {
          debugPrint("❌ 메일 앱 실행 불가능, Gmail 웹으로 이동");
          final Uri webMailUri = Uri.parse("https://mail.google.com/mail/u/0/?view=cm&fs=1&to=$recipientsStr");
          if (await canLaunchUrl(webMailUri)) {
            await launchUrl(webMailUri, mode: LaunchMode.externalApplication);
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('메일을 보낼 수 없습니다. 다른 메일 앱을 사용해보세요.')),
              );
            }
          }
        }
      }
    } catch (e) {
      debugPrint("⚠️ 오류 발생: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류가 발생했습니다: $e')),
        );
      }
    }
  }

  late ScrollController controller;
  bool isOnLoad = false;

  void _scrollListener() {
    if(!isOnLoad){
      if (controller.position.extentAfter < 500) {
        isOnLoad = true;
        _bloc.add(LoadGroup(widget.type, widget.code));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _bloc.add(LoadGroup(widget.type, widget.code));
    controller = ScrollController()..addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return _body;
  }
}

extension on _GroupPageState {
  Widget get _body {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: BlocListener(
          bloc: _bloc,
          listener: (_, GroupState state) {
            isOnLoad = false;
            if (state.message != null) {
              // Fluttertoast.showToast(msg: state.message!);
              showToast(state.message!);
            }
          },
          child: BlocBuilder(
            bloc: _bloc,
            builder: (_, GroupState state) {
              return Column(
                children: [
                  Navigation(title: widget.name),
                  if(isOnSelectText || isOnSelectMail) checkController,
                  Expanded(
                    child: ListView.builder(
                      controller: controller,
                      itemCount: state.userList.length,
                      itemBuilder: (_, index) =>
                          userItem(state.userList[index], index),
                    ),
                  ),
                  bottom(state.userList),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget get checkController {
    String text = "완료";
    if(isOnSelectText) text = "문자 전송";
    if(isOnSelectMail) text = "메일 전송";
      return Column(
        children: [
          const HeightBox(4),
          Row(
            children: [
              const Spacer(),
              GestureDetector(
                onTap: _onClearCheck,
                child: const BasicContainer(width: 72, height: 28, alignment: Alignment.center, child: BasicText("초기화", 14, 28, FontWeight.w400)),
              ),
              const WidthBox(12),
              GestureDetector(
                onTap: _onDoneCheck,
                child: BasicContainer(width: 84, height: 28, alignment: Alignment.center, child: BasicText(text, 14, 28, FontWeight.w400)),
              ),
              const WidthBox(12),
            ],
          ),
          const HeightBox(12),
        ],
      );
  }
  Widget userItem(User user, int index) {
    Color backgroundColor = index.isEven ? const Color(0xffEBEDFF) : const Color(0xffF7F8FA);
    bool isChecked = (selectedUserList.indexWhere((selectedUser) => selectedUser.id == user.id) != -1);
    IconData checkIcon = isChecked ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded;
    bool isSelectable =
        (isOnSelectText && user.isPublicMobile && user.mobileNumber != null && user.mobileNumber!.isNotEmpty) ||
            (isOnSelectMail && user.isPublicEmail && user.email != null && user.email!.isNotEmpty);
    return GestureDetector(
      onTap: () => _onClickUser(user, isSelectable),
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
                  if (user.isStudent && user.isPublicDepartment && user.companyName != null)
                    const HeightBox(6),
                  if (user.isStudent && user.isPublicDepartment && user.companyName != null)
                    SingleChildScrollView( // ✅ 가로 스크롤 가능하게 감싸기
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          BasicText(
                            user.companyName!,
                            12, 10, FontWeight.w400,
                            textColor: const Color(0xff616161),
                          ),
                        ],
                      ),
                    ),
                  if(user.isPublicEmail && user.email != null) BasicText(user.email!, 12, 20, FontWeight.w400, textColor: const Color(0xff616161)),
                ],
              ),
            ),
            if(isSelectable) const WidthBox(20),
            if(isSelectable) Icon(checkIcon, size: 24),
          ],
        ),
      ),
    );
  }

  Widget bottom(List<User> userList) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        border: Border(
          top: BorderSide(color: Colors.white, width: 3),
        ),
      ),
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: _onClickHome,
            child: Container(
              color: Colors.transparent,
              alignment: Alignment.center,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.home_rounded, size: 32, color: AppColors.black),
                  BasicText("홈", 12, 28, FontWeight.w400),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _onClickText(userList),
            child: Container(
              color: Colors.transparent,
              alignment: Alignment.center,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.textsms_rounded, size: 32, color: AppColors.black),
                  BasicText("단체문자", 12, 28, FontWeight.w400),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _onClickMail(userList),
            child: Container(
              color: Colors.transparent,
              alignment: Alignment.center,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mail_rounded, size: 32, color: AppColors.black),
                  BasicText("단체메일", 12, 28, FontWeight.w400),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
