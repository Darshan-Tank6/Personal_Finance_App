// // // import 'package:flutter/material.dart';
// // // import 'package:url_launcher/url_launcher.dart';
// // // import '../pages/view_past_records.dart';

// // // class SettingsPage extends StatelessWidget {
// // //   const SettingsPage({Key? key}) : super(key: key);

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

// // //     return Scaffold(
// // //       appBar: AppBar(title: const Text('Settings')),
// // //       body: ListView(
// // //         padding: const EdgeInsets.all(16.0),
// // //         children: [
// // //           SwitchListTile(
// // //             title: const Text('Dark Mode'),
// // //             value: isDarkMode,
// // //             onChanged: (bool value) {
// // //               // Implement theme switching logic
// // //               if (value) {
// // //                 // Switch to dark mode
// // //                 ThemeMode.dark;
// // //               } else {
// // //                 // Switch to light mode
// // //                 ThemeMode.light;
// // //               }
// // //             },
// // //           ),
// // //           const Divider(),
// // //           ListTile(
// // //             title: const Text('View Past Records'),
// // //             trailing: const Icon(Icons.arrow_forward),
// // //             onTap: () {
// // //               Navigator.pushNamed(context, '/view-records');
// // //             },
// // //           ),
// // //           const Divider(),
// // //           ListTile(
// // //             title: const Text('Contact Us'),
// // //             subtitle: const Text('Follow us on social media'),
// // //             trailing: const Icon(Icons.open_in_new),
// // //             onTap: () async {
// // //               const url =
// // //                   'https://your-social-link-here.com'; // Replace with your actual social link
// // //               if (await canLaunchUrl(Uri.parse(url))) {
// // //                 await launchUrl(Uri.parse(url));
// // //               } else {
// // //                 ScaffoldMessenger.of(context).showSnackBar(
// // //                   const SnackBar(content: Text('Could not open the link')),
// // //                 );
// // //               }
// // //             },
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// // import 'package:flutter/material.dart';
// // import 'package:url_launcher/url_launcher.dart';
// // import '../pages/view_past_records.dart';

// // class SettingsPage extends StatefulWidget {
// //   const SettingsPage({Key? key}) : super(key: key);

// //   @override
// //   State<SettingsPage> createState() => _SettingsPageState();
// // }

// // class _SettingsPageState extends State<SettingsPage> {
// //   bool isDarkMode = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     isDarkMode = Theme.of(context).brightness == Brightness.dark;
// //   }

// //   void toggleTheme(bool value) {
// //     setState(() {
// //       isDarkMode = value;
// //     });
// //     // You’ll want to use your state management solution to persist this change
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text('Settings')),
// //       body: ListView(
// //         padding: const EdgeInsets.all(16.0),
// //         children: [
// //           SwitchListTile(
// //             title: const Text('Dark Mode'),
// //             value: isDarkMode,
// //             onChanged: toggleTheme,
// //           ),
// //           const Divider(),
// //           ListTile(
// //             title: const Text('View Past Records'),
// //             trailing: const Icon(Icons.arrow_forward),
// //             onTap: () {
// //               Navigator.pushNamed(context, '/view-records');
// //             },
// //           ),
// //           const Divider(),
// //           ListTile(
// //             title: const Text('Contact Us'),
// //             subtitle: const Text('Follow us on social media'),
// //             trailing: const Icon(Icons.open_in_new),
// //             onTap: () async {
// //               const url = 'https://your-social-link-here.com';
// //               if (await canLaunchUrl(Uri.parse(url))) {
// //                 await launchUrl(Uri.parse(url));
// //               } else {
// //                 ScaffoldMessenger.of(context).showSnackBar(
// //                   const SnackBar(content: Text('Could not open the link')),
// //                 );
// //               }
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // import 'package:flutter/material.dart';
// // // import 'package:url_launcher/url_launcher.dart';

// // // class SettingsPage extends StatefulWidget {
// // //   const SettingsPage({Key? key}) : super(key: key);

// // //   @override
// // //   State<SettingsPage> createState() => _SettingsPageState();
// // // }

// // // class _SettingsPageState extends State<SettingsPage> {
// // //   bool isDarkMode = false;

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(title: const Text('Settings')),
// // //       body: ListView(
// // //         padding: const EdgeInsets.all(16.0),
// // //         children: [
// // //           SwitchListTile(
// // //             title: const Text('Dark Mode'),
// // //             value: isDarkMode,
// // //             onChanged: (bool value) {
// // //               setState(() {
// // //                 isDarkMode = value;
// // //               });
// // //               final newTheme = value ? ThemeMode.dark : ThemeMode.light;
// // //               (context.findAncestorWidgetOfExactType<MaterialApp>()
// // //                       as MaterialApp?)
// // //                   ?.themeMode = newTheme;
// // //             },
// // //           ),
// // //           const Divider(),
// // //           ListTile(
// // //             title: const Text('View Past Records'),
// // //             trailing: const Icon(Icons.arrow_forward),
// // //             onTap: () {
// // //               Navigator.pushNamed(context, '/view-records');
// // //             },
// // //           ),
// // //           const Divider(),
// // //           ListTile(
// // //             title: const Text('Contact Us'),
// // //             subtitle: const Text('Follow us on social media'),
// // //             trailing: const Icon(Icons.open_in_new),
// // //             onTap: () async {
// // //               const url =
// // //                   'https://your-social-link-here.com'; // Replace with your actual social link
// // //               if (await canLaunchUrl(Uri.parse(url))) {
// // //                 await launchUrl(Uri.parse(url));
// // //               } else {
// // //                 ScaffoldMessenger.of(context).showSnackBar(
// // //                   const SnackBar(content: Text('Could not open the link')),
// // //                 );
// // //               }
// // //             },
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:provider/provider.dart';
// import '../pages/theme_provider.dart';

// class SettingsPage extends StatelessWidget {
//   const SettingsPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);

//     return Scaffold(
//       appBar: AppBar(title: const Text('Settings')),
//       body: ListView(
//         padding: const EdgeInsets.all(16.0),
//         children: [
//           SwitchListTile(
//             title: const Text('Dark Mode'),
//             value: themeProvider.themeMode == ThemeMode.dark,
//             onChanged: (bool value) {
//               themeProvider.toggleTheme(value);
//             },
//           ),
//           const Divider(),
//           ListTile(
//             title: const Text('View Past Records'),
//             trailing: const Icon(Icons.arrow_forward),
//             onTap: () {
//               Navigator.pushNamed(context, '/view-records');
//             },
//           ),
//           const Divider(),
//           ListTile(
//             title: const Text('Contact Us'),
//             subtitle: const Text('Follow us on social media'),
//             trailing: const Icon(Icons.open_in_new),
//             onTap: () async {
//               const url =
//                   'https://your-social-link-here.com'; // Replace with your actual social link
//               if (await canLaunchUrl(Uri.parse(url))) {
//                 await launchUrl(Uri.parse(url));
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Could not open the link')),
//                 );
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// // class ThemeProvider extends ChangeNotifier {
// //   ThemeMode _themeMode = ThemeMode.system;

// //   ThemeMode get themeMode => _themeMode;

// //   void toggleTheme(bool isDark) {
// //     _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
// //     notifyListeners();
// //   }
// // }

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../pages/theme_provider.dart';
import '../helpers/transaction_provider.dart';
import '../widgets/add_item_dialog.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _expenseExpanded = false;
  bool _paymentExpanded = false;

  void _showAddDialog(
    BuildContext context,
    String title,
    Function(String) onAdd,
  ) {
    showDialog(
      context: context,
      builder: (context) => AddItemDialog(title: title, onAdd: onAdd),
    ).then((_) {
      setState(() {}); // ✅ Refresh UI after adding an item
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final transactionProvider = Provider.of<TransactionProvider>(
      context,
      listen: true,
    ); // ✅ Listen for changes

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (bool value) {
              themeProvider.toggleTheme(value);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('View Past Records'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pushNamed(context, '/view-records');
            },
          ),
          const Divider(),

          /// 📌 Expense Types Section
          ExpansionTile(
            title: const Text('Manage Expense Types'),
            initiallyExpanded: _expenseExpanded,
            onExpansionChanged: (expanded) {
              setState(() {
                _expenseExpanded = expanded;
              });
            },
            children: [
              ...transactionProvider.expenseTypes.map((expenseType) {
                return ListTile(
                  title: Text(expenseType),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      transactionProvider.removeExpenseType(expenseType);
                      setState(() {}); // ✅ Refresh UI after delete
                    },
                  ),
                );
              }).toList(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text("Add Expense Type"),
                    onPressed:
                        () => _showAddDialog(
                          context,
                          "Expense Type",
                          transactionProvider.addExpenseType,
                        ),
                  ),
                ),
              ),
            ],
          ),
          const Divider(),

          /// 📌 Payment Methods Section
          ExpansionTile(
            title: const Text('Manage Payment Methods'),
            initiallyExpanded: _paymentExpanded,
            onExpansionChanged: (expanded) {
              setState(() {
                _paymentExpanded = expanded;
              });
            },
            children: [
              ...transactionProvider.paymentMethods.map((paymentMethod) {
                return ListTile(
                  title: Text(paymentMethod),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      transactionProvider.removePaymentMethod(paymentMethod);
                      setState(() {}); // ✅ Refresh UI after delete
                    },
                  ),
                );
              }).toList(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text("Add Payment Method"),
                    onPressed:
                        () => _showAddDialog(
                          context,
                          "Payment Method",
                          transactionProvider.addPaymentMethod,
                        ),
                  ),
                ),
              ),
            ],
          ),
          const Divider(),

          /// 📌 Contact Us
          ListTile(
            title: const Text('Contact Us'),
            subtitle: const Text('Follow us on social media'),
            trailing: const Icon(Icons.open_in_new),
            onTap: () async {
              const url = 'https://your-social-link-here.com';
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not open the link')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
