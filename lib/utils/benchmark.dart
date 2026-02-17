import '../models/search_result.dart';
import '../models/metrics.dart';

/// Utilitário para realizar benchmarks de algoritmos de busca.
/// Fornece métodos para medir tempo de execução e contar comparações.
class Benchmark {
  /// Executa um algoritmo de busca e coleta métricas de desempenho.
  static SearchResult execute({
    required String algorithmName,
    required SearchResult? Function(String text, String pattern) searchFunction,
    required String text,
    required String pattern,
  }) {
    final stopwatch = Stopwatch()..start();
    final result = searchFunction(text, pattern);
    stopwatch.stop();

    if (result == null) {
      return SearchResult(
        positions: [],
        metrics: Metrics(
          executionTimeMicros: stopwatch.elapsedMicroseconds,
          comparisons: 0,
        ),
        algorithmName: '$algorithmName (não implementado)',
      );
    }

    return result;
  }

  /// Executa múltiplas iterações de um algoritmo e retorna estatísticas.
  static Map<String, dynamic> executeMultiple({
    required String algorithmName,
    required SearchResult? Function(String text, String pattern) searchFunction,
    required String text,
    required String pattern,
    int iterations = 10,
  }) {
    final executionTimes = <int>[];
    final comparisons = <int>[];
    final preprocessingTimes = <int>[];
    SearchResult? lastResult;

    for (var i = 0; i < iterations; i++) {
      final result = execute(
        algorithmName: algorithmName,
        searchFunction: searchFunction,
        text: text,
        pattern: pattern,
      );

      executionTimes.add(result.metrics.executionTimeMicros);
      comparisons.add(result.metrics.comparisons);
      preprocessingTimes.add(result.metrics.preprocessingTimeMicros ?? 0);
      lastResult = result;
    }

    executionTimes.sort();
    comparisons.sort();
    preprocessingTimes.sort();

    return {
      'algorithmName': algorithmName,
      'iterations': iterations,
      'positions': lastResult?.positions ?? [],
      'occurrences': lastResult?.positions.length ?? 0,
      'executionTime': {
        'mean': _calculateMean(executionTimes),
        'median': _calculateMedian(executionTimes),
        'min': executionTimes.first,
        'max': executionTimes.last,
        'stdDev': _calculateStdDev(executionTimes),
      },
      'comparisons': {
        'mean': _calculateMean(comparisons),
        'median': _calculateMedian(comparisons),
        'min': comparisons.first,
        'max': comparisons.last,
        'stdDev': _calculateStdDev(comparisons),
      },
      'preprocessingTime': {'mean': _calculateMean(preprocessingTimes)},
    };
  }

  /// Calcula a média de uma lista de valores.
  static double _calculateMean(List<int> values) {
    if (values.isEmpty) return 0.0;
    return values.reduce((a, b) => a + b) / values.length;
  }

  /// Calcula a mediana de uma lista de valores (já deve estar ordenada).
  static double _calculateMedian(List<int> values) {
    if (values.isEmpty) return 0.0;

    final middle = values.length ~/ 2;
    if (values.length % 2 == 0) {
      return (values[middle - 1] + values[middle]) / 2.0;
    } else {
      return values[middle].toDouble();
    }
  }

  /// Calcula o desvio padrão de uma lista de valores.
  static double _calculateStdDev(List<int> values) {
    if (values.isEmpty) return 0.0;

    final mean = _calculateMean(values);
    final variance =
        values
            .map((value) => (value - mean) * (value - mean))
            .reduce((a, b) => a + b) /
        values.length;

    return variance.sqrt();
  }
}

/// Extensão para adicionar método sqrt a num
extension NumExtension on num {
  double sqrt() => this < 0 ? double.nan : (this as double).squareRoot();
}

/// Extensão para adicionar método squareRoot a double
extension DoubleExtension on double {
  double squareRoot() {
    if (this < 0) return double.nan;
    if (this == 0) return 0;

    var x = this;
    var prev = 0.0;

    while ((x - prev).abs() > 0.000001) {
      prev = x;
      x = (x + this / x) / 2;
    }

    return x;
  }
}
