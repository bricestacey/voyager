module Voyager
  module SIP
    class Client
      include BasicSipClient
      #--
      # Sends a Login Message
      #
      # Example login request:
      #    9300CNusername|COpassword|CPCIRC|
      # Example login response:
      #   941
      #++
      def login(username, password, location)
        msg = "9300CN#{username}|CO#{password}|CP#{location}|\r"

        send(msg) do |response|
          response = parse_login(response)

          raise "Invalid login: #{response[:raw]}" unless response[:ok] == '1'

          if block_given?
            yield response
          end

          response
        end
      end

      def parse_login(msg)
        match = msg.match(/^94(0|1)\r$/)
        if match
          {:raw => msg,
           :id => 94,
           :ok => match[1]}
        end
      end

      #--
      # Sends a Create Bib Message
      #
      # Example create bib request:
      #   8120100813    133505AO|MFSelfchk|AJThe transformation of learning : / *77087*|AB77087|AC|^M
      # Example create bib response:
      #   821MJ633124|MA630995|AFCreate Bib successful.|^M
      #++
      def create_bib(operator, title, barcode)
        msg = "81#{self.timestamp}|AO|MF#{operator}|AJ#{title}|AB#{barcode}|AC|"

        send(msg) do |response|
          response = parse_create_bib(response)

          # Bib/MFHD/Item create failed
          raise "Bib/MFHD/Item create failed: #{response['raw']}" if response[:ok] == '0'

          # Bib was created, but not the item
          #
          # This is possible if we have a duplicate barcode, however we
          # check for that. Possible race condition, though unlikely.
          #
          # Store the bib_id for troubleshooting
          raise "Duplicate barcode. A bib exists without an item and should be deleted: #{response['raw']}" if response[:item_id].empty?


          if block_given?
            yield response
          end

          response
        end
      end

      def parse_create_bib(msg)
        # 821MJ640267|MA818432|AFCreate Bib successful.|
        # [2] - OK? 1:yes, 0:no
        # MJ - Item number
        # MA - Bib number
        # AF - Print screen
        match = msg.match(/^82(.)MJ(.*)\|MA(.*)\|AF(.*)\|\r$/)
        if match
          {:raw => msg,
           :id => 82,
           :ok => match[1],
           :item_id => match[2],
           :bib_id => match[3],
           :print_msg => match[4]
          }
        end
      end

      def item_status(item_identifier)
        msg = "17#{self.timestamp}|AO|AB#{item_identifier}|AC|"

        send(msg) do |response|
          response = parse_item_status(response)

          if block_given?
            yield response
          end

          response
        end
      end

      def parse_item_status(msg)
        # 1803000120110408    150732CF0|AH|CJ|AB96917|AJBokml - Test for Nostos *96917*|BGHealey_Library|AQCirculation Desk|AFItem Info retrieved successfully.|
        match = msg.match(/^18([0-9]{2})([0-9]{2})([0-9]{2})(.{18})(.*)\r$/)
        # 1 - Circulation Status
        # 2 - Security Marker
        # 3 - Fee Type
        # 4 - Transaction Date
        # 5 - Variable Fields
        var_fields = msg.scan(/([A-Z]{2})([^|]*)\|/)
        if match
          r = {:raw => msg,
               :id => 18,
               :circ_status => match[1],
               :security_marker => match[2],
               :fee_type => match[3],
               :transaction_date => match[4],
          }
          var_fields.each do |field|
            r[field.first.to_sym] = field.last
          end
          r
        end
      end

      # Utilities
      def timestamp
        Time.now.strftime("%Y%m%d    %H%M%S")
      end
    end
  end
end
