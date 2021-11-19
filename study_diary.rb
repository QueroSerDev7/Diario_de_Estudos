require 'io/console'
require_relative 'category'
require_relative 'study_item'

REGISTER = '1'
VIEW = '2'
SEARCH = '3'
LIST_BY_CATEGORY = '4'
DELETE = '5'
DESCRIPTION = '6'
MARK_AS_CONCLUDED = '7'
EXIT = '8'

RUBY = 1
RAILS = 2
HTML = 3

ITEM_DELIMITER = "\n---\n"

def register(items)
  print 'Digite o título do seu item de estudo: '
  title = gets.chomp

  print 'Dê uma descrição ao item: '
  description = gets.chomp

  puts <<~CATEGORIES
  #1 - Ruby
  #2 - Rails
  #3 - HTML
  CATEGORIES

  print 'Escolha uma categoria para o seu item de estudo: '

  option = gets

  category_name = case option.to_i
                  when RUBY
                    'Ruby'
                  when RAILS
                    'Rails'
                  when HTML
                    'HTML'
                  else
                    puts 'Opção inválida. Foi atribuída a categoria miscelânea.'  # talvez fazer um loop
                  end

  category = category_name ? Category.new(name: category_name) : Category.new

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
    found_items << item if item.title.downcase.include?(search_term.downcase)
  end

    case found_items.size
  when 0
    puts "\n", 'nenhum item encontrado'
  when 1
    puts "\n", 'Foi encontrado 1 item'
  else
    puts "\n", "Foram encontrados #{found_items.size} itens"
  end

  found_items.each_index do |index|
    puts "\n", "##{index + 1} - #{found_items[index].title} - #{found_items[index].category.name}"
  end
end

def list_by_category(items)
  print 'indique a categoria cujos itens devem ser listados: '

  target_category = gets.chomp

  found_titles = []

  items.each { |item| found_titles << item.title if item.category.name == target_category }

  case found_titles.size
  when 0
    puts "", 'nenhum item da categoria indicada encontrado'
  when 1
    puts "", 'item da categoria indicada encontrado:'
  else
    puts "", 'itens da categoria indicada encontrados:'
  end

  puts found_titles
end

def delete(items)
  print 'indique o título dos itens que serão apagados: '

  title_to_delete = gets.chomp

  found_items = []

  items.each { |item| found_items << item if item.title == title_to_delete }

  found_items.each { |item| items.delete(item) }

  case found_items.size
  when 0
    puts "", 'Nenhum item com o título indicado encontrado. Nenhum item apagado.'
  when 1
    puts "", '1 item apagado'
  else
    puts "", "#{found_items.size} itens apagados"
  end
end

def search_in_title_and_description(items)
  print 'indique por qual termo buscar: '

  search_term = gets.chomp

  found_titles = []

  items.each do |item|
    if ((item.title.include?(search_term)) || (item.description.include?(search_term)))
      found_titles << item.title
    end
  end

  case found_titles.size
  when 0
    puts "", 'nenhum item encontrado'
  when 1
    puts "", 'item encontrado:'
  else
    puts "", 'itens encontrados:'
  end

  puts found_titles
end

def mark_as_concluded(items, concluded_items)
  case concluded_items.size
  when 0
    puts "não há atualmente nenhum item marcado como concluído\n"
  when 1
    puts "há atualmente um total de 1 item marcado como concluído:\n"
  else
    puts "há atualmente um total de #{concluded_items.size} itens marcados como concluídos:\n"
  end

  concluded_items.each { |item| puts item.title }

  print 'indique o título dos itens que serão marcados como concluídos: '

  title_done = gets.chomp

  found_items = []

  items.each { |item| found_items << item if item.title == title_done }

  concluded_items.concat(found_items)

  found_items.each { |item| items.delete(item) }

  case found_items.size
  when 0
    puts "\nNenhum item com o título indicado encontrado."
  when 1
    puts "\n1 item encontrado e marcado como concluído:"
  else
    puts "\n#{concluded_items.size} itens encontrados e marcados como concluídos:"
  end

  found_items.each { |item| puts item.title }
end

def exit(items, concluded_items)
  puts 'por favor pressione a tecla s para salvar a sessão (a sessão anterior, caso exista, será perdida),'\
        'ou pressione outra tecla para sair'

  if (STDIN.getch == 's')  #fazer um case talvez
    # salvar em um arquivo/banco de dados; talvez fazer um arquivo de backup e depois deletalo
    file = File.open("study_diary.txt", "w") # ver se quando open pra montar items ja nao pe suficiente (talvez nao porque toda vez o arquivo tem que ser zerado; ver outros atubutos tipo r

    items.each do |item|
      file.write("#{item.title}\n#{item.description}\n#{item.category.name}#{ITEM_DELIMITER}")
    end

    file.close
  end

  puts 'Obrigado por usar o Diário de Estudos', "\n"
end

items = []
concluded_items = []

#acho que vai ter que abrir a stringona e manusear para separa o que é de items e o que é de concluded items
# data = open("study diary.txt").read.lines("\n---\n", chomp: true) # with no block open is a synonim for new

if File.exist?("study_diary.txt")
  file = File.open("study_diary.txt")

  file.each(ITEM_DELIMITER) do |attributes|
    items << StudyItem.new(title: attributes.lines(chomp: true).first,
                           description: attributes.lines(chomp: true)[1],
                           category: Category.new(name: attributes.lines(chomp: true)[2]))
  end

  file.close
end

print `clear`
puts "Bem-vindo ao Diário de Estudos, seu companheiro para estudar!"

loop do
  puts <<~MENU
  [#{REGISTER}] Cadastrar um item para estudar
  [#{VIEW}] Ver todos os itens cadastrados
  [#{SEARCH}] Buscar um item de estudo
  [#{LIST_BY_CATEGORY}] Listar por categoria
  [#{DELETE}] Apagar um item
  [#{DESCRIPTION}] Descrição de um item e pesquisa
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
  when DESCRIPTION
    search_in_title_and_description(items)
  when MARK_AS_CONCLUDED
    mark_as_concluded(items, concluded_items)
  when EXIT
    exit(items, concluded_items)
    break
  else
    puts 'opção inválida'
  end

  puts "\n", 'Pressione qualquer tecla para continuar'

  STDIN.getch

  print `clear`
end
