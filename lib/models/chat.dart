import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  late final String senderId;
  final String receiverId;
  final String message;
  final String type; // could be "text" or "audio" or "image" or "video"
  late final Timestamp timestamp;
  bool isSent;
  bool isReceived;
  bool isRead;
  
  Chat({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isSent = false,
    this.isReceived = false,
    this.isRead = false
  });
  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      message: json['message'],
      type: json['type'],
      timestamp: json['timestamp'],
      isSent: json['isSent'],
      isReceived: json['isReceived'],
      isRead: json['isRead'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'type': type,
      'timestamp': timestamp,
      'isSent': isSent,
      'isReceived': isReceived,
      'isRead': isRead
    };
  }
}
