require_relative "questions_db_manager.rb"

class Question

  def self.find_by_id(id)
    result = QuestionsDBManager.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      questions
    WHERE
      id = ?
    SQL
    Question.new(result.first)
  end

  def self.find_by_author_id(author_id)
    results = QuestionsDBManager.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = ?
    SQL
    results.map { |entry| Question.new(entry) }
  end

  def self.all
    entries = QuestionsDBManager.instance.execute(<<-SQL)
    SELECT
      *
    FROM
      questions
    SQL

    entries.map { |entry| Question.new(entry) }
  end

  attr_accessor :id, :title, :body, :author_id

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

  def author
    User.find_by_id(@author_id)
  end

  def replies
    Reply.find_by_question_id(@id)
  end
end
