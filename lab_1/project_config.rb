require_relative 'quiz_manager'

# Конфігурування параметрів для QuizShelest
QuizShelest::Quiz::config do |par|
  par[:yaml_dir] = "quiz/yml"         # Директорія для YAML-файлів з питаннями
  par[:in_ext] = "yml"                # Розширення файлів з питаннями
  par[:answers_dir] = "quiz/answers"  # Директорія для збереження відповідей
end