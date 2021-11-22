require 'io/console'
require_relative 'lib/category'
require_relative 'lib/table_file'
require_relative 'lib/study_item'
require_relative 'lib/study_diary_methods'

include StudyDiaryMethods

REGISTER = '1'
VIEW_NOT_CONCLUDED = '2'
SEARCH = '3'
LIST_BY_CATEGORY = '4'
DELETE = '5'
MARK_AS_CONCLUDED = '6'
VIEW_CONCLUDED = '7'
EXIT = '8'

$stdout.clear_screen

TableFile.new unless TableFile.exist?

puts "Bem-vindo ao Diário de Estudos, seu companheiro para estudar!"

loop do
  puts <<~MENU
    [#{REGISTER}] Cadastrar um item para estudar
    [#{VIEW_NOT_CONCLUDED}] Ver todos os itens cadastrados
    [#{SEARCH}] Buscar um item de estudo
    [#{LIST_BY_CATEGORY}] Listar por categoria
    [#{DELETE}] Apagar um item
    [#{MARK_AS_CONCLUDED}] Marcar um item como concluído
    [#{VIEW_CONCLUDED}] Ver todos os itens marcados como concluído
    [#{EXIT}] Sair
  MENU

  print 'Escolha uma opção: '

  option = gets.chomp

  case option
  when REGISTER then StudyItem.register
  when VIEW_NOT_CONCLUDED then StudyItem.view_not_concluded
  when SEARCH then StudyItem.search
  when LIST_BY_CATEGORY then StudyItem.list_by_category
  when DELETE then StudyItem.delete
  when MARK_AS_CONCLUDED then StudyItem.mark_as_concluded
  when VIEW_CONCLUDED then StudyItem.view_concluded
  when EXIT then break
  else puts 'Opção inválida'
  end

  puts '', 'Pressione qualquer tecla para continuar'

  $stdin.getch

  $stdout.clear_screen
end

puts 'Obrigado por usar o Diário de Estudos', ''
