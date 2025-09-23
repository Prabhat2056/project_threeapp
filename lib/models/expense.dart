// Model
// class Expense {
//   final String id;
//   final String title;
//   final double amount;
//   final String? description;
//   final DateTime date;

//   Expense({
//     required this.id,
//     required this.title,
//     required this.amount,
//     this.description,
//     required this.date,
//   });
// }

class Expense {
  final String id;
  final String title;
  final double amount;
  final String? description;
  final DateTime date;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    this.description,
    required this.date,
  });
}
