=begin

--------------------------------------------------------

autor: Daniel Schmidt
datum: Wed Mar 18 12:28:30 CET 2009
--------------------------------------------------------
=end

=begin rdoc

This module provides the thumbnail creating of the unzipped 
images.

=end

module MarkinMessenger
  module Acts
    module MarkinThumbnail
      
      def self.included(base)
        base.class_eval do
          include InstanceMethods
          extend ClassMethods
        end
      end
    
      module InstanceMethods
        
        
        # creates the thumbnail 
        # file is the path of the source 
        # thumb_dir is a directory string where the thumb has to be stored in
        def thumbnail(file,thumb_dir)
          file_bases = File.split(file)
          
          output = "#{thumb_dir}/thumb_#{file_bases[1]}"
          
          geometry = Paperclip::Geometry.parse(styles)
          im_scales = geometry.transformation_to(geometry,true)
          
          command = "convert"
          
          options = "#{file} -resize #{im_scales[0]} -gravity center  -crop #{im_scales[1]} +repage #{output}"
          
          exec_command(command,options)
          
          do_branding_with_text(output,print_over_for_thumb,"WEST",22)
          
        end
      
      end
      
      module ClassMethods
      
      end
    
    end
  end
end
