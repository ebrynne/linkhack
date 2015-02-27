class Link < ActiveRecord::Base
  validates :shortlink, presence: true
  validates :url, presence: true
end
