require 'sqlite3'

DATABASE = 'database.db'
DATABASE_DIRECTORY = "#{__dir__}/../db"

class TableFile
  def self.find_by_mode(search_term = '', mode:)
    db = SQLite3::Database.open("#{DATABASE_DIRECTORY}/#{DATABASE}")

    # ver direito isso aqui
    db.results_as_hash = true

    items = case mode
            when VIEW_CONCLUDED
              db.execute('SELECT title, description, category_name, is_concluded '\
                         "FROM items where is_concluded = 'true'")
            when VIEW_NOT_CONCLUDED
              db.execute('SELECT title, description, category_name, is_concluded '\
                         "FROM items where is_concluded = 'false'")
            # talvez nao precise de interpolacoes
            when SEARCH
              db.execute('SELECT title, description, category_name, is_concluded FROM items '\
                         "where (title LIKE '%#{search_term}%' OR description LIKE '%#{search_term}%') "\
                         "AND is_concluded = 'false'")
            when DELETE, MARK_AS_CONCLUDED
              db.execute('SELECT title, description, category_name, is_concluded '\
                         "FROM items where title = '#{search_term}' AND is_concluded = 'false'")
            when LIST_BY_CATEGORY
              db.execute('SELECT title, description, category_name, is_concluded '\
                         "FROM items where category_name = '#{search_term}' AND is_concluded = 'false'")
            else []
            end

    db.close

    items.map do |item|
      StudyItem.new(title: item['title'], description: item['description'],
                    category: Category.new(name: item['category_name']), is_concluded: item['is_concluded'])
    end
  end

  def self.update_db(mode:, item: nil, title: nil)
    db = SQLite3::Database.open("#{DATABASE_DIRECTORY}/#{DATABASE}")

    case mode
    when REGISTER
      db.execute("INSERT INTO items VALUES('#{item.title}', '#{item.description}', "\
                                          "'#{item.category.name}', '#{item.is_concluded}')")
    when DELETE
      db.execute("DELETE FROM items where title = '#{title}'")
    when MARK_AS_CONCLUDED
      db.execute("UPDATE items SET is_concluded = 'true' where title='#{title}'")
    else
      puts 'Comando inválido. Não foi possível atualizar a sessão.'
    end

    db.close
  end

  def self.exist?
    File.exist?("#{DATABASE_DIRECTORY}/#{DATABASE}")
  end

  def initialize
    begin
      # Dir.chdir("#{Dir.home}/study")

      Dir.mkdir(DATABASE_DIRECTORY) unless Dir.exists?(DATABASE_DIRECTORY)

      db = SQLite3::Database.open("#{DATABASE_DIRECTORY}/#{DATABASE}")

      db.execute('CREATE TABLE Items(title varchar(255), description varchar(255),'\
                                    'category_name varchar(255), is_concluded boolean);')
    rescue SQLite3::Exception => e
      puts e
    ensure
      db.close if db
    end
  end
end
