import 'package:flutter/material.dart';

void main() {
  runApp(ReminderApp());
}

class ReminderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReminderPage(),
    );
  }
}

class ReminderPage extends StatefulWidget {
  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  int _selectedIndex = 3;
  List<Map<String, dynamic>> reminders = [
    {"title": "It's Work Out Time!", "time": "10:00 AM WIB", "isActive": true},
    {"title": "Lunch Time", "time": "12:00 PM WIB", "isActive": true},
    {"title": "Sleep", "time": "10:00 PM WIB", "isActive": false},
    {
      "title": "Sunlight and Fresh Air",
      "time": "08:00 AM WIB",
      "isActive": true
    },
    {
      "title": "Don't skip a healthy dinner!",
      "time": "07:00 PM WIB",
      "isActive": false
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Navigasi ke halaman untuk menambah alarm baru
  void _navigateToAddReminderPage(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddReminderPage()),
    );
    if (result != null) {
      setState(() {
        reminders.add(result);
      });
    }
  }

  // Fungsi untuk menghapus reminder
  void _deleteReminder(int index) {
    setState(() {
      reminders.removeAt(index); // Menghapus reminder berdasarkan index
    });
  }

  @override
  Widget build(BuildContext context) {
    final customColor = Color(0xFF00D9C0);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Reminder',
          style: TextStyle(color: customColor),
        ),
        leading: Icon(Icons.arrow_back, color: Colors.black),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2),
          child: Container(
            color: Colors.grey,
            height: 2,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          final reminder = reminders[index];
          return Dismissible(
            key: Key(reminder['title']!), // Menggunakan key untuk setiap item
            direction: DismissDirection.endToStart, // Swipe ke kiri
            onDismissed: (direction) {
              // Konfirmasi penghapusan saat di swipe
              setState(() {
                reminders.removeAt(index);
              });

              // Menampilkan snackbar untuk konfirmasi penghapusan
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${reminder['title']} deleted")),
              );
            },
            background: Container(
              color: Colors.red, // Warna latar belakang saat swipe
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Delete',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              title: Text(
                reminder['title']!,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text("Every day at ${reminder['time']}"),
              trailing: Switch(
                value: reminder['isActive'],
                onChanged: (bool value) {
                  setState(() {
                    reminder['isActive'] = value;
                  });
                },
                activeColor: customColor,
                inactiveThumbColor: Colors.grey,
                inactiveTrackColor: Colors.white,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddReminderPage(context),
        backgroundColor: customColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ""),
          BottomNavigationBarItem(icon: const Icon(Icons.add), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
        selectedItemColor: customColor,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}

class AddReminderPage extends StatefulWidget {
  @override
  _AddReminderPageState createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  final _titleController = TextEditingController();
  bool _isActive = true;
  final _formKey = GlobalKey<FormState>();
  String _timeText = "Select Time"; // Default text before time is selected

  // Menampilkan Time Picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(), // Waktu awal saat picker muncul
    );

    if (picked != null && picked != TimeOfDay.now()) {
      setState(() {
        _timeText = picked.format(context); // Mengupdate waktu yang dipilih
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final customColor = Color(0xFF00D9C0);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Reminder',
          style: TextStyle(color: customColor),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2),
          child: Container(
            color: Colors.grey,
            height: 2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                final reminder = {
                  'title': _titleController.text,
                  'time': _timeText,
                  'isActive': _isActive,
                };
                Navigator.pop(context, reminder);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Reminder Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              GestureDetector(
                onTap: () => _selectTime(
                    context), // Memanggil time picker saat teks di klik
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: TextEditingController(text: _timeText),
                    decoration: InputDecoration(labelText: 'Reminder Time'),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value == "Select Time") {
                        return 'Please select a time';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final reminder = {
                      'title': _titleController.text,
                      'time': _timeText,
                      'isActive': _isActive,
                    };
                    Navigator.pop(context, reminder);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: customColor,
                  foregroundColor: Colors.white,
                ),
                child: Text('Save Reminder'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
