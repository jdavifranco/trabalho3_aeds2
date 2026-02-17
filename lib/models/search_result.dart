import 'metrics.dart';

/// Representa o resultado de uma busca de padrão em um texto.

class SearchResult {
  /// Posições (índices) onde o padrão foi encontrado no texto
  final List<int> positions;

  /// Métricas de desempenho da execução
  final Metrics metrics;

  /// Nome do algoritmo utilizado
  final String algorithmName;

  const SearchResult({
    required this.positions,
    required this.metrics,
    required this.algorithmName,
  });
}
