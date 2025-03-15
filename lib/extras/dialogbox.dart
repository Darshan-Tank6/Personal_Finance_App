void _showDialog1(BuildContext context, String type) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      List<Widget> getInputFields() {
        switch (type) {
          case 'Income':
            return [
              TextField(
                decoration: InputDecoration(labelText: 'Source'),
                controller: _nameController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                controller: _amountController,
              ),
              Row(
                mainAxisSize: MainAxisSize.min, // Use min to fit content
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Date: ${formatter.format(_selectedDate)}",
                    style: TextStyle(fontSize: 14),
                  ),
                  Spacer(), // Push the icon to the end
                  IconButton(
                    onPressed: _pickDate,
                    icon: Icon(
                      Icons.date_range_rounded,
                      color: Colors.purpleAccent[100],
                    ),
                    iconSize: 18,
                    tooltip: 'Pick a date',
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                ],
              ),
            ];
          case 'Expense':
            return [
              TextField(
                decoration: InputDecoration(labelText: 'Name'),
                controller: _nameController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                controller: _amountController,
              ),
              Row(
                mainAxisSize: MainAxisSize.min, // Use min to fit content
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Date: ${formatter.format(_selectedDate)}",
                    style: TextStyle(fontSize: 14),
                  ),
                  Spacer(), // Push the icon to the end
                  IconButton(
                    onPressed: _pickDate,
                    icon: Icon(
                      Icons.date_range_rounded,
                      color: Colors.purpleAccent[100],
                    ),
                    iconSize: 18,
                    tooltip: 'Pick a date',
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                ],
              ),
            ];
          case 'Borrow':
            return [
              TextField(
                decoration: InputDecoration(labelText: "Borrower's Name"),
                controller: _nameController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                controller: _amountController,
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(labelText: 'Status'),
                items:
                    ['Pending', 'Paid'].map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                onChanged: (value) {},
              ),
              Row(
                mainAxisSize: MainAxisSize.min, // Use min to fit content
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Date: ${formatter.format(_selectedDate)}",
                    style: TextStyle(fontSize: 14),
                  ),
                  Spacer(), // Push the icon to the end
                  IconButton(
                    onPressed: _pickDate,
                    icon: Icon(
                      Icons.date_range_rounded,
                      color: Colors.purpleAccent[100],
                    ),
                    iconSize: 18,
                    tooltip: 'Pick a date',
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                ],
              ),
            ];
          case 'Lend':
            return [
              TextField(
                decoration: InputDecoration(labelText: "Lender's Name"),
                controller: _nameController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                controller: _amountController,
              ),
              Row(
                mainAxisSize: MainAxisSize.min, // Use min to fit content
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Date: ${formatter.format(_selectedDate)}",
                    style: TextStyle(fontSize: 14),
                  ),
                  Spacer(), // Push the icon to the end
                  IconButton(
                    onPressed: _pickDate,
                    icon: Icon(
                      Icons.date_range_rounded,
                      color: Colors.purpleAccent[100],
                    ),
                    iconSize: 18,
                    tooltip: 'Pick a date',
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                ],
              ),
            ];
          default:
            return [Text('Invalid type')];
        }
      }

      void handleSubmit() {
        switch (type) {
          case 'Income':
            _addIncome();
            print('Income submitted');
            break;
          case 'Expense':
            _addExpense();
            print('Expense submitted');
            break;
          case 'Borrow':
            _addBorrow();
            print('Borrow submitted');
            break;
          case 'Lend':
            _addLending();
            print('Lend submitted');
            break;
          default:
            print('Invalid type');
        }
        Navigator.of(context).pop();
      }

      return AlertDialog(
        title: Text('Add $type'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: getInputFields(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(onPressed: handleSubmit, child: Text('Submit')),
        ],
      );
    },
  );
}
