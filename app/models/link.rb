require 'uri'

class Link < ActiveRecord::Base
  validates :shortlink, presence: true, uniqueness: true
  validates :url, :url => true

  def self.search(query)
    if query.present?
      Link.where("shortlink like '%#{query}%' OR description like '%#{query}%' OR url like '%#{query}%'").all
    else
      Link.all
    end
  end
end
