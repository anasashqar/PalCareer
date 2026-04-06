import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/career_taxonomy.dart';

class TaxonomyRepository {
  final FirebaseFirestore _firestore;

  TaxonomyRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<CareerTaxonomy?> fetchTaxonomies() async {
    try {
      final snapshot = await _firestore
          .collection('app_config')
          .doc('career_taxonomies')
          .get();
      if (snapshot.exists && snapshot.data() != null) {
        return CareerTaxonomy.fromJson(snapshot.data()!);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
