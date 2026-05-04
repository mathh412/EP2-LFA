require_relative 'gramatica'
 
class CYKParser
  attr_reader :tabela, :gramatica
 
  def initialize(gramatica)
    @gramatica = gramatica
  end
 
  def parse(entrada)
    # Exemplo. Quero reconhecer uma L = {a^n b^n | n >= 1}
    # Gramática na forma normal de Chomsky:
    # 
    # S -> AB | AC
    # A -> a
    # B -> b
    # C -> SB
    
    n = entrada.length
    @tabela = Array.new(n) { Array.new(n) { [] } }
 
    @tabela.each_with_index do |coluna, index|
      (0..index-1).each do |i|
        @tabela[index][i] << "⚫️"
      end
    end
    
    ##########################################
    # Exemplo: entrada = "aabb"
    # 
    #  Tabela Inicializada (4x4):
    #  _______________________________________
    #  | a |   |   |   |
    #  | ⚫️ | a |   |   |
    #  | ⚫️ | ⚫️ | b |   |  
    #  | ⚫️ | ⚫️ | ⚫️ | b |
    #
 
    # Passo 1: Analiza os símbolos terminais
    # e adiciona seus não-terminais geradores A->a
    adiciona_terminais(entrada)
 
    ##########################################
    #  Tabela: 
    #  _______________________________________
    #  | [A] |     |     |     |
    #  |     | [A] |     |     |
    #  |     |     | [B] |     |  
    #  |     |     |     | [B] |
    #
 
    # Passo 2: subir na tabela pelas regras
    # com não-terminais A->BC
    adiciona_nao_terminais(entrada)
 
    tabela
  end
 
  def aceito?
    # verifica se o símbolo inicial está 
    # na última linha e primeira coluna da tabela
    tabela[0][-1].include?(gramatica.simbolo_inicial)
  end
 
  private
 
  def adiciona_terminais(entrada)
    lista_simbolos = Array.new(entrada.length) { [] }
    lista_simbolos_entrada = entrada.split('')
 
    lista_simbolos_entrada.each_with_index do |simbolo, i|
      @gramatica.regras.each do |regra|
        # verifica se a regra é terminal
        if terminal?(regra.direita, simbolo)
          tabela[i][i] << regra.esquerda
          lista_simbolos[i] << regra.esquerda
        end
      end
    end
 
    imprime_tabela(tabela)
  end
 
  def adiciona_nao_terminais(entrada)
    n = entrada.length
    regras_aceitas = ""
    
    for largura in 1...n
      for inicio in 0...(n - largura)
        fim = inicio + largura
        (inicio...fim).each do |meio|
          @gramatica.regras.each do |regra|
            # verifica se a regra é não-terminal
            if match_de_nao_terminais?(inicio, meio, fim, regra)
              tabela[inicio][fim] << regra.esquerda
              imprime_tabela(tabela)
              regras_aceitas << "Passo #{largura}: Regra aceita: #{regra}\n"
              puts regras_aceitas
            end
          end
        end
      end
    end
  end
 
  def match_de_nao_terminais?(inicio, meio, fim, regra)
    # simbolo terminal
    return false if regra.direita.length < 2 
 
    # A -> BC 
    # primeira_direita = B
    # segunda_direita = C
    primeira_direita = regra.direita[0]
    segunda_direita = regra.direita[1]
 
    tabela[inicio][meio].include?(primeira_direita) &&
      tabela[meio + 1][fim].include?(segunda_direita)
  end
 
  def terminal?(direita, simbolo_lido)
    direita.length == 1 && direita[0] == simbolo_lido
  end
 
  def imprime_tabela(tabela)
    system "clear"
    puts @gramatica
    puts "\n"
    
    tabela.each do |coluna|
      print "| " 
      coluna.each do |celula|
        print celula.join(",").center(3)
        print " | "
      end
      puts ""
    end
  end
end