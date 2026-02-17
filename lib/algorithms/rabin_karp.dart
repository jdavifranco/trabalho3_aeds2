import '../models/metrics.dart';
import '../models/search_result.dart';

/// Algoritmo Rabin-Karp: Gera código p para o padrão (calculado uma vez).
/// Para cada porção do texto gera código t e compara com p. Usa rolling hash e MOD.
/// Quando p = q, usa comparação como Força Bruta para tratar possível colisão.
class RabinKarp {
  static const int _base = 256;
  static const int _mod = 101;

  SearchResult? search(String text, String pattern) {
    final stopwatch = Stopwatch()..start();
    final n = text.length;
    final m = pattern.length;
    final positions = <int>[];
    var comparisons = 0;

    if (m == 0 || m > n) {
      stopwatch.stop();
      return SearchResult(
        positions: positions,
        metrics: Metrics(
          executionTimeMicros: stopwatch.elapsedMicroseconds,
          comparisons: 0,
        ),
        algorithmName: 'Rabin-Karp',
      );
    }

    // Pré-processamento: hash do padrão, primeira janela e fator h
    final prepStopwatch = Stopwatch()..start();
    final patternHash = _computeHash(pattern);
    var textHash = _computeHash(text.substring(0, m));
    var h = 1;
    for (var i = 0; i < m - 1; i++) {
      h = (h * _base) % _mod;
    }
    prepStopwatch.stop();
    final preprocessingMicros = prepStopwatch.elapsedMicroseconds;

    for (var i = 0; i <= n - m; i++) {
      comparisons++;
      //Se o hash do texto for igual ao hash do padrão, verifica comparando caractere por caractere para tratar possível colisão
      if (patternHash == textHash) {
        comparisons++;
        var j = 0;
        while (j < m && text[i + j] == pattern[j]) {
          j++;
          comparisons++;
        }
        if (j == m) {
          comparisons++;
          positions.add(i);
        }
      }

      //Atualiza o hash do texto para a próxima janela se ainda houver espaço
      if (i < n - m) {
        comparisons++;
        var newHash =
            (_base * (textHash - text.codeUnitAt(i) * h) +
                text.codeUnitAt(i + m)) %
            _mod;
        textHash = newHash < 0 ? newHash + _mod : newHash;
      }
    }

    stopwatch.stop();
    return SearchResult(
      positions: positions,
      metrics: Metrics(
        executionTimeMicros: stopwatch.elapsedMicroseconds,
        comparisons: comparisons,
        preprocessingTimeMicros: preprocessingMicros,
      ),
      algorithmName: 'Rabin-Karp',
    );
  }

  // hash polinomial com MOD nos cálculos intermediários para evitar overflow
  int _computeHash(String str) {
    var hash = 0;
    for (var i = 0; i < str.length; i++) {
      hash = (_base * hash + str.codeUnitAt(i)) % _mod;
    }
    return hash;
  }
}
