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
