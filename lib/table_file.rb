require 'sqlite3'

STORED_SESSION_PATH = 'db/database.db'

class TableFile
  def self.find_by_mode(search_term = '', mode:)
    db = SQLite3::Database.open STORED_SESSION_PATH

    db.results_as_hash = true

    items = case mode
            when VIEW_CONCLUDED
              db.execute 'SELECT title, description, category_name, is_concluded '\
                         "FROM items where is_concluded = 'true'"
            when VIEW_NOT_CONCLUDED
              db.execute 'SELECT title, description, category_name, is_concluded '\
                         "FROM items where is_concluded = 'false'"
            when SEARCH
              db.execute 'SELECT title, description, category_name, is_concluded FROM items '\
                         "where (title LIKE '%#{search_term}%' OR description LIKE '%#{search_term}%') "\
                         "AND is_concluded = 'false'"
            when DELETE, MARK_AS_CONCLUDED
              db.execute 'SELECT title, description, category_name, is_concluded '\
                         "FROM items where title = '#{search_term}' AND is_concluded = 'false'"
            when LIST_BY_CATEGORY
              db.execute 'SELECT title, description, category_name, is_concluded '\
                         "FROM items where category_name = '#{search_term}' AND is_concluded = 'false'"
            else []
            end

    db.close

    items.map do |item|
      StudyItem.new(title: item['title'], description: item['description'],
                    category_name: item['category_name'], is_concluded: item['is_concluded'])
    end
  end

  def self.save_to_db(item)
    db = SQLite3::Database.open STORED_SESSION_PATH

    db.execute "INSERT INTO items VALUES('#{item.title}', '#{item.description}', "\
                                        "'#{item.category_name}', '#{item.is_concluded}')" # ver se precisa desses esapcos

    db.close
  end

  def self.exist?
    File.exist?(STORED_SESSION_PATH)
  end

  def initialize
    begin
      db = SQLite3::Database.open STORED_SESSION_PATH

      db.execute <<~SQL
        CREATE TABLE Items(title varchar(255), description varchar(255),
                           category_name varchar(255), is_concluded boolean);
      SQL
    rescue SQLite3::Exception => e
      puts e
    ensure
      db.close if db
    end
  end
end
