# -------------------------------------------------------------------
# PROJETO FINAL: MODELO DE REGRESSÃO LINEAR
# GRUPO INFNET "R"
# Data: 08/09/2025
# Descrição: Análise dos fatores que influenciam os custos médicos.
# -------------------------------------------------------------------

# 1ª ETAPA: CONFIGURAÇÃO DO AMBIENTE
# ----------------------------------

# Instalar pacotes (quem ainda não tiver)
#install.packages("tidyverse")
#install.packages("corrplot")

# Carregar os pacotes que vamos utilizar
library(tidyverse)
library(corrplot)


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
