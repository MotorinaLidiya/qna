class SearchService
  MODELS = {
    'questions' => Question,
    'answers' => Answer,
    'comments' => Comment,
    'users' => User
  }.freeze

  FIELDS = {
    'Question' => %w[title body author_email],
    'Answer' => %w[body author_email],
    'Comment' => %w[body author_email],
    'User' => %w[email]
  }.freeze

  def self.call(query, scope = nil)
    models = scope.present? && MODELS.key?(scope) ? [MODELS[scope]] : MODELS.values
    models.flat_map { |model| search_by_model(model, query) }
  end

  def self.search_by_model(model, query)
    model.search(query: { multi_match: { query:, fields: FIELDS[model.name] || [] } }).records
  end
end
