import glob
from pathlib import Path

import matplotlib.pyplot as plt
import pandas as pd

RESULTS_DIR = Path(__file__).parent.parent / 'results'


def _carregar_dados():
    arquivos = sorted(glob.glob(str(RESULTS_DIR / '*_results.csv')))
    if not arquivos:
        raise FileNotFoundError(
            f'Nenhum CSV encontrado em {RESULTS_DIR}. '
            'Execute: dart run bin/tp03.dart'
        )
    dfs = []
    for arq in arquivos:
        df = pd.read_csv(arq)
        df['experimento'] = Path(arq).stem.replace('_results', '')
        dfs.append(df)
    return pd.concat(dfs, ignore_index=True)


def main():
    df = _carregar_dados()
    df['tempo_total_ms'] = df['tempo_ms'] + df['tempo_preprocessamento_ms'].fillna(0)

    pivot_tempo = df.pivot(index='experimento', columns='algoritmo', values='tempo_total_ms')
    pivot_comps = df.pivot(index='experimento', columns='algoritmo', values='comparacoes')

    pivot_tempo = pivot_tempo.clip(lower=0.0001)
    pivot_comps = pivot_comps.clip(lower=1)

    pivot_tempo.plot(kind='bar', figsize=(12, 5), width=0.8, rot=45, logy=True)
    plt.xlabel('Experimento')
    plt.ylabel('Tempo total (ms) - escala log')
    plt.title('Tempo de execução + pré-processamento por experimento')
    plt.legend(bbox_to_anchor=(1.02, 1), loc='upper left')
    plt.grid(axis='y', alpha=0.3)
    plt.tight_layout()
    plt.savefig(RESULTS_DIR / 'grafico_tempo.png', dpi=150, bbox_inches='tight')
    plt.close()

    pivot_comps.plot(kind='bar', figsize=(12, 5), width=0.8, rot=45, logy=True)
    plt.xlabel('Experimento')
    plt.ylabel('Comparações - escala log')
    plt.title('Número de comparações por experimento')
    plt.legend(bbox_to_anchor=(1.02, 1), loc='upper left')
    plt.grid(axis='y', alpha=0.3)
    plt.tight_layout()
    plt.savefig(RESULTS_DIR / 'grafico_comparacoes.png', dpi=150, bbox_inches='tight')
    plt.close()


if __name__ == '__main__':
    main()
