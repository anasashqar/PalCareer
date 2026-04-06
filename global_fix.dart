import 'dart:io';

void main() {
  // 1. Fix app_colors.dart Invalid constructor
  var appColorsFile = File('lib/core/theme/app_colors.dart');
  if (appColorsFile.existsSync()) {
    var content = appColorsFile.readAsStringSync();
    content = content.replaceAll('class Theme.of(context).colorScheme._ {', 'class AppColors._ {');
    appColorsFile.writeAsStringSync(content);
  }

  // 2. Fix const errors globally
  var libDir = Directory('lib');
  for (var file in libDir.listSync(recursive: true).whereType<File>()) {
    if (!file.path.endsWith('.dart')) continue;
    var content = file.readAsStringSync();
    content = content.replaceAllMapped(RegExp(r'const\s+(Icon|BoxDecoration|Center|Text|Row|Column|Container|Padding|BorderSide)\b'), (m) => m[1]!);
    content = content.replaceAllMapped(RegExp(r'const\s+(SizedBox|CircleAvatar|RoundedRectangleBorder|TextStyle|EdgeInsets|Color|Align|Positioned)\b'), (m) => m[1]!);
    file.writeAsStringSync(content);
  }

  // 3. Fix onboarding_screen.dart taxonomy issues and context
  var onboardingFile = File('lib/features/onboarding/screens/onboarding_screen.dart');
  if (onboardingFile.existsSync()) {
    var content = onboardingFile.readAsStringSync();
    // Rename static access to use taxonomyAsync
    content = content.replaceAll('CareerTaxonomy.sectors', 'taxonomyAsync.value!.sectors');
    content = content.replaceAll('CareerTaxonomy.getSubSectors', 'CareerTaxonomy.getSubSectorsFallback');
    
    // Fix context in _buildCard and _buildOption
    content = content.replaceAll('_buildCard(String title, String subtitle, {', '_buildCard(BuildContext context, String title, String subtitle, {');
    content = content.replaceAll('_buildOption(String title, {', '_buildOption(BuildContext context, String title, {');
    
    // We already invoked them inside build, but wait, do we pass context?
    // Let's replace _buildOption(...) to _buildOption(context, ...)
    // Wait, regex might be tricky, let's just do it directly.
    content = content.replaceAll('_buildOption(\n', '_buildOption(context,\n');
    content = content.replaceAll('_buildCard(\n', '_buildCard(context,\n');
    // Also inline if it's on the same line
    content = content.replaceAll('                    _buildCard(', '                    _buildCard(context, ');
    content = content.replaceAll('                          _buildOption(', '                          _buildOption(context, ');

    onboardingFile.writeAsStringSync(content);
  }
}
