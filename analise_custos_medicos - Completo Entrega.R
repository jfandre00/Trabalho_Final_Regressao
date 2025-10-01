# -------------------------------------------------------------------
# PROJETO FINAL: MODELO DE REGRESSÃO LINEAR
# GRUPO INFNET "R"
# Data: 30/09/2025
# Descrição: Análise dos fatores que influenciam os custos médicos.
# -------------------------------------------------------------------

# 1ª ETAPA: CONFIGURAÇÃO DO AMBIENTE
# ----------------------------------

# Instalar pacotes (quem ainda não tiver)
#install.packages("tidyverse")
#install.packages("corrplot")
#install.packages("plotly")

# Carregar os pacotes que vamos utilizar
library(tidyverse)
library(corrplot)
library(plotly)


# 2ª ETAPA: CARGA E VERIFICAÇÃO DOS DADOS
# --------------------------------------

# Carregar o dataset a partir da pasta do projeto.
# Como o arquivo está na subpasta 'data', o caminho é "data/insurance.csv".
dados <- read.csv("data/insurance.csv")

# Verificar se os dados foram carregados corretamente
head(dados)  # 6 primeiras linhas
str(dados)   # Estrutura do dataset

# PASSO 3: LIMPEZA E PREPARAÇÃO
# -----------------------------

# A função 'str()' nos mostrou que sex, smoker e region são 'chr'.
# Vamos convertê-los para o tipo 'factor', que é o tipo correto para
# variáveis categóricas no R.
dados <- dados %>%
  mutate(
    sex = as.factor(sex),
    smoker = as.factor(smoker),
    region = as.factor(region)
  )

# Vamos verificar a estrutura novamente para confirmar a mudança.
# Agora você verá 'Factor' ao lado dessas variáveis.
str(dados)

# Verificar se há valores ausentes (NA) no dataset.
# Este comando soma os NAs por coluna.
colSums(is.na(dados))
# Resultado: Zero para todos. Ótimo, nosso dataset é limpo!

# PASSO 4: ANÁLISE EXPLORATÓRIA
# -----------------------------

# a) Análise da Variável Dependente (Charges)
# Vamos criar um histograma para ver a distribuição dos custos.
ggplot(dados, aes(x = charges)) +
  geom_histogram(aes(y = ..density..), fill = "skyblue", color = "white", bins = 30) +
  geom_density(col = "red", size = 1) +
  labs(
    title = "Distribuição dos Custos Médicos (Charges)",
    x = "Custos ($)",
    y = "Densidade"
  ) +
  theme_minimal()

# b) Visualizando a transformação logarítmica
ggplot(dados, aes(x = log(charges))) +
  geom_histogram(aes(y = ..density..), fill = "lightgreen", color = "white", bins = 30) +
  geom_density(col = "darkgreen", size = 1) +
  labs(
    title = "Distribuição dos Custos Médicos (Escala Logarítmica)",
    x = "Log(Custos)",
    y = "Densidade"
  ) +
  theme_minimal()

# c) Relação de Charges com Preditores Categóricos

# Charges vs. Smoker
ggplot(dados, aes(x = smoker, y = charges, fill = smoker)) +
  geom_boxplot(show.legend = FALSE) +
  labs(
    title = "Custos Médicos: Fumantes vs. Não Fumantes",
    x = "É Fumante?",
    y = "Custos ($)"
  ) +
  scale_y_continuous(labels = scales::dollar) + # Formata o eixo Y para dólar
  theme_minimal()

# d) Relação de Charges com Preditores Quantitativos

# Charges vs. Age (colorindo por smoker para mais insights)
ggplot(dados, aes(x = age, y = charges)) +
  geom_point(aes(color = smoker), alpha = 0.7) +
  labs(
    title = "Custo Médico vs. Idade",
    subtitle = "Colorido por status de fumante",
    x = "Idade",
    y = "Custos ($)"
  ) +
  theme_minimal()

#charges vs BMI (colorido por smoker)
ggplot(dados, aes(x = bmi, y = charges)) +
  geom_point(aes(color = smoker), alpha = 0.7) +
  labs(
    title = "Custo Médico vs. IMC",
    subtitle = "Colorido por status de fumante",
    x = "IMC",
    y = "Custos ($)"
  ) +
  theme_minimal()

# PASSO 5: MODELAGEM - CONSTRUÇÃO DO MODELO
# ------------------------------------------

# Vamos construir nosso primeiro modelo usando os preditores que a Análise
# Exploratória sugeriu serem os mais importantes.
# Nossa variável dependente será log(charges) para satisfazer os pressupostos do modelo.

modelo_1 <- lm(log(charges) ~ age + bmi + smoker, data = dados)

# A função summary() nos dá um relatório completo sobre o nosso modelo.
# Este é o output mais importante de toda a sua análise!
summary(modelo_1)

# PASSO 6: DIAGNÓSTICO DO MODELO
# -------------------------------

# A função plot() aplicada a um objeto 'lm' gera 4 gráficos de diagnóstico.
# Usamos par(mfrow = c(2, 2)) para arranjar os 4 gráficos em uma grade 2x2.

par(mfrow = c(2, 2))
plot(modelo_1)

# É uma boa prática resetar o layout gráfico para o padrão depois.
par(mfrow = c(1, 1))

# ------------------------------------------------------------
# ENTENDENDO O COMPORTAMENTO DOS FUMANTES
# Analisando a diferença de custos para fumantes

fumantes <- subset(dados, smoker == "yes")

ggplot(fumantes, aes(x = age, y = bmi, color = charges)) +
  geom_point(alpha = 0.8, size = 3) +
  scale_color_gradient(low = "green", high = "red", labels = scales::dollar) +
  labs(
    title = "Relação entre Idade, IMC e Custos",
    x = "Idade",
    y = "Índice de Massa Corporal (IMC)",
    color = "Custos" # Título da legenda de cores
  ) +
  theme_minimal() + theme(plot.title = element_text(hjust = 0.5))

plot_ly(data = fumantes,
        x = ~age,
        y = ~bmi,
        z = ~charges,
        type = 'scatter3d',
        mode = 'markers',
        marker = list(color = ~charges, colorscale = 'Viridis', showscale = TRUE)) %>%
  layout(title = "Custos vs. Idade e IMC em 3D")

# Nova Análise

fumantes <- fumantes %>%
  mutate(
    is_obese = ifelse(bmi >= 30, 1, 0)
  )

fumantes_nao_obesos <- subset(fumantes, is_obese == 0)

modelo_2 <- lm(log(charges) ~ bmi + age, data = fumantes_nao_obesos)
summary(modelo_2)

par(mfrow = c(2, 2))
plot(modelo_2)
par(mfrow = c(1, 1))

fumantes_obesos <- subset(fumantes, is_obese == 1)

modelo_2 <- lm(log(charges) ~ bmi + age, data = fumantes_obesos)
summary(modelo_2)

par(mfrow = c(2, 2))
plot(modelo_2)
par(mfrow = c(1, 1))

# Modelo Final
# -----------------------------------------

modelo_2 <- lm(log(charges) ~ (age + bmi) * is_obese, data = fumantes)

summary(modelo_2)

par(mfrow = c(2, 2))
plot(modelo_2)
par(mfrow = c(1, 1))

# 5ª ETAPA: SEGUNDA ANÁLISE
# LIMPEZA E PREPARAÇÃO

dados_pt <- dados %>%
  rename(
    idade = age,
    sexo = sex,
    imc = bmi,
    filhos = children,
    fumante = smoker,
    regiao = region,
    custos = charges
  ) %>%
  mutate(
    eh_fumante = ifelse(fumante == "yes", 1, 0),
    sexo_masculino = ifelse(sexo == "male", 1, 0),
    regiao_norte = ifelse(grepl("north", regiao), 1, 0),
    regiao_leste = ifelse(grepl("east", regiao), 1, 0)
  )
dados_pt <- dados_pt %>%
  select_if(is.numeric)
head(dados_pt)
# Renomeia colunas para melhor organização e identificação de
# seus dados e ajusta as variáveis para o formato numérico.

#ANÁLISE EXPLORATÓRIA - ÊNFASE EM NÃO FUMANTES
# a) Análise Descritiva dos Dados

# A Média de 'charges' ($13.2k) é bem maior que a Mediana ($9.3k),
# indicando que custos muito altos de poucas pessoas influenciam o total.
# A base é bem balanceada em sexo e região, mas com muito mais não-fumantes.
summary(dados_pt)

# b) Análise da Distribuição do IMC
# Boxplot para analisar a mediana, dispersão e outliers do IMC.

ggplot(dados_pt, aes(y = imc)) +
  geom_boxplot(fill = "orange") +
  labs(title = "Distribuição do IMC", y = "Índice de Massa Corporal (IMC)") +
  theme_minimal()

# Visualizando um boxplot que distribui a mediana do IMC das pessoas, é possível identificar algumas discrepâncias com
# IMC muito alto, ou seja, outliers. Essas pessoas podem de fato possuir esse IMC, portanto, não serão desconsideradas.
# Isso pode apontar para o fato de que algumas pessoas podem ter custos médicos altos não em decorrência do cigarro, mas talvez
# da obesidade, podendo possuir esse fato correlação com o hábito de fumar ou não.


# c) Matriz de Correlação (Não Fumantes)
# Análise das relações lineares para o subgrupo de não fumantes.

nao_fumantes <- subset(dados_pt, eh_fumante == 0) %>% select(-eh_fumante)

matriz_cor <- cor(nao_fumantes)
corrplot(matriz_cor, method = "number", type = "upper")

# A correlação mostra que o IMC tende a ser maior nas regiões sul e leste.
# Entre não fumantes, a idade domina e o impacto do IMC é mínimo,
# sendo menos relevante que o número de filhos.

# d) Análise Gráfica das Relações com Custos

# Gráfico 1: Custo vs. IMC, comparando fumantes e não fumantes.
ggplot(dados, aes(x = bmi, y = charges, color = smoker)) +
  geom_point(alpha = 0.7) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    title = "Custos Médicos vs. IMC",
    subtitle = "Colorido por status de fumante",
    x = "IMC",
    y = "Custos ($)"
  ) +
  theme_minimal()

# Gráfico 2: Custo vs. Número de filhos para não fumantes.
ggplot(nao_fumantes, aes(x = filhos, y = custos)) +
  geom_point(alpha = 0.7,
             fill = "orange",
             color = "black",
             shape = 21, size = 3) +
  geom_smooth(method = "lm",
              se = FALSE,
              linetype = "dotted",
              linewidth = 1.5) +
  labs(
    title = "Custos Médicos x Número de filhos",
    x = "Número de filhos",
    y = "Custos Médicos ($)"
  ) +
  theme_minimal() + theme(plot.title = element_text(hjust = 0.5))


# Gráfico 3: Comparação de Custos Médicos: Norte vs. Sul
ggplot(dados_pt, aes(x = factor(regiao_norte),
                     y = custos,
                     fill = factor(regiao_norte))) +
  geom_boxplot(show.legend = FALSE) +
  scale_x_discrete(labels = c("0" = "Sul", "1" = "Norte")) +
  scale_fill_manual(values = c("0" = "skyblue", "1" = "orange")) +
  labs(
    title = "Comparação de Custos Médicos: Norte vs. Sul",
    x = "Região",
    y = "Custos Médicos ($)"
  ) +
  theme_minimal()

# MODELAGEM - CONSTRUÇÃO DO MODELO

# Criação do modelo para não fumantes com base na análise exploratória.

modelo_nao_fumantes <- lm(log(custos) ~ idade + filhos + regiao_norte + I(idade^2), data = nao_fumantes)

# Análise dos coeficientes e performance do modelo.
summary(modelo_nao_fumantes)

# O modelo para não fumantes é estatisticamente significativo (valor-p < 0.05)
# e explica 68.7% da variabilidade dos custos.
# Os custos crescem com o número de filhos e são maiores na região Norte.
# A idade tem um efeito curvo: os custos aumentam com a idade,
# porém de forma cada vez mais lenta.

# DIAGNÓSTICO DO MODELO

par(mfrow = c(2, 2))
plot(modelo_nao_fumantes)
par(mfrow = c(1, 1))

# A linha de tendência bastante proxima de zero confirma a homocedasticidade do modelo.
# O gráfico Q-Q mostra que a distribuição dos resíduos não é perfeitamente normal, apresentando uma assimetria à direita
# causada por outliers (pacientes com custos muito altos) que o modelo não consegue prever adequadamente.
# Apesar disso, esses outliers não afetam o modelo de maneira significativa, pois nenhum ponto ultrapassa a distância de Cook.