class Topic < ApplicationRecord
  has_and_belongs_to_many :users

  validates :name, uniqueness: { case_sensitive: false }, presence: true

  scope :search, ->(name) { where("name like ?", "%#{name}%") }
  scope :by_name, ->(list) { where(name: list) }
end