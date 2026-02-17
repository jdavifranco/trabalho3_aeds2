import '../models/metrics.dart';
import '../models/search_result.dart';

/// Algoritmo de Força Bruta: Método simples, desloca uma posição a cada
/// iteração. O padrão desloca-se no texto como uma janela. Complexidade O(n*m).
class BruteForce {
  SearchResult? search(String text, String pattern) {
    final stopwatch = Stopwatch()..start();
    final n = text.length;
    final m = pattern.length;
    final positions = <int>[];
    var comparisons = 0;

    //Percore o texto até o final do texto menos o tamanho do padrão
    //Para cada deslocamento s (0 ≤ s ≤ n-m), serão feitas comparações conforme tamanho m
    for (var i = 0; i <= n - m; i++) {
      comparisons++;
      var j = i;
      var k = 0;
      //Percore o padrão enquanto os caracteres forem iguais
      while (k < m && text[j] == pattern[k]) {
        comparisons++;
        k++;
        j++;
      }
      //Se o padrão foi encontrado, adiciona a posição ao resultado
      if (k == m) {
        comparisons++;
        positions.add(i);
      }
    }

    stopwatch.stop();
    return SearchResult(
      positions: positions,
      metrics: Metrics(
        executionTimeMicros: stopwatch.elapsedMicroseconds,
        comparisons: comparisons,
      ),
      algorithmName: 'Força Bruta',
    );
  }
}
