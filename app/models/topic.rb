class Topic < ApplicationRecord
  has_and_belongs_to_many :users

  validates :name, uniqueness: { case_sensitive: false }, presence: true

  #FIXME_AB: default value name = nil
  scope :search, ->(name) { where("name like ?", "%#{name}%") }
  #FIXME_AB: default values name = [] and rename by_names
  scope :by_name, ->(list) { where(name: list) }
end
