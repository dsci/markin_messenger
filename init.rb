require 'zip/zip' #zip upload
require 'zip/zipfilesystem' # zip upload

require 'markin_messenger'

ActiveRecord::Base.send :include, MarkinMessenger::Acts::ImageExtensions