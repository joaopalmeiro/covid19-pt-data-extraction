# Notas

As datas, que constituem os nomes dos vários conjuntos de dados, coincidem com as datas de emissão dos Relatórios de Situação por parte da DGS (mais informação [aqui](https://covid19.min-saude.pt/relatorio-de-situacao/)).

## Dicionário de dados

| Nome da variável       | Significado                                                                                                                                                                                                                                                         | Formato          | Exemplo  |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- | -------- |
| `concelho`             | Nome do concelho (conforme os Relatórios de Situação).                                                                                                                                                                                                              | Texto            | `Lisboa` |
| `reportado_por_ARS_RA` | Caso o número de casos confirmados tenha sido reportado pelas Administrações Regionais de Saúde e Regiões Autónomas, esta variável toma o valor `1`. Apenas os conjuntos de dados derivados de Relatórios de Situação com esta nota de rodapé contêm esta variável. | Inteiro (0 ou 1) | `1`      |
| `n_casos`              | Número de casos confirmados.                                                                                                                                                                                                                                        | Inteiro (>= 3)   | `366`    |

## Nomenclatura dos concelhos

- `Vila Real de Santo António` == `V. R. S. António`.

## Potenciais problemas

- `2020-03-30.csv`: O `concelho` do `Porto` surge com `n_casos` duplicado. Poderão haver outros concelhos na mesma situação. O problema foi "corrigido" no Relatório de Situação do dia seguinte. Mais informação em:
  - [_31/03/2020 | Conferência de Imprensa COVID-19_](https://youtu.be/OKBZ2XDvvNQ?t=983) (SNS).
  - [_Covid-19. DGS admite duplicações na contagem de casos no Porto_](https://rr.sapo.pt/2020/03/31/pais/covid-19-dgs-admite-duplicacoes-na-contagem-de-casos-no-porto/noticia/187403/) (Rádio Renascença).
  - [_Número de recuperados não sobe, mas um erro fez duplicar infetados. O que foi explicado na conferência de imprensa_](https://observador.pt/2020/03/31/numero-de-recuperados-nao-sobe-mas-um-erro-fez-duplicar-infetados-o-que-foi-explicado-na-conferencia-de-imprensa/) (Observador).
- `2020-04-02.csv`: O `concelho` de `Penacova` surge duas vezes com `n_casos` distintos.
