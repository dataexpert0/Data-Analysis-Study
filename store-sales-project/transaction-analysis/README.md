<h1>**Projeto com transações de uma loja (grocery store)**</h1>
<h2>Gráficos: soma das transações feitas em cada dia do mês a cada ano.</h2>

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

<img src="https://github.com/user-attachments/assets/60b1730c-06e3-4cba-9e1a-3e12044815a7" width="500" />

Esses *outliers* não foram tratados inicialmente, pois para mim, poderiam ser importantes ou especiais nesse contexto, ainda mais lidando com número de transações em certos meses específicos.

Em seguida, foi feito uma análise do ACF (Autocorrelaction Function, ou função de autocorrelação). Isso é para poder ver se existe ou não sazonalidade na série temporal criada. Devido ao fato do comportamento dos lags, e além de que existe um pico no lag 12 e um lag 24 também mais ou menos alto, foi assumido que existe sazonalidade nessa série. Eu já havia presumido pelo fato de envolver transações de uma *loja* em datas específicas, então pode incluir feriados, datas especiais, entre outros, que possam afetar ela.

<img src="https://i.imgur.com/wpETGjB.png" width="500"/>

Assim, crio o modelo de **Holt-Winters** para fazer uma análise de previsão dos meses seguintes e aparentemente, o número de transações despenca ao longo do tempo, o que parece ser diferente do modelo ARIMA, que veremos a seguir.

<img src="https://i.imgur.com/oS4fihB.png" width="500"/>

Já para esse caso do modelo ARIMA, foi feito o teste de Dickey-Fuller, onde o p-valor foi menor que 0.05. Isso constatou que a série é estacionária e seasonal = TRUE. Então, ele foi aplicado diretamente sem recorrer a outros métodos.

<img src = "https://i.imgur.com/6bNoZtb.png" width = "500"/> 

Foi feito um summary() do modelo para avaliar os valores de RMSE e MAE e após comparar entre o modelo ARIMA e o modelo Holt-Winters. No fim, os dois modelos pareciam ser eficazes.

<img src = "https://i.imgur.com/40dSqxr.png" width = "500"/>

**A análise** dos erros foi feita abaixo, entre um modelo e outro.

1. Modelo de ARIMA

   <img src = "https://i.imgur.com/EboDvgv.png" width = "500"/>
   <img src = "https://i.imgur.com/470Ls1d.png" width = "500"/>
   <img src = "https://i.imgur.com/lOP166B.png" width = "500"/>

3. Modelo de Holt-Winters

   <img src = "https://i.imgur.com/yiteCWL.png" width = "500"/>
   <img src = "https://i.imgur.com/S0iGraj.png" width = "500"/>
   <img src = "https://i.imgur.com/IFKi5TH.png" width = "500"/>

O modelo ARIMA parece ser mais eficaz devido ao fato de ter um erro quadrático menor e resíduos mais consistentes com ruído branco. Porém, o *U de Theil* ou *coeficiente de incerteza* do modelo de Holt-Winters parece estar próximo do valor de *0.61*, o que significa que o modelo já é melhor que um ingênuo e pode ser preferível também. É visto que o *U de Theil* pode ser calculado através da forma:

![image](https://github.com/user-attachments/assets/385f9cb2-54b6-4e58-bb19-15567d497482)

E, se caso *U <= 1* (menor ou igual a 1), o modelo se diz ser "melhor do que advinhar". Caso o contrário, o modelo não é eficaz.
Com isso, foi previsto que o número de transações ao longo do tempo é um pouco randômico nesse caso, devido a alta variabilidade. Acredito que nesse contexto, seria muito útil utilizar algum tratamento *"bayesiano"* futuramente, como o **Bayesian Structural Time Series (BSTS)** ou **Dynamic Linear Models (DLMs)**.
