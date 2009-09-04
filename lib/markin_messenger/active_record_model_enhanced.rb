=begin

--------------------------------------------------------

author: Daniel Schmidt
date: Fri Sep  4 10:59:25 CEST 2009
--------------------------------------------------------
=end

=begin rdoc
...comment here...

=end

module MarkinMessenger
  
  module Acts
    
    module ActiveRecordModelEnhanced
      
      def self.included(base)
        base.class_eval do
          extend ClassMethods
          
        end
      end
      
      module ClassMethods
        
        
        # Includes a bunch of instance methods. acts_as_unzipped could have a hash as attribute with the following
        # keys:
        #   :storage_folder - a path within RAILS ROOT/public - if you want to set a storage path outside public use the :public => false key  
        #   :public - default its true. If public is false the storage path is within RAILS_ROOT but not in public. 1
        #   :style- the size for paperclip cropping and resizing (as string)
        def acts_as_unzipped(opt={})
          include MarkinMessenger::Acts::MarkinThumbnail # include instance methods for creating a thumbnail
          include MarkinMessenger::Acts::ActsAsUnzippedMethods # include all instance methods for ActsAsUnzipped Model 
          unless opt.empty?
            
            #default_values
            public_storage = "public"
            storage_folder = ""
            
            if opt.has_key?("public") 
              public_storage = opt[:public].eql?("true") ? "public" : ""  
            end
            
            define_method(:storage_folder) do
              return "#{RAILS_ROOT}/#{public_storage}/#{storage_folder}"
            end
            
            define_method(:styles) do 
              return opt[:style]
            end
            
          end
        end
        
        
        # Includes a bunch of instance methods. 
        #
        # :paperclip_file - the generated paperclip filename
        def acts_as_zipped(opt={})
          include MarkinMessenger::Acts::ActsAsZippedMethods
          
          unless opt.empty?
            logger.debug "inspect acts_as_zipped #{opt.has_key?(:paperclip_file)}"
            raise MarkinMessenger::Errors::PaperclipFilePathMissingError, "No paperclip filename given" unless opt.has_key?(:paperclip_file)
            paperclip_file_name = opt[:paperclip_file]
            
            define_method(:file_name) do
              attachment = self.send(paperclip_file_name.to_s)
              return attachment.path
            end
            
            define_method(:storage_folder) do
              return "#{RAILS_ROOT}/tmp/markin_messenger/#{self.id}"
            end
          end 
        end
      
      end
     end
  end
end