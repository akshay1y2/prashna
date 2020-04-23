class HomeController < ApplicationController
  def index
    @questions = Question.all_published.order(published_at: 'desc')
  end
end
