import 'dart:math';

import 'package:tp03/utils/experiment_data.dart';
import 'package:tp03/utils/text_generator.dart';

/// Gera uma única vez os arquivos de experimento na pasta experiments.
/// Todos os experimentos têm pelo menos uma ocorrência do padrão no texto.
/// O número de ocorrências é aleatório e salvo no próprio arquivo.
void main() async {
  const seed = 42;
  final random = Random(seed);

  // 1. Textos pequenos, médios e grandes
  var p = TextGenerator.generatePattern(5, TextGenerator.alphabetSmall);
  var occ = (random.nextDouble() * 10).round() + 1;
  var t = TextGenerator.generateTextWithPattern(
    textLength: 95,
    pattern: p,
    occurrences: occ,
    alphabet: TextGenerator.alphabetSmall,
  );
  await ExperimentDataLoader.save(
    'texto_pequeno',
    ExperimentData(text: t, pattern: p, expectedOccurrences: occ),
  );

  p = TextGenerator.generatePattern(10, TextGenerator.alphabetMedium);
  occ = (random.nextDouble() * 10).round() + 1;
  t = TextGenerator.generateTextWithPattern(
    textLength: 9990,
    pattern: p,
    occurrences: occ,
    alphabet: TextGenerator.alphabetMedium,
  );
  await ExperimentDataLoader.save(
    'texto_medio',
    ExperimentData(text: t, pattern: p, expectedOccurrences: occ),
  );

  p = TextGenerator.generatePattern(15, TextGenerator.alphabetLarge);
  occ = (random.nextDouble() * 10).round() + 1;
  t = TextGenerator.generateTextWithPattern(
    textLength: 99985,
    pattern: p,
    occurrences: occ,
    alphabet: TextGenerator.alphabetLarge,
  );
  await ExperimentDataLoader.save(
    'texto_grande',
    ExperimentData(text: t, pattern: p, expectedOccurrences: occ),
  );

  // 2. Padrões curtos e longos
  p = TextGenerator.generatePattern(3, TextGenerator.alphabetMedium);
  occ = (random.nextDouble() * 10).round() + 1;
  t = TextGenerator.generateTextWithPattern(
    textLength: 49997,
    pattern: p,
    occurrences: occ,
    alphabet: TextGenerator.alphabetMedium,
  );
  await ExperimentDataLoader.save(
    'padrao_curto',
    ExperimentData(text: t, pattern: p, expectedOccurrences: occ),
  );

  p = TextGenerator.generatePattern(50, TextGenerator.alphabetMedium);
  occ = (random.nextDouble() * 10).round() + 1;
  t = TextGenerator.generateTextWithPattern(
    textLength: 49950,
    pattern: p,
    occurrences: occ,
    alphabet: TextGenerator.alphabetMedium,
  );
  await ExperimentDataLoader.save(
    'padrao_longo',
    ExperimentData(text: t, pattern: p, expectedOccurrences: occ),
  );

  // 3. Muitas e poucas ocorrências
  occ = 100;
  t = TextGenerator.generateTextWithPattern(
    textLength: 9700,
    pattern: 'ABC',
    occurrences: occ,
    alphabet: TextGenerator.alphabetMedium,
  );
  await ExperimentDataLoader.save(
    'muitas_ocorrencias',
    ExperimentData(text: t, pattern: 'ABC', expectedOccurrences: occ),
  );

  occ = (random.nextDouble() * 5).round() + 1;
  t = TextGenerator.generateTextWithPattern(
    textLength: 9991,
    pattern: 'XYZ',
    occurrences: occ,
    alphabet: TextGenerator.alphabetMedium,
  );
  await ExperimentDataLoader.save(
    'poucas_ocorrencias',
    ExperimentData(text: t, pattern: 'XYZ', expectedOccurrences: occ),
  );

  // 4. Alfabetos pequeno e grande
  p = TextGenerator.generatePattern(8, TextGenerator.alphabetSmall);
  occ = (random.nextDouble() * 10).round() + 1;
  t = TextGenerator.generateTextWithPattern(
    textLength: 9992,
    pattern: p,
    occurrences: occ,
    alphabet: TextGenerator.alphabetSmall,
  );
  await ExperimentDataLoader.save(
    'alfabeto_pequeno_dna',
    ExperimentData(text: t, pattern: p, expectedOccurrences: occ),
  );

  p = TextGenerator.generatePattern(10, TextGenerator.alphabetLarge);
  occ = (random.nextDouble() * 10).round() + 1;
  t = TextGenerator.generateTextWithPattern(
    textLength: 9990,
    pattern: p,
    occurrences: occ,
    alphabet: TextGenerator.alphabetLarge,
  );
  await ExperimentDataLoader.save(
    'alfabeto_grande',
    ExperimentData(text: t, pattern: p, expectedOccurrences: occ),
  );

  // 5. Pior caso
  const patternLength = 99;
  p = "${TextGenerator.generateText(patternLength, "A")}B";
  t = TextGenerator.generateTextWithPattern(
    textLength: 99985,
    pattern: p,
    occurrences: 1,
    alphabet: "A",
  );
  t = "${t}B";
  await ExperimentDataLoader.save(
    'pior_caso',
    ExperimentData(text: t, pattern: p, expectedOccurrences: 1),
  );
}
