require File.dirname(__FILE__) + '/spec_helper'

describe MarkinMessenger, "styles options for thumbnails" do
  before(:each) do
    @is = ImageSet.new
    @is.id = 10
    
    @file = "#{RAILS_ROOT}/vendor/plugins/markin_messenger/assets/logo.png"
  end
  
  it "should provide an styles method" do
    @is.methods.include?("styles").should be true
  end
  
  it "should provide an styles method which returns a size string" do
    @is.styles.class.should be String
  end
  
  it "should provide an thumbnail method" do
    @is.methods.include?("thumbnail").should be true
  end
  
  it "should return paperclip geometry " do
    #p @is.thumbnail(@file,@is.storage_folder).transformation_to(@is.thumbnail(@file,@is.storage_folder),true)
    #@is.thumbnail(@file).class.should be Array 
  end
  
  it "should return a storage folder" do
    @is.storage_folder.should == "public/imageset/#{@is.id}"
  end
  
end

