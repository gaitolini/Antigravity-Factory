# Padrões de Desenvolvimento Delphi (Windows-1252 ANSI)

Este documento define as regras e diretrizes que orientam os agentes de IA na criação e modificação de código Delphi neste repositório.

## 1. Padrões de Codificação e Estilo de Código

### 1.1. Codificação de Arquivos (Mandatória)
* **Arquivos do Delphi**: `.pas`, `.dfm`, `.dpr`, `.dproj` e scripts SQL **DEVEM** ser codificados e salvos usando o charset **Windows-1252 (ANSI)**. Isso garante compatibilidade total com IDEs legadas e Delphi 10.3/10.4/12 compilando em sistemas Windows locais.
* **Documentação**: Arquivos `.md` (Markdown), `.txt` ou `.json` criados para IA/agentes **DEVEM** ser salvos em **UTF-8 (Sem BOM)**.

### 1.2. Nomenclatura e Convenções Pascal Case
* **Units**:
  - Formulários / Views: `UFrmNomeForm.pas` (ex: `UFrmVendas.pas`)
  - DataModules: `UDMNomeDM.pas` (ex: `UDMConexao.pas`)
  - Controllers: `UControllerNome.pas` (ex: `UControllerCliente.pas`)
  - Models / Services: `UServiceNome.pas` ou `UClassNome.pas`
* **Componentes Visuais (Prefixos em minúsculo)**:
  - `edt` para TEdit
  - `btn` para TButton / TBitBtn / TSpeedButton
  - `lbl` para TLabel
  - `cb` para TComboBox
  - `chk` para TCheckBox
  - `grid` ou `dbg` para TDBGrid
  - `qry` para TFDQuery / TQuery
  - `ds` para TDataSource

---

## 2. Padrão Arquitetural

* **Separação de Camadas (MVC / MVVM)**:
  - Nenhuma regra de negócio ou lógica complexa deve estar diretamente codificada no evento do clique do botão na View (`TForm`).
  - O Formulário deve apenas disparar chamadas para a camada de controle (`Controller`) ou serviço (`Service`).
* **Gerenciamento de Memória**:
  - Sempre utilize blocos `try..finally` ao criar objetos dinamicamente para evitar vazamentos de memória (Memory Leaks).
  - Exemplo:
    ```pascal
    LController := TControllerCliente.Create;
    try
      LController.Salvar(LCliente);
    finally
      LController.Free;
    end;
    ```

---

## 3. Segurança e Banco de Dados (Firebird 3.0)

### 3.1. Consultas SQL Seguras
* **Uso Obrigatório de Parâmetros**: Nunca concatene strings diretamente em consultas SQL dinâmicas. Use `Params` do FireDAC.
* **Exemplo Correto**:
  ```pascal
  qryConsulta.SQL.Text := 'SELECT * FROM CLIENTE WHERE ID = :ID';
  qryConsulta.ParamByName('ID').AsInteger := LIdCliente;
  qryConsulta.Open;
  ```

### 3.2. Controle de Transações
* Inicie a transação o mais tarde possível e conclua-a (`Commit`) ou aborte-a (`Rollback`) imediatamente no bloco `try..except` correspondente.
* Nunca mantenha transações abertas enquanto exibe caixas de diálogo interativas (`ShowMessage`, `MessageDlg`) para o usuário, para evitar locks no banco de dados.
