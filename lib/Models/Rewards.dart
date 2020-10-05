class Rewards {
  int id;
  int users_point;
  String rewards;
  Rewards({
    this.id,
    this.users_point,
    this.rewards
  });
  factory Rewards.fromJson(Map<String , dynamic> json){
    return Rewards(
      id : json['id'] as int,
      users_point : json['users_point'] as int,
      rewards : json['rewards'] as String
    );
  }
  Map<String , dynamic> toJsonCreate() => {
    'rewards' : rewards,
    'users_point' : users_point
  };
  Map<String , dynamic> toJsonUpdate() => {
    'id' : id,
    'users_point' : users_point,
    'rewards' : rewards
  };
}