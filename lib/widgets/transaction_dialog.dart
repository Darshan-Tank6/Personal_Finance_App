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

//             // 📌 Expense Type Selection (Only for Expense)
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

//             // 📌 Status Selection (For Lend/Borrow)
//             if (type == 'Borrow' || type == 'Lending' || type == 'Lend')
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Select Status:',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   Consumer<TransactionProvider>(
//                     builder: (context, provider, _) {
//                       return SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Row(
//                           children:
//                               ['Pending', 'Paid'].map((status) {
//                                 return Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 4.0,
//                                   ),
//                                   child: ChoiceChip(
//                                     label: Text(status),
//                                     selected: provider.selectedStatus == status,
//                                     onSelected: (selected) {
//                                       provider.setStatus(status);
//                                     },
//                                     selectedColor: Colors.blue.shade300,
//                                     backgroundColor: Colors.grey.shade200,
//                                     labelStyle: TextStyle(
//                                       color:
//                                           provider.selectedStatus == status
//                                               ? Colors.white
//                                               : Colors.black,
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
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

class TransactionDialog extends StatefulWidget {
  final String type;
  final Function(
    String name,
    double amount,
    String date,
    String status,
    String paymentMethod, [
    String? expenseType,
    String? repetetive,
  ])
  onSubmit;
  final dynamic transaction;

  const TransactionDialog({
    required this.type,
    required this.onSubmit,
    this.transaction,
    Key? key,
  }) : super(key: key);

  @override
  _TransactionDialogState createState() => _TransactionDialogState();
}

class _TransactionDialogState extends State<TransactionDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward(); // Start animation
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
                Navigator.of(context).pop();
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    ).then((_) => provider.notifyListeners());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context, listen: false);
    if (widget.transaction != null) {
      provider.setEditingTransaction(widget.transaction, widget.type);
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (context, scrollController) {
          //var isRecurring;
          return SlideTransition(
            position: _slideAnimation,
            child: Material(
              elevation: 6,
              color: Colors.transparent,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        '${widget.transaction == null ? 'Add' : 'Edit'} ${widget.type}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          // color: Theme.of(context).primaryColor,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: provider.nameController,
                        decoration: InputDecoration(
                          labelText:
                              widget.type == 'Income' ? 'Source' : 'Name',
                          border: OutlineInputBorder(),
                          //filled: true,
                          //fillColor: Colors.grey.shade100,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: provider.amountController,
                        decoration: const InputDecoration(
                          labelText: 'Amount',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () => provider.pickDate(context),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Date: ${DateFormat('dd-MM-yyyy').format(provider.selectedDate)}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              Icon(
                                Icons.date_range_rounded,
                                color: Colors.purpleAccent[100],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value:
                            provider.paymentMethods.contains(
                                  provider.selectedPaymentType,
                                )
                                ? provider.selectedPaymentType
                                : null,
                        decoration: const InputDecoration(
                          labelText: "Payment Method",
                          border: OutlineInputBorder(),
                        ),
                        items:
                            provider.paymentMethods.map((method) {
                              return DropdownMenuItem(
                                value: method,
                                child: Text(method),
                              );
                            }).toList(),
                        onChanged:
                            (newValue) =>
                                provider.setPaymentMethod(newValue ?? "Cash"),
                      ),
                      // if (widget.type == 'Expense') ...[
                      //   const SizedBox(height: 8),
                      //   const Text(
                      //     'Select Expense Type:',
                      //     style: TextStyle(fontWeight: FontWeight.bold),
                      //   ),
                      //   const SizedBox(height: 8),
                      //   Wrap(
                      //     spacing: 6,
                      //     children: [
                      //       ...provider.expenseTypes.map((expenseType) {
                      //         return ChoiceChip(
                      //           label: Text(expenseType),
                      //           selected:
                      //               provider.selectedExpenseType == expenseType,
                      //           onSelected:
                      //               (selected) =>
                      //                   provider.setExpenseType(expenseType),
                      //           selectedColor: Colors.green.shade400,
                      //           backgroundColor: Colors.grey.shade200,
                      //           elevation: 2,
                      //           labelStyle: TextStyle(
                      //             color:
                      //                 provider.selectedExpenseType ==
                      //                         expenseType
                      //                     ? Colors.white
                      //                     : Colors.black,
                      //           ),
                      //         );
                      //       }).toList(),
                      //       ActionChip(
                      //         label: const Text("+ Add"),
                      //         onPressed: () => _showAddExpenseDialog(context),
                      //         backgroundColor: Colors.purpleAccent.shade100,
                      //       ),
                      //     ],
                      //   ),
                      // ],
                      if (widget.type == 'Expense') ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            const Text(
                              'Select Expense Type:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Consumer<TransactionProvider>(
                              builder: (context, provider, _) {
                                return SingleChildScrollView(
                                  scrollDirection:
                                      Axis.horizontal, // ✅ Enables horizontal scrolling
                                  child: Row(
                                    children: [
                                      ...provider.expenseTypes.map((
                                        expenseType,
                                      ) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0,
                                          ),
                                          child: ChoiceChip(
                                            label: Text(
                                              expenseType,
                                              style: TextStyle(
                                                fontWeight:
                                                    provider.selectedExpenseType ==
                                                            expenseType
                                                        ? FontWeight
                                                            .w700 // Bold for selected chip
                                                        : FontWeight
                                                            .w400, // Lighter for unselected
                                                fontSize:
                                                    provider.selectedExpenseType ==
                                                            expenseType
                                                        ? 15
                                                        : 14, // Slightly larger text
                                                color:
                                                    Colors
                                                        .white, // Ensuring text is readable in dark mode
                                              ),
                                            ),
                                            selected:
                                                provider.selectedExpenseType ==
                                                expenseType,
                                            onSelected: (selected) {
                                              provider.setExpenseType(
                                                expenseType,
                                              );
                                            },
                                            backgroundColor:
                                                Colors
                                                    .black54, // Dark grey for unselected chips
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              side: BorderSide(
                                                width:
                                                    provider.selectedExpenseType ==
                                                            expenseType
                                                        ? 2
                                                        : 1, // Thicker border for selected
                                                color:
                                                    provider.selectedExpenseType ==
                                                            expenseType
                                                        ? Colors
                                                            .white // White border for selected
                                                        : Colors
                                                            .grey
                                                            .shade700, // Subtle border for unselected
                                              ),
                                            ),
                                            elevation:
                                                provider.selectedExpenseType ==
                                                        expenseType
                                                    ? 6
                                                    : 0, // Raised effect for selected
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 10,
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
                                                color: Colors.black,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                "Add",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          onPressed:
                                              () => _showAddExpenseDialog(
                                                context,
                                              ),
                                          backgroundColor: Colors.tealAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Mark as repetitive"),
                                Text(
                                  provider.repetetive,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      provider.repetetive =
                                          provider.repetetive == "true"
                                              ? "false"
                                              : "true";
                                    });
                                  },
                                  child: const Text("Toggle"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                      if (widget.type == 'Borrow' ||
                          widget.type == 'Lending' ||
                          widget.type == 'Lend') ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            const Text(
                              'Select Status:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Consumer<TransactionProvider>(
                              builder: (context, provider, _) {
                                List<String> statuses = ['Pending', 'Paid'];
                                int selectedIndex = statuses.indexOf(
                                  provider.selectedStatus,
                                );

                                return Center(
                                  child: ToggleButtons(
                                    isSelected: List.generate(
                                      statuses.length,
                                      (index) => index == selectedIndex,
                                    ),
                                    onPressed: (index) {
                                      provider.setStatus(statuses[index]);
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    selectedColor: Colors.black,
                                    fillColor: Colors.greenAccent,
                                    color: Colors.white,
                                    constraints: const BoxConstraints(
                                      minHeight: 40,
                                      minWidth: 80,
                                    ),
                                    children:
                                        statuses
                                            .map(
                                              (status) => Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                    ),
                                                child: Text(status),
                                              ),
                                            )
                                            .toList(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        //column
                      ],
                      const SizedBox(height: 15),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                widget.onSubmit(
                                  provider.nameController.text.trim(),
                                  double.tryParse(
                                        provider.amountController.text,
                                      ) ??
                                      0.0,
                                  DateFormat(
                                    'dd-MM-yyyy',
                                  ).format(provider.selectedDate),
                                  provider.selectedStatus,
                                  provider.selectedPaymentType,
                                  provider.selectedExpenseType,
                                );
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    widget.transaction == null
                                        ? Colors.purpleAccent
                                        : Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                widget.transaction == null
                                    ? 'Submit'
                                    : 'Update',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
