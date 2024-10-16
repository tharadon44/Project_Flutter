import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testlab/AddEquipmentPage.dart';
import 'package:testlab/controllers/tool_controllers.dart';
import 'package:testlab/models/tool_model.dart';
import 'package:testlab/page/Edittool.dart';
import 'package:testlab/pages/Addlootpage.dart';
import 'package:testlab/providers/usar_providers.dart';

class Adminpage extends StatelessWidget {
  const Adminpage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const NavigationExample(),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;
  List<UserTool> tool = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchtools();
  }

  Future<void> _fetchtools() async {
    try {
      final toolList = await toolController().getTools(context);
      setState(() {
        tool = toolList;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Error fetching tools: $error';
        isLoading = false;
      });
    }
  }

  void deleteTool(UserTool tool) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EdittoolPage(tool: tool),
      ),
    );
  }

  Future<void> deletetool(UserTool tool) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการลบห้อง'),
          content: const Text('คุณแน่ใจหรือไม่ว่าต้องการลบห้องนี้?'),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('ลบ'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      try {
        final response = await toolController().deleteTool(context, tool.id);

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('ลบห้องสำเร็จ')));
          await _fetchtools();
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting tool: $error')));
      }
    }
  }

  @override
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
      body: IndexedStack(
        index: currentPageIndex,
        children: [
          /// Home Page - Showing tools
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
                  ? Center(child: Text(errorMessage!))
                  : _buildtoolsList(),

          /// Empty placeholder for AddtoolPage (เปิดผ่าน Navigator)
        ],
      ),
    );
  }

  Widget _buildtoolsList() {
    return ListView.builder(
      itemCount: tool.length,
      itemBuilder: (context, index) {
        final toolItem = tool[index];
        return Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: const Border(
              bottom: BorderSide(
                color: Color.fromARGB(255, 225, 215, 183),
                width: 1.0,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('วันที่: ${toolItem.dateTime}'),
                    Text('เวลาเข้า: ${toolItem.timeIn}'),
                    Text('เวลาออก: ${toolItem.timeOut}'),
                    Text('ชื่อชื่ออุปกรณ์: ${toolItem.toolName}'),
                    Text('ชื่อผู้ใช้: ${toolItem.userName}'),
                    Text('เบอร์โทร: ${toolItem.phone}'),
                    Text('วัตถุประสงค์: ${toolItem.objective}'),
                    Text('ที่ปรึกษา: ${toolItem.adviser}'),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Color(0xffFABC3F)),
                onPressed: () {
                  deleteTool(toolItem);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Color(0xff821131)),
                onPressed: () {
                  deletetool(toolItem);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
