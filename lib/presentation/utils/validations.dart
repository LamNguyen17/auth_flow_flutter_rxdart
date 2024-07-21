import 'package:flutter/material.dart';

class Validation {
  static String? validateName(String? name) {
    if(name == "" || name == null){
      return 'Name Invalid';
    }
    var isValid = RegExp(r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$").hasMatch(name);
    if (!isValid){
      return 'Name Invalid';
    }
  }

  static String? validatePhone(String? phone) {
    if (phone == null) {
      return 'Phone number Invalid';
    }
    if (phone.length < 10) {
      return 'Phone number require minimum 10 characters';
    }
    return null;
  }

  static String? validatePass(String? pass) {
    if (pass == null) {
      return 'Mật khẩu không hợp lệ';
    }
    if (pass.length < 6) {
      return 'Mật khẩu yêu cầu tối thiểu 6 ký tự';
    }
    return null;
  }

  static String? validateConfirmPass(String? pass, String? confirmPass) {
    if (pass == null || confirmPass == null) {
      return 'Mật khẩu không hợp lệ';
    }
    if (confirmPass.length < 6) {
      return 'Mật khẩu yêu cầu tối thiểu 6 ký tự';
    }
    if (pass != confirmPass) {
      return 'Mật khẩu không trùng khớp';
    }
    return null;
  }

  static String? validateEmail(String? email) {
    if (email == null) {
      return 'Email không hợp lệ';
    }
    var isValid =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    if (!isValid) {
      return 'Email không hợp lệ';
    }
    if (email.length <= 10) {
      return 'Email không nhỏ hơn 10 kí tự';
    }
    print("validateEmail: $email");
    return null;
  }
}
