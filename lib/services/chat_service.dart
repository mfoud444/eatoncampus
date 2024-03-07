import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construction/models/chat.dart';
import 'package:construction/models/person.dart';
import 'package:construction/services/userService.dart';
import 'package:rxdart/rxdart.dart';

class ChatService {
  final CollectionReference _chatsCollection =
      FirebaseFirestore.instance.collection('chats');
  final UserService _userService = UserService();

  Future<void> sendMessage(Chat chat) async {
    chat.isSent = true;
    await _chatsCollection.add(chat.toJson());
  }

  // .orderBy('timestamp', descending: true)
  Stream<List<Chat>> getChatStream(
      {required String studentId, required String restaurantId}) {
    var snapshots1 = _chatsCollection
        .where('senderId', isEqualTo: restaurantId)
        .where('receiverId', isEqualTo: studentId)
        .snapshots();

    var snapshots2 = _chatsCollection
        .where('senderId', isEqualTo: studentId)
        .where('receiverId', isEqualTo: restaurantId)
        .snapshots();

    var combinedSnapshots = Rx.merge([snapshots1, snapshots2]);

    return combinedSnapshots.map((snapshot) => snapshot.docs
        .map((doc) => Chat.fromJson(doc.data() as Map<String, dynamic>))
        .toList());
  }

  Future<void> markAsRead({required String chatId}) async {
    await _chatsCollection.doc(chatId).update({'isRead': true});
  }

  Future<List<Person>> getListChatStudent() async {
    // Get current user
    final currentUser = await _userService.getCurrentUser();
    String restaurantId = currentUser['id'];

    // Get all chats
    var chats = await FirebaseFirestore.instance.collection("chats").get();

    // Create set to store unique student IDs
    Set<String> studentIds = Set();

    // Loop through each chat document
    chats.docs.forEach((chat) {
      String senderId = chat.data()['senderId'];
      String receiverId = chat.data()['receiverId'];

      // Check if restaurant is either sender or receiver
      if (restaurantId == senderId) {
        studentIds.add(receiverId);
      } else if (restaurantId == receiverId) {
        studentIds.add(senderId);
      }
    });

    // Get data for each student
    List<Person> students = [];
    for (String studentId in studentIds) {
      Map<String, dynamic> data = await UserService().getDataUser(studentId);
      students.add(Person.fromJson(data));
    }

    return students;
  }
}
