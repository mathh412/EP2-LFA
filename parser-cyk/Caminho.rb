class CYKParser
  def avisos(verificacao, entrada, era_pra_ser)
    puts era_pra_ser
    puts "e foi"
    if verificacao
      puts "Aceito"
      resultado = reconstruir(0, entrada.length - 1, @gramatica.simbolo_inicial, entrada)
      puts resultado.inspect
      resultado
    else
      puts "Não aceito"
      ponto = identificar_ponto_falha(entrada.length)
      marcador = entrada.dup
      marcador.insert(ponto, " [!] ")
      msg = "Falha: #{marcador}"
      puts msg
      msg
    end
  end
 
  private
 
  # Reconstrói a árvore de derivação a partir da tabela CYK.
  #
  # Convenção de saída:
  #   Terminal           → Integer (se número) ou String
  #   Nó interno binário → [label, operando_esquerdo, operando_direito]
  #
  # Exemplo: 4+5*2  →  ["soma", 4, ["multiplicacao", 5, 2]]
  def reconstruir(i, j, simbolo, entrada)
    # Caso base: célula diagonal = terminal
    if i == j
      token = entrada[i]
      return token.match?(/\A\d\z/) ? token.to_i : token
    end
 
    @gramatica.regras.each do |regra|
      next if regra.esquerda != simbolo
      next if regra.direita.length < 2
 
      b = regra.direita[0]
      c = regra.direita[1]
 
      (i...j).each do |k|
        next unless @tabela[i][k].include?(b) && @tabela[k + 1][j].include?(c)
 
        # Nós de passagem X1/X2/X3: carregam [label, operando_dir] para o pai montar
        if ["X1", "X2", "X3"].include?(simbolo)
          label    = traduzir_operador(b)
          operando = reconstruir(k + 1, j, c, entrada)
          return [label, operando]
        end
 
        # Qualquer símbolo com X1/X2/X3 no lado direito: pai -> esq Xn
        # Xn devolve [label, op_dir]; monta [label, esq, op_dir]
        if ["X1", "X2", "X3"].include?(c)
          esq           = reconstruir(i, k, b, entrada)
          par           = reconstruir(k + 1, j, c, entrada)
          label, op_dir = par[0], par[1]
          return [label, esq, op_dir]
        end
 
        # Parênteses: qualquer símbolo com Cpe X4
        # X4 -> E Cpd; descarta '(' e ')' e retorna só o E interno
        if b == "Cpe" && c == "X4"
          inner = reconstruir_inner_parenteses(k + 1, j, entrada)
          return ["parenteses", inner]
        end
 
        # Negativação: qualquer símbolo com Csub U
        if b == "Csub" && c == "U"
          operando = reconstruir(k + 1, j, c, entrada)
          return ["negativacao", operando]
        end
 
        # Números multi-dígito: N -> N D
        if ["N", "D", "U"].include?(simbolo)
          esq = reconstruir(i, k, b, entrada)
          dir = reconstruir(k + 1, j, c, entrada)
          return "#{esq}#{dir}".to_i
        end
 
        # Caso genérico
        esq = reconstruir(i, k, b, entrada)
        dir = reconstruir(k + 1, j, c, entrada)
        return [simbolo, esq, dir]
      end
    end
 
    entrada[i..j]
  end
 
  # Desce em X4 (E Cpd) e retorna apenas o E interno, descartando o ')'
  def reconstruir_inner_parenteses(i, j, entrada)
    @gramatica.regras.each do |regra|
      next if regra.esquerda != "X4"
      next if regra.direita.length < 2
 
      b = regra.direita[0]  # E
      c = regra.direita[1]  # Cpd
 
      (i...j).each do |k|
        next unless @tabela[i][k].include?(b) && @tabela[k + 1][j].include?(c)
        return reconstruir(i, k, b, entrada)
      end
    end
    entrada[i..j]
  end
 
  # Mapeia símbolo do operador → nome da operação
  def traduzir_operador(simbolo)
    case simbolo
    when "Csoma" then "soma"
    when "Csub"  then "subtracao"
    when "Cmult" then "multiplicacao"
    when "Cdiv"  then "divisao"
    when "Cexp"  then "potencia"
    else simbolo
    end
  end
 
  def identificar_ponto_falha(n)
    alcance = 0
    (0...n).each do |fim|
      if @tabela[0][fim].any? { |s| ["E", "T", "F", "P", "U", "N"].include?(s) }
        alcance = fim + 1
      end
    end
    alcance
  end
end