=begin

--------------------------------------------------------

autor: Daniel Schmidt
datum: Tue Mar 17 08:43:50 CET 2009
--------------------------------------------------------
=end

=begin rdoc

All compressing stuff is here. 

=end


module MarkinMessenger
  
  module Acts
    
    module Compress
      
      def self.included(base)
        base.class_eval do
          extend ClassMethods
          include InstanceMethods
        end
      end
      
      module ClassMethods
      end
      
      module InstanceMethods
        
        #:nodoc
        #autor: Daniel Schmidt

        #compresses files 
        #  
        def compress(assets,zip_path)
          zip_archive = zip_path
          FileUtils.rm zip_archive,:force => true
          Zip::ZipFile.open("#{zip_archive}", Zip::ZipFile::CREATE) do |zipfile|
            assets.each do |file|
              zipfile.add(File.basename(file), file) if File.exists?(file)
            end
          end
        end
        
      end
      
    end
    
  end
  
end