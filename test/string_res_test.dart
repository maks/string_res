import 'dart:convert';

import 'package:string_res/src/builder.dart';
import 'package:test/test.dart';

const example = '''
{
    "first_name": "First Name",
    "log_in": "Log in"
}
''';

const longExample = '''
{
    "first_name": "First Name",
    "very_long": "This is a very long value, in fact it is long enough to be truncated"
}
''';

void main() {
  test('can generate string consts', () {
    final generator = StringConstGenerator();
    final buffer = StringBuffer();
    generator.makeResource(json.decode(example) as Map<String, Object>, buffer);

    expect(buffer.toString(),
        '// First Name\nstatic const FIRST_NAME = "first_name";\n// Log in\nstatic const LOG_IN = "log_in";\n');
  });

  test('can generate truncated comments for string consts', () {
    final generator = StringConstGenerator();
    final buffer = StringBuffer();
    generator.makeResource(
        json.decode(longExample) as Map<String, Object>, buffer);

    expect(buffer.toString(),
        '// First Name\nstatic const FIRST_NAME = "first_name";\n// This is a very long value, in fact it is long enou...\nstatic const VERY_LONG = "very_long";\n');
  });
}
