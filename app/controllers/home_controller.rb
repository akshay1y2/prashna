class HomeController < ApplicationController
  #FIXME_AB: skip specific actions
  skip_before_action :authorize

  def index
  end
end
