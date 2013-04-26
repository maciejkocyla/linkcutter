class Link < ActiveRecord::Base
  require 'open-uri'
  attr_accessible :short_url, :full_url

  VALID_URL = /https?:\/\/[\S]+/ 
  VALID_SHORT_URL =  /^[A-Za-z\d_]+$/

  validates :short_url, presence: true, uniqueness: true 
  validates :short_url, format: {with: VALID_SHORT_URL, :message => "Can only be alphanumeric"}
  validates :full_url, presence: true, format: { with: VALID_URL}
  validate :working_link

 
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
      errors.add(:full_url, "You typed or pasted leads to nowhere")    
    end
    
  end
  
end
