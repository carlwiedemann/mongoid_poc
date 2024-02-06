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

  def ==(other)
    if other.is_a?(Address)
      other&.country == country
    end

    false
  end
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

# 5. Let us confirm that the address was persisted to disk.
pp my_person.reload.address
pp my_person.reload

# 6. However, let us now create a separate address object, which is identical aside from the city name.
my_address2 = Address.new
my_address2.street_primary = '3902 Midsummer Ln S'
my_address2.city = 'Denver'
my_address2.province = 'Colorado'
my_address2.postal_code = '80917'
my_address2.country = 'US'

# 7. We will set this as the value.
my_person.address = my_address2

# 8. However, because we have overridden equality `#==` we now see that in mongoid the document was not persisted.
# But for ActiveRecord, it is indeed persisted, because it does not check equality.
pp my_person.reload.address
pp my_person.reload

