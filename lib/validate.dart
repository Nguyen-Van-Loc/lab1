String validateName (String txt){
  if(txt.isEmpty){
    return "Tên khách hàng không được để trống !";
  }
  return "";
}
String validateAddress (String txt){
  if(txt.isEmpty){
    return "Dịa chỉ không được để trống !";
  }
  return "";
}String validatePhone (String txt){
  if(txt.isEmpty){
    return "Số điện thoại không được để trống !";
  }
  final RegExp _phoneNumberRegExp = RegExp(r'^(03|09)[0-9]{8}$');
  if (!_phoneNumberRegExp.hasMatch(txt)) {
    return "Số điện thoại không đúng định dạng";
  }
  return "";
}
