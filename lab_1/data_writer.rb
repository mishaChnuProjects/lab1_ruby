module QuizShelest
  class FileWriter
    # Ініціалізація об'єкта FileWriter з режимом запису та іншими аргументами
    def initialize(mode, *args)
      @mode = mode
      @answers_dir = args[0]
      @filename = prepare_filename(args[1])
    end

    # Метод для запису повідомлення у файл
    def write(message)
      File.open(@filename, @mode) do |f|
        f.puts message
      end
    end

    # Метод для підготовки повного шляху до файлу
    def prepare_filename(filename)
      return File.expand_path(@answers_dir + '/' + filename, __dir__)
    end
  end
end