/// Métricas de desempenho da execução de um algoritmo de busca.
///
/// Armazena informações sobre tempo de execução, número de comparações
/// e tempo de pré-processamento (quando aplicável).
class Metrics {
  /// Tempo de execução em microsegundos
  final int executionTimeMicros;

  /// Número de comparações de caracteres realizadas
  final int comparisons;

  /// Tempo de pré-processamento em microsegundos (para KMP, Boyer-Moore, etc.)
  final int? preprocessingTimeMicros;

  const Metrics({
    required this.executionTimeMicros,
    required this.comparisons,
    this.preprocessingTimeMicros,
  });
}
