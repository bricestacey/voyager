module Voyager
  module AR
    class Item < Voyager::AR::Base
      # ActiveRecord Configuration
      set_table_name 'item'
      set_primary_key 'item_id'

      # Associations
      has_one :barcode, :foreign_key => 'item_id', :class_name => 'Voyager::AR::Item::Barcode'
      has_one :circ_transaction, :class_name => 'Voyager::AR::Circ::Transaction'

      has_one :bib_text, :through => :bib_item, :class_name => 'Voyager::AR::Bib::Text'
      has_one :bib_item, :foreign_key => 'item_id', :class_name => 'Voyager::AR::Bib::Item'

      # Class Methods
      def charged?
        circ_transaction.nil? ? false : true
      end
    end
  end
end
