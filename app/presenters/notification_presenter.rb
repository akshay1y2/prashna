class NotificationPresenter < ApplicationPresenter
  presents :notification

  @delegation_methods = [:id, :message]

  delegate *@delegation_methods, to: :notification

  def display_message
    "#{id} - #{I18n.t(message)} - "
  end
end
