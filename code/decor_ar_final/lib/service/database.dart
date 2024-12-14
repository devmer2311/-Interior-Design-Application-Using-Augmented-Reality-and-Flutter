import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  Future addUser(String userId, Map<String, dynamic>  userInfoMap){
    return FirebaseFirestore.instance.collection("UserDetails").doc(userId).set(userInfoMap);
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> checkUserExists(String email) async {
    try {
      // Query the users collection in Firestore for the provided email
      QuerySnapshot querySnapshot = await _firestore
          .collection('UserDetails')
          .where('email', isEqualTo: email)
          .get();

      // If the querySnapshot contains any documents, the user exists
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      // Handle any potential errors, such as Firestore exceptions
      print("Error checking user existence: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUserDetails(String phoneNumber) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('UserDetails')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data();
      } else {
        return null; // User not found
      }
    } catch (e) {
      print("Error fetching user details: $e");
      return null;
    }
  }
}