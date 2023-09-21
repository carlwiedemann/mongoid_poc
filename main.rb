require 'bundler'
Bundler.require(:default)
Mongoid.load!("./mongoid.yml", :development)

class Person
  include Mongoid::Document

  field :first_name, type: String
  field :last_name, type: String

  has_one :address, autosave: false
end

class Address
  include Mongoid::Document

  field :street_primary, type: String
  field :street_secondary, type: String
  field :city, type: String
  field :province, type: String
  field :postal_code, type: String
  field :country, type: String

  belongs_to :person
end

# 1. Create an instance of a `Person` document.
my_person = Person.new
my_person.first_name = 'Martin'
my_person.last_name = 'Fowler'

# 2. Persist the `Person` instance to disk.
my_person.save!

# 3. Create an instance of an `Address` document.
my_address = Address.new
my_address.street_primary = '3902 Midsummer Ln S'
my_address.city = 'Colorado Springs'
my_address.province = 'Colorado'
my_address.postal_code = '80917'
my_address.country = 'US'

# 4. Set the `Address` instance as a child object of the `Person` instance.
my_person.address = my_address

# 5. At this point, I would expect that the `Person` instance that was persisted to disk in step (2) above does not
# yet contain any `Address` child document also persisted to disk, because we have only assigned the `Address`
# instance in memory, it has not been explicitly persisted. Therefore, I would expect it would be necessary to actually
# call `my_person.save!` in order to persist the `Address` as a child document.

# my_person.save! # Not calling this, on purpose.

# 6. Below we note that the association *was* persisted to disk, despite never being saved. I would expect this line to
# print nil, but it instead prints an instance of the address record, and I confirmed that the record was written using
# Mongodb Compass.
pp my_person.reload.address

# This behavior is consistent regardless of whether the association is embedded or non-embedded, and regardless of the
# value of the `autosave` option.
