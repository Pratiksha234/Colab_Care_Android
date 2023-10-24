class UserData {
  final String uid;
  final String first_name;
  final String last_name;
  final String email;
  final String user_role;
  final String token;

  UserData({
    required this.uid,
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.token,
    // required this.goals,
    required this.user_role,
    // required this.dailyCheckin,
    // required this.val1,
    // required this.val2,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'token': token,
      // 'goals': goals,
      'user_role': user_role,
      // 'daily Check in': dailyCheckin,
      // 'val1': val1,
      // 'val2': val2,
    };
  }
}
