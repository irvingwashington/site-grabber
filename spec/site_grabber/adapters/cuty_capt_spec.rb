require 'site_grabber'

describe SiteGrabber::Adapters::CutyCapt do

  it "initializes" do
    klass.new({}).should be_a(klass)
  end
  
  it "assigns settings" do
    test_settings = {:test => true}
    adapter = klass.new(test_settings)
    adapter.instance_variable_get('@settings').should eq(test_settings)
  end

  context "(render)" do
    
    it "raises exception on no cuty_capt_path" do
      adapter = klass.new({:xvfb_path => true})
      lambda { adapter.render }.should raise_exception(ArgumentError)
    end
    
    it "raises exception on no xvfb_path" do
      adapter = klass.new({:cuty_capt_path => true})
      lambda { adapter.render }.should raise_exception(ArgumentError)      
    end

    it "returns true" do
      Open3.stub!(:popen3).and_return(mocked_streams)
      adapter = klass.new({:cuty_capt_path => true, :xvfb_path => true})
      adapter.render.should be_true
    end
    
    it "returns false" do
      Open3.stub!(:popen3).and_return(mocked_streams)
      $?.stub!('to_i').and_return(1) # XXX
      adapter = klass.new({:cuty_capt_path => true, :xvfb_path => true})
      adapter.render.should_not be_true
    end
  end
  
  protected
  
  def klass
    SiteGrabber::Adapters::CutyCapt
  end
  
  def mocked_streams
    [:stdin,:stdout,:stderr].map do |stream|
      s = mock('stream')
      s.stub!('any?').and_return(false)
      s
    end
  end
end