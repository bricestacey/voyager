module Voyager
  module AR
    module Bib
      class Item < Voyager::AR::Base
        set_table_name 'bib_item'
        set_primary_key 'bib_id'

        has_one :bib_text, :foreign_key => :bib_id, :class_name => 'Voyager::AR::Bib::Text'
      end
    end
  end
end
