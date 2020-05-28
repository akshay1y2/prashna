module Api
  class QuestionsController < BaseController
    def index
      @questions = Question.all
      respond_to do |format|
        format.json
      end
    end
  end
end