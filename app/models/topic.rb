class Topic < ApplicationRecord
  has_and_belongs_to_many :users

  validates :name, uniqueness: { case_sensitive: false }, presence: true

  #FIXME_AB: We should have a spece after comma and around '='
  scope :search, ->(name=nil) { where("name like ?", "%#{name}%") }
  scope :by_names, ->(list=[]) { where(name: list) }
end
