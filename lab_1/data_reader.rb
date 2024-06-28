module QuizShelest
  class InputReader
    # Ініціалізація об'єкта InputReader з вітальним повідомленням, валідатором, повідомленням про помилку та процесором
    def initialize(welcome_message, validator, error_message, process)
      @welcome_message = welcome_message
      @validator = validator
      @error_message = error_message
      @process = process
    end
    
    # Метод для зчитування даних через виклик класового методу read
    def read
      InputReader::read(@welcome_message, @validator, @error_message, @process)
    end

    class << self
      # Класовий метод для зчитування та обробки введених даних
      def read(welcome_message, validator, error_message, process)
        is_ok = false
        while !is_ok
          # Виведення вітального повідомлення
          puts welcome_message
          # Зчитування введених даних
          data = gets.chomp
          # Перевірка валідності введених даних
          is_ok = validator.call(data)
          if !is_ok
            # Виведення повідомлення про помилку у випадку невалідних даних
            puts error_message
          end
        end
        # Обробка та повернення валідних даних
        return process.call(data)
      end
    end
  end
end