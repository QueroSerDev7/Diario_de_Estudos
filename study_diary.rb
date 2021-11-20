require 'io/console'
require_relative 'lib/category'
require_relative 'lib/study_item'

REGISTER = '1'
VIEW = '2'
SEARCH = '3'
LIST_BY_CATEGORY = '4'
DELETE = '5'
MARK_AS_CONCLUDED = '6'
EXIT = '7'

CONCLUDED = '6.5'

RUBY = 1
RAILS = 2
HTML = 3

ITEM_DELIMITER = "\n---\n"
CONCLUDED_DELIMITER = "\n===\n"

STORED_SESSION = 'lib/study_diary.txt'

def register(items)
  print 'Digite o título do seu item de estudo: '
  title = gets.chomp

  print 'Dê uma descrição ao seu item de estudo: '
  description = gets.chomp

  print_categories

  print 'Escolha uma categoria para o seu item de estudo: '

  category_name = fetch_category

  category = if (category_name)
               Category.new(name: category_name)
             else
               puts ' Será atribuída a categoria miscelânea.'
               Category.new
             end

  items << StudyItem.new(title: title, description: description, category: category)

  puts "Item '#{items.last.title}' da categoria '#{items.last.category.name}' cadastrado com sucesso!"
end

def view(items)
  print_items(items, show_index: false, show_category: true)
end

def search(items)
  print 'Digite uma palavra para procurar: '

  found_items = fetch_items(items, mode: SEARCH)

  print_results_message(found_items.size, mode: SEARCH)

  print_items(found_items, show_index: true, show_category: true)
end

def list_by_category(items)
  print_categories

  print 'Escolha uma categoria cujos itens de estudo devam ser listados: '

  found_items = fetch_items(items, mode: LIST_BY_CATEGORY, search_term: fetch_category)

  print_results_message(found_items.size, mode: LIST_BY_CATEGORY)

  print_items(found_items, show_index: true, show_category: false)
end

def delete(items)
  print 'Digite o título dos seus itens de estudo que serão apagados: '

  found_items = fetch_items(items, mode: DELETE)

  found_items.each { |item| items.delete(item) }

  print_results_message(found_items.size, mode: DELETE)

  print_items(found_items, show_index: true, show_category: true)
end

def mark_as_concluded(items, concluded_items)
  print_results_message(concluded_items.size, mode: CONCLUDED)

  print_items(concluded_items, show_index: true, show_category: true)

  print 'Digite o título dos seus itens de estudo que serão marcados como concluídos: '

  found_items = fetch_items(items, mode: MARK_AS_CONCLUDED)

  concluded_items.concat(found_items)

  found_items.each { |item| items.delete(item) }

  print_results_message(found_items.size, mode: MARK_AS_CONCLUDED)

  print_items(found_items, show_index: true, show_category: true)
end

def exit(items, concluded_items)
  puts 'Por favor pressione a tecla s para salvar a sessão (a sessão anterior, caso exista, será perdida), '\
       'ou pressione outra tecla para sair.'

  if (STDIN.getch == 's')
    # salvar em um arquivo/banco de dados
    file = File.new('.file_to_manipulate', 'w')

    items.each do |item|
      file.write("#{item.title}\n#{item.description}\n#{item.category.name}#{ITEM_DELIMITER}")
    end

    file.write(CONCLUDED_DELIMITER)

    concluded_items.each do |item|
      file.write("#{item.title}\n#{item.description}\n#{item.category.name}#{ITEM_DELIMITER}")
    end

    #poderia salvar as sessoes
    File.rename(file, STORED_SESSION)

    file.close

    puts 'Sessão salva com sucesso'
  end

  puts 'Obrigado por usar o Diário de Estudos', ''
end

def clear_terminal
  STDOUT.clear_screen
end

def print_categories
  puts <<~CATEGORIES
    ##{RUBY} - Ruby
    ##{RAILS} - Rails
    ##{HTML} - HTML
  CATEGORIES
end

def fetch_category
  option = gets.chomp

  category_name = case option.to_i
                  when RUBY
                    'Ruby'
                  when RAILS
                    'Rails'
                  when HTML
                    'HTML'
                  else
                    puts 'Opção inválida. Serão listados os itens da categoria miscelânea.'
                  end

  category_name ||= Category.new.name
end

def fetch_items(items, mode:, search_term: nil)
  search_term ||= gets.chomp

  case mode
  when SEARCH
    items.select do |item|
      (item.title.downcase.include?(search_term.downcase) ||
       item.description.downcase.include?(search_term.downcase))
    end
  when LIST_BY_CATEGORY
    items.select { |item| item.category.name == search_term }
  when DELETE, MARK_AS_CONCLUDED
    items.select { |item| item.title == search_term }
  else []
  end
end

def print_items(items, show_index:, show_category:)
  items.each_index do |index|
    print "##{index + 1} - " if show_index
    print "#{items[index].title}"
    print " - #{items[index].category.name}" if show_category
    puts ''
  end
end

def print_results_message(size, mode:)
  puts '', case mode
           when SEARCH
             case size
             when 0 then 'Não foi encontrado nenhum item'
             when 1 then 'Foi encontrado 1 item'
             else "Foram encontrados #{size} itens"
             end
           when LIST_BY_CATEGORY
             case size
             when 0 then 'Não foi encontrado nenhum item da categoria escolhida'
             when 1 then 'Foi encontrado 1 item da categoria escolhida'
             else "Foram encontrados #{size} itens da categoria escolhida"
             end
           when DELETE
             case size
             when 0 then 'Não foi encontrado nenhum item com o título indicado. Nenhum item apagado.'
             when 1 then 'Foi apagado 1 item'
             else "Foram apagados #{size} itens"
             end
           when CONCLUDED
             case size
             when 0 then 'Não há atualmente nenhum item marcado como concluído'
             when 1 then 'Há atualmente um total de 1 item marcado como concluído'
             else "Há atualmente um total de #{size} itens marcados como concluídos"
             end
           when MARK_AS_CONCLUDED
             case size
             when 0 then 'Não foi encontrado nenhum item com o título indicado'
             when 1 then 'Foi encontrado e marcado como concluído 1 item'
             else "Foram encontrados e marcados como concluídos #{size} itens"
             end
           else ''
           end

  puts '' unless size == 0
end

items = []
concluded_items = []

if File.exist?(STORED_SESSION)
  data = File.read(STORED_SESSION)

  # string_of_items, string_of_concluded_items = data.scan(/([\s\S]*) === ([\S\s]*)/).flatten
  string_of_items, string_of_concluded_items = data.split(CONCLUDED_DELIMITER)
  string_of_items ||= ''
  string_of_concluded_items ||= ''

  string_of_items.split(ITEM_DELIMITER) do |attributes|
    items << StudyItem.new(title: attributes.lines(chomp: true).first,
                           description: attributes.lines(chomp: true)[1],
                           category: Category.new(name: attributes.lines(chomp: true)[2]))
  end

  string_of_concluded_items.split(ITEM_DELIMITER) do |attributes|
    concluded_items << StudyItem.new(title: attributes.lines(chomp: true).first,
                                     description: attributes.lines(chomp: true)[1],
                                     category: Category.new(name: attributes.lines(chomp: true)[2]))
  end
end

clear_terminal

puts "Bem-vindo ao Diário de Estudos, seu companheiro para estudar!"

loop do
  puts <<~MENU
    [#{REGISTER}] Cadastrar um item para estudar
    [#{VIEW}] Ver todos os itens cadastrados
    [#{SEARCH}] Buscar um item de estudo
    [#{LIST_BY_CATEGORY}] Listar por categoria
    [#{DELETE}] Apagar um item
    [#{MARK_AS_CONCLUDED}] Marcar um item como concluído
    [#{EXIT}] Sair
  MENU

  print 'Escolha uma opção: '

  option = gets.chomp

  case option
  when REGISTER
    register(items)
  when VIEW
    view(items)
  when SEARCH
    search(items)
  when LIST_BY_CATEGORY
    list_by_category(items)
  when DELETE
    delete(items)
  when MARK_AS_CONCLUDED
    mark_as_concluded(items, concluded_items)
  when EXIT
    exit(items, concluded_items)
    break
  else
    puts 'Opção inválida'
  end

  puts '', 'Pressione qualquer tecla para continuar'

  STDIN.getch

  clear_terminal
end
