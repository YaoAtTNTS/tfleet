

import 'package:flutter/material.dart';

class AppLocalizations {

  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'network_issue':'Network connection issue',
      'login': 'Login',
      'attendance' : 'Attendance',
      'account': 'Mobile No',
      'password': 'Password',
      'please_key_in_pass': 'Please key in password.',
      'forgot_password': 'Forgot password?',
      'no_account' : 'No account? ',
      'tap_to_register' : 'Tap to register',
      'register': 'Register',
      'login_failed': 'Login failed',
      'invalid_credential': 'Invalid Credential',
      'account_does_not_exist': 'Account does not exist.',
      'mobile_already_existed' : 'Mobile already existed',
      'driver' : 'Driver',
      'passenger' : 'Passenger',
      'subcon' : 'Subcon',
      'attendant' : 'Attendant',
      'username' : 'Username',
      'please_confirm_pass' : 'Please confirm password',
      'confirm_password' :  'Confirm password',
      'profile_image' :  'Profile image',
      'camera' : 'Camera',
      'gallery' : 'Gallery',
      'submit' : 'Submit',
      'planned' : 'Planned',
      'completed' : 'Completed',
      'in_progress' : 'In progress',
      'cancelled' : 'cancelled',
      'cancelled_at' : 'Cancelled at: ',
      'trips' : 'My Trips',
      'clear' : 'Clear',
      'your_upcoming_trip': 'Your upcoming trip is',
      'to' : 'to',
      'have_not_arrived_destination' : 'You have not arrived at destination yet, still have some pickup points. ',
      'have_not_arrived_departure' : 'You have not arrived at departure point yet. ',
      'start' : 'Start',
      'end' : 'End',
      'panic' : 'Panic',
      'confirm_to_report' : 'Confirm to report ?',
      'yes': 'Yes',
      'cancel': 'Cancel',
      'settings' : 'Settings',
      'edit_profile': 'Edit profile',
      'salary': 'Salary',
      'payouts': 'Payouts',
      'change_password': 'Reset Password',
      'sign_out': 'Sign out',
      'privacy_policy' : 'Privacy policy',
      'terms_condition' : 'Terms & Condition',
      'version': 'Version 1.0.0',
      'confirm_to_sign_out' : 'Confirm to sign out?',
      'key_in_old_password' : 'Please key in old password.',
      'old_password' : 'Old password',
      'key_in_new_password' : 'Please key in new password.',
      'new_password' : 'New password',
      'action' : 'Action',
      'my' : 'My',
      'address': 'Address',
      'area': 'area',
      'add_address' : 'Add address',
      'add_passenger' : 'Add passenger',
      'add_driver' : 'Add driver',
      'add_attendant': 'Add bus attendant',
      'address_management' : 'Address management',
      'children_management' : 'Passenger Management',
      'invoice_management' : 'Invoice management',
      'driver_management' : 'Driver management',
      'attendant_management': 'Attendant management',
      'edit_address' : 'Edit address',
      'edit_driver': 'Edit driver profile',
      'edit_attendant': 'Edit attendant profile',
      'confirm_to_remove_address' : 'Confirm to remove this address?',
      'confirm_to_remove_driver' : 'Confirm to remove this driver?',
      'confirm_to_remove_attendant' : 'Confirm to remove this attendant?',
      'address_name' : 'Address name',
      'unit_no' : 'Unit no',
      'street_name' : 'Street name',
      'please_key_in_address' : 'Please key in address.',
      'postal_code' : 'Postal code',
      'passenger_name' : 'Passenger name',
      'school_name' : 'School name',
      'clazz_name' : 'Class name',
      'ezlink_card' : 'Ezlink card',
      'please_key_in_ezlink' : 'Please key in EzLink card no.',
      'select_address' : 'Select address',
      'select_attendant' : 'Select attendant',
      'select_area' : 'Select area',
      'select_school' : 'Select school',
      'select_leave' : 'Select leave type',
      'select_subcon': 'Select Owner',
      'edit_passenger_profile' : 'Edit Passenger Profile',
      'confirm_to_remove_child' : 'Confirm to remove this child? ',
      'pin_your_address': 'Pin Your Address',
      'confirm_student_absent' : 'Confirm this passenger is absent or onboard?',
      'confirm_remove_trip' : 'Confirm to remove this trip ?',
      'confirm_to_remove_files' : 'Confirm to remove this file?',
      'confirm_to_delete_leave' : 'Confirm to delete this leave? ',
      'assign_trip' : 'Assign trip',
      'select_driver' : 'Select driver',
      'select_vehicle' : 'Select vehicle',
      'please_assign_driver' : 'Please assign driver',
      'please_assign_vehicle' : 'Please assign vehicle',
      'assign' : 'Assign',
      'reject' : 'Reject',
      'confirm_reject_this_trip' : 'Confirm to reject this trip? ',
      'male' : 'Male',
      'female' : 'Female',
      'youDontHaveUpcomingTrip' : 'You do not have upcoming trip.',
      'edit' : 'Edit',
      'edit_assignment' : 'Edit Assignment',
      'missed_trip': 'Missed Trip',
      'files' : 'Files',
      'unknown': 'Unknown',
      'gender' : 'Gender',
      'pickupPoint' : 'Pickup Point',
      'dropoffPoint' : 'Dropoff Point',
      'eta': 'ETA',
      'notification': 'Notification',
      'leave': 'Leave'
    },
    'zh': {
      'network_issue':'网络连接出错',
      'login': '登录',
      'attendance' : '出行记录',
      'account': '手机号码',
      'password': '密码',
      'please_key_in_pass': '请输入密码。',
      'forgot_password': '忘记密码?',
      'no_account' : '没有账户? ',
      'tap_to_register' : '点击来注册。',
      'register': '注册',
      'login_failed': '登录失败',
      'invalid_credential': '账号或密码错误',
      'account_does_not_exist': '账户不存在',
      'mobile_already_existed' : '账户已经存在',
      'driver' : '司机',
      'passenger' : '乘客',
      'subcon' : '分包商',
      'attendant' : '乘务员',
      'username' : '用户名',
      'please_confirm_pass' : '请确认密码',
      'confirm_password' :  '确认密码',
      'profile_image' :  '头像',
      'camera' : '相机',
      'gallery' : '相册',
      'submit' : '提交',
      'planned' : '计划',
      'completed' : '完成',
      'in_progress' : '进行中',
      'cancelled' : '取消',
      'cancelled_at' : '取消于: ',
      'trips' : '我的行程',
      'clear' : '清除',
      'your_upcoming_trip': '您即将进行的行程是',
      'to' : '至',
      'have_not_arrived_destination' : '您还没有到达目的地,还有未完成的车站。 ',
      'have_not_arrived_departure' : '您还没有到达出发地点。 ',
      'start' : '开始行程',
      'end' : '结束行程',
      'panic' : '紧急情况',
      'confirm_to_report' : '请确认报告?',
      'yes': '确定',
      'cancel': '取消',
      'settings' : '设置',
      'edit_profile': '编辑资料',
      'salary': '薪水',
      'payouts': '收款',
      'change_password': '修改密码',
      'sign_out': '退出',
      'privacy_policy' : '隐私权政策',
      'terms_condition' : '条款与条件',
      'version': '版本 1.0.0',
      'confirm_to_sign_out' : '请确认退出?',
      'key_in_old_password' : '请输入旧密码。',
      'old_password' : '旧密码',
      'key_in_new_password' : '请输入新密码。',
      'new_password' : '新密码',
      'action' : '工作',
      'my' : '我的',
      'address': '地址',
      'area':'区域',
      'add_address' : '添加地址',
      'add_passenger' : '添加乘客',
      'add_driver': '添加司机',
      'add_attendant' : '添加乘务员',
      'address_management' : '地址管理',
      'children_management': '乘客管理',
      'invoice_management': '发票管理',
      'driver_management' : '司机管理',
      'attendant_management': '乘务员管理',
      'edit_address' : '编辑地址',
      'edit_driver': '编辑司机资料',
      'edit_attendant': '编辑乘务员资料',
      'confirm_to_remove_address' : '请确认删除当前地址？',
      'confirm_to_remove_driver' : '请确认删除当前司机',
      'confirm_to_remove_attendant' : '请确认删除当前乘务员',
      'confirm_to_delete_leave': '请确认删除假期？',
      'address_name' : '地址名',
      'unit_no' : '门牌号',
      'street_name' : '街道名',
      'please_key_in_address' : '请输入地址。',
      'postal_code' : '邮编',
      'passenger_name' : '乘客名称',
      'school_name' : '学校名称',
      'clazz_name' : '班级名称',
      'ezlink_card' : '易通卡',
      'please_key_in_ezlink' : '请输入易通卡密码。',
      'select_address' : '选择地址',
      'select_attendant' : '选择乘务员',
      'select_area' : '选择区域',
      'select_school' : '请选择学校',
      'select_leave' : '请选择假期类型',
      'select_subcon': '选择承包商',
      'edit_passenger_profile' : '编辑乘客资料',
      'confirm_to_remove_child' : '请确认删除当前乘车人? ',
      'pin_your_address': '地图选点',
      'confirm_student_absent' : '请确认当前乘客没有出现或者已乘车?',
      'confirm_remove_trip' : '请确认删除当前行程 ?',
      'confirm_to_remove_files': '请确认删除文件？',
      'assign_trip' : '安排车辆司机',
      'select_driver' : '选择司机',
      'select_vehicle' : '选择车辆',
      'please_assign_driver' : '请安排司机。',
      'please_assign_vehicle' : '请安排车辆。',
      'assign' : '安排',
      'reject' : '拒绝',
      'confirm_reject_this_trip' : '确认拒绝当前行程吗？',
      'male' : '男生',
      'female' : '女生',
      'youDontHaveUpcomingTrip' : '您暂时没有未完成行程。',
      'edit' : '修改',
      'edit_assignment' : '修改行程安排',
      'missed_trip': '未按时执行',
      'files': '文件',
      'unknown': '未知',
      'gender': '性别',
      'pickupPoint': '上车点',
      'dropoffPoint' : '下车点',
      'eta': '预计到达时间',
      'notification': '消息通知',
      'leave': '假期',
    }
  };

  //                      AppLocalizations.of(context)?.password ??

  String? get networkIssue => _localizedValues[locale.languageCode]?['network_issue'];
  String? get login => _localizedValues[locale.languageCode]?['login'];
  String? get attendance => _localizedValues[locale.languageCode]?['attendance'];
  String? get account => _localizedValues[locale.languageCode]?['account'];
  String? get password => _localizedValues[locale.languageCode]?['password'];
  String? get pleaseKeyInPass => _localizedValues[locale.languageCode]?['please_key_in_pass'];
  String? get forgotPassword => _localizedValues[locale.languageCode]?['forgot_password'];
  String? get noAccount => _localizedValues[locale.languageCode]?['no_account'];
  String? get tapToRegister => _localizedValues[locale.languageCode]?['tap_to_register'];
  String? get register => _localizedValues[locale.languageCode]?['register'];
  String? get loginFailed => _localizedValues[locale.languageCode]?['login_failed'];
  String? get invalidCredential => _localizedValues[locale.languageCode]?['invalid_credential'];
  String? get accountDoesNotExist => _localizedValues[locale.languageCode]?['account_does_not_exist'];
  String? get mobileAlreadyExisted => _localizedValues[locale.languageCode]?['mobile_already_existed'];
  String? get driver => _localizedValues[locale.languageCode]?['driver'];
  String? get passenger => _localizedValues[locale.languageCode]?['passenger'];
  String? get subcon => _localizedValues[locale.languageCode]?['subcon'];
  String? get attendant => _localizedValues[locale.languageCode]?['attendant'];
  String? get username => _localizedValues[locale.languageCode]?['username'];
  String? get pleaseConfirmPass => _localizedValues[locale.languageCode]?['please_confirm_pass'];
  String? get confirmPassword => _localizedValues[locale.languageCode]?['confirm_password'];
  String? get profileImage => _localizedValues[locale.languageCode]?['profile_image'];
  String? get camera => _localizedValues[locale.languageCode]?['camera'];
  String? get gallery => _localizedValues[locale.languageCode]?['gallery'];
  String? get submit => _localizedValues[locale.languageCode]?['submit'];
  String? get planned => _localizedValues[locale.languageCode]?['planned'];
  String? get completed => _localizedValues[locale.languageCode]?['completed'];
  String? get inProgress => _localizedValues[locale.languageCode]?['in_progress'];
  String? get cancelled => _localizedValues[locale.languageCode]?['cancelled'];
  String? get cancelledAt => _localizedValues[locale.languageCode]?['cancelled_at'];
  String? get trips => _localizedValues[locale.languageCode]?['trips'];
  String? get clear => _localizedValues[locale.languageCode]?['clear'];
  String? get yourUpcomingTrip => _localizedValues[locale.languageCode]?['your_upcoming_trip'];
  String? get to => _localizedValues[locale.languageCode]?['to'];
  String? get haveNotArrivedDestination => _localizedValues[locale.languageCode]?['have_not_arrived_destination'];
  String? get haveNotArrivedDeparture => _localizedValues[locale.languageCode]?['have_not_arrived_departure'];
  String? get start => _localizedValues[locale.languageCode]?['start'];
  String? get end => _localizedValues[locale.languageCode]?['end'];
  String? get panic => _localizedValues[locale.languageCode]?['panic'];
  String? get confirmToReport => _localizedValues[locale.languageCode]?['confirm_to_report'];
  String? get yes => _localizedValues[locale.languageCode]?['yes'];
  String? get cancel => _localizedValues[locale.languageCode]?['cancel'];
  String? get settings => _localizedValues[locale.languageCode]?['settings'];
  String? get editProfile => _localizedValues[locale.languageCode]?['edit_profile'];
  String? get salary => _localizedValues[locale.languageCode]?['salary'];
  String? get payouts => _localizedValues[locale.languageCode]?['payouts'];
  String? get changePassword => _localizedValues[locale.languageCode]?['change_password'];
  String? get signOut => _localizedValues[locale.languageCode]?['sign_out'];
  String? get privacyPolicy => _localizedValues[locale.languageCode]?['privacy_policy'];
  String? get termsCondition => _localizedValues[locale.languageCode]?['terms_condition'];
  String? get version => _localizedValues[locale.languageCode]?['version'];
  String? get confirmSignOut => _localizedValues[locale.languageCode]?['confirm_to_sign_out'];
  String? get keyInOldPassword => _localizedValues[locale.languageCode]?['key_in_old_password'];
  String? get oldPassword => _localizedValues[locale.languageCode]?['old_password'];
  String? get keyInNewPassword => _localizedValues[locale.languageCode]?['key_in_new_password'];
  String? get newPassword => _localizedValues[locale.languageCode]?['new_password'];
  String? get action => _localizedValues[locale.languageCode]?['action'];
  String? get leave => _localizedValues[locale.languageCode]?['leave'];
  String? get my => _localizedValues[locale.languageCode]?['my'];
  String? get address => _localizedValues[locale.languageCode]?['address'];
  String? get area => _localizedValues[locale.languageCode]?['area'];
  String? get addAddress => _localizedValues[locale.languageCode]?['add_address'];
  String? get addDriver => _localizedValues[locale.languageCode]?['add_driver'];
  String? get addAttendant => _localizedValues[locale.languageCode]?['add_attendant'];
  String? get addPassenger => _localizedValues[locale.languageCode]?['add_passenger'];
  String? get addressManagement => _localizedValues[locale.languageCode]?['address_management'];
  String? get childrenManagement => _localizedValues[locale.languageCode]?['children_management'];
  String? get invoiceManagement => _localizedValues[locale.languageCode]?['invoice_management'];
  String? get driverManagement => _localizedValues[locale.languageCode]?['driver_management'];
  String? get attendantManagement => _localizedValues[locale.languageCode]?['attendant_management'];
  String? get editAddress => _localizedValues[locale.languageCode]?['edit_address'];
  String? get editDriver => _localizedValues[locale.languageCode]?['edit_driver'];
  String? get editAttendant => _localizedValues[locale.languageCode]?['edit_attendant'];
  String? get confirmToRemoveAddress => _localizedValues[locale.languageCode]?['confirm_to_remove_address'];
  String? get confirmToRemoveFiles => _localizedValues[locale.languageCode]?['confirm_to_remove_files'];
  String? get confirmToDeleteLeave => _localizedValues[locale.languageCode]?['confirm_to_delete_leave'];
  String? get confirmToRemoveDriver => _localizedValues[locale.languageCode]?['confirm_to_remove_driver'];
  String? get confirmToRemoveAttendant => _localizedValues[locale.languageCode]?['confirm_to_remove_attendant'];
  String? get addressName => _localizedValues[locale.languageCode]?['address_name'];
  String? get unitNo => _localizedValues[locale.languageCode]?['unit_no'];
  String? get streetName => _localizedValues[locale.languageCode]?['street_name'];
  String? get pleaseKeyInAddress => _localizedValues[locale.languageCode]?['please_key_in_address'];
  String? get postalCode => _localizedValues[locale.languageCode]?['postal_code'];
  String? get passengerName => _localizedValues[locale.languageCode]?['passenger_name'];
  String? get schoolName => _localizedValues[locale.languageCode]?['school_name'];
  String? get clazzName => _localizedValues[locale.languageCode]?['clazz_name'];
  String? get ezLinkCard => _localizedValues[locale.languageCode]?['ezlink_card'];
  String? get pleaseKeyInEzlink => _localizedValues[locale.languageCode]?['please_key_in_ezlink'];
  String? get selectAddress => _localizedValues[locale.languageCode]?['select_address'];
  String? get selectSubcon => _localizedValues[locale.languageCode]?['select_subcon'];
  String? get selectAttendant => _localizedValues[locale.languageCode]?['select_attendant'];
  String? get selectArea => _localizedValues[locale.languageCode]?['select_area'];
  String? get selectSchool => _localizedValues[locale.languageCode]?['select_school'];
  String? get selectLeave => _localizedValues[locale.languageCode]?['select_leave'];
  String? get editPassengerProfile => _localizedValues[locale.languageCode]?['edit_passenger_profile'];
  String? get confirmRemoveChild => _localizedValues[locale.languageCode]?['confirm_to_remove_child'];
  String? get pinYourAddress => _localizedValues[locale.languageCode]?['pin_your_address'];
  String? get confirmStudentAbsent => _localizedValues[locale.languageCode]?['confirm_student_absent'];
  String? get confirmRemoveThisTrip => _localizedValues[locale.languageCode]?['confirm_remove_trip'];
  String? get assignTrip => _localizedValues[locale.languageCode]?['assign_trip'];
  String? get editAssignment => _localizedValues[locale.languageCode]?['edit_assignment'];
  String? get selectDriver => _localizedValues[locale.languageCode]?['select_driver'];
  String? get selectVehicle => _localizedValues[locale.languageCode]?['select_vehicle'];
  String? get pleaseAssignDriver => _localizedValues[locale.languageCode]?['please_assign_driver'];
  String? get pleaseAssignVehicle => _localizedValues[locale.languageCode]?['please_assign_vehicle'];
  String? get assign => _localizedValues[locale.languageCode]?['assign'];
  String? get reject => _localizedValues[locale.languageCode]?['reject'];
  String? get confirmRejectThisTrip => _localizedValues[locale.languageCode]?['confirm_reject_this_trip'];
  String? get male => _localizedValues[locale.languageCode]?['male'];
  String? get female => _localizedValues[locale.languageCode]?['female'];
  String? get youDontHaveUpcomingTrip => _localizedValues[locale.languageCode]?['youDontHaveUpcomingTrip'];
  String? get edit => _localizedValues[locale.languageCode]?['edit'];
  String? get missedTrip => _localizedValues[locale.languageCode]?['missed_trip'];
  String? get files => _localizedValues[locale.languageCode]?['files'];
  String? get unknown => _localizedValues[locale.languageCode]?['unknown'];
  String? get gender => _localizedValues[locale.languageCode]?['gender'];
  String? get pickupPoint => _localizedValues[locale.languageCode]?['pickupPoint'];
  String? get dropoffPoint => _localizedValues[locale.languageCode]?['dropoffPoint'];
  String? get eta => _localizedValues[locale.languageCode]?['eta'];
  String? get notification => _localizedValues[locale.languageCode]?['notification'];
}