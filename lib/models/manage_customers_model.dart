class CustomerCard {
  int? id;
  late String name;
  late String vehicleName;
  late String regNo;
  late double dueAmount;
  late double paidAmount;

  CustomerCard({
    this.id,
    required this.name,
    required this.vehicleName,
    required this.regNo,
    required this.dueAmount,
    required this.paidAmount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'vehicleName': vehicleName,
      'regNo': regNo,
      'dueAmount': dueAmount,
      'paidAmount': paidAmount,
    };
  }

  CustomerCard.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    vehicleName = map['vehicleName'];
    regNo = map['regNo'];
    dueAmount = map['dueAmount'];
    paidAmount = map['paidAmount'];
  }
}
