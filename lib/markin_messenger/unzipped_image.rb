=begin

--------------------------------------------------------

autor: Daniel Schmidt
datum: Wed Mar 18 14:28:46 CET 2009
--------------------------------------------------------
=end

=begin rdoc
comment here

=end

class UnzippedImage < ActiveRecord::Base
 include CryptieHasher
 
 belongs_to :image_set,:class_name => "ImageSet", :foreign_key => "asset_id"
 
 before_destroy :destroy_file
 
 # returns an thumbnail path for image_tags
 # => /images/set/id/thumb_020.jpg
 def thumbnail_url(size = :thumb)
   prefix = size.to_s
   
   fdir = File.dirname(self.filename)
   basename = File.basename(self.filename)
   
   public_dir = fdir.split("#{RAILS_ROOT}/public")[1]
   #return "/#{image_set.storage_folder}/#{size}_#{basename}"
   dir = image_set.storage_folder.gsub("public","")
   return "#{dir}/thumbs/#{size}_#{basename}"
 end
 
 def destroy_file
  FileUtils.rm_f(self.filename)
 end
 
 
end