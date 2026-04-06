import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../shared/models/career_taxonomy.dart';
import '../../shared/services/taxonomy_repository.dart';

final taxonomyRepositoryProvider = Provider<TaxonomyRepository>((ref) {
  return TaxonomyRepository();
});

final taxonomyProvider = FutureProvider<CareerTaxonomy>((ref) async {
  final repository = ref.watch(taxonomyRepositoryProvider);
  final box = await Hive.openBox<String>('cache');

  // Try to load from Firestore
  final remoteData = await repository.fetchTaxonomies();

  if (remoteData != null) {
    // Cache the standard json structure
    await box.put('taxonomy_cache', jsonEncode(remoteData.toJson()));
    return remoteData;
  } else {
    // Fallback to cache if offline
    final cached = box.get('taxonomy_cache');
    if (cached != null) {
      return CareerTaxonomy.fromJson(
        jsonDecode(cached) as Map<String, dynamic>,
      );
    }

    // Absolute fallback - returning mock structure
    return CareerTaxonomy.fallback;
  }
});
