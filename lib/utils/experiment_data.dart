import 'dart:io';

/// Dados de um experimento: texto, padrão e ocorrências esperadas.
class ExperimentData {
  final String text;
  final String pattern;
  final int expectedOccurrences;

  const ExperimentData({
    required this.text,
    required this.pattern,
    required this.expectedOccurrences,
  });
}

/// Utilitário para carregar e salvar dados de experimentos em arquivos.

class ExperimentDataLoader {
  static const _expectedMarker = '---EXPECTED_OCCURRENCES---';
  static const _patternMarker = '---PATTERN---';
  static const _textMarker = '---TEXT---';

  /// Carrega texto e padrão de um arquivo na pasta experiments.
  static Future<ExperimentData> load(String experimentName) async {
    final file = File('experiments/$experimentName.txt');
    if (!await file.exists()) {
      throw StateError(
        'Arquivo de experimento não encontrado: experiments/$experimentName.txt. '
        'Execute: dart run bin/generate_experiments.dart',
      );
    }
    final content = await file.readAsString();
    return _parse(content);
  }

  static ExperimentData _parse(String content) {
    final expectedIdx = content.indexOf(_expectedMarker);
    final patternIdx = content.indexOf(_patternMarker);
    final textIdx = content.indexOf(_textMarker);

    if (expectedIdx < 0 || patternIdx < 0 || textIdx < 0) {
      throw FormatException(
        'Formato inválido: esperado ---EXPECTED_OCCURRENCES---, ---PATTERN--- e ---TEXT---',
      );
    }

    final expectedStr = content
        .substring(expectedIdx + _expectedMarker.length, patternIdx)
        .trim();
    final parsed = int.tryParse(expectedStr);
    if (parsed == null || parsed < 0) {
      throw FormatException(
        'Valor inválido para ocorrências esperadas: "$expectedStr"',
      );
    }

    final pattern = content
        .substring(patternIdx + _patternMarker.length, textIdx)
        .trim();
    final text = content.substring(textIdx + _textMarker.length).trim();

    return ExperimentData(
      text: text,
      pattern: pattern,
      expectedOccurrences: parsed,
    );
  }

  /// Salva texto e padrão em um arquivo na pasta experiments.
  static Future<void> save(String experimentName, ExperimentData data) async {
    final dir = Directory('experiments');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    final file = File('experiments/$experimentName.txt');
    final content =
        '$_expectedMarker\n${data.expectedOccurrences}\n'
        '$_patternMarker\n${data.pattern}\n$_textMarker\n${data.text}';
    await file.writeAsString(content);
  }
}
