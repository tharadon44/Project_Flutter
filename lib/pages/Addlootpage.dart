import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testlab/AddEquipmentPage.dart';
import 'package:testlab/pages/adminPage.dart';

class AddtoolPage extends StatefulWidget {
  const AddtoolPage({super.key});

  @override
  State<AddtoolPage> createState() => _AddtoolPageState();
}

class _AddtoolPageState extends State<AddtoolPage> {
  String? userName;
  int currentPageIndex = 0; // เพิ่มตัวแปรเพื่อเก็บดัชนีของหน้า

  void loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString("userName");
    });
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          if (index == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const Adminpage(),
              ),
            );
          } else if (index == 2) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AddtoolPage(),
              ),
            );
          } else if (index == 3) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AddEquipmentPage(),
              ),
            );
          } else {
            setState(() {
              currentPageIndex = index;
            });
          }
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_sharp),
            label: 'AddtoolPage',
          ),
          NavigationDestination(
            icon: Icon(Icons.messenger_sharp),
            label: 'AddEquipmentPage',
          ),
        ],
      ),
      body: const Center(),
    );
  }
}

//------------หน้า InsertPage--------------------------------------------
class InsertPage extends StatelessWidget {
  const InsertPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('เพิ่มห้อง'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'เลข',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'ห้อง',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // เพิ่มฟังก์ชันการบันทึกข้อมูล
              },
              child: const Text('บันทึก'),
            ),
          ],
        ),
      ),
    );
  }
}

//------------หน้า DeletePage--------------------------------------------
class DeletePage extends StatelessWidget {
  const DeletePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('ลบอุปกรณ์'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'หน้านี้คือหน้าลบอุปกรณ์',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

//------------หน้า UpdatePage--------------------------------------------
class UpdatePage extends StatelessWidget {
  const UpdatePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('แก้ไขอุปกรณ์'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'เลข',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                suffixIcon: Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'ห้อง',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                suffixIcon: Icon(Icons.edit),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // เพิ่มฟังก์ชันการบันทึกข้อมูลที่แก้ไข
              },
              child: const Text('บันทึกการแก้ไข'),
            ),
          ],
        ),
      ),
    );
  }
}