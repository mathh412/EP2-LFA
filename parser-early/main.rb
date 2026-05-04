require_relative "early"
require_relative "gramatica"
require_relative "Caminho"

regras = [
  Regra.new('E', %w[E + T]),
  Regra.new('E', %w[E - T]),
  Regra.new('E', %w[T]),
  Regra.new('T', %w[T * T]),
  Regra.new('T', %w[T / F]),
  Regra.new('T', %w[F]),
  
  Regra.new('F', %w[P ^ F]),
  Regra.new('F', %w[P]),

  Regra.new('P', %w[- U]),
  Regra.new('P', %w[U]),

  Regra.new('U', %w[( E )]),
  Regra.new('U', %w[N]),

  Regra.new('N', %w[N D]),
  Regra.new('N', %w[D]),

  Regra.new('D', %w[0]),
  Regra.new('D', %w[1]),
  Regra.new('D', %w[2]),
  Regra.new('D', %w[3]),
  Regra.new('D', %w[4]),
  Regra.new('D', %w[5]),
  Regra.new('D', %w[6]),
  Regra.new('D', %w[7]),
  Regra.new('D', %w[8]),
  Regra.new('D', %w[9]),
]

gramatica = Gramatica.new(regras, "E")

parser = EarleyParser.new(gramatica)

input1 = "(1+4)*2^4"
input2 = "7/(1-3)"
input3 = "9^(1*6/2+4)"
input4 = "2+4^-4/4"

input5 = "^2+4"
input6 = "9*2+"
input7 = "9++3"
input8 = "()*3"
input9 = "(3+3"

parser.avisos(parser.parse(input1),input1, "Aceito")
#parser.avisos(parser.parse(input2),input2, "Aceito")
#parser.avisos(parser.parse(input3),input3, "Aceito")
#parser.avisos(parser.parse(input4),input4, "Aceito")

#parser.avisos(parser.parse(input5),input5, "Não Aceito")
#parser.avisos(parser.parse(input6),input6, "Não Aceito")
#parser.avisos(parser.parse(input7),input7, "Não Aceito")
#parser.avisos(parser.parse(input8),input8, "Não Aceito")