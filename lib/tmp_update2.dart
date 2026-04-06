import 'dart:io';
import 'dart:math';

void main() {
  final file = File(r'c:\مشاريع برمجية\PalCareer\lib\features\jobs\providers\jobs_provider.dart');
  var content = file.readAsStringSync();
  
  final random = Random();

  // Create a regex to match the postedAt and expiresAt combo
  // Example: postedAt: ..., expiresAt: ....,
  final regex = RegExp(r'(postedAt:.*?)(expiresAt:.*?,)');
  
  content = content.replaceAllMapped(regex, (match) {
    // Generate diverse dates
    // Some posted today, some yesterday, some a week ago, some a month ago
    final postedDaysAgo = random.nextInt(40); // 0 to 40 days ago
    final durationHours = random.nextInt(24);
    
    // Expires could be anywhere from -5 days (expired) to +40 days (active)
    final expiresDaysFromNow = random.nextInt(45) - 5;
    
    final newPosted = "postedAt: DateTime.now().subtract(const Duration(days: $postedDaysAgo, hours: $durationHours)),";
    
    String newExpires;
    if (expiresDaysFromNow < 0) {
      newExpires = "expiresAt: DateTime.now().subtract(const Duration(days: ${expiresDaysFromNow.abs()})),";
    } else {
      newExpires = "expiresAt: DateTime.now().add(const Duration(days: $expiresDaysFromNow)),";
    }

    return '$newPosted $newExpires';
  });
  
  file.writeAsStringSync(content);
  print('Done updating job dates');
}
