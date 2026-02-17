import 'dart:io';

import 'package:path/path.dart' as path;

import '../algorithms/brute_force.dart';
import '../algorithms/rabin_karp.dart';
import '../algorithms/kmp.dart';
import '../algorithms/boyer_moore.dart';
import '../algorithms/boyer_moore_horspool.dart';
import '../algorithms/boyer_moore_horspool_sunday.dart';
import '../models/metrics.dart';
import '../models/search_result.dart';
import '../utils/benchmark.dart';
import '../utils/experiment_data.dart';

/// Classe responsável por executar experimentos e comparar algoritmos.
///
/// Fornece métodos para testar diferentes cenários e coletar
/// resultados comparativos entre todos os algoritmos implementados.
class ExperimentRunner {
  final _bruteForce = BruteForce();
  final _rabinKarp = RabinKarp();
  final _kmp = KMP();
  final _boyerMoore = BoyerMoore();
  final _boyerMooreHorspool = BoyerMooreHorspool();
  final _boyerMooreHorspoolSunday = BoyerMooreHorspoolSunday();

  /// Lista de todos os algoritmos.
  Map<String, SearchResult? Function(String, String)> get algorithms => {
    'Força Bruta': _bruteForce.search,
    'Rabin-Karp': _rabinKarp.search,
    'KMP': _kmp.search,
    'Boyer-Moore': _boyerMoore.search,
    'Boyer-Moore-Horspool': _boyerMooreHorspool.search,
    'Boyer-Moore-Horspool-Sunday': _boyerMooreHorspoolSunday.search,
  };

  /// Executa todos os experimentos
  /// Cada experimento é salvo em um arquivo separado
  /// texto_pequeno_results.csv, texto_medio_results.csv, etc.

  Future<void> runAllAndExportCsv({
    String outputDir = 'results',
    int iterations = 3,
  }) async {
    final outputDirectory = Directory(outputDir);
    if (!await outputDirectory.exists()) {
      await outputDirectory.create(recursive: true);
    }

    final createdFiles = <String>[];

    Future<void> addRecordsAndWrite(
      String scenario,
      String text,
      String pattern,
      int expectedOcc,
    ) async {
      final results = runComparison(
        text: text,
        pattern: pattern,
        iterations: iterations,
      );
      final records = results
          .map(
            (r) => _ExperimentRecord(
              experimento: scenario,
              textSize: text.length,
              patternSize: pattern.length,
              expectedOccurrences: expectedOcc,
              algorithm: r.algorithmName,
              timeMs: r.metrics.executionTimeMicros / 1000.0,
              preprocessingMs: r.metrics.preprocessingTimeMicros != null
                  ? r.metrics.preprocessingTimeMicros! / 1000.0
                  : 0.0,
              comparisons: r.metrics.comparisons,
              occurrencesFound: r.positions.length,
            ),
          )
          .toList();
      final fileName = '${scenario}_results.csv';
      final filePath = path.join(outputDir, fileName);
      await _writeCsv(records, filePath);
      createdFiles.add(File(filePath).absolute.path);
    }

    const experimentNames = [
      'texto_pequeno',
      'texto_medio',
      'texto_grande',
      'padrao_curto',
      'padrao_longo',
      'muitas_ocorrencias',
      'poucas_ocorrencias',
      'alfabeto_pequeno_dna',
      'alfabeto_grande',
      'pior_caso',
    ];

    for (final name in experimentNames) {
      final data = await ExperimentDataLoader.load(name);
      await addRecordsAndWrite(
        name,
        data.text,
        data.pattern,
        data.expectedOccurrences,
      );
    }
  }

  Future<void> _writeCsv(
    List<_ExperimentRecord> records,
    String filePath,
  ) async {
    const header =
        'experimento,tamanho_texto,tamanho_padrao,ocorrencias_esperadas,algoritmo,'
        'tempo_ms,tempo_preprocessamento_ms,comparacoes,ocorrencias_encontradas';
    final file = File(filePath);
    final lines = [header, ...records.map((r) => r.toCsvRow())];
    await file.writeAsString(lines.join('\n'));
  }

  /// Executa um experimento comparando todos os algoritmos.
  /// Retorna uma lista de resultados para cada algoritmo.
  List<SearchResult> runComparison({
    required String text,
    required String pattern,
    int iterations = 1,
  }) {
    final results = <SearchResult>[];

    for (final entry in algorithms.entries) {
      final algorithmName = entry.key;
      final searchFunction = entry.value;

      if (iterations == 1) {
        final result = Benchmark.execute(
          algorithmName: algorithmName,
          searchFunction: searchFunction,
          text: text,
          pattern: pattern,
        );
        results.add(result);
      } else {
        final stats = Benchmark.executeMultiple(
          algorithmName: algorithmName,
          searchFunction: searchFunction,
          text: text,
          pattern: pattern,
          iterations: iterations,
        );
        final meanTime = (stats['executionTime']!['mean'] as num).round();
        final meanComps = (stats['comparisons']!['mean'] as num).round();
        final meanPrep = (stats['preprocessingTime']!['mean'] as num).round();
        final lastResult = stats['positions'] != null
            ? SearchResult(
                positions: stats['positions'] as List<int>,
                metrics: Metrics(
                  executionTimeMicros: meanTime,
                  comparisons: meanComps,
                  preprocessingTimeMicros: meanPrep > 0 ? meanPrep : null,
                ),
                algorithmName: algorithmName,
              )
            : SearchResult(
                positions: [],
                metrics: Metrics(
                  executionTimeMicros: meanTime,
                  comparisons: meanComps,
                  preprocessingTimeMicros: meanPrep > 0 ? meanPrep : null,
                ),
                algorithmName: algorithmName,
              );
        results.add(lastResult);
      }
    }

    return results;
  }
}

// Classe auxiliar para gravar os resultados em um CSV
class _ExperimentRecord {
  final String experimento;
  final int textSize;
  final int patternSize;
  final int expectedOccurrences;
  final String algorithm;
  final double timeMs;
  final double? preprocessingMs;
  final int comparisons;
  final int occurrencesFound;

  _ExperimentRecord({
    required this.experimento,
    required this.textSize,
    required this.patternSize,
    required this.expectedOccurrences,
    required this.algorithm,
    required this.timeMs,
    this.preprocessingMs,
    required this.comparisons,
    required this.occurrencesFound,
  });

  String toCsvRow() {
    final prep = preprocessingMs?.toStringAsFixed(5) ?? '0.00000';
    return '$experimento,$textSize,$patternSize,$expectedOccurrences,$algorithm,'
        '${timeMs.toStringAsFixed(5)},$prep,$comparisons,$occurrencesFound';
  }
}
