class Transactions {
  int id;
  String transaction_id;
  int users_id;
  String product_name;
  int product_total_count;
  int product_price;
  int product_total_price;
  int transaction_point;
  Transactions({
    this.id,
    this.transaction_id,
    this.users_id,
    this.product_name,
    this.product_total_count,
    this.product_price,
    this.product_total_price,
    this.transaction_point
  });
  factory Transactions.fromJson(Map<String , dynamic> json){
    return Transactions(
      id : json['id'] as int,
      transaction_id : json['transaction_id'] as String,
      users_id : json['users_id'] as int,
      product_name : json['product_name'] as String,
      product_total_count : json['product_total_count'] as int,
      product_price : json['product_price'] as int,
      product_total_price: json['product_total_price'] as int,
      transaction_point: json['transaction_point'] as int
    );
  }
  Map<String, dynamic> toJsonCreate() => {
    'users_id' : users_id,
    'product_name' : product_name,
    'product_total_count' : product_total_count,
    'product_price' : product_price,
    'product_total_price' : product_total_price,
    'transaction_point' : transaction_point
  };
  Map<String , dynamic> toJsonUpdate() => {
    'id' : id,
    'product_name' : product_name,
    'product_total_count' : product_total_count,
    'product_price' : product_price,
    'product_total_price' : product_total_price
  };
}