class Link < ActiveRecord::Base
  attr_accessible :short_url, :full_url

  VALID_URL = /https?:\/\/[\S]+/ 

  after_save :rebuild_routes
  after_destroy :rebuild_routes

  validates :short_url, presence: true, uniqueness: true
  validates :full_url, presence: true, format: { with: VALID_URL}

  def rebuild_routes
    Rails.application.reload_routes!
  end

  
end
