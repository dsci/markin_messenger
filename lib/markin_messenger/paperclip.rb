=begin

--------------------------------------------------------

autor: Daniel Schmidt
datum: Tue Mar 17 12:06:59 CET 2009
--------------------------------------------------------
=end

=begin rdoc
comment here

=end

module MarkinMessenger
  
  module Acts
    
    module MarkinPaperclip
      def self.included(base)
        base.class_eval do
          #extend ClassMethods
          include InstanceMethods
        end
      end
    end
    
    module InstanceMethods
      
      #
      # returns Paperclip Image Magick path
      #
      def image_magick 
        Paperclip.options[:command_path]
      end
      
      #
      # returns the attachment_object
      #
      def attached_paperclip
        meth = self.markin_attachment.to_s
        self.send meth
      end
      
      #:nodoc
      #autor: Daniel Schmidt

      # calls Paperclip.run
      #  
      def exec_command(command,options = "")
        Paperclip.run(command,options)
      rescue Paperclip::PaperclipCommandLineError
        raise Paperclip::PaperclipError, "There was an error processing the image "
      end
    end
  
  end
  
end