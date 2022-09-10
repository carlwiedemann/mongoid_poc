require 'bundler'
Bundler.require(:default)
Mongoid.load!("./mongoid.yml", :development)

##
# Author class.
#
class Author
  include Mongoid::Document
  include Mongoid::Timestamps

  field :first_name, type: String
  field :last_name, type: String
end

##
# Main.
#
lambda do

  # Cleanup.
  Author.delete_all

  # Try to persist an author.
  a = Author.new

  a.first_name = 'Martin'
  a.last_name = 'Fowler'

  pp a

  pp a.save!

  pp a

end.call
