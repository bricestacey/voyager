module Voyager
  module AR
    class Item
      class Barcode < Voyager::AR::Base
        set_table_name 'item_barcode'
        set_primary_key 'item_id'

        belongs_to :item, :class_name => 'Voyager::AR::Item'
      end
    end
  end
end
