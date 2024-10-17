import 'dart:math';
import 'package:flutter/material.dart';
import 'package:testlab/controllers/tool_controllers.dart';
import 'package:testlab/models/product_model.dart';
import 'package:testlab/models/tool_model.dart';
import 'package:testlab/widget/custmCliper.dart';

class EdittoolPage extends StatefulWidget {
  final UserTool tool;

  const EdittoolPage({Key? key, required this.tool}) : super(key: key);

  @override
  _EditRoomPageState createState() => _EditRoomPageState();
}

class _EditRoomPageState extends State<EdittoolPage> {
  final _formKey = GlobalKey<FormState>();
  final toolController _toolController = toolController();
  // late DateTime dateTime;
  late String timein;
  late String timeout;
  late String toolName;
  late String userName;
  late String phone;
  late String objective;
  late String adviser;

  @override
  void initState() {
    super.initState();
    // ดึงข้อมูลจาก RoomModel มาแสดงในฟอร์ม
    // dateTime = widget.tool.dateTime;
    timein = widget.tool.timeIn;
    timeout = widget.tool.timeOut;
    toolName = widget.tool.toolName;
    userName = widget.tool.userName;
    phone = widget.tool.phone;
    objective = widget.tool.objective;
    adviser = widget.tool.adviser;
  }

  Future<void> _updatetool(BuildContext context, String toolID) async {
    // ฟังก์ชันสำหรับการอัปเดตข้อมูลห้อง
    _toolController
        .updatetool(context, timein, timeout, toolName, userName, phone,
            objective, adviser, toolID)
        .then((response) {
      print(response.statusCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: [
            // Background
            Positioned(
              top: -height * .15,
              right: -width * .4,
              child: Transform.rotate(
                angle: -pi / 3.5,
                child: ClipPath(
                  clipper: ClipPainter(),
                  child: Container(
                    height: height * .5,
                    width: width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xffE9EFEC),
                          Color(0xffFABC3F),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Form content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: height * .1),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'แก้ไข',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                          color: Color(0xffC7253E),
                        ),
                        children: [
                          TextSpan(
                            text: 'สินค้า',
                            style: TextStyle(
                                color: Color(0xffE85C0D), fontSize: 35),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          // _buildTextField(
                          //   label: 'วันที่',
                          //   initialValue: dateTime,
                          //   onSaved: (value) => dateTime = value!,
                          // ),
                          SizedBox(height: 30),
                          _buildTextField(
                            label: 'เวลาเข้า',
                            initialValue: timein,
                            onSaved: (value) => timein = value!,
                          ),
                          SizedBox(height: 30),
                          _buildTextField(
                            label: 'เวลาออก',
                            initialValue: timeout,
                            onSaved: (value) => timeout = value!,
                          ),
                          SizedBox(height: 30),
                          _buildTextField(
                            label: 'เครื่องมือ',
                            initialValue: toolName,
                            onSaved: (value) => toolName = value!,
                          ),
                          SizedBox(height: 30),
                          _buildTextField(
                            label: 'ชื่อ',
                            initialValue: userName,
                            onSaved: (value) => userName = value!,
                          ),
                          SizedBox(height: 30),
                          _buildTextField(
                            label: 'phone',
                            initialValue: phone,
                            onSaved: (value) => phone = value!,
                          ),
                          SizedBox(height: 30),
                          _buildTextField(
                            label: 'วัตถุประสงค์',
                            initialValue: objective,
                            onSaved: (value) => objective = value!,
                          ),
                          SizedBox(height: 30),
                          _buildTextField(
                            label: 'ที่ปรึกษา',
                            initialValue: adviser,
                            onSaved: (value) => adviser = value!,
                          ),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    // Call the update function
                                    _updatetool(context, widget.tool.id);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff821131),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 12.0),
                                  child: Text(
                                    'แก้ไข',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(context,
                                      '/home'); // เปลี่ยนไปยังหน้าแสดงสินค้า
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromRGBO(103, 103, 103, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 12.0),
                                  child: Text(
                                    'ยกเลิก',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required FormFieldSetter<String> onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      initialValue: initialValue,
      onSaved: onSaved,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณากรอก $label';
        }
        return null;
      },
    );
  }
}
