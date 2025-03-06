import 'dart:io';

import 'package:flutter/services.dart';
import 'package:testApp/bloc/home/profile/profile_edit_bloc.dart';
import 'package:testApp/component/basic/basic_button.dart';
import 'package:testApp/component/basic/basic_text_field.dart';
import 'package:testApp/component/basic_container.dart';
import 'package:testApp/component/basic_text.dart';
import 'package:testApp/component/common/asset_widget.dart';
import 'package:testApp/component/common/height_box.dart';
import 'package:testApp/component/common/navigation.dart';
import 'package:testApp/component/common/width_box.dart';
import 'package:testApp/constant/assets.dart';
import 'package:testApp/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testApp/model/user.dart';
import 'package:testApp/util/extensions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../util/toast_helper.dart';

class ProfileEditPage extends StatefulWidget {
  final User user;
  const ProfileEditPage({super.key, required this.user});

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> with TickerProviderStateMixin {
  final ProfileEditBloc _bloc = ProfileEditBloc();

  _onClickProfile() {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // 모달 바깥 영역 터치시 닫히지 않도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.center,
          title: const Text('프로필 사진 수정', textAlign: TextAlign.center),
          content: const Text('프로필 사진 수정 방법을 선택해주세요', textAlign: TextAlign.center),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: <Widget>[
            GestureDetector(
              child: Container(color: Colors.transparent, child: const Text('카메라', style: TextStyle(fontSize: 16, color: Colors.black))),
              onTap: () {
                Navigator.of(context).pop(); // 모달 닫기
                _onClickCamera();
              },
            ),
            GestureDetector(
              child:Container(color: Colors.transparent, child: const Text('갤러리', style: TextStyle(fontSize: 16, color: Colors.black))),
              onTap: () {
                Navigator.of(context).pop(); // 모달 닫기
                _onClickGallery();
              },
            ),
            GestureDetector(
              child: Container(color: Colors.transparent, child: const Text('삭제', style: TextStyle(fontSize: 16, color: Colors.red))),
              onTap: () {
                Navigator.of(context).pop(); // 모달 닫기
                _bloc.add(DeleteImageProfileEdit());
              },
            ),
            GestureDetector(
              child: Container(color: Colors.transparent, child: const Text('취소', style: TextStyle(fontSize: 16, color: Colors.grey))),
              onTap: () {
                Navigator.of(context).pop(); // 모달 닫기
              },
            ),
          ],
        );
      },
    );
  }

  String editedImage = "";
  ImagePicker picker = ImagePicker();
  _onClickCamera() async {
    picker.pickImage(source: ImageSource.camera).then((value) async {
      if(value != null){
        File file = File(value.path.toString());
        _setFile(file);
      }
    }).onError((error, stackTrace) => _onHandleError(error));
  }

  _onClickGallery() async {
    picker.pickImage(source: ImageSource.gallery).then((value) async {
      if(value != null){
        File file = File(value.path.toString());
        _setFile(file);
      }
    }).onError((error, stackTrace) => _onHandleError(error));
  }

  _setFile(File file) async {
    var fileBytes = await file.readAsBytes();
    var fileSize = fileBytes.lengthInBytes;
    String unit = "KB";
    double size = fileSize.toDouble();
    var fileSizeInKB = fileSize / 1000;

    size = fileSizeInKB;
    if(fileSizeInKB > 1000){
      var fileSizeInMB = fileSizeInKB / 1000;
      unit = "MB";
      size = fileSizeInMB;
      if(fileSizeInMB > 1000){
        var fileSizeInGB = fileSizeInMB / 1000;
        unit = "GB";
        size = fileSizeInGB;
        if(fileSizeInGB > 1000){
          var fileSizeInTB = fileSizeInGB / 1000;
          unit = "TB";
          size = fileSizeInTB;
        }
      }
    }

    setState(() {
      _file = file;
      _fileSize = "${size.toStringAsFixed(2)}$unit";
    });
  }

  File? _file;
  String? _fileSize;

  _onHandleError(Object? error){
    if(error is PlatformException){
      getPermission();
    }
  }

  Future<void> getPermission() async {
    final statusStorage = await Permission.storage.request();
    final statusCamera = await Permission.camera.request();
    if (statusStorage == PermissionStatus.granted && statusCamera == PermissionStatus.granted) {
      /// 둘 다 APPROVED
      print('Permission granted');
    } else if (statusStorage == PermissionStatus.permanentlyDenied || statusCamera == PermissionStatus.permanentlyDenied) {
      /// 둘 다 PERMANENT DENIED
      print('Take the user to the settings page.');
      await openAppSettings();
    } else if (statusStorage == PermissionStatus.denied || statusCamera == PermissionStatus.denied) {
      /// 1개 이상 DENIED
      print('Permission denied. Show a dialog and again ask for the permission');
    }
  }

  bool _isRetirement = false;
  _onClickRetirement(bool isRetirement){
    setState(() {
      _isRetirement = isRetirement;
    });
  }

  String companyName = "";
  _onCompanyNameChange(String text){
    setState(() {
      companyName = text;
    });
  }

  String job = "";
  _onJobChange(String text){
    setState(() {
      job = text;
    });
  }

  String level = "";
  _onLevelChange(String text){
    setState(() {
      level = text;
    });
  }

  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController officePhoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController officeAddressController = TextEditingController();
  final TextEditingController jobController = TextEditingController();
  final TextEditingController levelController = TextEditingController();

  _onClickEdit(){
    String mobileNumber = mobileNumberController.text.trim();
    String officePhone = officePhoneController.text.trim();


    if (mobileNumber.isEmpty) {
      // Fluttertoast.showToast(msg: "전화번호는 필수입니다.");
      showToast("전화번호는 필수입니다.");
      return;
    }

    if (mobileNumber.length != 11) {
      // Fluttertoast.showToast(msg: "휴대전화번호 11자리를 입력해주세요");
      showToast("휴대전화번호 11자리를 입력해주세요.");
      return;
    }

    if (officePhone.isNotEmpty && (officePhone.length != 10 && officePhone.length != 11)) {
      // Fluttertoast.showToast(msg: "사무실 번호는 10자리 또는 11자리를 입력해주세요");
      showToast("사무실 번호는 10자리 또는 11자리를 입력해주세요.");
      return;
    }

    var user = widget.user;
    Map<String, dynamic> body = {
      "id": user.id,
      "loginId": user.loginId,
      "email": emailController.text.trim().isEmpty ? null : emailController.text.trim(),
      "mobileNumber": mobileNumberController.text.trim().isEmpty ? null : mobileNumberController.text.trim(),
      "name": user.name,
      "job": jobController.text.trim().isEmpty ? null : jobController.text.trim(),
      "level": levelController.text.trim().isEmpty ? null : levelController.text.trim(),
    };


    if (user.isStudent) {
      body.addAll({
        "companyName": companyNameController.text.trim().isEmpty ? null : companyNameController.text.trim(),
        "officePhone": officePhoneController.text.trim().isEmpty ? null : officePhoneController.text.trim(),
        "email": emailController.text.trim().isEmpty ? null : emailController.text.trim(),
        "officeAddress": officeAddressController.text.trim().isEmpty ? null : officeAddressController.text.trim(),
        "retirement": _isRetirement,
      });
    }

    _bloc.add(DoProfileEdit(
      body,
      _file,
    ));
  }
  bool isDeleted = false; // 삭제 여부를 추적하는 변수

  _onListenBloc(BuildContext context, ProfileEditState state) async {
    if(state is ProfileEditDefault){
      // if(state.message.isExist){
      //   Fluttertoast.showToast(msg: state.message!);
      // }
      setState(() {
        if (state.message == "deleted") {
          _file = null;  // 🔥 삭제 이벤트일 때만 기본 이미지 적용
          isDeleted = true; // 🔥 삭제됨을 표시
        }
      });
    }else if(state is ProfileEditDone){
      // Fluttertoast.showToast(msg: state.message);
      showToast(state.message);
      Navigator.of(context).pop(true);
    }
  }

  @override
  void initState() {
    super.initState();
    _isRetirement = widget.user.retirement;
    companyName = widget.user.companyName ?? "";
    companyNameController.text = widget.user.companyName ?? "";
    mobileNumberController.text = widget.user.mobileNumber ?? "";
    officePhoneController.text = widget.user.officePhone ?? "";
    emailController.text = widget.user.email ?? "";
    officeAddressController.text = widget.user.officeAddress ?? "";
    jobController.text = widget.user.job ?? "";
    levelController.text = widget.user.level ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return _body;
  }
}

extension on _ProfileEditPageState {
  Widget get _body {
    User user = widget.user;
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: BlocListener(
          bloc: _bloc,
          listener: _onListenBloc,
          child: BlocBuilder(
            bloc: _bloc,
            builder: (_, ProfileEditState state) {
              return Column(
                children: [
                  const Navigation(title: "내 프로필"),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 160,
                            height: 160,
                            child: Stack(
                              children: [
                                (_file != null) ? Positioned.fill(
                                  child: ClipOval(
                                    child: SizedBox(
                                      width: 160, // diameter
                                      height: 160,
                                      child: Image.file(
                                        _file!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ) : Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(360),
                                    // child: AssetWidget(user.profileImage ?? Assets.ic_account, width: 160, height: 160, fit: BoxFit.cover),
                                    child: (_file != null) // 사용자가 새로 선택한 이미지가 있으면 사용
                                        ? Image.file(_file!, fit: BoxFit.cover)
                                        : (widget.user.profileImage != null && widget.user.profileImage!.isNotEmpty && !isDeleted)
                                        ? AssetWidget(widget.user.profileImage!, width: 160, height: 160, fit: BoxFit.cover) // 기존 사진 유지
                                        : AssetWidget(Assets.ic_account, width: 160, height: 160, fit: BoxFit.cover), // 기본 이미지 적용
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: GestureDetector(
                                    onTap: _onClickProfile,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: const Color(0xffEE8924),
                                        borderRadius: BorderRadius.circular(360),
                                      ),
                                      child: const Icon(Icons.edit, size: 24, color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
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
                                  if(user.isPublicBirth && user.birthYear != null) const HeightBox(4),
                                  if(user.isPublicBirth && user.birthYear != null) BasicText("${user.birthYear}년생", 14, 20, FontWeight.w500),
                                  const HeightBox(8),
                                  Row(
                                    children: [
                                      Container(
                                        height: 35,
                                        padding: const EdgeInsets.symmetric(horizontal: 15),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF2155A8),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: BasicText(user.infoTitle, 20, 28, FontWeight.w700, textColor: const Color(0xffEAFAFF)),
                                      ),
                                      const WidthBox(12),
                                      BasicText(user.infoDescription, 20, 28, FontWeight.w500, textColor: Colors.black),
                                    ],
                                  ),
                                  if(user.isStudent && companyName.isNotEmpty) const HeightBox(12),
                                  if(user.isStudent && companyName.isNotEmpty) retirementWidget(user.retirement),
                                  const HeightBox(12),

                                  editWidget(Icons.phone_android, "휴대전화", mobileNumberController, onChange: (text) {
                                    String filteredText = text.replaceAll(RegExp(r'[^0-9]'), '');
                                    if (filteredText.length > 11) {
                                      filteredText = filteredText.substring(0, 11);
                                    }
                                    mobileNumberController.text = filteredText;
                                    mobileNumberController.selection = TextSelection.fromPosition(
                                      TextPosition(offset: filteredText.length),
                                    );
                                  },),
                                  if(user.isStudent) editWidget(Icons.call, "전화", officePhoneController, onChange: (text) {
                                    String filteredText = text.replaceAll(RegExp(r'[^0-9]'), '');
                                    if (filteredText.length > 11) {
                                      filteredText = filteredText.substring(0, 11);
                                    }
                                    officePhoneController.text = filteredText;
                                    officePhoneController.selection = TextSelection.fromPosition(
                                      TextPosition(offset: filteredText.length),
                                    );
                                  },),
                                  editWidget(Icons.email, "이메일", emailController),
                                  if(user.isStudent) editWidget(Icons.description_rounded, "회사명", companyNameController, onChange: _onCompanyNameChange),

                                  // 직책, 직급 부분을 회사명이 있을 때만 표시
                                  Visibility(
                                    visible: companyName.isNotEmpty,
                                    child: Column(
                                      children: [
                                        editWidget(Icons.business, "직급", levelController, onChange: _onLevelChange),
                                        editWidget(Icons.work, "직책", jobController, onChange: _onJobChange),
                                      ],
                                    ),
                                  ),

                                  editWidget(Icons.location_pin, "장소", officeAddressController),
                                  if(user.isStudent && user.advisor.isExist) const HeightBox(20),
                                  if(user.isStudent && user.advisor.isExist) const BasicText("지도교수", 14, 20, FontWeight.w500),
                                  if(user.isStudent && user.advisor.isExist) const HeightBox(4),
                                  if(user.isStudent && user.advisor.isExist) BasicContainer(padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), alignment: Alignment.centerLeft, child: BasicText(user.advisor!, 14, 18, FontWeight.w400)),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                          child: BasicButton("완료", _onClickEdit, width: double.infinity),
                        ),
                      ],
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

  Widget retirementWidget(bool retirement){
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => _onClickRetirement(false),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(_isRetirement ? Icons.radio_button_off_rounded : Icons.radio_button_checked_rounded, size: 20),
                const WidthBox(8),
                const BasicText("현직", 20, 29, FontWeight.w400, textColor: Color(0xff2C2C2E)),
              ],
            ),
          ),
          const WidthBox(28),
          GestureDetector(
            onTap: () => _onClickRetirement(true),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(_isRetirement ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded, size: 20),
                const WidthBox(8),
                const BasicText("퇴직", 20, 29, FontWeight.w400, textColor: Color(0xff2C2C2E)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget editWidget(IconData icon, String hint, TextEditingController controller, {Function(String)? onChange}){
    return Column(
      children: [
        const HeightBox(8),
        Row(
          children: [
            Icon(icon, size: 24, color: AppColors.black),
            const WidthBox(18),
            Expanded(
              child: BasicContainer(
                height: 45,
                child: BasicTextField(
                  hint,
                  controller,
                  fontSize: 16,
                  height: 20,
                  hintColor: const Color(0xff606060),
                  onChanged: onChange,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}