# Trabalho Prático - Casamento de Padrões

**Disciplina:** Algoritmos e Estruturas de Dados II  
**Tema:** Casamento de Padrões em Strings

## 📋 Descrição

Este projeto implementa e compara diferentes algoritmos de busca de padrões em strings, analisando seus comportamentos teóricos e empíricos em diversos cenários.

## 🎯 Algoritmos Implementados

1. **Força Bruta** - Complexidade: O(n·m)
2. **Rabin-Karp** - Complexidade: O(n+m) médio, O(n·m) pior caso
3. **Knuth-Morris-Pratt (KMP)** - Complexidade: O(n+m)
4. **Boyer-Moore** - Complexidade: Sublinear médio, O(n·m) pior caso
5. **Boyer-Moore-Horspool** - Complexidade: Sublinear médio
6. **Boyer-Moore-Horspool-Sunday** - Complexidade: Sublinear médio



### Executando o Programa

```bash
# 1. Gerar os arquivos de experimento (execute uma única vez)
dart run bin/generate_experiments.dart

# 2. Executar os experimentos e gerar relatórios CSV
dart run bin/tp03.dart
```

Os arquivos de experimento são salvos em `experiments/` e reutilizados em todas as execuções. Os resultados (CSVs) são salvos em `results/`.



## 📄 Licença

Este projeto é parte de um trabalho acadêmico da disciplina de Algoritmos e Estruturas de Dados II.


