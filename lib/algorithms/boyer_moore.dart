import '../models/metrics.dart';
import '../models/search_result.dart';

/// Algoritmo Boyer-Moore: Comparações da direita para a esquerda do padrão.
/// Duas heurísticas: concordância (bom sufixo) e carácter discordante (mau caractere).
/// Usa o maior dos saltos calculados. Pior caso O(nm), melhor/médio O(n/m).
class BoyerMoore {
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
        algorithmName: 'Boyer-Moore',
      );
    }

    // Pré-processamento: tabelas de mau caractere e bom sufixo
    final prepStopwatch = Stopwatch()..start();
    final badChar = _buildBadCharTable(pattern);
    final (goodSuffix, goodSuffixComparisons) = _buildGoodSuffixTable(pattern);
    prepStopwatch.stop();
    final preprocessingMicros = prepStopwatch.elapsedMicroseconds;
    comparisons += goodSuffixComparisons;
    var s = 0; // deslocamento do padrão no texto

    while (s <= n - m) {
      // Comparações da direita para a esquerda do padrão
      var j = m - 1;
      while (j >= 0 && pattern[j] == text[s + j]) {
        comparisons++;
        j--;
      }
      if (j < 0) {
        //Padrão encontrado em s
        positions.add(s);
        s += goodSuffix[0];
      } else {
        // Heurística mau caractere:alinhar caractere do texto com ocorrência no padrão
        final bcShift = j - badChar[text.codeUnitAt(s + j)];
        //Heurística bom sufixo: skip[j] quando falha na posição j
        final gsShift = goodSuffix[j + 1];
        //Usa o maior dos saltos
        final shift = bcShift > gsShift ? bcShift : gsShift;
        s += shift > 0 ? shift : 1;
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
      algorithmName: 'Boyer-Moore',
    );
  }

  /// Heurística caractere discordante: tabela indexada por caractere do alfabeto.
  /// Armazena última posição de cada caractere no padrão.
  List<int> _buildBadCharTable(String pattern) {
    final table = List<int>.filled(256, -1);
    for (var i = 0; i < pattern.length; i++) {
      table[pattern.codeUnitAt(i)] = i;
    }
    return table;
  }

  /// Heurística de concordância: deslizar padrão sobre si próprio.
  /// skip[j] = quantas posições avançar quando falha na posição j.
  (List<int>, int) _buildGoodSuffixTable(String pattern) {
    var comparisons = 0;
    final m = pattern.length;
    final suffix = List<int>.filled(m + 1, 0);
    final goodSuffix = List<int>.filled(m + 1, m);

    var i = m;
    var j = m + 1;
    suffix[i] = j;
    while (i > 0) {
      comparisons++;
      while (j <= m && pattern[i - 1] != pattern[j - 1]) {
        comparisons++;
        if (goodSuffix[j] == m) {
          comparisons++;
          goodSuffix[j] = j - i;
        }
        j = suffix[j];
      }
      i--;
      j--;
      suffix[i] = j;
    }
    j = suffix[0];
    for (i = 0; i <= m; i++) {
      if (goodSuffix[i] == m) {
        comparisons++;
        goodSuffix[i] = j;
      }
      if (i == j) {
        comparisons++;
        j = suffix[j];
      }
    }
    return (goodSuffix, comparisons);
  }
}
