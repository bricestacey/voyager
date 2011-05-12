module Voyager
  module AR
    class Patron
      class Barcode < Voyager::AR::Base
        set_table_name 'patron_barcode'
        set_primary_key 'patron_barcode_id'

        belongs_to :patron, :class_name => 'Voyager::AR::Patron'
      end
    end
  end
end
