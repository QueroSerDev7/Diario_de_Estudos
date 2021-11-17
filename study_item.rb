class StudyItem
  attr_accessor :title, :description, :category

  def initialize(title:, description:, category: Category.new)
    @title = title
    @description = description
    @category = category
  end
end
