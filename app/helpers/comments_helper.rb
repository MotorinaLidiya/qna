module CommentsHelper
  def comment_link(result)
    case result.commentable
    when Question
      path = question_path(result.commentable, anchor: "comment-#{result.id}")
      title = result.commentable.title
    when Answer
      path = question_path(result.commentable.question, anchor: "comment-#{result.id}")
      title = truncate(result.commentable.body.to_s, length: 30)
    else
      path = '#'
      title = 'Unknown'
    end

    link_to "Comment to #{result.commentable_type}: #{title}", path
  end
end
