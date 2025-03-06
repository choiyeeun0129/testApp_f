import 'package:gnu_mot_t/bloc/home/profile/profile_my_bloc.dart';
import 'package:gnu_mot_t/component/basic/basic_button.dart';
import 'package:gnu_mot_t/component/basic_container.dart';
import 'package:gnu_mot_t/component/basic_text.dart';
import 'package:gnu_mot_t/component/common/asset_widget.dart';
import 'package:gnu_mot_t/component/common/height_box.dart';
import 'package:gnu_mot_t/component/common/navigation.dart';
import 'package:gnu_mot_t/component/common/width_box.dart';
import 'package:gnu_mot_t/component/profile_info_widget.dart';
import 'package:gnu_mot_t/constant/assets.dart';
import 'package:gnu_mot_t/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gnu_mot_t/model/user.dart';
import 'package:gnu_mot_t/router/app_routes.dart';

class ProfileMyPage extends StatefulWidget {
  const ProfileMyPage({super.key});

  @override
  _ProfileMyPageState createState() => _ProfileMyPageState();
}

class _ProfileMyPageState extends State<ProfileMyPage> {
  final ProfileMyBloc _bloc = ProfileMyBloc();

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

  _onClickEdit(User user) async {
    Map<String, dynamic> args = {"user": user};
    var isEdited = await Navigator.of(context).pushNamed(routeProfileEditPage, arguments: args);
    if (isEdited == true) {
      _bloc.add(InitProfileMy());
    }
  }

  _onListenBloc(BuildContext context, ProfileMyState state) async {
    if (state is ProfileMyFail) {
      Fluttertoast.showToast(msg: state.message);
    }
  }

  @override
  void initState() {
    super.initState();
    _bloc.add(InitProfileMy());
  }

  @override
  Widget build(BuildContext context) {
    return _body;
  }
}

extension on _ProfileMyPageState {
  Widget get _body {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: BlocListener(
          bloc: _bloc,
          listener: _onListenBloc,
          child: BlocBuilder(
            bloc: _bloc,
            builder: (_, ProfileMyState state) {
              return Column(
                children: [
                  const Navigation(title: "내 프로필"),
                  if (state is ProfileMyDefault)
                    Expanded(child: defaultWidget(state.user))
                  else
                    const Center(child: CircularProgressIndicator()),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget defaultWidget(User user) {
    return Column(
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
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: AppColors.black, width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BasicText(user.name, 20, 29, FontWeight.w700),
                  if (user.birthYear != null) const HeightBox(4),
                  if (user.birthYear != null) BasicText("${user.birthYear}년생", 14, 20, FontWeight.w500),
                  const HeightBox(8),
                  Row(
                    children: [
                      Container(
                        height: 35,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        alignment: Alignment.center,
                        //재학,졸업
                        decoration: BoxDecoration(
                          color: const Color(0xFF2155A8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: BasicText(user.infoTitle, 20, 28, FontWeight.w700, textColor: const Color(0xffEAFAFF)),
                      ),
                      const WidthBox(12),
                      BasicText(user.infoDescription, 20, 28, FontWeight.w500, textColor: Colors.black,),
                    ],
                  ),
                  if (user.companyName?.isNotEmpty ?? false) ...[
                    const HeightBox(8),
                    BasicText(
                        "${user.retirementText} ${user.companyName}"
                            "${user.level != null && user.level!.isNotEmpty ? " | ${user.level}" : ""}"
                            "${user.job != null && user.job!.isNotEmpty ? " | ${user.job}" : ""}",
                        16, 23, FontWeight.w500
                    ),
                  ],
                  const HeightBox(20),
                  ProfileInfoWidget(Icons.phone_android, formatPhoneNumber(user.mobileNumber ?? "", isMobile: true)),
                  if (user.officePhone?.isNotEmpty ?? false) ...[
                    const HeightBox(8),
                    ProfileInfoWidget(Icons.call, formatPhoneNumber(user.officePhone ?? "", isMobile: false)),
                  ],
                  if (user.email?.isNotEmpty ?? false) ...[
                    const HeightBox(8),
                    ProfileInfoWidget(Icons.email, user.email ?? ""),
                  ],
                  if (user.officeAddress?.isNotEmpty ?? false) ...[
                    const HeightBox(8),
                    ProfileInfoWidget(Icons.location_pin, user.officeAddress ?? ""),
                  ],
                  if (user.isStudent) const HeightBox(20),
                  if (user.isStudent) const BasicText("지도교수", 14, 20, FontWeight.w500),
                  if (user.isStudent) const HeightBox(4),
                  if (user.isStudent)
                    BasicContainer(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      alignment: Alignment.centerLeft,
                      child: BasicText(user.advisor ?? "", 16, 18, FontWeight.w400),
                    ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
          child: BasicButton("수정", () => _onClickEdit.call(user), width: double.infinity),
        ),
      ],
    );
  }
}
