require_relative 'data_writer'

module QuizShelest
  class Statistics
    # Ініціалізація об'єкта Statistics з переданим об'єктом writer
    def initialize(writer)
      @writer = writer
      @correct_answer = 0
      @incorrect_answer = 0
    end

    # Геттери і сеттери для правильних та неправильних відповідей
    attr_accessor :correct_answer, :incorrect_answer

    # Метод для друку звіту
    def print_report
      # Обчислення відсотка правильних відповідей
      correctness = (incorrect_answer + correct_answer > 0) ? ((correct_answer * 100) / (incorrect_answer + correct_answer)) : 0
      # Формування рядка зі статистикою
      str = "Correct: #{correct_answer}\nIncorrect: #{incorrect_answer}\nCorrectness: #{correctness}%"
      # Запис звіту у файл
      @writer.write(str)
      # Виведення звіту на екран
      puts str
    end
  end
end