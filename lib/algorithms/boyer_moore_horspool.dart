import '../models/metrics.dart';
import '../models/search_result.dart';

/// Algoritmo Boyer-Moore-Horspool:  Versão simplificada do Boyer-Moore.
/// Usa apenas a heurística do bad caractere. Tabela indexada pelo caractere
/// do texto que se alinha ao último caractere do padrão.
class BoyerMooreHorspool {
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
        algorithmName: 'Boyer-Moore-Horspool',
      );
    }

    // Pré-processamento: tabela de deslocamento
    final prepStopwatch = Stopwatch()..start();
    final (shiftTable, shiftTableComparisons) = _buildShiftTable(pattern);
    prepStopwatch.stop();
    final preprocessingMicros = prepStopwatch.elapsedMicroseconds;
    comparisons += shiftTableComparisons;
    var s = 0; // início da janela no texto

    while (s <= n - m) {
      comparisons++;
      // Comparações da direita para a esquerda
      var j = m - 1;
      while (j >= 0 && pattern[j] == text[s + j]) {
        comparisons++;
        j--;
      }
      if (j < 0) {
        positions.add(s);
        s += m;
      } else {
        comparisons++;
        //caractere discordante = texto[s+m-1]; desloca pela tabela
        final c = text.codeUnitAt(s + m - 1);
        final shift = shiftTable[c] ?? m;
        s += shift;
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
      algorithmName: 'Boyer-Moore-Horspool',
    );
  }

  /// Tabela de deslocamento: shift[c] = distância até última ocorrência de c no padrão.
  /// Só para posições 0..m-2 (último caractere excluído). Valor padrão m se c não está no padrão.
  (Map<int, int>, int) _buildShiftTable(String pattern) {
    var comparisons = 0;
    final m = pattern.length;
    final shift = <int, int>{};
    for (var i = 0; i < m - 1; i++) {
      comparisons++;
      shift[pattern.codeUnitAt(i)] = m - 1 - i;
    }
    return (shift, comparisons);
  }
}
