class RegisterModel {
  final String fullName;
  final String email;
  final String phone;
  final String password;

  RegisterModel({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "email": email,
        "phone": phone,
        "password": password,
      };
}
