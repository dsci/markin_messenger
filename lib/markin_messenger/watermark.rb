=begin

--------------------------------------------------------

autor: Daniel Schmidt
datum: Tue Mar 17 08:39:45 CET 2009
--------------------------------------------------------
=end

=begin rdoc

Stick a watermark on each image which was found in given 
directory.

The directory is temporary.  

=end

module MarkinMessenger
  
  module Acts
    
    module Watermark
      
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

        
        # creates the watermark for each entry
        # if watermark_logo was defined, watermark_text would be ignored!!!
        # logo is a paperclip attachment
        def do_branding_with_logo(path,logo)
          watermark_logo = logo
          command = "convert"
          options = "#{watermark_logo} -fill grey50 -colorize 40  miff:- | composite -dissolve 70 -gravity SouthEast -  #{path} #{path}"
          exec_command(command,options)
        rescue
          return false
        end
        
        def do_branding_with_text(path,text = nil,gravity=nil,pointsize=nil)
          watermarked_text = text.nil? ? watermark_text : text
          pointsize = pointsize.nil? ? "" : "-pointsize #{pointsize}"
          gravity = gravity.nil? ? "SouthEast" : gravity
          command = "convert"
          options = "#{path}  -fill white  -undercolor '#00000080' #{pointsize} -gravity #{gravity} -annotate +30+5  ' #{watermarked_text} ' #{path}"
          #p options
          exec_command(command,options)
        rescue
          return false
        end
      end
      
    end
  
  end
  
end