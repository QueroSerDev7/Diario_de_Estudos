class Category
  CATEGORIES = ['Ruby', 'Rails', 'HTML']

  attr_reader :name

  def self.print_categories
    CATEGORIES.each_index { |index| puts "##{index + 1} - #{CATEGORIES[index]}" }
  end

  def self.fetch_category
    option = gets.chomp.to_i

    (1..CATEGORIES.size).include?(option) ? CATEGORIES[option - 1] : nil
  end

  def initialize(name: 'miscelânea')
    @name = name
  end
end
