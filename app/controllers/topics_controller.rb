class TopicsController < ApplicationController
  def search
    @topics = Topic.search(params[:q])
  end
end
