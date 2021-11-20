class StudyItem
  attr_reader :title, :description, :category

  def initialize(title:, description:, category: Category.new)
    @title = title
    @description = description
    @category = category
  end
end
