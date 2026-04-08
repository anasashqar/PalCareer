import 'dart:io';

void main() {
  final libDir = Directory('lib');
  for (final file in libDir.listSync(recursive: true)) {
    if (file is File && file.path.endsWith('.dart')) {
      final content = file.readAsStringSync();
      if (content.contains('AppColors.')) {
        final newContent = content.replaceAll('AppColors.', 'Theme.of(context).colorScheme.');
        file.writeAsStringSync(newContent);
        // ignore: avoid_print
        print('Updated ${file.path}');
      }
    }
  }
}
