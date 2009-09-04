require File.dirname(__FILE__) + '/spec_helper'

class Watermark
  attr_accessor :path
  
  def initialize
    @path = "#{RAILS_ROOT}/vendor/plugins/markin_messenger/assets/logo.png"
  end
end

describe MarkinMessenger, "instance methods" do
  before(:each) do
    @is = ImageSet.new
  end
  
  it "should provide the image magick path options" do
    @is.methods.include?("image_magick").should be true
  end
  
  it "should provide an uncompress option" do
    @is.methods.include?("uncompress").should be true
  end
  
  it "should provide an watermark option" do
    @is.methods.include?("watermark").should be true
  end
  
  it "should have asset instance variable defined" do
     @is.methods.include?("assets").should be true
  end
  
  it "should have a relationship for unzipped _images" do
    ImageSet.reflect_on_association(:unzipped_images).should be true
  end
  
end

describe MarkinMessenger, "logo branding" do
  
  before(:each) do
    
    @watermark = Watermark.new
    @is = ImageSet.new
    
    #@path = "#{RAILS_ROOT}/vendor/plugins/markin_messenger/assets/test.zip"
    @path = "#{RAILS_ROOT}/assets/image_sets/667/original/test.zip"
    @asset = mock_model(Asset,:path => @path)
    
    @is.stub!(:id).and_return(667)
    #@is.stub!(:asset).and_return(@asset)
    @is.stub!(:description).and_return("foo")
    @is.stub!(:save_attached_files).and_return true
    @is.asset = File.new(@path)
    
    @is.save!
  end
  
  it "should return the test zip path" do
    @is.asset.path.should == @path
  end
  
  #it "should assign a logo instance variable" do
    
  #end
  
  it "should brand the images in a zip file" do
    
    File.exists?(@watermark.path).should be true
    @is.watermark(@watermark.path).should_not == true
    
    @is.unzipped_images.empty?.should be false
    
    ui = UnzippedImage.find(:last)
    
    ui.should_not be nil
    
    #p ui.id
    #p UnzippedImage.find(:last)
    p ui.image_set.id
    
    im = ImageSet.find(:last)
    
    p im.id
    p im.methods.include?("unzipped_images").should be true
    ImageSet.find(:last).unzipped_images.empty?.should be false
  end
end

