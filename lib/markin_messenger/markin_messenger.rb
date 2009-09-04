=begin

--------------------------------------------------------

autor: Daniel Schmidt
datum: Tue Mar 17 08:31:52 CET 2009
--------------------------------------------------------
=end

=begin rdoc
comment here

=end


module MarkinMessenger
  
  module Acts
    
    module ImageExtensions
      
      def self.included(base)
        base.class_eval do
          include InstanceMethods
          extend ClassMethods
          
        end
      end
      
      class MarkinMessengerError < StandardError #:nodoc:
      end
      
      module ClassMethods
        
        # put this function in your ActiveRecord::Base Model
        # 
        #  attr is a hash:
        # :zip => {:compress => :false}, :style => {:size => "200x200"}, :watermark => {:text => "Lorem ipsum"}
        #
        def print_with_watermark_for(*attributes)
          
          before_destroy :destroy_unzipped_files
          
          # declare a relation to unzipped images
          has_many :unzipped_images, :class_name => "UnzippedImage", :foreign_key => "asset_id", :dependent => :destroy
          
          
          include MarkinMessenger::Acts::Watermark
          include MarkinMessenger::Acts::Compress
          include MarkinMessenger::Acts::Uncompress
          include MarkinMessenger::Acts::MarkinThumbnail
          include MarkinMessenger::Acts::MarkinFile
          
          opt = attributes.last.is_a?(Hash) ? attributes.pop : {}
          
          attachment = attributes.first
          
          compress = true # should we compress files again ? default value 
          
          folder = "public/#{self.name.downcase}" # folder for thumbs
          
          printover_for_thumb = "Preview"
          
          unless opt.empty?
            compress = opt[:zip][:compress] if opt.has_key?(:zip)
            style = opt[:style][:size] if opt.has_key?(:style)
            watermark = opt[:watermark][:text] if opt.has_key?(:watermark)
            folder = "public/#{opt[:storage][:folder]}" if opt.has_key?(:storage)
            printover_for_thumb = opt[:thumb][:printover] if opt.has_key?(:thumb)
          end
          
          define_method(:watermark_text){ return watermark } unless watermark.nil?
          
          define_method(:compress?){return compress }
          
          define_method(:assets=){|var| instance_variable_set(:@assets, var)}
          
          define_method(:assets){instance_variable_get(:@assets)}
          
          # use this to calculate the price of each single asset in zip file
          define_method(:assets_inside){ instance_variable_get(:@assets)}
          
          define_method(:print_over_for_thumb){ return printover_for_thumb}
          
          define_method(:storage_folder) do
            id = send(:id)
            return "#{folder}/#{id}"
          end
          
          define_method(:styles){ return style } unless style.nil?
          
          # get the filepath of zipset
          # get the path of imagemagick
          if self.respond_to?(:has_attached_file) # class uses paperclip
            include MarkinMessenger::Acts::MarkinPaperclip
            define_method(:markin_attachment){ return attachment.to_sym}
          else
            #nothing happens here yet
          end
          
        end
        
      end
      
      module InstanceMethods
        
        #:nodoc
        #autor: Daniel Schmidt

        # unzips attached file and stick some watermarks on the images 
        # if compress is true it zips the content of the attached zip back to its 
        # archive on source path 
        def watermark(logo)
          zip_path = attached_paperclip.path
          assets = uncompress(zip_path,logo)
          
          compress(assets,zip_path) if compress?
          
          save_assets
        rescue MarkinMessengerError => me
          p me
          return false
        end
        
        alias_method :do_watermarking,:watermark
        alias_method :mark_set,:watermark
        
        #:nodoc
        #autor: Daniel Schmidt

        # removes unzipped_files from db and filesystem
        #  
        def destroy_unzipped_files
          FileUtils.rm_rf(storage_folder)
        end
        
        
        protected
        
        
        # saves each unzipped asset to the db and moves it 
        # back to its sourceplace
        #
        def save_assets
          raise ArgumentError if @assets.empty?
          raise ArgumentError if @assets.nil?
        
          path_for_asset = asset_file_path(attached_paperclip.path)
          
          #unzipped = []
          
          @assets.each do |a|
            # get filename 
            fname = File.basename(a)
            # save asset to db
            unzipped_image = UnzippedImage.new
            unzipped_image.filename = "#{path_for_asset}/#{fname}"
            unzipped_image.download_key = generate_download_key_for("#{path_for_asset}/#{fname}")
            unzipped_image.price = assign_price_for_unzipped()
            
            unzipped_image.save!
            #self.unzipped_images << unzipped_image
            
            unzipped_images << unzipped_image
            
            #self.update_attribute(:unzipped_images,unzipped)
            
            # move asset to new path
            move_asset_to_folder(a,path_for_asset)
          end
          
          
        end
        
        def assign_price_for_unzipped
        end
        
    
      end
      
    end
    
  end
  
end