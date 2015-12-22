require 'textacular'

class Event < ActiveRecord::Base.extend(Textacular)
  belongs_to :venue
  belongs_to :category
  has_many :ticket_types
  has_one :user

  validates_presence_of :extended_html_description, :venue, :category, :starts_at
  validates_uniqueness_of :name, uniqueness: {scope: [:venue, :starts_at]}

  def is_past_event?
    return false if !self.ends_at

    self.ends_at <= DateTime.now
  end

  def self.upcoming_events
  	where("ends_at > ? AND published = ?", DateTime.now, true)
  end

  def self.search(query)
  	basic_search(query).where('published = ?', true)
  end
end
