class HomeController < ApplicationController
  def index
    @questions = Question.all_published.order(published_at: 'desc')
  end

  def filter
    @questions = Question.all_published
  end
end
