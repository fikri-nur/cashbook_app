class Transaction {
  int? id;
  String type; // 'income' atau 'outcome'
  double amount;
  String date; // Format: 'dd-mm-yyyy'
  String description;

  Transaction({
    this.id,
    required this.type,
    required this.amount,
    required this.date,
    required this.description,
  });

  // Konversi objek Transaction menjadi Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'date': date,
      'description': description,
    };
  }

  // Konversi Map menjadi objek Transaction
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      type: map['type'],
      amount: map['amount'],
      date: map['date'],
      description: map['description'],
    );
  }
}
