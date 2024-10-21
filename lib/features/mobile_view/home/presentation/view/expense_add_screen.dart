import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_budget/core/util/widgets/outlined_text_field.dart';

/// @author : Jibin K John
/// @date   : 17/10/2024
/// @time   : 22:14:01

class ExpenseAddScreen extends StatefulWidget {
  const ExpenseAddScreen({super.key});

  @override
  State<ExpenseAddScreen> createState() => _ExpenseAddScreenState();
}

class _ExpenseAddScreenState extends State<ExpenseAddScreen> {
  final ValueNotifier<DateTime> _date = ValueNotifier(DateTime.now());

  @override
  void dispose() {
    _date.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Add Expense",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          const Text("Choose Date"),
          FilledButton.icon(
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _date.value,
                firstDate: DateTime(1890),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                _date.value = date;
              }
            },
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            label: ValueListenableBuilder(
                valueListenable: _date,
                builder: (ctx, date, _) {
                  return Text(
                    DateFormat.yMMMEd().format(date),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15.0,
                    ),
                  );
                }),
            icon: const Icon(Icons.calendar_month_rounded),
          ),
          const SizedBox(height: 20.0),
          Text("Amount"),
          OutlinedTextField(
            textFieldKey: "amount",
            isObscure: false,
            hintText: "10,00",
            icon: Text("EUR"),

            inputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.none,
            inputType: TextInputType.number,
            validator: (value) {},
          )
        ],
      ),
    );
  }
}
