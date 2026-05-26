import 'dart:convert';
import 'dart:io';

const projectId = 'aadil-legal-g1-68e92';
const databaseId = '(default)';
const seedPath = 'assets/data/portfolio_seed.json';

Future<void> main() async {
  final token = _firebaseCliAccessToken();
  final seedFile = File(seedPath);
  if (!seedFile.existsSync()) {
    stderr.writeln('Seed file not found: $seedPath');
    exitCode = 1;
    return;
  }

  final seed =
      jsonDecode(await seedFile.readAsString()) as Map<String, dynamic>;
  final writes = <Map<String, dynamic>>[];

  final firmProfile = seed['firm_profile'] as Map<String, dynamic>;
  final defaultProfile = firmProfile['default'] as Map<String, dynamic>;
  writes.add(_write('firm_profile', 'default', defaultProfile));

  _addCollection(writes, seed, 'practice_areas');
  _addCollection(writes, seed, 'attorneys');
  _addCollection(writes, seed, 'representative_matters');
  _addCollection(writes, seed, 'testimonials');
  _addCollection(writes, seed, 'resources');
  _addCollection(writes, seed, 'faqs');

  final client = HttpClient();
  try {
    final uri = Uri.https(
      'firestore.googleapis.com',
      '/v1/projects/$projectId/databases/$databaseId/documents:commit',
    );
    final request = await client.postUrl(uri);
    request.headers.contentType = ContentType.json;
    request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
    request.write(jsonEncode({'writes': writes}));
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();
    if (response.statusCode < 200 || response.statusCode >= 300) {
      stderr.writeln('Firestore seed failed (${response.statusCode}):');
      stderr.writeln(body);
      exitCode = 1;
      return;
    }

    stdout.writeln('Firestore seed completed for project $projectId.');
    stdout.writeln('Documents written: ${writes.length}');
    stdout.writeln(
      'Collections: firm_profile, practice_areas, attorneys, '
      'representative_matters, testimonials, resources, faqs',
    );
  } finally {
    client.close(force: true);
  }
}

void _addCollection(
  List<Map<String, dynamic>> writes,
  Map<String, dynamic> seed,
  String collection,
) {
  final records = seed[collection] as List<dynamic>? ?? [];
  for (final record in records.whereType<Map<String, dynamic>>()) {
    final id = record['id'] as String?;
    if (id == null || id.trim().isEmpty) {
      throw FormatException('Missing id in $collection seed record.');
    }
    final data = Map<String, dynamic>.from(record)..remove('id');
    writes.add(_write(collection, id, data));
  }
}

Map<String, dynamic> _write(
  String collection,
  String id,
  Map<String, dynamic> data,
) {
  return {
    'update': {
      'name':
          'projects/$projectId/databases/$databaseId/documents/$collection/$id',
      'fields': _fields(data),
    },
  };
}

Map<String, dynamic> _fields(Map<String, dynamic> data) {
  return data.map((key, value) => MapEntry(key, _value(value)));
}

Map<String, dynamic> _value(Object? value) {
  if (value == null) return {'nullValue': null};
  if (value is bool) return {'booleanValue': value};
  if (value is int) return {'integerValue': value.toString()};
  if (value is double) return {'doubleValue': value};
  if (value is num) return {'doubleValue': value.toDouble()};
  if (value is String) return {'stringValue': value};
  if (value is List) {
    return {
      'arrayValue': {'values': value.map(_value).toList()},
    };
  }
  if (value is Map) {
    return {
      'mapValue': {
        'fields': value.map(
          (key, item) => MapEntry(key.toString(), _value(item)),
        ),
      },
    };
  }
  throw FormatException('Unsupported Firestore seed value: $value');
}

String _firebaseCliAccessToken() {
  final home = Platform.environment['HOME'];
  if (home == null || home.isEmpty) {
    throw StateError('HOME is not set; cannot find Firebase CLI credentials.');
  }

  final configFile = File('$home/.config/configstore/firebase-tools.json');
  if (!configFile.existsSync()) {
    throw StateError(
      'Firebase CLI credentials not found. Run firebase login first.',
    );
  }

  final config =
      jsonDecode(configFile.readAsStringSync()) as Map<String, dynamic>;
  final tokens = config['tokens'] as Map<String, dynamic>?;
  final token = tokens?['access_token'] as String?;
  if (token == null || token.isEmpty) {
    throw StateError(
      'Firebase CLI access token missing. Run firebase login again.',
    );
  }
  return token;
}
