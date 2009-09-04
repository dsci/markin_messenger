require File.dirname(__FILE__) + '/spec_helper'

describe UnzippedImage do
  before(:each) do
    @is = ImageSet.new(:id => 10)
    @is.stub!(:storage_folder).and_return("foo/bar/hungry")
    @uz = UnzippedImage.new
    @uz.image_set = @is
    @uz.filename = "#{RAILS_ROOT}/mcs/images/imageset/DSC_099.jpg"
  end
  
  it "should provide an thumbnail url method" do
    @uz.methods.include?("thumbnail_url").should be true
  end
  
  it "should provide an download_key" do
    @uz.methods.include?("download_key").should be true
  end
  
  it "should return the image tag url for thumbnail" do
    erg = "/foo/bar/hungry/thumb_DSC_099.jpg"
    @uz.thumbnail_url.should == erg
  end
end