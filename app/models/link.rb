require 'uri'

class Link < ActiveRecord::Base
  validates :shortlink, presence: true, uniqueness: true
  validates :url, :url => true
end
