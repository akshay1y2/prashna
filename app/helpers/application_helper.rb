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
    content_tag(:div, id: "vote-#{type.to_s}-#{votable.id}") do
      link_to(
        image_tag('upvote.png'), 
        votes_path(type => votable, vote: :up),
        method: :post, remote: true,
        class: "btn btn-sm btn-outline-success #{vote && vote.up? ? 'border-right-0' : 'border-0'}"
      ) +
      content_tag(:em, votable.net_upvotes) +
      link_to(
        image_tag('dnvote.png'),
        votes_path(type => votable, vote: :down),
        method: :post, remote: true,
        class: "btn btn-sm btn-outline-warning #{vote && vote.down? ? 'border-left-0' : 'border-0'}"
      )
    end
  end

  def topic_links(question)
    question.topic_names.map { |t| link_to t, root_path(topic: t) }.join(', ').html_safe
  end
end
