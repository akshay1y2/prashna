module Admin
  class BaseController < ApplicationController
<<<<<<< HEAD
    layout 'admin'

=======
>>>>>>> fixed CR changes
    before_action :authorize_admin

    private def authorize_admin
      unless current_user.admin?
        redirect_to root_path, notice: t('.access_denied')
      end
    end
  end
end
