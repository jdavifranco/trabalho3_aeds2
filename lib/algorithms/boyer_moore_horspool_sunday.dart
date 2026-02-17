import '../models/metrics.dart';
import '../models/search_result.dart';

/// Algoritmo Boyer-Moore-Horspool-Sunday: Usa o caractere após a janela.
/// Tabela indexada por text[s+m] (caractere logo após o padrão). Valor padrão m+1.
/// Em geral permite saltos maiores que Horspool.
class BoyerMooreHorspoolSunday {
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
        algorithmName: 'Boyer-Moore-Horspool-Sunday',
      );
    }

    // Pré-processamento: tabela indexada pelo caractere após a janela
    final prepStopwatch = Stopwatch()..start();
    final (shiftTable, shiftTableComparisons) = _buildShiftTable(pattern);
    prepStopwatch.stop();
    final preprocessingMicros = prepStopwatch.elapsedMicroseconds;
    comparisons += shiftTableComparisons;
    var s = 0;

    while (s <= n - m) {
      comparisons++;
      var j = 0;
      while (j < m && pattern[j] == text[s + j]) {
        comparisons++;
        j++;
      }
      if (j == m) {
        comparisons++;
        positions.add(s);
        s += 1;
      } else {
        if (s + m < n) {
          comparisons++;
          //caractere após a janela = text[s+m]; deslocamento m+1 se não está no padrão
          final c = text.codeUnitAt(s + m);
          final shift = shiftTable[c] ?? m + 1;
          s += shift;
        } else {
          break;
        }
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
      algorithmName: 'Boyer-Moore-Horspool-Sunday',
    );
  }

  /// shift[c] = posição até último c no padrão (inclui último caractere).
  /// Fórmula shift[pattern[i]] = m - i. Valor padrão m+1 quando c não está no padrão.
  (Map<int, int>, int) _buildShiftTable(String pattern) {
    var comparisons = 0;
    final m = pattern.length;
    final shift = <int, int>{};
    for (var i = 0; i < m; i++) {
      comparisons++;
      shift[pattern.codeUnitAt(i)] = m - i;
    }
    return (shift, comparisons);
  }
}
