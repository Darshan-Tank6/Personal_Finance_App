// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import '../helpers/transaction_provider.dart';

// class TransactionDialog extends StatelessWidget {
//   final String type;
//   final Function() onSubmit;

//   TransactionDialog({required this.type, required this.onSubmit});

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<TransactionProvider>(context);
//     return AlertDialog(
//       title: Text('Add $type'),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TextField(
//             controller: provider.nameController,
//             decoration: InputDecoration(
//               labelText: type == 'Income' ? 'Source' : 'Name',
//             ),
//           ),
//           TextField(
//             controller: provider.amountController,
//             decoration: InputDecoration(labelText: 'Amount'),
//             keyboardType: TextInputType.number,
//           ),
//           Row(
//             children: [
//               Text(
//                 "Date: ${DateFormat('dd-MM-yyyy').format(provider.selectedDate)}",
//               ),
//               IconButton(
//                 icon: Icon(
//                   Icons.date_range_rounded,
//                   color: Colors.purpleAccent[100],
//                 ),
//                 onPressed: () => provider.pickDate(context),
//               ),
//             ],
//           ),
//           DropdownButtonFormField<String>(
//             value: provider.selectedPaymentType,
//             decoration: InputDecoration(labelText: "Payment Method"),
//             items:
//                 ['Cash', 'UPI', 'Card'].map((method) {
//                   return DropdownMenuItem(value: method, child: Text(method));
//                 }).toList(),
//             onChanged:
//                 (newValue) => provider.setPaymentMethod(newValue ?? 'Cash'),
//           ),
//           if (type == 'Lend' || type == 'Borrow')
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children:
//                   ['Pending', 'Paid'].map((status) {
//                     return ElevatedButton(
//                       onPressed: () => provider.setStatus(status),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor:
//                             provider.selectedStatus == status
//                                 ? Colors.purpleAccent
//                                 : Colors.grey[300],
//                         foregroundColor:
//                             provider.selectedStatus == status
//                                 ? Colors.white
//                                 : Colors.black,
//                       ),
//                       child: Text(status),
//                     );
//                   }).toList(),
//             ),
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: Text('Cancel'),
//         ),
//         TextButton(onPressed: onSubmit, child: Text('Submit')),
//       ],
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import '../helpers/transaction_provider.dart';

// class TransactionDialog extends StatelessWidget {
//   final String type;
//   final Function(
//     String name,
//     double amount,
//     String date,
//     String status,
//     String paymentMethod, [
//     String? expenseType,
//   ])
//   onSubmit;
//   final dynamic transaction;

//   TransactionDialog({
//     required this.type,
//     required this.onSubmit,
//     this.transaction,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<TransactionProvider>(context, listen: false);

//     // Pre-fill fields if editing
//     if (transaction != null) {
//       provider.setEditingTransaction(transaction, type);
//     }

//     return AlertDialog(
//       title: Text('${transaction == null ? 'Add' : 'Edit'} $type'),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TextField(
//             controller: provider.nameController,
//             decoration: InputDecoration(
//               labelText: type == 'Income' ? 'Source' : 'Name',
//             ),
//           ),
//           TextField(
//             controller: provider.amountController,
//             decoration: InputDecoration(labelText: 'Amount'),
//             keyboardType: TextInputType.number,
//           ),
//           Row(
//             children: [
//               Text(
//                 "Date: ${DateFormat('dd-MM-yyyy').format(provider.selectedDate)}",
//               ),
//               IconButton(
//                 icon: Icon(
//                   Icons.date_range_rounded,
//                   color: Colors.purpleAccent[100],
//                 ),
//                 onPressed: () => provider.pickDate(context),
//               ),
//             ],
//           ),
//           DropdownButtonFormField<String>(
//             value: provider.selectedPaymentType,
//             decoration: const InputDecoration(labelText: "Payment Method"),
//             items:
//                 ['Cash', 'UPI', 'Card'].map((method) {
//                   return DropdownMenuItem(value: method, child: Text(method));
//                 }).toList(),
//             onChanged:
//                 (newValue) => provider.setPaymentMethod(newValue ?? 'Cash'),
//           ),
//           if (type == 'Expense')
//             DropdownButtonFormField<String>(
//               value: provider.selectedExpenseType,
//               decoration: const InputDecoration(labelText: "Expense Type"),
//               items:
//                   provider.expenseTypes.map((expenseType) {
//                     return DropdownMenuItem(
//                       value: expenseType,
//                       child: Text(expenseType),
//                     );
//                   }).toList(),
//               onChanged: (newValue) => provider.setExpenseType(newValue ?? ""),
//             ),
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: const Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             onSubmit(
//               provider.nameController.text.trim(),
//               double.tryParse(provider.amountController.text) ?? 0.0,
//               DateFormat('dd-MM-yyyy').format(provider.selectedDate),
//               provider.selectedStatus,
//               provider.selectedPaymentType,
//               provider.selectedExpenseType,
//             );
//             Navigator.of(context).pop();
//           },
//           child: Text(transaction == null ? 'Submit' : 'Update'),
//         ),
//       ],
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import '../helpers/transaction_provider.dart';

// class TransactionDialog extends StatelessWidget {
//   final String type;
//   final Function(
//     String name,
//     double amount,
//     String date,
//     String status,
//     String paymentMethod, [
//     String? expenseType,
//   ])
//   onSubmit;
//   final dynamic transaction;
//   void _showAddExpenseDialog(BuildContext context) {
//     final TextEditingController _controller = TextEditingController();
//     final provider = Provider.of<TransactionProvider>(context, listen: false);

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Add Expense Type"),
//           content: TextField(
//             controller: _controller,
//             decoration: const InputDecoration(
//               hintText: "Enter new expense type",
//               border: OutlineInputBorder(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text("Cancel"),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 String newType = _controller.text.trim();
//                 if (newType.isNotEmpty &&
//                     !provider.expenseTypes.contains(newType)) {
//                   provider.addExpenseType(newType);
//                 }
//                 Navigator.of(context).pop(); // ✅ Close dialog
//               },
//               child: const Text("Add"),
//             ),
//           ],
//         );
//       },
//     ).then((_) {
//       // ✅ Refresh dropdown after dialog closes
//       provider.notifyListeners();
//     });
//   }

//   TransactionDialog({
//     required this.type,
//     required this.onSubmit,
//     this.transaction,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<TransactionProvider>(context, listen: false);

//     // Pre-fill fields if editing
//     if (transaction != null) {
//       provider.setEditingTransaction(transaction, type);
//     }

//     return AlertDialog(
//       title: Text('${transaction == null ? 'Add' : 'Edit'} $type'),
//       content: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: provider.nameController,
//               decoration: InputDecoration(
//                 labelText: type == 'Income' ? 'Source' : 'Name',
//               ),
//             ),
//             TextField(
//               controller: provider.amountController,
//               decoration: InputDecoration(labelText: 'Amount'),
//               keyboardType: TextInputType.number,
//             ),
//             Row(
//               children: [
//                 Text(
//                   "Date: ${DateFormat('dd-MM-yyyy').format(provider.selectedDate)}",
//                 ),
//                 IconButton(
//                   icon: Icon(
//                     Icons.date_range_rounded,
//                     color: Colors.purpleAccent[100],
//                   ),
//                   onPressed: () => provider.pickDate(context),
//                 ),
//               ],
//             ),

//             DropdownButtonFormField<String>(
//               value:
//                   provider.paymentMethods.contains(provider.selectedPaymentType)
//                       ? provider.selectedPaymentType
//                       : null, // Ensures value exists
//               decoration: const InputDecoration(labelText: "Payment Method"),
//               items:
//                   provider.paymentMethods.map((method) {
//                     return DropdownMenuItem(value: method, child: Text(method));
//                   }).toList(),
//               onChanged:
//                   (newValue) => provider.setPaymentMethod(newValue ?? "Cash"),
//             ),

//             if (type == 'Expense')
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 8),
//                   const Text(
//                     'Select Expense Type:',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   Consumer<TransactionProvider>(
//                     builder: (context, provider, _) {
//                       return SingleChildScrollView(
//                         scrollDirection:
//                             Axis.horizontal, // ✅ Enables horizontal scrolling
//                         child: Row(
//                           children: [
//                             ...provider.expenseTypes.map((expenseType) {
//                               return Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 4.0,
//                                 ),
//                                 child: ChoiceChip(
//                                   label: Text(expenseType),
//                                   selected:
//                                       provider.selectedExpenseType ==
//                                       expenseType,
//                                   onSelected: (selected) {
//                                     provider.setExpenseType(expenseType);
//                                   },
//                                   selectedColor: Colors.green.shade300,
//                                   backgroundColor: Colors.grey.shade200,
//                                   labelStyle: TextStyle(
//                                     color:
//                                         provider.selectedExpenseType ==
//                                                 expenseType
//                                             ? Colors.white
//                                             : Colors.black,
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 4.0,
//                               ),
//                               child: ActionChip(
//                                 label: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: const [
//                                     Icon(
//                                       Icons.add,
//                                       size: 16,
//                                       color: Colors.green,
//                                     ),
//                                     SizedBox(width: 4),
//                                     Text("Add"),
//                                   ],
//                                 ),
//                                 onPressed: () => _showAddExpenseDialog(context),
//                                 backgroundColor: Colors.green.shade100,
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: const Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             onSubmit(
//               provider.nameController.text.trim(),
//               double.tryParse(provider.amountController.text) ?? 0.0,
//               DateFormat('dd-MM-yyyy').format(provider.selectedDate),
//               provider.selectedStatus,
//               provider.selectedPaymentType,
//               provider.selectedExpenseType,
//             );
//             Navigator.of(context).pop();
//           },
//           child: Text(transaction == null ? 'Submit' : 'Update'),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../helpers/transaction_provider.dart';

class TransactionDialog extends StatelessWidget {
  final String type;
  final Function(
    String name,
    double amount,
    String date,
    String status,
    String paymentMethod, [
    String? expenseType,
  ])
  onSubmit;
  final dynamic transaction;

  void _showAddExpenseDialog(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    final provider = Provider.of<TransactionProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Expense Type"),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: "Enter new expense type",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                String newType = _controller.text.trim();
                if (newType.isNotEmpty &&
                    !provider.expenseTypes.contains(newType)) {
                  provider.addExpenseType(newType);
                }
                Navigator.of(context).pop(); // ✅ Close dialog
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    ).then((_) {
      // ✅ Refresh dropdown after dialog closes
      provider.notifyListeners();
    });
  }

  TransactionDialog({
    required this.type,
    required this.onSubmit,
    this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context, listen: false);

    // Pre-fill fields if editing
    if (transaction != null) {
      provider.setEditingTransaction(transaction, type);
    }

    return AlertDialog(
      title: Text('${transaction == null ? 'Add' : 'Edit'} $type'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: provider.nameController,
              decoration: InputDecoration(
                labelText: type == 'Income' ? 'Source' : 'Name',
              ),
            ),
            TextField(
              controller: provider.amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            Row(
              children: [
                Text(
                  "Date: ${DateFormat('dd-MM-yyyy').format(provider.selectedDate)}",
                ),
                IconButton(
                  icon: Icon(
                    Icons.date_range_rounded,
                    color: Colors.purpleAccent[100],
                  ),
                  onPressed: () => provider.pickDate(context),
                ),
              ],
            ),

            DropdownButtonFormField<String>(
              value:
                  provider.paymentMethods.contains(provider.selectedPaymentType)
                      ? provider.selectedPaymentType
                      : null, // Ensures value exists
              decoration: const InputDecoration(labelText: "Payment Method"),
              items:
                  provider.paymentMethods.map((method) {
                    return DropdownMenuItem(value: method, child: Text(method));
                  }).toList(),
              onChanged:
                  (newValue) => provider.setPaymentMethod(newValue ?? "Cash"),
            ),

            // 📌 Expense Type Selection (Only for Expense)
            if (type == 'Expense')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'Select Expense Type:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Consumer<TransactionProvider>(
                    builder: (context, provider, _) {
                      return SingleChildScrollView(
                        scrollDirection:
                            Axis.horizontal, // ✅ Enables horizontal scrolling
                        child: Row(
                          children: [
                            ...provider.expenseTypes.map((expenseType) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4.0,
                                ),
                                child: ChoiceChip(
                                  label: Text(expenseType),
                                  selected:
                                      provider.selectedExpenseType ==
                                      expenseType,
                                  onSelected: (selected) {
                                    provider.setExpenseType(expenseType);
                                  },
                                  selectedColor: Colors.green.shade300,
                                  backgroundColor: Colors.grey.shade200,
                                  labelStyle: TextStyle(
                                    color:
                                        provider.selectedExpenseType ==
                                                expenseType
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                              );
                            }).toList(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                              ),
                              child: ActionChip(
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(
                                      Icons.add,
                                      size: 16,
                                      color: Colors.green,
                                    ),
                                    SizedBox(width: 4),
                                    Text("Add"),
                                  ],
                                ),
                                onPressed: () => _showAddExpenseDialog(context),
                                backgroundColor: Colors.green.shade100,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),

            // 📌 Status Selection (For Lend/Borrow)
            if (type == 'Borrow' || type == 'Lending' || type == 'Lend')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Status:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Consumer<TransactionProvider>(
                    builder: (context, provider, _) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children:
                              ['Pending', 'Paid'].map((status) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                  ),
                                  child: ChoiceChip(
                                    label: Text(status),
                                    selected: provider.selectedStatus == status,
                                    onSelected: (selected) {
                                      provider.setStatus(status);
                                    },
                                    selectedColor: Colors.blue.shade300,
                                    backgroundColor: Colors.grey.shade200,
                                    labelStyle: TextStyle(
                                      color:
                                          provider.selectedStatus == status
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      );
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            onSubmit(
              provider.nameController.text.trim(),
              double.tryParse(provider.amountController.text) ?? 0.0,
              DateFormat('dd-MM-yyyy').format(provider.selectedDate),
              provider.selectedStatus,
              provider.selectedPaymentType,
              provider.selectedExpenseType,
            );
            Navigator.of(context).pop();
          },
          child: Text(transaction == null ? 'Submit' : 'Update'),
        ),
      ],
    );
  }
}
