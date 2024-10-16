// To parse this JSON data, do
//
//     final userTool = userToolFromJson(jsonString);

import 'dart:convert';

UserTool userToolFromJson(String str) => UserTool.fromJson(json.decode(str));

String userToolToJson(UserTool data) => json.encode(data.toJson());

class UserTool {
    DateTime dateTime;
    String timeIn;
    String timeOut;
    String toolName;
    String userName;
    String phone;
    String objective;
    String adviser;
    String id;

    UserTool({
        required this.dateTime,
        required this.timeIn,
        required this.timeOut,
        required this.toolName,
        required this.userName,
        required this.phone,
        required this.objective,
        required this.adviser,
        required this.id,
    });

    factory UserTool.fromJson(Map<String, dynamic> json) => UserTool(
        dateTime: DateTime.parse(json["date_time"]),
        timeIn: json["time_in"],
        timeOut: json["time_out"],
        toolName: json["tool_name"],
        userName: json["user_name"],
        phone: json["phone"],
        objective: json["objective"],
        adviser: json["adviser"],
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "date_time": dateTime.toIso8601String(),
        "time_in": timeIn,
        "time_out": timeOut,
        "tool_name": toolName,
        "user_name": userName,
        "phone": phone,
        "objective": objective,
        "adviser": adviser,
        "_id": id,
    };
}
