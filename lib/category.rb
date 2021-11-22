class Category
  CATEGORY1 = 'Ruby'
  CATEGORY2 = 'Rails'
  CATEGORY3 = 'HTML'

  attr_reader :name

  def initialize(name: 'miscelânea')
    @name = name
  end

  def self.print_categories
    puts <<~CATEGORIES
      #1 - #{CATEGORY1}
      #2 - #{CATEGORY2}
      #3 - #{CATEGORY3}
    CATEGORIES
  end

  def self.fetch_category
    option = gets.chomp

    category_name = case option.to_i
                    when 1
                      CATEGORY1
                    when 2
                      CATEGORY2
                    when 3
                      CATEGORY3
                    else
                      print 'Opção inválida.'
                    end
  end
end
