class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  private def content_words
    respond_to?(:content) ? content.split(' ') : []
  end
end
