class Link < ActiveRecord::Base
  validates :shortlink, presence: true, uniqueness: true
  validates :url, presence: true
end
