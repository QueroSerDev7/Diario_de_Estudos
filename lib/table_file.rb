require 'sqlite3'

class TableFile
  DATABASE = 'database.db'
  DATABASE_DIRECTORY = "#{__dir__}/../db"

  def self.find_by_mode(search_term = '', mode:)
    db = SQLite3::Database.open("#{DATABASE_DIRECTORY}/#{DATABASE}")

    db.results_as_hash = true

    items = case mode
            when VIEW_CONCLUDED
              db.execute('SELECT title, description, category_name, is_concluded '\
                         "FROM items where is_concluded = 'true'")
            when VIEW_NOT_CONCLUDED
              db.execute('SELECT title, description, category_name, is_concluded '\
                         "FROM items where is_concluded = 'false'")
            when SEARCH
              db.execute('SELECT title, description, category_name, is_concluded FROM items '\
                         "where (title LIKE '%#{search_term}%' OR description LIKE '%#{search_term}%') \
                          AND is_concluded = 'false'")
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
      #method boolean? defined on lib/study_diary_methods.rb
      unless (item.title.is_a?(String) && item.description.is_a?(String) &&
              item.category.name.is_a?(String) && boolean?(item.is_concluded))
        return puts 'Ocorreu um erro ao tentar adicionar um item de estudo: '\
                    'tipo de dado diferente do esperado. Não foi possível atualizar a sessão.'
      end

      # ver se precisa das aspas
      db.execute("INSERT INTO items VALUES('#{item.title}', '#{item.description}', \
                                           '#{item.category.name}', '#{item.is_concluded}', \
                                           '#{item.concluded_at}', '#{item.registered_at}', \
                                           '#{item.index_id}')")
    when DELETE then db.execute("DELETE FROM items where title = '#{title}'")
    when MARK_AS_CONCLUDED
       db.execute("UPDATE items SET concluded_at = '#{Time.now.floor}' \
                   where title = '#{title}' AND concluded_at = 'nil'")

       db.execute("UPDATE items SET is_concluded = 'true' where title = '#{title}'")
    else puts 'Comando inválido. Não foi possível atualizar a sessão.'
    end

    db.close
  end

  def self.exist?
    File.exist?("#{DATABASE_DIRECTORY}/#{DATABASE}")
  end

  def self.restart
    puts 'Essa ação apagará de forma definitiva todos os dados salvos no Diário de Estudos.'
    print 'Deseja continuar? [s/n] '
    option = gets.chomp

    return puts 'Operação cancelada com sucesso. Os dados não foram apagados.' unless option == 's'

    File.delete("#{DATABASE_DIRECTORY}/#{DATABASE}")

    TableFile.new

    puts 'Diário de Estudos reiciado com sucesso'
  end

  def initialize
    begin
      Dir.mkdir(DATABASE_DIRECTORY) unless Dir.exists?(DATABASE_DIRECTORY)

      db = SQLite3::Database.open("#{DATABASE_DIRECTORY}/#{DATABASE}")

      db.execute('CREATE TABLE Items(title TEXT, description TEXT, category_name TEXT, '\
                                    'is_concluded BOOLEAN, concluded_at DATETIME, '\
                                    'registered_at DATETIME, index_id INTEGER)')
    rescue SQLite3::Exception => e
      puts e
    ensure
      db.close if db
    end
  end
end
