require 'net/http/post/multipart'

require 'stringio'

class File
  def continue_timeout()
    sleep 2
  end
end

class Net::HTTPGenericRequest
  def write_tmp(filename="tmp.tmp")
    File.open(filename,'w') do |out|
      exec(out, '1.1', path)
    end
  end
end


module Mspire
  module Mascot
    class Submit
      def initialize(data={})
        @data = data
      end

      def submit!(file=nil)
        file = '/home/jtprince/dev/mspire-mascot-dat/spec/testfiles/two_spectra.mgf'

        @data = {
          URL: 'http://jp1.chem.byu.edu/mascot/cgi/nph-mascot.exe?1',
          INTERMEDIATE: '',
          FORMVER: 	'1.01',
          SEARCH: 	'MIS',
          PEAK: 	'AUTO',
          REPTYPE: 	'peptide',
          ErrTolRepeat: 	'0',
          SHOWALLMODS: '',
          USERNAME: 	'John Smith',
          USEREMAIL: 	'jtprince@gmail.com',
          COM: 	'Charles from browser try number 2',
          DB: 	'GbetaCCT_drome',
          CLE: 	'Trypsin',
          PFA: 	'1',
          QUANTITATION: 'None',
          TAXONOMY: 	'All entries',
          MODS: 	'Carbamidomethyl (C)',
          IT_MODS: 	'Oxidation (M)',
          TOL: 	'1.2',
          TOLU: 	'Da',
          PEP_ISOTOPE_ERROR: 	'1',
          ITOL: 	'0.6',
          ITOLU: 	'Da',
          CHARGE: 	'2+',
          MASS: 	'Monoisotopic',

          ## These are all associated as one object!!
          #FILE: 	'two_spectra.mgf',
          #Size: 	'12.45 KB (12745 bytes)',
          #Content: '-Type	application/octet-stream',
            
          FORMAT: 	'Mascot generic',
          PRECURSOR: 	'',
          INSTRUMENT: 	'ESI-TRAP',
          DECOY: 	'1',
          REPORT: 	'AUTO',
        }
        # http://stackoverflow.com/questions/12097491/uploading-a-file-using-ruby-nethttp-api-to-a-remote-apache-server-failing-with

        #uri = "http://jp1.chem.byu.edu/mascot/cgi/search_form.pl?FORMVER=2&SEARCH=MIS"
        #uri = "http://jp1.chem.byu.edu/mascot/cgi/search_form.pl"
        #uri = "http://jp1.chem.byu.edu/mascot/cgi/nph-mascot.exe?1"

        uri = @data.delete(:URL)

        url = URI.parse(uri)

        basename = File.basename(file)

        File.open(file) do |io|
          # MAYBE
          #@data['Content-Type'] = 'text/html'
          @data["FILE"] = UploadIO.new(io, "application/octet-stream", basename)
          @data.keys.each {|k| @data[k.to_s] = @data.delete(k) }
          #@data['Size'] = io.size
          req = Net::HTTP::Post::Multipart.new(url.path, @data, headers={}, "---------------------------117983339220455289611819249521")
          http = Net::HTTP.new(url.host, url.port)
          http.set_debug_output $stderr # DUMP
          #req.write_tmp
          res = http.start {|http| http.request(req) }
          #abort 'here'
          #res = Net::HTTP.start(url.host, url.port) do |http|
          #  p http
          #  reply = http.request(req)
          #  sleep 4
          #  p reply
          #end
          puts "AFTER REQUEST!!!!"
          p res
          p res.methods - Object.new.methods
          #begin
          #  puts "#{methd}: #{res.send(methd)}"
          #rescue
          #end
          p res.to_hash

          ### You should choose better exception.
          #raise ArgumentError, 'HTTP redirect too deep' if limit == 0

          #url = URI.parse( uri_str )

          #req = Net::HTTP::Get.new url.path

          #http = Net::HTTP.new(url.host, url.port)
          #if url.scheme == "https"
          #http.use_ssl = url.port == 443
          #end

          ##http.set_debug_output $stderr if true  # dump out stuff
          #begin
          #response = http.start { |http| http.request(req) }
          #case response
          #when Net::HTTPRedirection 
          #then
          #http_fetch(response['location'], temp_file_name, limit - 1 )

          #when Net::HTTPSuccess
          #then
          #file = ::Tempfile.new( temp_file_name )
          #file.binmode
          #file.unlink
          #file.write( response.body )
          #file.rewind
          #file
          #else
          #response.error!
          #end
          #end
          #rescue EOFError
          ## Reached the end of the response
          #end



        end

        #:get_fields, :each_header, :each, :each_name, :each_key, :each_capitalized_name, :each_value, :delete, :key?, :to_hash, :each_capitalized, :canonical_each, :range, :set_range, :range=, :content_length, :content_length=, :chunked?, :content_range, :range_length, :content_type, :main_type, :sub_type, :type_params, :set_content_type, :content_type=, :set_form_data, :form_data=, :set_form, :basic_auth, :proxy_basic_auth, :connection_close?, :connection_keep_alive?]
      end

    end

  end
end
