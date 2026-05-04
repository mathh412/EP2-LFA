require_relative "cyk"
require_relative "gramatica"
require_relative "Caminho"

gramatica = Gramatica.new("E")
#--------------------------------------------------------------------------------------------------------------
gramatica.adiciona_regra(Regra.new('E', ['E','X1']))
gramatica.adiciona_regra(Regra.new('E', ['T','X2']))
gramatica.adiciona_regra(Regra.new('E', ['P','X3']))
gramatica.adiciona_regra(Regra.new('E', ['Csub','U']))
gramatica.adiciona_regra(Regra.new('E', ['Cpe','X4']))
gramatica.adiciona_regra(Regra.new('E', ['N','D']))
gramatica.adiciona_regra(Regra.new('E', ['0']))
gramatica.adiciona_regra(Regra.new('E', ['1']))
gramatica.adiciona_regra(Regra.new('E', ['2']))
gramatica.adiciona_regra(Regra.new('E', ['3']))
gramatica.adiciona_regra(Regra.new('E', ['4']))
gramatica.adiciona_regra(Regra.new('E', ['5']))
gramatica.adiciona_regra(Regra.new('E', ['6']))
gramatica.adiciona_regra(Regra.new('E', ['7']))
gramatica.adiciona_regra(Regra.new('E', ['8']))
gramatica.adiciona_regra(Regra.new('E', ['9']))

gramatica.adiciona_regra(Regra.new('T', ['T','X2']))
gramatica.adiciona_regra(Regra.new('T', ['P','X3']))
gramatica.adiciona_regra(Regra.new('T', ['Csub','U']))
gramatica.adiciona_regra(Regra.new('T', ['Cpe','X4']))
gramatica.adiciona_regra(Regra.new('T', ['N','D']))
gramatica.adiciona_regra(Regra.new('T', ['0']))
gramatica.adiciona_regra(Regra.new('T', ['1']))
gramatica.adiciona_regra(Regra.new('T', ['2']))
gramatica.adiciona_regra(Regra.new('T', ['3']))
gramatica.adiciona_regra(Regra.new('T', ['4']))
gramatica.adiciona_regra(Regra.new('T', ['5']))
gramatica.adiciona_regra(Regra.new('T', ['6']))
gramatica.adiciona_regra(Regra.new('T', ['7']))
gramatica.adiciona_regra(Regra.new('T', ['8']))
gramatica.adiciona_regra(Regra.new('T', ['9']))

gramatica.adiciona_regra(Regra.new('F', ['P','X3']))
gramatica.adiciona_regra(Regra.new('F', ['Csub','U']))
gramatica.adiciona_regra(Regra.new('F', ['Cpe','X4']))
gramatica.adiciona_regra(Regra.new('F', ['N','D']))
gramatica.adiciona_regra(Regra.new('F', ['0']))
gramatica.adiciona_regra(Regra.new('F', ['1']))
gramatica.adiciona_regra(Regra.new('F', ['2']))
gramatica.adiciona_regra(Regra.new('F', ['3']))
gramatica.adiciona_regra(Regra.new('F', ['4']))
gramatica.adiciona_regra(Regra.new('F', ['5']))
gramatica.adiciona_regra(Regra.new('F', ['6']))
gramatica.adiciona_regra(Regra.new('F', ['7']))
gramatica.adiciona_regra(Regra.new('F', ['8']))
gramatica.adiciona_regra(Regra.new('F', ['9']))

gramatica.adiciona_regra(Regra.new('P', ['Csub','U']))
gramatica.adiciona_regra(Regra.new('P', ['Cpe','X4']))
gramatica.adiciona_regra(Regra.new('P', ['N','D']))
gramatica.adiciona_regra(Regra.new('P', ['0']))
gramatica.adiciona_regra(Regra.new('P', ['1']))
gramatica.adiciona_regra(Regra.new('P', ['2']))
gramatica.adiciona_regra(Regra.new('P', ['3']))
gramatica.adiciona_regra(Regra.new('P', ['4']))
gramatica.adiciona_regra(Regra.new('P', ['5']))
gramatica.adiciona_regra(Regra.new('P', ['6']))
gramatica.adiciona_regra(Regra.new('P', ['7']))
gramatica.adiciona_regra(Regra.new('P', ['8']))
gramatica.adiciona_regra(Regra.new('P', ['9']))

gramatica.adiciona_regra(Regra.new('U', ['Cpe','X4']))
gramatica.adiciona_regra(Regra.new('U', ['N','D']))
gramatica.adiciona_regra(Regra.new('U', ['0']))
gramatica.adiciona_regra(Regra.new('U', ['1']))
gramatica.adiciona_regra(Regra.new('U', ['2']))
gramatica.adiciona_regra(Regra.new('U', ['3']))
gramatica.adiciona_regra(Regra.new('U', ['4']))
gramatica.adiciona_regra(Regra.new('U', ['5']))
gramatica.adiciona_regra(Regra.new('U', ['6']))
gramatica.adiciona_regra(Regra.new('U', ['7']))
gramatica.adiciona_regra(Regra.new('U', ['8']))
gramatica.adiciona_regra(Regra.new('U', ['9']))

gramatica.adiciona_regra(Regra.new('N', ['N','D']))
gramatica.adiciona_regra(Regra.new('N', ['0']))
gramatica.adiciona_regra(Regra.new('N', ['1']))
gramatica.adiciona_regra(Regra.new('N', ['2']))
gramatica.adiciona_regra(Regra.new('N', ['3']))
gramatica.adiciona_regra(Regra.new('N', ['4']))
gramatica.adiciona_regra(Regra.new('N', ['5']))
gramatica.adiciona_regra(Regra.new('N', ['6']))
gramatica.adiciona_regra(Regra.new('N', ['7']))
gramatica.adiciona_regra(Regra.new('N', ['8']))
gramatica.adiciona_regra(Regra.new('N', ['9']))

gramatica.adiciona_regra(Regra.new('D', ['0']))
gramatica.adiciona_regra(Regra.new('D', ['1']))
gramatica.adiciona_regra(Regra.new('D', ['2']))
gramatica.adiciona_regra(Regra.new('D', ['3']))
gramatica.adiciona_regra(Regra.new('D', ['4']))
gramatica.adiciona_regra(Regra.new('D', ['5']))
gramatica.adiciona_regra(Regra.new('D', ['6']))
gramatica.adiciona_regra(Regra.new('D', ['7']))
gramatica.adiciona_regra(Regra.new('D', ['8']))
gramatica.adiciona_regra(Regra.new('D', ['9']))
#--------------------------------------------------------------------------------------------------------------
gramatica.adiciona_regra(Regra.new('X1', ['Csoma', 'T']))
gramatica.adiciona_regra(Regra.new('X1', ['Csub','T']))
gramatica.adiciona_regra(Regra.new('X2', ['Cmult','F']))
gramatica.adiciona_regra(Regra.new('X2', ['Cdiv','F']))
gramatica.adiciona_regra(Regra.new('X3', ['Cexp','F']))
gramatica.adiciona_regra(Regra.new('X4', ['E','Cpd']))
#---------------------------------------------------------------------------------------------------------------
gramatica.adiciona_regra(Regra.new('Csoma', ['+']))
gramatica.adiciona_regra(Regra.new('Csub',  ['-']))
gramatica.adiciona_regra(Regra.new('Cmult', ['*']))
gramatica.adiciona_regra(Regra.new('Cdiv',  ['/']))
gramatica.adiciona_regra(Regra.new('Cexp',  ['^']))
gramatica.adiciona_regra(Regra.new('Cpe',   ["("]))
gramatica.adiciona_regra(Regra.new('Cpd',   [")"]))


parser = CYKParser.new(gramatica)

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
