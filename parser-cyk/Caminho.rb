class CYKParser
  def avisos(verificacao, entrada, era_pra_ser)
    puts "---"
    puts "Entrada: #{entrada}"
    puts "Esperado: #{era_pra_ser}"
    
    if verificacao
      puts "Status: Aceito"
      resultado = reconstruir(0, entrada.length - 1, @gramatica.simbolo_inicial, entrada)
      puts "Caminho:"
      p resultado
      resultado
    else
      puts "Status: Não aceito"
      ponto = identificar_ponto_falha(entrada.length)
      marcador = entrada.dup
      marcador.insert(ponto, " [!] ")
      msg = "Falha: #{marcador}"
      puts msg
      msg
    end
  end
 
  private
 
  def reconstruir(i, j, simbolo, entrada)
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
 
        if ["X1", "X2", "X3"].include?(simbolo)
          label    = traduzir_operador(b)
          operando = reconstruir(k + 1, j, c, entrada)
          return [label, operando]
        end
 
        if ["X1", "X2", "X3"].include?(c)
          esq           = reconstruir(i, k, b, entrada)
          par           = reconstruir(k + 1, j, c, entrada)
          label, op_dir = par[0], par[1]
          return [label, esq, op_dir]
        end
 
        if b == "Cpe" && c == "X4"
          return reconstruir_inner_parenteses(k + 1, j, entrada)
        end
 
        if b == "Csub" && c == "U"
          operando = reconstruir(k + 1, j, c, entrada)
          return ["negativacao", operando]
        end
 
        if b == "N" && c == "D"
          esq = reconstruir(i, k, b, entrada)
          dir = reconstruir(k + 1, j, c, entrada)
          return "#{esq}#{dir}".to_i
        end
 
        esq = reconstruir(i, k, b, entrada)
        dir = reconstruir(k + 1, j, c, entrada)
        return [simbolo, esq, dir]
      end
    end
 
    entrada[i..j]
  end
 
  def reconstruir_inner_parenteses(i, j, entrada)
    @gramatica.regras.each do |regra|
      next if regra.esquerda != "X4"
      next if regra.direita.length < 2
 
      b = regra.direita[0]
      c = regra.direita[1]
 
      (i...j).each do |k|
        next unless @tabela[i][k].include?(b) && @tabela[k + 1][j].include?(c)
        return reconstruir(i, k, b, entrada)
      end
    end
    entrada[i..j]
  end
 
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