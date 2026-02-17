import '../models/metrics.dart';
import '../models/search_result.dart';

/// Algoritmo Knuth-Morris-Pratt: Tempo linear O(n+m). Utiliza função prefixo π
/// pré-calculada em O(m). Os valores indicam quantas casas devem ser puladas.
class KMP {
  SearchResult? search(String text, String pattern) {
    final stopwatch = Stopwatch()..start();
    final n = text.length;
    final m = pattern.length;
    final positions = <int>[];
    var count = 0;

    if (m == 0 || m > n) {
      stopwatch.stop();
      return SearchResult(
        positions: positions,
        metrics: Metrics(
          executionTimeMicros: stopwatch.elapsedMicroseconds,
          comparisons: 0,
        ),
        algorithmName: 'KMP',
      );
    }

    // função prefixo
    final prepStopwatch = Stopwatch()..start();
    final (next, nextComparisons) = _funcaoPrefixoKMP(pattern);
    prepStopwatch.stop();
    final preprocessingMicros = prepStopwatch.elapsedMicroseconds;
    count += nextComparisons;
    var i = 0;
    var j = 0;

    while (j < n) {
      //Em caso de mismatch, next[i] indica a partir de qual posição continuar a comparação
      while (i > -1 && pattern[i] != text[j]) {
        count++;
        i = next[i];
      }
      count++;
      i++;
      j++;
      //Padrão encontrado quando i >= m, next[i] permite continuar buscando ocorrências
      if (i >= m) {
        positions.add(j - i);
        i = next[i];
      }
    }

    stopwatch.stop();
    return SearchResult(
      positions: positions,
      metrics: Metrics(
        executionTimeMicros: stopwatch.elapsedMicroseconds,
        comparisons: count,
        preprocessingTimeMicros: preprocessingMicros,
      ),
      algorithmName: 'KMP',
    );
  }

  /// Função prefixo: calcula next[] para saber quantas casas pular em cada posição.
  /// next[i] = índice para continuar quando mismatch na posição i.
  (List<int>, int) _funcaoPrefixoKMP(String pattern) {
    var comparisons = 0;
    final m = pattern.length;
    final next = List<int>.filled(m + 1, 0);
    var i = 0;
    var j = next[0] = -1;

    while (i < m) {
      comparisons++;
      //Se o caractere atual for diferente do caractere no prefixo, decrementa o tamanho do prefixo
      while (j > -1 && pattern[i] != pattern[j]) {
        comparisons++;
        j = next[j];
      }
      //Incrementa o índice do texto e do padrão
      i++;
      j++;
      if (i >= m) {
        comparisons++;
        next[i] = j;
      } else if (pattern[i] == pattern[j]) {
        comparisons++;
        next[i] = next[j];
      } else {
        comparisons++;
        next[i] = j;
      }
    }
    return (next, comparisons);
  }
}
