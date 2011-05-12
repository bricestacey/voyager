module Voyager
  module AR
    class Patron < Voyager::AR::Base
      # ActiveRecord Configuration
      set_table_name 'patron'
      set_primary_key 'patron_id'

      # Associations
      has_one :barcode, :foreign_key => 'patron_id', :class_name => 'Voyager::AR::Patron::Barcode'
      has_many :circ_transactions, :class_name => 'Voyager::AR::Circ::Transaction'
    end
  end
end
