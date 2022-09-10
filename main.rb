require 'bundler'
Bundler.require(:default)
Mongoid.load!("./mongoid.yml", :development)

##
# Person class.
#
class Person
  include Mongoid::Document

  field :first_name, type: String
  field :last_name, type: String

  embeds_one :address, as: :addressable
end

##
# Business class.
#
class Business
  include Mongoid::Document

  field :name, type: String

  embeds_one :address, as: :addressable
end

##
# Address class.
#
class Address
  include Mongoid::Document

  field :street_primary, type: String
  field :street_secondary, type: String
  field :city, type: String
  field :province, type: String
  field :postal_code, type: String
  field :country, type: String

  embedded_in :addressable
end

##
# Main.
#
lambda do

  # Cleanup.
  Person.destroy_all
  Business.destroy_all

  ############
  # EXERCISE #
  ############
  my_person = Person.new
  my_person.first_name = 'Martin'
  my_person.last_name = 'Fowler'

  my_person.save!

  my_business = Business.new
  my_business.name = 'Spalding'

  my_business.save!

  ############
  # EXERCISE #
  ############
  # Persist an address.
  my_first_address = Address.new
  my_first_address.street_primary = '3902 Midsummer Ln S'
  my_first_address.city = 'Colorado Springs'
  my_first_address.province = 'Colorado'
  my_first_address.postal_code = '80917'
  my_first_address.country = 'US'

  my_person.address = my_first_address

  # This appears to save everything.
  my_person.save!

  # Persist an address.
  my_second_address = Address.new
  my_second_address.street_primary = '2233 Collegiate Dr'
  my_second_address.city = 'Colorado Springs'
  my_second_address.province = 'Colorado'
  my_second_address.postal_code = '80918'
  my_second_address.country = 'US'

  my_business.address = my_second_address

  # This appears to save everything.
  my_business.save!

  # Observe the relations.
  pp my_person.address
  pp my_first_address.addressable

  # Observe the relations.
  pp my_business.address
  pp my_second_address.addressable

end.call
