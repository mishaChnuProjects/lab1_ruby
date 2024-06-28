# Підключення залежностей з інших файлів
require_relative 'question_data_manager'
require_relative 'quiz_manager'
require_relative 'data_reader'

# Основний модуль для роботи з квізом
module QuizShelest
  class Engine
    # Ініціалізація об'єктів та налаштування початкових параметрів
    def initialize
      # Створення колекції питань з використанням даних з YAML-файлів
      @question_collection = QuestionData.new(Quiz::yaml_dir, Quiz::in_ext)
      # Створення об'єкта для зчитування відповідей з перевіркою на пустоту
      @input_reader = InputReader.new("Choose correct answer", 
                                    ->(str) { !str.empty?},
                                    "Answer too small",
                                    ->(str) { return str[0].upcase})
      # Зчитування імені користувача з перевіркою довжини
      @user_name = InputReader::read("Write your name", 
                                    ->(str) {str.size() > 2},
                                    "Name must be grater than 2",
                                    ->(str) { return str})
      # Отримання поточного часу у форматі YYYYMMDDHHMMSS
      @current_time = Time.now.strftime("%Y%m%d%H%M%S")
      # Створення об'єкта для запису відповідей у файл
      @writer = FileWriter.new("a", Quiz::answers_dir, @user_name + '_' + @current_time + ".txt")
      # Створення об'єкта для збору статистики
      @statistics = Statistics.new(@writer)
    end

    # Основний метод для запуску квізу
    def run
      # Ітерація через всі питання у колекції
      @question_collection.collection.each do |question|
        # Виведення питання на екран
        puts question
        # Запис питання у файл
        @writer.write(question)
        # Отримання та виведення відповідей на питання
        answers =  question.display_answers
        puts answers
        # Запис відповідей у файл
        @writer.write(answers)
        # Зчитування відповіді користувача
        get_answer_by_char(question)
      end
      # Виведення та запис результатів квізу
      puts "Result"
      @writer.write("Result")
      # Друк звіту зі статистикою
      @statistics.print_report
    end

    # Метод для зчитування та обробки відповіді користувача
    def get_answer_by_char(question)
      # Зчитування відповіді
      answer = @input_reader.read()
      # Запис відповіді у файл
      @writer.write("Answer: " + answer)
      # Перевірка правильності відповіді
      check(question.find_answer_by_char(answer), question.question_correct_answer)
    end

    # Метод для перевірки відповіді користувача
    def check(user_answer, correct_answer)
      if user_answer == correct_answer
        # Якщо відповідь правильна, збільшуємо кількість правильних відповідей
        @statistics.correct_answer += 1
        # Виведення та запис повідомлення про правильну відповідь
        puts "Correct!\n\n"
        @writer.write("Correct!\n\n")
      else
        # Якщо відповідь неправильна, збільшуємо кількість неправильних відповідей
        @statistics.incorrect_answer += 1
        # Виведення та запис повідомлення про неправильну відповідь
        puts "Incorrect!\n\n"
        @writer.write("Incorrect!\n\n")
      end
    end
  end
end