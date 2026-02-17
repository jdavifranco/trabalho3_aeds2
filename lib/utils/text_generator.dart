import 'dart:io';
import 'dart:math';

/// Fornece métodos para criar diferentes cenários de teste:

class TextGenerator {
  static final _random = Random();

  /// Alfabeto pequeno
  static const String alphabetSmall = 'ACGT';

  /// Alfabeto médio
  static const String alphabetMedium = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  /// Alfabeto grande
  static const String alphabetLarge =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 .,;!?';

  /// Gera um texto aleatório com o tamanho e alfabeto especificados.

  static String generateText(int length, String alphabet) {
    final buffer = StringBuffer();
    for (var i = 0; i < length; i++) {
      buffer.write(alphabet[_random.nextInt(alphabet.length)]);
    }
    return buffer.toString();
  }

  /// Gera um padrão aleatório.
  static String generatePattern(int length, String alphabet) {
    return generateText(length, alphabet);
  }

  /// Gera um texto com um padrão específico inserido várias vezes.
  static String generateTextWithPattern({
    required int textLength,
    required String pattern,
    required int occurrences,
    required String alphabet,
  }) {
    if (pattern.isEmpty || textLength < pattern.length) {
      return generateText(textLength, alphabet);
    }

    //Gera as posições possíveis para o padrão considerando nao ter sobreposição
    final patternsPossible = List.generate(
      (textLength - pattern.length) ~/ pattern.length,
      (index) => index * pattern.length,
    );
    patternsPossible.shuffle();

    final patternPositions = patternsPossible.take(occurrences).toList();
    patternPositions.sort();
    final buffer = StringBuffer();
    var patternPositionIndex = 0;
    var i = 0;
    //Gera o texto com o padrão inserido várias vezes
    while (i < textLength) {
      //Se a posição do padrão for a mesma que a posição atual, insere o padrão no texto
      if (patternPositionIndex < patternPositions.length &&
          patternPositions[patternPositionIndex] == i) {
        buffer.write(pattern);
        patternPositionIndex++;
        i += pattern.length;
      } else {
        //Se a posição do padrão não for a mesma que a posição atual, insere um caractere aleatório no texto
        buffer.write(alphabet[_random.nextInt(alphabet.length)]);
        i++;
      }
    }

    return buffer.toString();
  }

  /// Carrega um texto de um arquivo.
  static Future<String> loadTextFromFile(String filePath) async {
    try {
      final file = File(filePath);
      return await file.readAsString();
    } catch (e) {
      throw Exception('Erro ao carregar arquivo: $e');
    }
  }

  /// Salva um texto em um arquivo.
  static Future<void> saveTextToFile(String text, String filePath) async {
    try {
      final file = File(filePath);
      await file.writeAsString(text);
    } catch (e) {
      throw Exception('Erro ao salvar arquivo: $e');
    }
  }
}
