import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maen/models/university.dart';
import 'package:uuid/uuid.dart';

class UniversityServices {
  String collection = "universities";
  Firestore _firestore = Firestore.instance;

  void createUniversity(Map<String, dynamic> data){
    var id = Uuid();
    String universityId = id.v1();
    _firestore.collection(collection).document(universityId).setData(data);
  }

  Future<List<DocumentSnapshot>> getSuggestions(String suggestion) =>
  _firestore.collection(collection).where('university', isEqualTo: suggestion).getDocuments()
      .then((snap) {
        return snap.documents;
  });

  Future<List<UniversityModel>> getUniversities() async =>
      _firestore.collection(collection).getDocuments().then((result) {
        List<UniversityModel> universities = [];
        for(DocumentSnapshot university in result.documents){
          universities.add(UniversityModel.fromSnapshot(university));
        }
        return universities;
      });

}