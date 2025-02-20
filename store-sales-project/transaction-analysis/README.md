Essa primeira iniciativa teve como intenção usar os dados de um arquivo "transactions.csv" de transações realizadas ao longo do tempo em uma loja.

Esses foram disponibilizados pela Kaggle, e está disponível o acesso para baixar o dataset de acordo com as especificações do site.
O nome do dataset é "Store Sales - Time Series Forecasting" desc: (Use machine learning to predict grocery sales).

O livro que me inspirou a exercitar esse tema foi "Using R for Time Series Analysis", presente no link: "https://a-little-book-of-r-for-time-series.readthedocs.io/en/latest/src/timeseries.html"
Através do site é possível baixar o documento para leitura em PDF.

O que foi feito:
- uso de ferramentas gráficas para plotagem e visualização dos dados apresentados
- a criação de modelos de previsão como Holt-Winters e ARIMA para suavização exponencial com h = 12 (mensal).
- análise exploratória de alguns dados, através de um boxplot, para verificar os valores atípicos ou outliers da amostra.
- plot de ACF para verificar sazonalidade (como retornou um pico no décimo segundo lag, foi assumido que havia sazonalidade) 
- verificação de parâmetro para que se encaixe no modelo ARIMA (se a série é estacionária)
- estudo da precisão apresentada ao se utilizar quaisquer 1 dos 2 modelos (ARIMA ou Holt-Winters)

A princípio, tive um pouco de dificuldade ao tratar os dados. Assim como em qualquer problema desse tipo, os valores faltantes podem impactar nos modelos.
Antes, eu estava aplicando todo o código, porém sem tratar esses valores (sem atribuir 0, NULL, NA) ou algo do tipo.

Para resolver isso, eu fiz um DataFrame completo, que solucionava essa questão e atribuía valores NA/nulos aos dados faltantes (interpolação linear). 
Uma biblioteca/library importante para isso foi o "zoo".

Depois, criei uma série sazonal para fazer uma análise mensal. (dados agrupados por mês + soma das transações)
O motivo de ter escolhido essa opção foi para estudar melhor a sazonalidade e fazer previsão de curto prazo.

Foi visto através do boxplot que haviam alguns outliers na amostra, os tais valores atípicos.

![image](https://github.com/user-attachments/assets/60b1730c-06e3-4cba-9e1a-3e12044815a7)
