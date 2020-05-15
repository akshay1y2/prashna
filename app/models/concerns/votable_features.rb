require 'active_support/concern'

module VotableFeatures
  extend ActiveSupport::Concern

  included do
    def refresh_votes!
      update_columns(net_upvotes: votes.up_votes.count - votes.down_votes.count)
    end
  end
end
