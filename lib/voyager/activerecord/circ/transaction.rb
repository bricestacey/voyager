module Voyager
  module AR
    module Circ
      class Transaction < Voyager::AR::Base
        # ActiveRecord Configuration
        set_table_name 'circ_transactions'
        set_primary_key 'circ_transactions_id'

        # AR Associations
        belongs_to :item, :class_name => 'Voyager::AR::Item'
      end
    end
  end
end
