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

  embeds_many :addresses
end

class Address
  include Mongoid::Document
  include Mongoid::Timestamps

  field :street_primary, type: String
  field :street_secondary, type: String
  field :city, type: String
  field :province, type: String
  field :postal_code, type: String
  field :country, type: String
end

##
# Main.
#
lambda do

  # Cleanup.
  Author.destroy_all

  # Try to persist an author.
  my_author = Author.new
  my_author.first_name = 'Martin'
  my_author.last_name = 'Fowler'

  pp my_author
  pp my_author.save!
  pp my_author

  my_first_address = Address.new
  my_first_address.street_primary = '3902 Midsummer Ln S'
  my_first_address.city = 'Colorado Springs'
  my_first_address.province = 'Colorado'
  my_first_address.postal_code = '80917'
  my_first_address.country = 'US'

  my_author.addresses = [
    my_first_address
  ]

  pp my_author
  pp my_author.save!
  pp my_author

  # Ok, let's actually see the persistence behavior that we expect.
  my_second_address = Address.new
  my_second_address.street_primary = '2233 Collegiate Dr'
  my_second_address.city = 'Colorado Springs'
  my_second_address.province = 'Colorado'
  my_second_address.postal_code = '80918'
  my_second_address.country = 'US'

  # THIS ACTUALLY PERSISTS INFORMATION!!!!!!!!! RAGE RAGE RAGE
  my_author.addresses = [
    my_second_address
  ]

end.call
