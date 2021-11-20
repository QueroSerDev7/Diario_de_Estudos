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
  items.each { |item| puts "#{item.title} - #{item.category.name}" }
end

def search(items)
  print 'Digite uma palavra para procurar: '

  search_term = gets.chomp

  found_items = []

  items.each do |item|
    found_items << item if (item.title.downcase.include?(search_term.downcase) ||
                            item.description.downcase.include?(search_term.downcase))
  end

    case found_items.size
  when 0
    puts '', 'Não foi encontrado nenhum item'
  when 1
    puts '', 'Foi encontrado 1 item'
  else
    puts '', "Foram encontrados #{found_items.size} itens"
  end

  found_items.each_index do |index|
    puts '', "##{index + 1} - #{found_items[index].title} - #{found_items[index].category.name}"
  end
end

def list_by_category(items)
  print_categories

  print 'Escolha uma categoria cujos itens de estudo devam ser listados: '

  category_name = fetch_category

  unless category_name
    category_name = Category.new.name
    puts ' Serão listados os itens da categoria miscelânea.'
  end

  found_titles = []

  items.each { |item| found_titles << item.title if item.category.name == category_name }

  case found_titles.size
  when 0
    puts '', 'Não foi encontrado nenhum item da categoria escolhida', ''
  when 1
    puts '', 'Foi encontrado 1 item da categoria escolhida', ''
  else
    puts '', "Foram encontrados #{found_titles.size} itens da categoria escolhida", ''
  end

  found_titles.each_index { |index| puts "##{index + 1} - #{found_titles[index]}" }
end

def delete(items)
  print 'Digite o título dos seus itens de estudo que serão apagados: '

  title_to_delete = gets.chomp

  found_items = []

  items.each { |item| found_items << item if item.title == title_to_delete }

  found_items.each { |item| items.delete(item) }

  case found_items.size
  when 0
    puts '', 'Não foi encontrado nenhum item com o título indicado. Nenhum item apagado.', ''
  when 1
    puts '', 'Foi apagado 1 item', ''
  else
    puts '', "Foram apagados #{found_items.size} itens", ''
  end

  found_items.each_index do |index|
    puts "##{index + 1} - #{found_items[index].title} - #{found_items[index].category.name}"
  end
end

def mark_as_concluded(items, concluded_items)
  case concluded_items.size
  when 0
    puts 'Não há atualmente nenhum item marcado como concluído', ''
  when 1
    puts 'Há atualmente um total de 1 item marcado como concluído', ''
  else
    puts "Há atualmente um total de #{concluded_items.size} itens marcados como concluídos", ''
  end

  concluded_items.each { |item| puts item.title }

  print 'Digite o título dos seus itens de estudo que serão marcados como concluídos: '

  title_done = gets.chomp

  found_items = []

  items.each { |item| found_items << item if item.title == title_done }

  concluded_items.concat(found_items)

  found_items.each { |item| items.delete(item) }

  case found_items.size
  when 0
    puts '', 'Não foi encontrado nenhum item com o título indicado'
  when 1
    puts '', 'Foi encontrado e marcado como concluído 1 item'
  else
    puts '', "Foram encontrados e marcados como concluídos #{concluded_items.size} itens"
  end

  found_items.each { |item| puts item.title }
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

items = []
concluded_items = []

# nao precisa fechar se so ler?
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

def clear_terminal
  print RUBY_PLATFORM.include?('windows') ? `cls` : `clear`
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

  case option.to_i
  when RUBY
    'Ruby'
  when RAILS
    'Rails'
  when HTML
    'HTML'
  else
    print 'Opção inválida.'
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
