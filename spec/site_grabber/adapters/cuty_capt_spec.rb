require 'site_grabber'

describe SiteGrabber::Grabbers::CutyCapt do

  it "initializes" do
    klass.new({}).should be_a(klass)
  end
  
  it "assigns settings" do
    test_settings = {:test => true}
    grabber = klass.new(test_settings)
    grabber.instance_variable_get('@settings').should eq(test_settings)
  end

  context "(render)" do
    
    it "raises exception on no cuty_capt_path" do
      grabber = klass.new({:xvfb_path => true})
      lambda { grabber.render }.should raise_exception(ArgumentError)
    end
    
    it "raises exception on no xvfb_path" do
      grabber = klass.new({:cuty_capt_path => true})
      lambda { grabber.render }.should raise_exception(ArgumentError)      
    end

    it "returns true" do
      Open3.stub!(:popen3).and_yield(*mocked_streams)
      grabber = klass.new({:cuty_capt_path => true, :xvfb_path => true})
      grabber.render.should be_true
    end
    
    it "returns false" do
      Open3.stub!(:popen3).and_yield(*mocked_streams(1))
      grabber = klass.new({:cuty_capt_path => true, :xvfb_path => true})
      grabber.render.should_not be_true
    end
  end
  
  protected
  
  def klass
    SiteGrabber::Grabbers::CutyCapt
  end
  
  def mocked_streams(value=0)
    [:stdin,:stdout,:stderr, :wait_thr].map do |stream|
      s = mock(stream)
      s.stub!('any?').and_return(false)
      if stream == :wait_thr
        s.stub!(:value).and_return(value)
      end
      s
    end
  end
end