module MarkinMessenger
  module Acts
    # Methods included by acts_as_zip method
    #
    #
    module ActsAsZippedMethods
      # adds functionalty for unzipping the self.file
      # 
      #
      def unzip
        assets = []
        thumb_dir = "#{RAILS_ROOT}/#{storage_folder}/thumbs/"
        
        logger.debug "unzip_dir #{thumb_dir}"
        
        FileUtils.mkdir_p(thumb_dir)
        
        Zip::ZipFile.open(self.file_name) do |z|
          z.each do |e|
            #prevent to unzip a fucking __MACOSX folder
            unless e.name.include?("__")
              fpath = File.join(self.storage_folder, e.name)
              #puts "fpath is #{fpath}"
              FileUtils.mkdir_p(File.dirname(fpath))
              z.extract(e,fpath) 
              #create_watermark(fpath)
              assets << fpath unless File.directory?(fpath)
              #create_watermark(fpath) unless File.directory?(fpath)
              #unless File.directory?(fpath)
              #  thumbnail(fpath,thumb_dir)
              # end
            end
          end
        end
        return assets
      end # end unzip
    end
  end
end