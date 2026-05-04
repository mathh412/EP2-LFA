class EarleyParser
  def avisos(verificacao, entrada, era_pra_ser)
    puts era_pra_ser 
    puts "e foi "
    if verificacao
      puts "Aceito"
      resultado = reconstruir(gramatica.simbolo_inicial, 0, entrada.length, entrada)
      puts resultado.inspect
    else
      puts "Não aceito"
      ponto = identificar_ponto_falha(entrada)
      marcador = entrada.dup
      marcador.insert(ponto, " [!] ")
      puts "Falha: #{marcador}"
    end
    nil
  end
 
  private
 
  # Reconstrói a árvore de derivação a partir da tabela de Earley.
  #
  # Convenção de saída:
  #   Terminal           → Integer (se número) ou String
  #   Nó interno binário → [label, operando_esquerdo, operando_direito]
  #
  # Exemplo: 4+5*2  →  ["soma", 4, ["multiplicacao", 5, 2]]
  #
  # Busca em @tabela[fim] um estado completo com:
  #   - regra.esquerda == simbolo
  #   - inicio == ini
  # e reconstrói seus filhos recursivamente.
  def reconstruir(simbolo, ini, fim, entrada)
    # Caso base: terminal de um único caractere
    if ini + 1 == fim
      token = entrada[ini]
      return token.match?(/\A\d\z/) ? token.to_i : token
    end
 
    # Busca estado completo que deriva 'simbolo' de ini até fim
    estado = @tabela[fim].estados.find do |e|
      e.regra.esquerda == simbolo &&
      e.completo?                 &&
      e.inicio == ini             &&
      e.regra.direita.length > 1  # ignora regra artificial S->S
    end
 
    # Tenta também regra unitária (length == 1) se não achou binária
    estado ||= @tabela[fim].estados.find do |e|
      e.regra.esquerda == simbolo &&
      e.completo?                 &&
      e.inicio == ini
    end
 
    return entrada[ini...fim] unless estado
 
    filhos = reconstruir_filhos(estado.regra.direita, ini, fim, entrada)
    traduzir(simbolo, estado.regra.direita, filhos)
  end
 
  # Dado um array de símbolos de uma regra e o intervalo [ini, fim),
  # encontra a partição correta e reconstrói cada filho.
  def reconstruir_filhos(direita, ini, fim, entrada)
    return [] if direita.empty?
 
    # Caso base: símbolo único
    if direita.length == 1
      sym = direita[0]
      if terminal_da_gramatica?(sym)
        token = entrada[ini]
        return [token.match?(/\A\d\z/) ? token.to_i : token]
      else
        return [reconstruir(sym, ini, fim, entrada)]
      end
    end
 
    # Tenta cada ponto de corte para dividir os primeiros (length-1) símbolos
    # do último símbolo
    prefixo = direita[0...-1]
    ultimo  = direita[-1]
 
    (ini...fim).each do |meio|
      # Verifica se o prefixo cobre [ini, meio) e o último cobre [meio, fim)
      next unless prefixo_valido?(prefixo, ini, meio, entrada) &&
                  simbolo_cobre?(ultimo, meio, fim, entrada)
 
      filhos_prefixo = reconstruir_filhos(prefixo, ini, meio, entrada)
      filho_ultimo   = reconstruir_simbolo(ultimo, meio, fim, entrada)
 
      return filhos_prefixo + [filho_ultimo] if filhos_prefixo
    end
 
    []
  end
 
  # Verifica se a sequência de símbolos 'prefixo' pode cobrir [ini, meio)
  def prefixo_valido?(prefixo, ini, meio, entrada)
    return ini == meio if prefixo.empty?
 
    if prefixo.length == 1
      return simbolo_cobre?(prefixo[0], ini, meio, entrada)
    end
 
    sub_prefixo = prefixo[0...-1]
    ultimo      = prefixo[-1]
 
    (ini...meio).any? do |k|
      prefixo_valido?(sub_prefixo, ini, k, entrada) &&
      simbolo_cobre?(ultimo, k, meio, entrada)
    end
  end
 
  # Verifica se o símbolo 'sym' pode cobrir o intervalo [ini, fim)
  def simbolo_cobre?(sym, ini, fim, entrada)
    if terminal_da_gramatica?(sym)
      fim == ini + 1 && entrada[ini] == sym
    else
      @tabela[fim].estados.any? do |e|
        e.regra.esquerda == sym && e.completo? && e.inicio == ini
      end
    end
  end
 
  # Reconstrói um único símbolo no intervalo [ini, fim)
  def reconstruir_simbolo(sym, ini, fim, entrada)
    if terminal_da_gramatica?(sym)
      token = entrada[ini]
      token.match?(/\A\d\z/) ? token.to_i : token
    else
      reconstruir(sym, ini, fim, entrada)
    end
  end
 
  # Um símbolo é terminal se não aparece como esquerda de nenhuma regra
  def terminal_da_gramatica?(sym)
    @gramatica.regras.none? { |r| r.esquerda == sym }
  end
 
  # Traduz os filhos para o formato [label, esq, dir] conforme a gramática
  def traduzir(simbolo, direita, filhos)
    case simbolo
    when "E"
      return [filhos[1] == "+" ? "soma" : "subtracao", filhos[0], filhos[2]] if filhos.length == 3
      filhos.length == 1 ? filhos[0] : filhos
 
    when "T"
      return [filhos[1] == "*" ? "multiplicacao" : "divisao", filhos[0], filhos[2]] if filhos.length == 3
      filhos.length == 1 ? filhos[0] : filhos
 
    when "F"
      return ["potencia", filhos[0], filhos[2]] if filhos.length == 3
      filhos.length == 1 ? filhos[0] : filhos
 
    when "P"
      return ["negativacao", filhos[1]] if filhos.length == 2 && filhos[0] == "-"
      filhos.length == 1 ? filhos[0] : filhos
 
    when "U"
      return ["parenteses", filhos[1]] if filhos.length == 3
      filhos.length == 1 ? filhos[0] : filhos
 
    when "N"
      return "#{filhos[0]}#{filhos[1]}".to_i if filhos.length == 2
      filhos.length == 1 ? filhos[0] : filhos
 
    when "D"
      filhos[0].is_a?(Integer) ? filhos[0] : filhos[0].to_i
 
    else
      filhos.length == 1 ? filhos[0] : filhos
    end
  end
 
  def identificar_ponto_falha(entrada)
    alcance = 0
    (0...entrada.length).each do |i|
      if @tabela[i + 1].estados.any? { |e| ["E", "T", "F", "P", "U", "N"].include?(e.regra.esquerda) && e.completo? && e.inicio == 0 }
        alcance = i + 1
      end
    end
    alcance
  end
end
 