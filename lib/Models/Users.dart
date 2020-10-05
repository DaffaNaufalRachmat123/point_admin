class Users {
  int id;
  String username;
  String email;
  String password;
  int transactions_count;
  int users_point;
  String is_user_admin;
  Users({
    this.id,
    this.username,
    this.email,
    this.password,
    this.transactions_count,
    this.users_point,
    this.is_user_admin
  });
  factory Users.fromJson(Map<String , dynamic> json){
    return Users(
      id : json['id'] as int,
      username : json['username'] as String,
      password : json['password'] as String,
      transactions_count : json['transactions_count'] as int,
      users_point : json['users_point'] as int,
      is_user_admin : json['is_user_admin'] as String
    );
  }
  Map<String , dynamic> toJsonLogin() => {
    'username' : username,
    'password' : password
  };
  Map<String , dynamic> toJsonCreate() => {
    'username' : username,
    'email' : email,
    'password' : password,
    'is_user_admin' : is_user_admin
  };
  Map<String , dynamic> toJsonUpdate() => {
    'id' : id,
    'username' : username,
    'email' : email,
    'is_user_admin' : is_user_admin
  };
}