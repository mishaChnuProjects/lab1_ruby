require_relative 'quiz_question'
require 'yaml'
require 'thread'

module QuizShelest
  class QuestionData
    # Ініціалізація об'єкта QuestionData з директорією для YAML-файлів та їх розширенням
    def initialize(dir, ext)
      @collection = []
      @yaml_dir = dir
      @in_ext = ext
      @threads = []
      load_data()      # Завантаження даних при створенні об'єкта
      @collection.shuffle!   # Перемішування колекції питань
    end

    # Геттер і сеттер для колекції питань
    attr_accessor :collection

    # Метод для конвертації колекції у YAML формат
    def to_yaml
      hash = @collection.map { |item| item.to_h }
      return hash.to_yaml
    end

    # Метод для конвертації колекції у JSON формат
    def to_json
      hash = @collection.map { |item| item.to_h }
      return JSON.pretty_generate(hash)
    end

    # Метод для збереження колекції у YAML файл
    def save_to_yaml(file_name)
      File.open(file_name, 'w') do |f|
        f.write to_yaml
      end
    end

    # Метод для збереження колекції у JSON файл
    def save_to_json(file_name)
      File.open(file_name, 'w') do |f|
        f.write to_json
      end
    end

    # Метод для підготовки повного шляху до файлу
    def prepare_filename(filename)
      return File.expand_path(@yaml_dir + '/' + filename, __dir__)
    end

    # Метод для ітерації через всі файли у директорії
    def each_file
      return unless block_given?
      files = Dir.glob("*.#{@in_ext}", base: @yaml_dir)

      files.each do |file|
        yield file
      end
    end

    # Метод для виконання блоку коду у новому потоці
    def in_thread(&block)
      return unless block_given?
      @threads << Thread.new do
        yield
      end
    end

    # Метод для завантаження даних з файлу
    def load_from(filename)
      data = YAML.load_file(prepare_filename(filename))
      @collection += data.map do |question|
        Question.new(question["question"], question["answers"])
      end
    end

    # Метод для завантаження всіх даних
    def load_data
      each_file do |file|
        in_thread do
          load_from(file)
        end
      end

      # Очікування завершення всіх потоків
      @threads.each do |thread|
        thread.join()
      end
    end
  end
end