=begin

--------------------------------------------------------

autor: Daniel Schmidt
datum: Tue Mar 17 08:43:50 CET 2009
--------------------------------------------------------
=end

=begin rdoc

All uncompressing stuff is here. 


=end


module MarkinMessenger
  
  module Acts
    
    module Uncompress
      
      def self.included(base)
        base.class_eval do
          extend ClassMethods
          include InstanceMethods
        end
      end
      
      module ClassMethods
        
        def assets
          @assets ||=[]
        end
      end
      
      module InstanceMethods
        
        #
        # uncompresses zip file and returns path of uncompressed dir
        # 
        def uncompress(zip_path,logo)
          # create a thumbnail dir in source directory
          path = File.dirname(zip_path).to_s
          thumb_dir = "#{RAILS_ROOT}/#{storage_folder}/thumbs/"
          
          FileUtils.mkdir_p(thumb_dir)
          
          @assets = []
          zip = zip_path
          #name = File.basename("#{zip}",zip)
          #p name
          outdir = "#{RAILS_ROOT}/tmp/markin_messenger/#{self.id}/"
          
          #outdir_name = "#{outdir}/#{name}"
          
          #FileUtils.mkdir_p(outdir) unless File.exists?(outdir)
          FileUtils.mkdir_p(outdir) unless File.exists?(outdir)
          
          Zip::ZipFile.open(zip){ |z|
            z.each{ |e|
              fpath = File.join(outdir, e.name)
              #puts "fpath is #{fpath}"
              FileUtils.mkdir_p(File.dirname(fpath))
              z.extract(e,fpath)
              #create_watermark(fpath)
              @assets << fpath unless File.directory?(fpath)
              #create_watermark(fpath) unless File.directory?(fpath)
              unless File.directory?(fpath)
                thumbnail(fpath,thumb_dir)
                do_branding_with_logo(fpath,logo) unless logo.nil?
                do_branding_with_text(fpath) if logo.nil?
              end
            }
          }
          
          return @assets
        #rescue Zip::ZipDestinationFileExistsError => error
        #  return false
        end
        
      end
      
    end
    
  end
  
end