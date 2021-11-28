class StudyItem
  attr_reader :title, :description, :category, :is_concluded

  def self.register
    print 'Digite o título do seu item de estudo: '
    title = gets.chomp

    return puts 'O título do item não pode ser vazio. Por favor tente novamente.' if title.empty?

    Category.print_categories

    print 'Escolha uma categoria para o seu item de estudo: '

    category_name = Category.fetch_category

    category = if category_name
                 Category.new(name:category_name)
               else
                 puts "Opção inválida. Será atribuída a categoria '#{Category.new.name}'."
                 Category.new
               end

    print 'Dê uma descrição ao seu item de estudo (opcional): '
    description = gets.chomp

    new_item = StudyItem.new(title: title, description: description, category: category)

    TableFile.update_db(mode: REGISTER, item: new_item)

    # new_item = db.execute 'SELECT * FROM items ORDER BY rowid DESC LIMIT 1;'
    # ver o que pode/precisa mudar aqui na query acima
    print "Item '#{new_item.title}' da categoria '#{new_item.category.name}' "
    print "com a descrição '#{new_item.description}' " if new_item.description?
    puts 'cadastrado com sucesso!'
  end

  def self.view_not_concluded
    items = TableFile.find_by_mode(mode: VIEW_NOT_CONCLUDED)

    print_items(items, show_index: false, show_category: true, show_description: true)
  end

  def self.search
    print 'Digite uma palavra para procurar: '
    search_term = gets.chomp

    found_items = TableFile.find_by_mode(search_term.downcase, mode: SEARCH)

    print_results_message(found_items.size, mode: SEARCH)
    print_items(found_items, show_index: true, show_category: true, show_description: true)
  end

  def self.list_by_category
    Category.print_categories

    print 'Escolha uma categoria cujos itens de estudo devam ser listados: '

    search_term = Category.fetch_category

    unless search_term
      puts "Opção inválida. Serão listados os itens da categoria '#{Category.new.name}'."

      search_term = Category.new.name
    end

    found_items = TableFile.find_by_mode(search_term, mode: LIST_BY_CATEGORY)

    print_results_message(found_items.size, mode: LIST_BY_CATEGORY)
    print_items(found_items, show_index: true, show_category: false, show_description: true)
  end

  def self.delete
    print 'Digite o título dos seus itens de estudo que serão apagados: '
    title = gets.chomp

    found_items = TableFile.find_by_mode(title, mode: DELETE)

    TableFile.update_db(mode: DELETE, title: title)

    print_results_message(found_items.size, mode: DELETE)
    print_items(found_items, show_index: true, show_category: true, show_description: true)
  end

  def self.mark_as_concluded
    print 'Digite o título dos seus itens de estudo que serão marcados como concluídos: '
    title = gets.chomp

    found_items = TableFile.find_by_mode(title, mode: MARK_AS_CONCLUDED)

    TableFile.update_db(mode: MARK_AS_CONCLUDED, title: title)

    print_results_message(found_items.size, mode: MARK_AS_CONCLUDED)
    print_items(found_items, show_index: true, show_category: true, show_description: true)
  end

  def self.view_concluded
    items = TableFile.find_by_mode(mode: VIEW_CONCLUDED)

    print_results_message(items.size, mode: VIEW_CONCLUDED)
    print_items(items, show_index: true, show_category: true, show_description: true)
  end

  def self.print_items(items, show_index:, show_description:, show_category:)
    items.each_index do |index|
      print "##{index + 1} - " if show_index
      print "#{items[index].title}"
      print " - #{items[index].category.name}" if show_category
      print " - #{items[index].description}" if show_description && items[index].description?
      puts ''
    end
  end

  def initialize(title:, description:, category: Category.new, is_concluded: false)
    @title = title
    @description = description
    @category = category
    @is_concluded = is_concluded
  end

  def description?
    !@description.empty?
  end
end
