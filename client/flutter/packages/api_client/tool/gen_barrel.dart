import 'dart:io';

void main() {
  final dir = Directory('lib/src/graphql/generated');
  if (!dir.existsSync()) {
    stderr.writeln('Directory not found: ${dir.path}');
    stderr.writeln('Run build_runner first.');
    exit(1);
  }

  final files = dir
      .listSync(recursive: true)
      .whereType<File>()
      .map((f) => f.path.replaceAll('\\', '/'))
      .where((p) => p.endsWith('.dart'))
      .where((p) => !p.endsWith('/graphql_api.dart')) // avoid recursion
      .where((p) => !p.endsWith('.g.dart')) // skip part files
      .toList()
    ..sort();

  final out = StringBuffer()
    ..writeln('// GENERATED FILE - DO NOT EDIT.')
    ..writeln('// Run: dart run tool/gen_barrel.dart')
    ..writeln();

  for (final p in files) {
    final rel = p.replaceFirst('lib/src/graphql/', '');
    out.writeln("export '$rel';");
  }

  final outFile = File('lib/src/graphql/graphql_api.gen.dart');
  outFile.writeAsStringSync(out.toString());
  stdout.writeln('✅ Wrote ${outFile.path}');
}