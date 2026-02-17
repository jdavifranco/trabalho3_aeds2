import 'package:tp03/experiment/experiment_runner.dart';

/// Trabalho Prático - Casamento de Padrões
/// Disciplina: Algoritmos e Estruturas de Dados II
///
/// Executa todos os experimentos e gera relatórios CSV na pasta results.
/// Algoritmos: Força Bruta, Rabin-Karp, KMP, Boyer-Moore, Boyer-Moore-Horspool, Boyer-Moore-Horspool-Sunday
Future<void> main(List<String> arguments) async {
  final runner = ExperimentRunner();
  await runner.runAllAndExportCsv(
    outputDir: 'results',
    iterations: 3,
  );
}
