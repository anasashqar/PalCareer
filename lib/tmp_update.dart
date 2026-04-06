import 'dart:io';

void main() {
  final file = File(r'c:\مشاريع برمجية\PalCareer\lib\features\jobs\providers\jobs_provider.dart');
  var content = file.readAsStringSync();
  
  // Replace all occurrences of postedAt: ..., with postedAt: ..., expiresAt: ...
  // We match "postedAt: " until the next comma.
  content = content.replaceAllMapped(
    RegExp(r'(postedAt:\s*[^,]+,)'), 
    (match) => '${match.group(1)} expiresAt: DateTime.now().add(const Duration(days: 30)),'
  );
  
  file.writeAsStringSync(content);
  print('Done updating jobs_provider.dart');
}
