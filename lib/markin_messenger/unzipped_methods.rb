module MarkinMessenger
  
  module Acts
    
     # Methods included by acts_as_unzipped method
      #
      #
      module ActsAsUnzippedMethods
        
        # returns an thumbnail path for image_tags
         # => /images/set/id/thumb_020.jpg
         def thumbnail_url(size = :thumb)
           prefix = size.to_s

           #fdir = File.dirname(self.filepath)
           basename = File.basename(self.filepath)
           
           #public_dir = fdir.split("#{RAILS_ROOT}/public")[1]
           #return "/#{image_set.storage_folder}/#{size}_#{basename}"
           
           #logger.debug "public dir: #{public_dir}"
           
           # WE HAVE TO CHANGE image_set.storage_folder to some settable stuff!
           #dir = self.storage_folder.gsub("public","")
           
           public_dir = self.storage_folder.split("public")[1]
           
           return "#{public_dir}#{basename}"
         end

         def destroy_file
          FileUtils.rm_f(self.filename)
         end
        
         def move
           logger.debug "move filepath #{self.filepath}"
           default_dir = "#{RAILS_ROOT}/tmp/markin_messenger/#{self.id}"
           FileUtils.mv(self.filepath, self.storage_folder)
           basename = File.basename(self.filepath)
           self.filepath = "#{self.storage_folder}/#{basename}"
         rescue
           # then something is wrong the moving. 
         end
        
      end
          
  end
  
end