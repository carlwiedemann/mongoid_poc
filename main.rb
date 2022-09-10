require 'bundler'
Bundler.require(:default)
Mongoid.load!("./mongoid.yml", :development)

##
# Author class.
#
class Author
  include Mongoid::Document

  field :first_name, type: String
  field :last_name, type: String

  # Let's look at using relations in different collections.
  # Adding 'dependent means it will be destroyed if it is abandoned'
  has_many :addresses, dependent: :destroy

  # Alternatively, how about relations in the same collection
  # embeds_many :addresses

  # How about tags?
  has_and_belongs_to_many :tags
end

class Address
  include Mongoid::Document

  field :street_primary, type: String
  field :street_secondary, type: String
  field :city, type: String
  field :province, type: String
  field :postal_code, type: String
  field :country, type: String

  # For different collections.
  belongs_to :author

  # For same collection
  # embedded_in :author

  # How about tags?
  has_and_belongs_to_many :tags
end

class Tag
  include Mongoid::Document

  field :name, type: String

  has_and_belongs_to_many :authors
  has_and_belongs_to_many :addresses
end

##
# Main.
#
lambda do

  # Cleanup.
  Author.destroy_all
  Address.destroy_all
  Tag.destroy_all

  ############
  # EXERCISE #
  ############
  # Try to persist an author.
  my_author = Author.new
  my_author.first_name = 'Martin'
  my_author.last_name = 'Fowler'

  my_first_tag = Tag.new
  my_first_tag.name = 'apple'
  my_first_tag.save!

  my_author.tags << my_first_tag
  my_author.save!

  pp my_author

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

  my_second_tag = Tag.new
  my_second_tag.name = 'orange'
  my_second_tag.save!

  my_first_address.tags << my_second_tag

  my_author.addresses = [
    my_first_address
  ]

  # This appears to save everything.
  my_author.save!

  # Observe the relations.
  pp my_author.addresses
  pp my_first_address.author

end.call
