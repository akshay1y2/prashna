class CreateApiRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :api_requests do |t|
      t.string :client_ip, default: '', null: false
      t.string :path, default: '/api/', null: false

      t.datetime :created_at, null: false
    end
  end
end
