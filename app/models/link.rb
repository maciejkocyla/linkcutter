class Link < ActiveRecord::Base
  require 'open-uri'
  attr_accessible :short_url, :full_url

  VALID_URL = /https?:\/\/[\S]+/ 

  after_save :rebuild_routes
  after_destroy :rebuild_routes

  validates :short_url, presence: true, uniqueness: true
  validates :full_url, presence: true, format: { with: VALID_URL}
  validate :working_link

  def rebuild_routes
    Rails.application.reload_routes!
  end

  def self.search(search)
    if search
      where('full_url LIKE ?', "%#{search}%")
    else
      scoped
    end
  end

  def working_link
    begin
      url = self.full_url
      open(url)
    rescue 
      errors.add(:full_url, "sorry pal, but #{url} doesn't work")    
    end
    
  end
  
end
