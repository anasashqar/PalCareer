import 'dart:io';
import 'dart:math';

void main() {
  final file = File(r'c:\مشاريع برمجية\PalCareer\lib\features\jobs\providers\jobs_provider.dart');
  var content = file.readAsStringSync();
  
  final random = Random();
  final levels = ['junior', 'mid', 'senior'];

  // Match the end of a JobModel constructor definition, specifically looking for applyUrl or similar last fields.
  // Actually, let's just find "applyUrl: " and append experienceLevel right after it.
  
  content = content.replaceAllMapped(RegExp(r"(applyUrl:\s*'.*?',)"), (match) {
    final randLevel = levels[random.nextInt(levels.length)];
    return '${match.group(1)} experienceLevel: \'$randLevel\',';
  });
  
  file.writeAsStringSync(content);
  print('Done adding experience levels to jobs');
}
