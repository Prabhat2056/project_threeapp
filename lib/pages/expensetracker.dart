
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:project_etb/models/expense.dart';

class ExpenseTracker extends StatefulWidget {
  const ExpenseTracker({super.key});

  @override
  State<ExpenseTracker> createState() => _ExpenseTrackerState();
}

class _ExpenseTrackerState extends State<ExpenseTracker> {
  final CollectionReference _expenseRef = FirebaseFirestore.instance.collection('expenses');

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _searchController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  DateTime? _searchDate;

  Expense expenseFromMap(Map<String, dynamic> map) {
    DateTime date;
    if (map['date'] is Timestamp) {
      date = (map['date'] as Timestamp).toDate();
    } else if (map['date'] is DateTime) {
      date = map['date'] as DateTime;
    } else {
      date = DateTime.now();
    }

    return Expense(
      id: map['id'],
      title: map['title'] ?? '',
      amount: (map['amount'] as num).toDouble(),
      description: map['description'] ?? '',
      date: date,
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickSearchDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _searchDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _searchDate = picked;
        _searchController.text = DateFormat('yyyy/MM/dd').format(picked);
      });
    }
  }

  void _addExpense() async {
    final title = _titleController.text.trim();
    final amount = double.tryParse(_amountController.text);
    final description = _descriptionController.text.trim();

    if (title.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid title and amount')),
      );
      return;
    }

    await _expenseRef.add({
      'title': title,
      'amount': amount,
      'description': description,
      'date': _selectedDate,
    });

    _titleController.clear();
    _amountController.clear();
    _descriptionController.clear();
    setState(() => _selectedDate = DateTime.now());

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Expense Added!')));
  }

  void _deleteExpense(String id) async {
    await _expenseRef.doc(id).delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Expense deleted')));
  }

  void _showUpdateDialog(Expense exp) {
    final _updateTitleController = TextEditingController(text: exp.title);
    final _updateAmountController = TextEditingController(text: exp.amount.toString());
    final _updateDescriptionController = TextEditingController(text: exp.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Expense'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: _updateTitleController, decoration: const InputDecoration(labelText: 'Title')),
              const SizedBox(height: 10),
              TextField(
                controller: _updateAmountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount'),
              ),
              const SizedBox(height: 10),
              TextField(controller: _updateDescriptionController, decoration: const InputDecoration(labelText: 'Description')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final updatedTitle = _updateTitleController.text.trim();
              final updatedAmount = double.tryParse(_updateAmountController.text);
              final updatedDescription = _updateDescriptionController.text.trim();

              if (updatedTitle.isEmpty || updatedAmount == null || updatedAmount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter valid title and amount')),
                );
                return;
              }

              await _expenseRef.doc(exp.id).update({
                'title': updatedTitle,
                'amount': updatedAmount,
                'description': updatedDescription,
              });

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Expense updated')));
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 232, 231, 236),
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        backgroundColor: const Color.fromARGB(255, 215, 197, 35),
      ),
      body: Column(
        children: [
          // Input Section
          SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.yellow[200], borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder())),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Amount', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),
                  TextField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder())),
                  const SizedBox(height: 10),
                  ElevatedButton(onPressed: _addExpense, child: const Text('Add Expense')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Expense List Section
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.yellow[100], borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  // Search Box
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.yellow[200], borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'Search by Date (yyyy/MM/dd)',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            onTap: _pickSearchDate,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchDate = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: const Text(
                      "Expenses List",
                      style: TextStyle(fontSize: 20, decoration: TextDecoration.underline, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Expense list
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _expenseRef.orderBy('date', descending: true).snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                        final expenses = snapshot.data!.docs.map((doc) {
                          final map = doc.data() as Map<String, dynamic>;
                          map['id'] = doc.id;
                          return expenseFromMap(map);
                        }).toList();

                        final filteredExpenses = _searchDate == null
                            ? expenses
                            : expenses.where((exp) => DateFormat('yyyy/MM/dd').format(exp.date) == DateFormat('yyyy/MM/dd').format(_searchDate!)).toList();

                        if (filteredExpenses.isEmpty) return const Center(child: Text('No expenses found'));

                        // Group by date
                        final Map<String, List<Expense>> groupedExpenses = {};
                        for (var exp in filteredExpenses) {
                          final formattedDate = DateFormat('yyyy/MM/dd').format(exp.date);
                          groupedExpenses.putIfAbsent(formattedDate, () => []);
                          groupedExpenses[formattedDate]!.add(exp);
                        }

                        return ListView(
                          children: groupedExpenses.entries.map((entry) {
                            final date = entry.key;
                            final expList = entry.value;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(date, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                                ),
                                Table(
                                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                  columnWidths: const {
                                    0: FlexColumnWidth(3),
                                    1: FlexColumnWidth(4),
                                    2: FlexColumnWidth(2),
                                    3: FlexColumnWidth(2),
                                  },
                                  border: TableBorder(
                                    horizontalInside: BorderSide(color: Colors.grey.shade300, width: 1),
                                    bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                                  ),
                                  children: [
                                    // Header
                                    TableRow(
                                      decoration: BoxDecoration(color: Colors.yellow.shade300),
                                      children: const [
                                        Padding(padding: EdgeInsets.all(8.0), child: Text('Title', style: TextStyle(fontWeight: FontWeight.bold))),
                                        Padding(padding: EdgeInsets.all(8.0), child: Text('Description', style: TextStyle(fontWeight: FontWeight.bold))),
                                        Padding(padding: EdgeInsets.all(8.0), child: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold))),
                                        Padding(padding: EdgeInsets.all(8.0), child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                                      ],
                                    ),
                                    // Expense rows
                                    ...expList.map((exp) => TableRow(
                                          children: [
                                            Padding(padding: const EdgeInsets.all(8.0), child: Text(exp.title)),
                                            Padding(padding: const EdgeInsets.all(8.0), child: Text(exp.description ?? '')),
                                            Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text("\Rs.${exp.amount.toStringAsFixed(0)}",
                                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 102, 104, 106)))),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  GestureDetector(onTap: () => _showUpdateDialog(exp), child: const Icon(Icons.edit, color: Colors.blue, size: 20)),
                                                  const SizedBox(width: 8),
                                                  GestureDetector(onTap: () => _deleteExpense(exp.id), child: const Icon(Icons.delete, color: Colors.red, size: 20)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ],
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


