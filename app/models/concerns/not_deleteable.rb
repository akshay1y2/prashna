require 'active_support/concern'

module NotDeleteable
  extend ActiveSupport::Concern

  class NotDeleteableException < StandardError
    def initialize(msg="The records are not deleteable.")
      super(msg)
    end
  end

  class_methods do
    ['delete_all', 'delete_by', 'destroy_by'].each do |method|
      define_method(method) { |*_,**__| raise NotDeleteableException }
    end
  end
  included do
    ['delete', 'destroy'].each do |method|
      define_method(method) { |*_,**__| raise NotDeleteableException }
    end
  end
end
