class Category
  CATEGORIES = %w[Ruby Rails HTML]

  attr_reader :name

  def self.print_categories
    CATEGORIES.each_index { |index| puts "##{index + 1} - #{CATEGORIES[index]}" }
  end

  def self.fetch_category
    option = gets.chomp

    return nil unless ((1..OPTIONS_MENU.size).include?(option.to_i) && option == option.to_i.to_s)

    CATEGORIES[option.to_i - 1]
  end

  def initialize(name: 'miscelânea')
    @name = name
  end
end
