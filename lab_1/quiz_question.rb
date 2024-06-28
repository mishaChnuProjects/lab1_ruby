require 'json'
require 'yaml'

module QuizShelest
  class Question
    # Ініціалізує об'єкт питання з вхідним текстом і списком відповідей
    def initialize(raw_text, raw_answers)
      @question_body = raw_text                     # Текст питання
      @question_correct_answer = raw_answers[0]      # Правильна відповідь
      @question_answers = load_answers(raw_answers) # Завантаження відповідей
    end

    attr_accessor :question_body, :question_correct_answer, :question_answers

    # Повертає масив строк для відображення всіх варіантів відповідей
    def display_answers
      result = []
      @question_answers.each do |key, value|
        result << "#{key}. #{value}"
      end
      return result
    end

    # Повертає текст питання при конвертації до строкового представлення
    def to_s
      return @question_body
    end

    # Перетворює об'єкт питання в хеш
    def to_h
      result = {}
      result[:question_body] = @question_body
      result[:question_correct_answer] = @question_correct_answer
      result[:question_answers] = @question_answers
      return result
    end

    # Перетворює об'єкт питання в JSON рядок
    def to_json
      return JSON.pretty_generate(to_h)
    end

    # Перетворює об'єкт питання в YAML рядок
    def to_yaml
      return to_h.to_yaml
    end

    # Завантажує відповіді з вхідного масиву та розташовує їх у випадковому порядку
    def load_answers(raw_answers)
      result = {}
      letter = 'A'
      raw_answers.shuffle!
      raw_answers.each do |answer|
        result[:"#{letter}"] = answer
        letter.next!
      end

      return result
    end

    # Знаходить відповідь за заданим символом (наприклад, 'A', 'B', і т.д.)
    def find_answer_by_char(char)
      return @question_answers[char.to_sym]
    end
  end
end