=begin

--------------------------------------------------------

autor: Daniel Schmidt
datum: Wed Mar 18 14:44:50 CET 2009
--------------------------------------------------------
=end

=begin rdoc

This module moves the thumbs and unzipped images back to its
source place. 

=end

module MarkinMessenger
  
  module Acts
  
    module MarkinFile
      
      def self.included(base)
        base.class_eval do
          include InstanceMethods
        end
      end
      
      module InstanceMethods
        
        #
        # creates a new asset directory for unzipped files
        #
        def asset_file_path(zip_path)
          path = File.dirname(zip_path)
          new_path = "#{path}/unzipped"
          FileUtils.mkdir_p(new_path) unless File.exists?(new_path)
          return new_path
        end
        
        #:nodoc
        #autor: Daniel Schmidt

        # moves the asset to the given folder
        #  
        def move_asset_to_folder(asset,folder)
          FileUtils.move(asset,folder, :force => true)
        end
      end
      
    end
  end
end