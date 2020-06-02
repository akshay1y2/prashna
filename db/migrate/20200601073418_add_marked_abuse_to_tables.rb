class AddMarkedAbuseToTables < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :marked_abuse, :boolean, default: false, nil: false
    add_column :answers, :marked_abuse, :boolean, default: false, nil: false
    add_column :comments, :marked_abuse, :boolean, default: false, nil: false
  end
end
