import 'dart:io';

void main() {
  final files = [
    'lib/features/profile/screens/profile_screen.dart',
    'lib/features/onboarding/screens/onboarding_screen.dart',
  ];
  
  for (var path in files) {
    if (!File(path).existsSync()) continue;
    var content = File(path).readAsStringSync();
    
    content = content.replaceAllMapped(RegExp(r'const\s+(Icon|BoxDecoration|Center|Text|Row|Column|Container|Padding|BorderSide)\b'), (m) => m[1]!);
    content = content.replaceAllMapped(RegExp(r'const\s+(SizedBox|CircleAvatar|RoundedRectangleBorder|TextStyle|EdgeInsets|Color|Align|Positioned)\b'), (m) => m[1]!);
    
    if (path.contains('profile')) {
      content = content.replaceAll('_buildFallbackAvatar(String userName)', '_buildFallbackAvatar(BuildContext context, String userName)');
      content = content.replaceAll('_buildFallbackAvatar(userName)', '_buildFallbackAvatar(context, userName)');
      content = content.replaceAll(RegExp(r'activeColor:\s+'), 'activeThumbColor: ');
    }
    
    File(path).writeAsStringSync(content);
  }
}
