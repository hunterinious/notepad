# encoding: utf-8
<<<<<<< HEAD

require 'sqlite3'

# Базовый класс «Запись» — здесь мы определим основные методы и свойства,
# общие для всех типов записей.
class Post
  SQLITE_DB_FILE = 'notepad.sqlite'.freeze

  def self.post_types
    {'Memo' => Memo, 'Task' => Task, 'Link' => Link}
  end

  def self.create(type)
    post_types[type].new
=======
#
# Базовый класс «Запись» — здесь мы определим основные методы и свойства,
# общие для всех типов записей.
class Post
  # Метод post_types класса Post, возвращает всех известных ему детей класса
  # Post в виде массива классов.
  def self.post_types
    [Memo, Task, Link]
  end
  # Метод create класса Post динамически (в зависимости от параметра) создает
  # объект нужного класса (Memo, Task или Link) из набора возможных детей,
  # получая список с помощью метода post_types, объявленного выше.
  def self.create(type_index)
    post_types[type_index].new
>>>>>>> f805f5052087bd9a74b84173bdab312b8ae85e3d
  end

  def initialize
    @created_at = Time.now
    @text = []
  end

<<<<<<< HEAD
  # Метод класса find_by_id находит в базе запись по идентификатору
  def self.find_by_id(id)
    # Если id не передали, мы ничего не ищем, а возвращаем nil
    return if id.nil?

    # Если id передали, едем дальше
    begin
      db = SQLite3::Database.open(SQLITE_DB_FILE)
    rescue SQLite3::SQLException => e
      puts "Не удалось открыть базу"
      abort e.message
    end

    db.results_as_hash = true

    # Начинаем аккуратно тянуть данные из базы методом execute
    begin
      result = db.execute('SELECT * FROM posts WHERE  rowid = ?', id)
    rescue SQLite3::SQLException => e
      # Если возникла ошибка, пишем об этом пользователю и выводим текст ошибки
      puts "Не удалось выполнить запрос в базе #{SQLITE_DB_FILE}"
      abort e.message
    end

    db.close

    return nil if result.empty?

    result = result[0]

    post = create(result['type'])
    post.load_data(result)
    post
  end

  # Метод класса find_all возвращает массив записей из базы данных, который
  # можно например показать в виде таблицы на экране.
  def self.find_all(limit, type)
    begin
    db = SQLite3::Database.open(SQLITE_DB_FILE)
    rescue SQLite3::SQLException => e
      puts "Не удалось открыть базу"
      abort e.message
    end

    db.results_as_hash = false

    query = 'SELECT rowid, * FROM posts '
    query += 'WHERE type = :type ' unless type.nil?
    query += 'ORDER by rowid DESC '
    query += 'LIMIT :limit ' unless limit.nil?

    # Перед подготовкой запроса поставим конструкцию begin, чтобы поймать
    # возможные ошибки например, если в базе нет таблицы posts.
    begin
      statement = db.prepare query
    rescue SQLite3::SQLException => e
      puts "Не удалось выполнить запрос в базе #{SQLITE_DB_FILE}"
      abort e.message
    end

    statement.bind_param('type', type) unless type.nil?
    statement.bind_param('limit', limit) unless limit.nil?

    # Перед запросом поставим конструкцию begin, чтобы поймать возможные ошибки
    # например, если в базе нет таблицы posts.
    begin
      result = statement.execute!
    rescue SQLite3::SQLException => e
      puts "Не удалось выполнить запрос в базе #{SQLITE_DB_FILE}"
      abort e.message
    end

    statement.close
    db.close

    result
  end

=======
>>>>>>> f805f5052087bd9a74b84173bdab312b8ae85e3d
  def read_from_console
    # Этот метод должен быть реализован у каждого ребенка
  end

  def to_strings
    # Этот метод должен быть реализован у каждого ребенка
  end

<<<<<<< HEAD
  def load_data(data_hash)
    @created_at = Time.parse(data_hash['created_at'])
    @text = data_hash['text']
  end

  def to_db_hash
    {
        'type' => self.class.name,
        'created_at' => @created_at.to_s
    }
  end

  def save_to_db
    db = SQLite3::Database.open(SQLITE_DB_FILE)
    db.results_as_hash = true

    post_hash = to_db_hash

    # Перед запросом поставим конструкцию begin, чтобы поймать возможные ошибки
    # например, если в базе нет таблицы posts.
    begin
      db.execute(
          'INSERT INTO posts (' +
              post_hash.keys.join(', ') +
              ") VALUES (#{('?,' * post_hash.size).chomp(',')})",
          post_hash.values
      )
    rescue SQLite3::SQLException => e
      puts "Не удалось выполнить запрос в базе #{SQLITE_DB_FILE}"
      abort e.message
    end

    insert_row_id = db.last_insert_row_id
    db.close
    insert_row_id
  end

  def save
    file = File.new(file_path, 'w:UTF-8')
=======
  def save
    file = File.new(file_path, 'w:UTF-8') # открываем файл на запись
>>>>>>> f805f5052087bd9a74b84173bdab312b8ae85e3d

    to_strings.each { |string| file.puts(string) }

    file.close
  end

  def file_path
    current_path = File.dirname(__FILE__)

    file_time = @created_at.strftime('%Y-%m-%d_%H-%M-%S')

    "#{current_path}/#{self.class.name}_#{file_time}.txt"
  end
end
<<<<<<< HEAD
=======

>>>>>>> f805f5052087bd9a74b84173bdab312b8ae85e3d
