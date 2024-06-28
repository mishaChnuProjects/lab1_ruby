module QuizShelest
  class Quiz
    class << self
      # Конфігурація модуля
      def config
        return unless block_given?

        # Задаємо параметри за замовчуванням
        params = {yaml_dir: "./", in_ext: "yaml", answers_dir: "./"}
        
        # Викликаємо блок з параметрами, які можна налаштувати
        yield params

        # Зберігаємо налаштування у змінних класу
        @@yaml_dir = params[:yaml_dir]
        @@in_ext = params[:in_ext]
        @@answers_dir = params[:answers_dir]
      end

      # Повертає директорію YAML файлів
      def yaml_dir
        @@yaml_dir
      end
      
      # Повертає розширення вхідних файлів
      def in_ext
        @@in_ext
      end
      
      # Повертає директорію з відповідями
      def answers_dir
        @@answers_dir
      end
    end
  end
end