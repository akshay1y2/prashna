module ApplicationHelper
  def errors_explanation_div(model)
    return if model.blank? || model.errors.empty?
    content_tag(:div, id: "error_explanation") do
      header = "#{pluralize(model.errors.count, 'error')} prohibited this #{model.class.name} from being saved:"
      list_items = model.errors.full_messages.map { |msg| content_tag(:li, msg) }
      content_tag(:h2, header) + content_tag(:ul, list_items.join.html_safe)
    end
  end

  def votes_div(type, votable)
    vote = Vote.by_user(current_user).on_votable(votable).first
    enable = current_user.id != votable.user_id
    content_tag(:div, id: "vote-#{type.to_s}-#{votable.id}") do
      link_to_if(
        enable,
        image_tag('upvote.png'), 
        votes_path(type => votable, vote: :up),
        method: :post, remote: true,
        class: "btn btn-sm rounded-circle #{vote && vote.up? ? 'btn-success mr-1' : 'btn-outline-success'}"
      ) +
      content_tag(:em, votable.net_upvotes, class: 'm-1 h6') +
      link_to_if(
        enable,
        image_tag('dnvote.png'),
        votes_path(type => votable, vote: :down),
        method: :post, remote: true,
        class: "btn btn-sm rounded-circle #{vote && vote.down? ? 'btn-warning ml-1' : 'btn-outline-warning'}"
      )
    end
  end

  def topic_links(question)
    question.topic_names.map { |t| link_to t, root_path(topic: t) }.join(', ').html_safe
  end
end
