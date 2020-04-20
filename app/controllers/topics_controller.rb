class TopicsController < ApplicationController
  def search
    #FIXME_AB: move presentation to .jbuilder
    topics = Topic.search(params[:q]).map { |t| { id: t.id, label: t.name, name: t.name } }
    render json: topics
  end
end
