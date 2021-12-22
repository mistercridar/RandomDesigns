class KharchaModel {
  final int? id;
  final String kharchaName;
  final int amount;

  KharchaModel(
      { this.id,
        required this.kharchaName,
        required this.amount});

  KharchaModel.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        kharchaName = res["kharchaName"],
        amount = res["amount"];

  Map<String, Object?> toMap() {
    return {'id':id,'kharchaName': kharchaName, 'amount': amount};
  }
}
