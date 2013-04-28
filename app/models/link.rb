class Link < ActiveRecord::Base
  require 'open-uri'
  require 'socket'
  attr_accessible :short_url, :full_url

  VALID_URL = /https?:\/\/[\S]+/ 
  VALID_SHORT_URL =  /^[A-Za-z\d_]+$/
  SELF_URL = /[https?]?linkcutter\.herokuapp\.com[\/\w+\d*]?/

  validates :short_url, format: {with: VALID_SHORT_URL, :message => "Can only be alphanumeric"}, uniqueness: true, :if => :validate_short_url 
  validates :full_url, presence: true, format: { with: VALID_URL}, uniqueness: true
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
      if self.full_url =~ SELF_URL
        errors.add(:full_url, "cannot be me")
      else
        url = self.full_url
        open(url)
      end
    rescue 
      errors.add(:full_url, "You typed or pasted leads to nowhere")    
    end
  end

  def validate_short_url
    if !self.short_url.blank? && self.short_url != "short_link" 
      true
    else
      false
    end
  end
  
end
