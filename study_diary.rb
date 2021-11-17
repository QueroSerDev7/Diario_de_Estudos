require 'io/console'
require_relative 'category'
require_relative 'study_item'

REGISTER = '1'
VIEW = '2'
SEARCH = '3'
LIST_BY_CATEGORY = '4'
DELETE = '5'
DESCRIPTION = '6'
MARK_AS_DONE = '7'
EXIT = '8'

RUBY = 1
RAILS = 2
HTML = 3

def register(subjects)
  print 'Digite o título do seu item de estudo: '
  title = gets.chomp

  print 'descrição do item: '
  description = gets.chomp

  puts <<~CATEGORIES
  #1 - Ruby
  #2 - Rails
  #3 - HTML
  CATEGORIES

  print 'Escolha uma categoria para o seu item de estudo: '

  option = STDIN.getch.to_i

  puts option

  category_name = case option
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

  subject = StudyItem.new(title: title, description: description, category: category)

  subjects << subject

  puts "Item '#{subjects.last.title}' da categoria '#{subjects.last.category.name}' cadastrado com sucesso!"
end

def view(subjects)
  subjects.each { |subject| puts "#{subject.title} - #{subject.category.name}" }
end

def search(subjects)
  print 'Digite uma palavra para procurar: '

  search_term = gets.chomp

  found_subjects = []

  subjects.each do |subject|
    found_subjects << subject if subject.title.downcase.include?(search_term.downcase)
  end

  puts

  case found_subjects.size
  when 0
    puts 'nenhum item encontrado'
  when 1
    puts 'Foi encontrado 1 item', "\n"
  else
    puts 'itens encontrados:'
  end

  found_subjects.each_index do |index|
    puts "##{index + 1} - #{found_subjects[index].title} - #{found_subjects[index].category.name}"
  end
end

def list_by_category(subjects)
  print 'indique a categoria cujos itens devem ser listados: '

  target_category = gets.chomp

  found_items = []

  subjects.each { |subject| found_items << subject.title if subject.category.name == target_category }

  puts

  case found_items.size
  when 0
    puts 'nenhum item da categoria indicada encontrado'
  when 1
    puts 'item da categoria indicada encontrado:'
  else
    puts 'itens da categoria indicada encontrados:'
  end

  puts found_items
end

def delete(subjects)
  print 'indique o título dos itens que serão apagados: '

  item_to_delete = gets.chomp

  found_subjects = []

  subjects.each { |subject| found_subjects << subject if subject.title == item_to_delete }

  found_subjects.each { |subject| subjects.delete(subject) }

  puts

  case found_subjects.size
  when 0
    puts 'Nenhum item com o título indicado encontrado. Nenhum item apagado.'
  when 1
    puts '1 item apagado'
  else
    puts "#{found_subjects.size} itens apagados"
  end
end

def search_in_title_and_description(subjects)
  print 'indique por qual termo buscar: '

  search_term = gets.chomp

  found_items = []

  subjects.each do |subject|
    if ((subject.title.include?(search_term)) || (subject.description.include?(search_term)))
      found_items << subject.title
    end
  end

  puts

  case found_items.size
  when 0
    puts 'nenhum item encontrado'
  when 1
    puts 'item encontrado:'
  else
    puts 'itens encontrados:'
  end

  puts found_items
end

def mark_as_done(subjects, concluded_subjects)
  case concluded_subjects.size
  when 0
    puts "não há atualmente nenhum item marcado como concluído\n"
  when 1
    puts "há atualment um total de 1 item marcado como concluído:\n"
  else
    puts "há atualmente um total de #{concluded_subjects.size} itens marcados como concluídos:\n"
  end

  concluded_subjects.each { |subject| puts subject.title }

  print 'indique o título dos itens que serão marcados como concluídos: '

  subject_done = gets.chomp

  found_subjects = []

  subjects.each { |subject| found_subjects << subject if subject.title == subject_done }

  concluded_subjects.concat(found_subjects)

  found_subjects.each { |subject| subjects.delete(subject) }

  case found_subjects.size
  when 0
    puts "\nNenhum item com o título indicado encontrado."
  when 1
    puts "\n1 item encontrado e marcado como concluído:"
  else
    puts "\n#{concluded_subjects.size} itens encontrados e marcados como concluídos:"
  end

  found_subjects.each { |subject| puts subject.title }
end

def exit
  puts 'por favor pressione a tecla s para salvar a sessão, ou pressione outra tecla para sair'

  if (STDIN.getch == 's')  #fazer um case talvez
    # salvar em um arquivo/banco de dados

    # File.new("study diary #{Time.now}.txt")
  end

  puts 'Obrigado por usar o Diário de Estudos', "\n"
end

subjects = []
concluded_subjects = []

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
  [#{MARK_AS_DONE}] Marcar um item como concluído
  [#{EXIT}] Sair
  MENU

  print 'Escolha uma opção: '

  option = STDIN.getch

  puts option

  case option
  when REGISTER
    register(subjects)
  when VIEW
    view(subjects)
  when SEARCH
    search(subjects)
  when LIST_BY_CATEGORY
    list_by_category(subjects)
  when DELETE
    delete(subjects)
  when DESCRIPTION
    search_in_title_and_description(subjects)
  when MARK_AS_DONE
    mark_as_done(subjects, concluded_subjects)
  when EXIT
    exit
    break
  else
    puts 'opção inválida'
  end

  puts "\n", 'Pressione qualquer tecla para continuar'

  STDIN.getch

  print `clear`
end
