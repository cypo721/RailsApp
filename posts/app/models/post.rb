class Post < ActiveRecord::Base
  has_and_belongs_to_many :tags
  validates_presence_of :autor, :title, :body
  validates_presence_of :tags_string, :message => 'must have at least one tag'

  attr_accessor :tags_string

  def tags_string
    string = ""
    tags.each { |t| string = string + t.name + ', ' }
    string[0...-2]
  end
end
