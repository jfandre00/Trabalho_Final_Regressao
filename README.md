# 🩺 Análise Preditiva de Custos de Seguro de Saúde  

![Linguagem](https://img.shields.io/badge/Linguagem-R-blue.svg)  
![Licença](https://img.shields.io/badge/Licença-MIT-green.svg)  

Este repositório contém o **trabalho final da disciplina Introdução à Ciência de Dados com R**.  
O projeto consiste na construção de um **modelo de regressão linear múltipla** para prever os custos de seguro de saúde com base em características demográficas e de estilo de vida dos segurados.  

---

## 📚 Tabela de Conteúdos
- [📖 Contexto do Projeto](#-contexto-do-projeto)
- [🎯 Objetivo](#-objetivo)
- [🗂️ O Dataset](#️-o-dataset)
- [⚙️ Como Executar o Projeto](#️-como-executar-o-projeto)
- [🔎 Metodologia](#-metodologia)
- [📊 Principais Resultados](#-principais-resultados)
- [👨‍💻 Autores](#-autores)

---

## 📖 Contexto do Projeto  
Este trabalho foi desenvolvido como avaliação final para a disciplina **Introdução à Ciência de Dados**.  
O objetivo foi aplicar de forma prática todas as etapas de um projeto de data science, desde a coleta e limpeza dos dados até a modelagem estatística, validação e comunicação dos resultados.  

---

## 🎯 Objetivo  
Desenvolver um **modelo de regressão linear** para identificar e quantificar o impacto de fatores demográficos e de estilo de vida — especificamente **idade**, **Índice de Massa Corporal (IMC)** e **tabagismo** — nos custos médicos individuais faturados por uma seguradora de saúde.  

---

## 🗂️ O Dataset  
O estudo utilizou o conjunto de dados **"Medical Cost Personal Datasets"**, disponível publicamente no Kaggle.  

- **Fonte:** [Kaggle - Medical Cost Personal Datasets](https://www.kaggle.com/datasets/mirichoi0218/insurance)  
- **Observações:** 1.338  
- **Variáveis principais:**  
  - `age`  
  - `sex`  
  - `bmi`  
  - `children`  
  - `smoker`  
  - `region`  
  - `charges` (variável alvo)  

---

## ⚙️ Como Executar o Projeto  

### 1. Pré-requisitos  
- **R** (versão 4.0 ou superior)  
- **RStudio**  

### 2. Instalação  
Clone este repositório para a sua máquina local:  

```bash
git clone https://github.com/jfandre00/Trabalho_Final_Regressao
```

Abra o projeto no **RStudio** clicando em `Trabalho_Final_Regressao.Rproj`.  
Isso irá configurar o diretório de trabalho automaticamente.  

Instale as dependências necessárias executando no console do R:  

```R
install.packages(c("tidyverse", "corrplot"))
```

---

## 🔎 Metodologia  

A análise foi conduzida em **quatro etapas principais**:  

1. **Preparação dos Dados**  
   - Verificação de valores ausentes.  
   - Transformação de variáveis categóricas.  
   - Aplicação de `log()` em `charges` para corrigir a assimetria e atender aos pressupostos do modelo.  

2. **Análise Exploratória de Dados (AED)**  
   - Histogramas, boxplots e gráficos de dispersão (`ggplot2`) para visualizar distribuições e relações entre variáveis.  

3. **Modelagem**  
   - Construção de um modelo de **regressão linear múltipla** com a função `lm()` para prever `log(charges)`.  

4. **Validação do Modelo**  
   - Análise dos resíduos para verificar os pressupostos de **linearidade, normalidade e homocedasticidade**.  

---

## 📊 Principais Resultados  

- O modelo final explicou **75% da variabilidade** nos custos de seguro de saúde  
  (**R² ajustado = 0.7499**).  
- As variáveis **idade**, **IMC** e **tabagismo** foram preditores estatisticamente significantes (p < 0.001).  
- O **tabagismo** foi o fator de maior impacto:  
  - Mantendo idade e IMC constantes, os custos para um fumante são, em média, **4,7 vezes maiores** do que para um não fumante.  

---

## 👨‍💻 Autores  

Este projeto foi desenvolvido por:  

- [Andre Loureiro Montini Ferreira](https://github.com/jfandre00)
- [Lucas Amorim Brusco](https://github.com/zbrusco)    
- [Pedro Conceição Costa](https://github.com/dev-pedr0)    
- [Marcelo De Azevedo Sampaio](https://github.com/marcelosampaio) 
- [Kauan Lima Oliveira](https://github.com/devKauanLima) 

---
