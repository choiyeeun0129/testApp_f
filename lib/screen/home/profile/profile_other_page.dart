import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:gnu_mot_t/bloc/home/profile/profile_other_bloc.dart';
import 'package:gnu_mot_t/component/basic_container.dart';
import 'package:gnu_mot_t/component/basic_text.dart';
import 'package:gnu_mot_t/component/common/asset_widget.dart';
import 'package:gnu_mot_t/component/common/height_box.dart';
import 'package:gnu_mot_t/component/common/navigation.dart';
import 'package:gnu_mot_t/component/common/width_box.dart';
import 'package:gnu_mot_t/component/indicator_widget.dart';
import 'package:gnu_mot_t/component/profile_info_widget.dart';
import 'package:gnu_mot_t/constant/assets.dart';
import 'package:gnu_mot_t/constant/colors.dart';
import 'package:gnu_mot_t/model/user.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../util/toast_helper.dart';

class ProfileOtherPage extends StatefulWidget {
  final User user;

  const ProfileOtherPage({super.key, required this.user});

  @override
  _ProfileOtherPageState createState() => _ProfileOtherPageState();
}

class _ProfileOtherPageState extends State<ProfileOtherPage>
    with TickerProviderStateMixin {
  final ProfileOtherBloc _bloc = ProfileOtherBloc();

  String formatPhoneNumber(String phoneNumber, {bool isMobile = true}) {
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

    if (cleanNumber.length == 11) {
      String formatted = '${cleanNumber.substring(0, 3)}-${cleanNumber.substring(3, 7)}-${cleanNumber.substring(7)}';
      return formatted;
    }

    if (cleanNumber.length == 10) {
      if (cleanNumber.startsWith("02")) {
        String formatted = '${cleanNumber.substring(0, 2)}-${cleanNumber.substring(2, 6)}-${cleanNumber.substring(6)}';
        return formatted;
      } else {
        String formatted = '${cleanNumber.substring(0, 3)}-${cleanNumber.substring(3, 6)}-${cleanNumber.substring(6)}';
        return formatted;
      }
    }

    return phoneNumber;
  }


  _onClickHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  _onClickCall(String phoneNumber) async {
    final String number = phoneNumber.replaceAll('-', '');
    print("숫자만 남겼음");

    final Uri launchUri = Uri(
      scheme: 'tel',
      path: number,
    );

    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        throw '전화를 걸 수 없습니다: $phoneNumber';
      }
    } catch (e) {
      print('전화 걸기 오류: $e');
    }
  }

  _onClickText(String phoneNumber) async {
    final String number = phoneNumber.replaceAll('-', '');

    final Uri smsUri = Uri(
      scheme: 'sms',
      path: number,
    );

    try {
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      } else {
        throw '문자를 보낼 수 없습니다: $phoneNumber';
      }
    } catch (e) {
      print('문자 보내기 오류: $e');
    }
  }

  _onClickMail(String email) async {
    // final Uri emailUri = Uri(
    //   scheme: 'mailto',
    //   path: email,
    //   queryParameters: {},
    // );

    final Uri emailUri = Uri.parse("mailto:$email");


    print("📧 메일 보내기 시도: ${emailUri.toString()}");

    try {
      bool? shouldSend = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('메일 보내기'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('다음 주소로 메일을 보내시겠습니까?'),
              const SizedBox(height: 8),
              Text('• $email'),
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
          final Uri webMailUri = Uri.parse("https://mail.google.com/mail/u/0/?view=cm&fs=1&to=$email");
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

  _onClickSave(String name, String number) async {
    try {
      // iOS 및 Android 권한 확인
      if (!await _requestPermission()) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('연락처 저장 권한이 필요합니다.')),
          );
        }
        return;
      }

      // 전화번호 형식 변경
      String phoneNumber = number.replaceAll('-', '');
      if (phoneNumber.length == 11) {
        phoneNumber = '${phoneNumber.substring(0, 3)}-'
            '${phoneNumber.substring(3, 7)}-'
            '${phoneNumber.substring(7)}';
      }

      // 연락처 생성
      final contact = Contact(
        name: Name(first: name),
        phones: [Phone(phoneNumber)],
      );

      // 🚨 iOS에서는 추가로 한 번 더 권한 요청이 필요할 수 있음
      if (Platform.isIOS) {
        bool hasPermission = await FlutterContacts.requestPermission(readonly: false);
        if (!hasPermission) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('iOS에서 연락처 저장 권한이 필요합니다. 설정에서 허용하세요.')),
            );
          }
          return;
        }
      }

      // 연락처 저장
      await FlutterContacts.insertContact(contact);

      // 성공 메시지 표시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('연락처가 저장되었습니다.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('연락처 저장 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  Future<bool> _requestPermission() async {
    if (Platform.isIOS) {
      return await FlutterContacts.requestPermission(readonly: false);
    } else {
      PermissionStatus permission = await Permission.contacts.status;
      if (permission != PermissionStatus.granted) {
        await Permission.contacts.request();
        permission = await Permission.contacts.status;
      }
      return permission == PermissionStatus.granted;
    }
  }

  _onListenBloc(BuildContext context, ProfileOtherState state) async {
    if (state is ProfileOtherFail) {
      // Fluttertoast.showToast(msg: state.message);
      showToast(state.message);
    }
  }

  @override
  void initState() {
    super.initState();
    _bloc.add(InitProfileOther(widget.user.id));
  }

  @override
  Widget build(BuildContext context) {
    return _body;
  }
}

extension on _ProfileOtherPageState {
  Widget get _body {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: BlocListener(
          bloc: _bloc,
          listener: _onListenBloc,
          child: BlocBuilder(
            bloc: _bloc,
            builder: (_, ProfileOtherState state) {
              return Column(
                children: [
                  Navigation(title: widget.user.pageTitle),
                  (state is ProfileOtherDefault)
                      ? defaultWidget(state.user)
                      : yetWidget,
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget get yetWidget {
    return const Expanded(child: IndicatorWidget());
  }

  Widget defaultWidget(User user) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15),
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(360),
              child: AssetWidget(user.profileImage ?? Assets.ic_account, width: 160, height: 160, fit: BoxFit.cover),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: AppColors.black, width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BasicText(user.name, 20, 29, FontWeight.w700),
                    if(user.isStudent && user.isPublicBirth && user.birthYear != null) const HeightBox(4),
                    if(user.isStudent && user.isPublicBirth && user.birthYear != null) BasicText("${user.birthYear}년생", 14, 20, FontWeight.w500),
                    const HeightBox(8),
                    Row(
                      children: [
                        Container(
                          height: 35,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFF6E6E6E),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:  BasicText(user.infoTitle, 20, 28, FontWeight.w700, textColor: const Color(0xffEAFAFF)),
                        ),
                        const WidthBox(12),
                        BasicText(user.infoDescription, 20, 28, FontWeight.w500, textColor: Colors.black,),
                        const Spacer(),
                      ],
                    ),
                    if (user.isStudent && user.isPublicDepartment && user.companyName != null) ...[
                      const HeightBox(8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal, // 🔹 가로 스크롤 가능하게 설정
                        child: Row(
                          children: [
                            BasicText(
                              "${user.retirementText} ${user.companyName}"
                                  "${user.level != null && user.level!.isNotEmpty ? " | ${user.level}" : ""}"
                                  "${user.job != null && user.job!.isNotEmpty ? " | ${user.job}" : ""}",
                              16, 23, FontWeight.w500,
                            ),
                          ],
                        ),
                      )
                    ],
                    const HeightBox(20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (user.isPublicMobile) ...[
                          ProfileInfoWidget(Icons.phone_android, formatPhoneNumber(user.mobileNumber ?? "", isMobile: true)),
                          const HeightBox(8),
                        ],

                        if ((user.isStudent || user.roleCode == "ROLE_1" || user.roleCode == "ROLE_2") &&
                            user.isPublicOffice &&
                            (user.officePhone?.isNotEmpty ?? false)) ...[
                          ProfileInfoWidget(Icons.call, formatPhoneNumber(user.officePhone ?? "", isMobile: false)),
                          const HeightBox(8),
                        ],

                        if (user.isPublicEmail && (user.email?.isNotEmpty ?? false)) ...[
                          ProfileInfoWidget(Icons.email, user.email ?? ""),
                          if (user.isPublicOffice || user.isStudent) const HeightBox(8), // 다음 위젯이 있을 때만 간격 추가
                        ],
                        if (user.isPublicOffice && (user.officeAddress?.isNotEmpty ?? false)) ...[
                          ProfileInfoWidget(Icons.location_pin, user.officeAddress ?? ""),
                          const HeightBox(20),
                        ]
                        else if (user.isStudent) ...[
                          const HeightBox(20),
                        ],

                        if (user.isStudent) ...[
                          const BasicText("지도교수", 14, 20, FontWeight.w500),
                          const HeightBox(4),
                          BasicContainer(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            alignment: Alignment.centerLeft,
                            child: BasicText(user.advisor ?? "", 16, 18, FontWeight.w400),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
          const HeightBox(12),
          bottom(user),
        ],
      ),
    );
  }

  Widget bottom(User user) {
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
          if (user.isPublicMobile && (user.mobileNumber != null))
            GestureDetector(
              onTap: () => _onClickCall(user.mobileNumber!),
              child: Container(
                color: Colors.transparent,
                alignment: Alignment.center,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.call, size: 32, color: AppColors.black),
                    BasicText("전화", 12, 28, FontWeight.w400),
                  ],
                ),
              ),
            ),
          if (user.isPublicMobile && (user.mobileNumber != null))
            GestureDetector(
              onTap: () => _onClickText(user.mobileNumber!),
              child: Container(
                color: Colors.transparent,
                alignment: Alignment.center,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.textsms_rounded, size: 32, color: AppColors.black),
                    BasicText("문자", 12, 28, FontWeight.w400),
                  ],
                ),
              ),
            ),
          if (user.isPublicEmail && (user.email != null))
            GestureDetector(
              onTap: () => _onClickMail(user.email!),
              child: Container(
                color: Colors.transparent,
                alignment: Alignment.center,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.mail_rounded, size: 32, color: AppColors.black),
                    BasicText("메일", 12, 28, FontWeight.w400),
                  ],
                ),
              ),
            ),
          if (user.isPublicMobile && (user.mobileNumber != null))
            GestureDetector(
              onTap: () => _onClickSave(user.name, user.mobileNumber!),
              child: Container(
                color: Colors.transparent,
                alignment: Alignment.center,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bookmark, size: 32, color: AppColors.black),
                    BasicText("저장", 12, 28, FontWeight.w400),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
