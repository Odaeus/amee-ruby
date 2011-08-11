# Copyright (C) 2008-2011 AMEE UK Ltd. - http://www.amee.com
# Released as Open Source Software under the BSD 3-Clause license. See LICENSE.txt for details.

require File.dirname(__FILE__) + '/spec_helper.rb'

describe AMEE::Data::Object do

  it "should have a full path under /data" do
    AMEE::Data::Object.new.full_path.should == "/data"
  end

end