module Voyager
  module AR
    module Bib
      class Text < Voyager::AR::Base
        set_table_name 'bib_text'
        set_primary_key 'bib_id'
      end
    end
  end
end
