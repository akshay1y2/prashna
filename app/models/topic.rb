class Topic < ApplicationRecord
  has_and_belongs_to_many :users

  validates :name, uniqueness: { case_sensitive: false }, presence: true

  scope :search, ->(name = nil) { where("name like ?", "%#{name}%") }
  scope :by_names, ->(list = []) { where(name: list) }

  def self.extract_names(names = '')
    names.split(",").map(&:strip).reject(&:empty?)
  end

  def self.get_topics_by_names(names = '')
    extract_names(names).map { |name| find_or_initialize_by(name: name) }
  end

  def self.get_ids_by_names(names = '')
    by_names(extract_names(names)).pluck('id')
  end
end
