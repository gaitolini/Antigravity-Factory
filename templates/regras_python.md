# Padrões de Desenvolvimento Python (Clean Code)

Este documento define as regras e diretrizes que orientam os agentes de IA na criação e modificação de código Python neste repositório.

## 1. Estilo de Código e Formatação

### 1.1. Conformidade com a PEP 8
* **Formatação Automática**: Siga estritamente os padrões da **PEP 8**. Use ferramentas como `black`, `ruff` ou `blue` para formatação.
* **Linhas de Código**: Limite todas as linhas a no máximo **88 ou 120 caracteres** (padrão de ferramentas modernas).
* **Nomenclatura**:
  - Funções, Métodos e Variáveis: `snake_case` (ex: `calcular_imposto`).
  - Classes: `PascalCase` (ex: `CalculadoraImposto`).
  - Constantes: `UPPER_SNAKE_CASE` (ex: `TAXA_PADRAO`).

### 1.2. Tipagem Estática (Type Hints)
* **Uso Obrigatório**: Sempre defina a tipagem de argumentos e retornos de funções.
* **Exemplo**:
  ```python
  def processar_pagamento(valor: float, cliente_id: int) -> bool:
      # Lógica aqui
      return True
  ```

---

## 2. Gerenciamento de Dependências e Ambiente

* **Virtual Environment (`.venv`)**:
  - Sempre verifique se o ambiente virtual está configurado e ativo.
  - Adicione a pasta `.venv/`, `__pycache__/` e `.pytest_cache/` ao arquivo `.gitignore`.
* **Gerenciadores de Pacote**:
  - Em projetos simples, mantenha o `requirements.txt` atualizado.
  - Em projetos modernos, prefira `pyproject.toml` (usando `poetry` ou `uv` para resolução rápida de dependências).

---

## 3. Estrutura e Práticas Recomendadas

### 3.1. Tratamento de Erros e Logs
* Nunca use cláusulas `except:` genéricas sem capturar ou registrar a exceção.
* **Exemplo Correto**:
  ```python
  import logging

  logger = logging.getLogger(__name__)

  try:
      resultado = 10 / 0
  except ZeroDivisionError as e:
      logger.error("Erro ao dividir por zero: %s", e)
  ```

### 3.2. Configurações de Ambiente
* Nunca insira chaves de API, senhas de banco de dados ou segredos diretamente no código-fonte.
* Utilize arquivos `.env` para carregar configurações em tempo de execução via bibliotecas como `python-dotenv` ou `pydantic-settings`.
