# EP2 LFA - Reconhecedor Sintático de Expressões Matemáticas
**Colaboradores:** Matheus Henrique Lima Batista, Paula Martins, Eric Donato

Este repositório contém a solução para o Exercício Programa 2 da disciplina de Linguagens Formais e Autômatos (LFA). O objetivo deste projeto é implementar analisadores sintáticos (Parsers) baseados em Gramáticas Livres de Contexto (GLC) capazes de reconhecer expressões matemáticas, validá-las e gerar a estrutura de árvore (AST) em formato de *array* aninhado.

⚠️ **Nota Técnica:** Conforme especificado no enunciado, este reconhecedor foca apenas na validação sintática e estruturação da árvore de operações. Ele **não** resolve (calcula) a expressão matemática (etapa correspondente à disciplina de Compiladores).

## 📜 Gramáticas Utilizadas

O projeto faz uso de duas gramáticas distintas para atender aos requisitos de cada algoritmo de parsing implementado. As árvores de expansão visuais para a expressão teste `9^(1*-2+3)-3/(6+3)` estão documentadas no arquivo de entrega oficial do projeto (`EP2 LFA.docx`).

### 1. Gramática Livre de Contexto (Sem Forma Normal)
Utilizada pelo **Parser de Earley**, esta gramática respeita a precedência e associatividade natural das operações matemáticas[cite: 24]:

```text
E -> E + T | E - T | T
T -> T * F | T / F | F
F -> P ^ F | P
P -> - U | U
U -> ( E ) | N
N -> N D | D
D -> 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
````
### 2. Gramática na Forma Normal de Chomsky (FNC)

Utilizada pelo **Parser CYK**, a gramática foi convertida para garantir que todas as regras gerem exatamente dois não-terminais ou um terminal:

```text
E -> E X1 | T X2 | P X3 | Csub U | Cpe X4 | N D | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
T -> T X2 | P X3 | Csub U | Cpe X4 | N D | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
F -> P X3 | Csub U | Cpe X4 | N D | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
P -> Csub U | Cpe X4 | N D | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
U -> Cpe X4 | N D | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
N -> N D | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
D -> 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9

X1 -> Csoma T | Csub T
X2 -> Cmult F | Cdiv F
X3 -> CExp F
X4 -> E Cpd

Csoma -> +
Csub  -> -
Cmult -> *
Cdiv  -> /
CExp  -> ^
Cpe   -> (
Cpd   -> )
```
## 🧠 Arquitetura: Dois Parsers Implementados

Para garantir robustez e explorar os conceitos da disciplina, o projeto entrega **dois reconhecedores distintos**:

1. **Parser de Earley (`early.rb`):**
   * Utiliza a gramática na sua forma natural.
   * Lida perfeitamente com recursão à esquerda sem entrar em loop.
   * Renderiza tabelas visuais no terminal mostrando os passos de *Predict*, *Scan* e *Complete*.

2. **Parser CYK (`cyk.rb`):**
   * Algoritmo *bottom-up* de complexidade $O(n^3)$.
   * Requer a gramática na **Forma Normal de Chomsky (FNC)**.
   * A lógica de reconstrução de caminho (`Caminho.rb`) reverte as variáveis auxiliares da FNC (como `X1`, `X2`) para as operações originais legíveis.

## 🚀 Funcionalidades e Operações Suportadas

O reconhecedor suporta números numéricos, respeita regras rígidas de precedência e associatividade, e mapeia a estrutura para os seguintes retornos na árvore:

| Operação      | Tipo    | Exemplo | Retorno na Árvore |
| :---          | :---    | :---    | :---              |
| Número        | Unário  | `10`    | `10`              |
| Negativação   | Unário  | `-1`    | `["negativacao", 1]` |
| Parênteses    | Unário  | `(3)`   | `3` *(O valor interno)* |
| Potência      | Binário | `2^2`   | `["potencia", 2, 2]` |
| Soma          | Binário | `1 + 1` | `["soma", 1, 1]` |
| Subtração     | Binário | `3 - 1` | `["subtracao", 3, 1]`|
| Multiplicação | Binário | `2 * 2` | `["multiplicacao", 2, 2]`|
| Divisão       | Binário | `4 / 2` | `["divisao", 4, 2]` |

## ⚙️ Como executar

### Instalação de dependências
O projeto utiliza o Ruby. Para instalar as gems necessárias de visualização (como o `tty-table`), execute:
```bash
bundle install
```
### Execução

Para rodar os analisadores contra a bateria de testes, execute:

```bash
ruby main.rb
```
## 🧪 Comportamento e Testes

O projeto cumpre o requisito de gerar saídas padronizadas. O algoritmo reconstrói a árvore de derivação e gera as mensagens adequadas para expressões válidas e inválidas.

### Casos de Sucesso (Expressões Válidas)

O parser identifica a expressão como aceita e gera o array descritivo da AST:

**Entrada:** `4+5*2`

```ruby
Status: Aceito
Caminho:
["soma", 4, ["multiplicacao", 5, 2]]
```
### Casos de Falha (Expressões Inválidas)

Quando a expressão viola as regras da gramática, o sistema emite `"Não aceito"` e aponta com o marcador `[!]` onde a validação sintática travou:

**Entrada:** `9 * 2 +`

```ruby
Status: Não aceito
Falha: 9*2 [!] +
```

---
**Linguagens Formais e Autômatos**
