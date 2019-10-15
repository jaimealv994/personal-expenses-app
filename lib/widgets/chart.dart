import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persona_expenses_app/widgets/chart_bar.dart';

import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  double get totalExpending {
    return groupedTransactions.fold(0.0, (acc, data) => acc + data['amount']);
  }

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      final DateTime weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0;

      for (var transaction in recentTransactions) {
        if (DateFormat.yMd().format(transaction.date) ==
            DateFormat.yMd().format(weekDay)) {
          totalSum += transaction.amount;
        }
      }

      print(weekDay);

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: groupedTransactions.map((data) {
          return ChartBar(
              data['day'],
              data['amount'],
              totalExpending == 0.0
                  ? 0.0
                  : (data['amount'] as double) / totalExpending);
        }).toList(),
      ),
    );
  }
}
