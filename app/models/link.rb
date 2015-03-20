require 'uri'

class Link < ActiveRecord::Base
  validates :shortlink, presence: true, uniqueness: true
  validates :url, presence: true, format: { with: URI::regexp(%w(http https)) }
end
