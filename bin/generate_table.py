import glob
from pathlib import Path

import pandas as pd

RESULTS_DIR = Path(__file__).parent.parent / 'results'

COLUNAS = [
    'tamanho_texto',
    'tamanho_padrao',
    'ocorrencias',
    'algoritmo',
    'tempo_ms',
    'tempo_preprocessamento_ms',
    'comparacoes',
]


def main():
    arquivos = sorted(glob.glob(str(RESULTS_DIR / '*_results.csv')))
    if not arquivos:
        raise FileNotFoundError(
            f'Nenhum CSV encontrado em {RESULTS_DIR}. '
            'Execute: dart run bin/tp03.dart'
        )

    for arq in arquivos:
        df = pd.read_csv(arq)
        df = df.rename(columns={'ocorrencias_encontradas': 'ocorrencias'})
        df = df[COLUNAS]

        nome = Path(arq).stem.replace('_results', '')
        output = RESULTS_DIR / f'{nome}_comparativo.csv'
        df.to_csv(output, index=False, float_format='%.5f')


if __name__ == '__main__':
    main()
