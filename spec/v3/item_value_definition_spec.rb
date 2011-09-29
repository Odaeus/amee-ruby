# Copyright (C) 2008-2011 AMEE UK Ltd. - http://www.amee.com
# Released as Open Source Software under the BSD 3-Clause license. See LICENSE.txt for details.

require 'spec_helper.rb'

describe AMEE::Admin::ItemValueDefinition, "with an authenticated XML connection" do

  before :each do
    @connection = flexmock "connection"
    @ivd=AMEE::Admin::ItemValueDefinition.new(:connection=> @connection,
      :uid=>'ABC',:itemdefuid=>'PQR')
  end

  it "should set metadata" do
    @connection.should_receive(:v3_get).with("/#{AMEE_API_VERSION}/definitions/PQR/values/ABC;wikiDoc;usages").
      and_return(<<HERE
#{XMLPreamble}
<Representation>
</Representation>
HERE
      ).once
    @connection.should_receive(:v3_put).with("/#{AMEE_API_VERSION}/definitions/PQR/values/ABC;wikiDoc;usages",
      :body => <<EOF
#{XMLPreamble}
<ItemValueDefinition>
  <WikiDoc>Mass of carbon per distance</WikiDoc>
  <Usages>
    <Usage>
      <Name>usageTwo</Name>
      <Type>IGNORED</Type>
    </Usage>
    <Usage>
      <Name>usageOne</Name>
      <Type>FORBIDDEN</Type>
    </Usage>
  </Usages>
</ItemValueDefinition>
EOF
).once
    @connection.should_receive(:v3_get).with("/#{AMEE_API_VERSION}/definitions/PQR/values/ABC;wikiDoc;usages").
      and_return(<<HERE
#{XMLPreamble}
<Representation>
</Representation>
HERE
      ).once
    @ivd.meta.wikidoc = "Mass of carbon per distance"
    @ivd.set_usage_type('usageOne', :forbidden)
    @ivd.set_usage_type('usageTwo', :ignored)
    @ivd.putmeta
  end

  it "should get metadata" do
    @connection.should_receive(:v3_get).with("/#{AMEE_API_VERSION}/definitions/PQR/values/ABC;wikiDoc;usages").
      and_return(<<HERE
#{XMLPreamble}
<Representation>
  <ItemValueDefinition>
    <Name>Test</Name>
    <Path>test</Path>
    <Value>42</Value>
    <WikiDoc>Mass of carbon per distance</WikiDoc>
    <ItemDefinition uid="PQR">
      <Name>Itemdef</Name>
    </ItemDefinition>
    <Usages>
      <Usage>
        <Name>usageTwo</Name>
        <Type>FORBIDDEN</Type>
      </Usage>
      <Usage>
        <Name>usageThree</Name>
        <Type>IGNORED</Type>
      </Usage>
      <Usage>
        <Name>usageFour</Name>
        <Type>OPTIONAL</Type>
      </Usage>
      <Usage>
        <Name>usageOne</Name>
        <Type>COMPULSORY</Type>
      </Usage>
    </Usages>
    <Choices>true=true,false=false</Choices>
    <DrillDown>false</DrillDown>
    <FromData>true</FromData>
    <FromProfile>false</FromProfile>
  </ItemValueDefinition>
  <Status>OK</Status>
  <Version>#{AMEE_API_VERSION}.0</Version>
</Representation>
HERE
    ).once
#    @ivd.name.should eql "Test"
#    @ivd.path.should eql "test"
#    @ivd.default.should eql 42
    @ivd.meta.wikidoc.should eql "Mass of carbon per distance"
    result_map = {
      'usageOne' => :compulsory,
      'usageTwo' => :forbidden,
      'usageThree' => :ignored,
      'usageFour' => :optional,
    }
    types = [:optional, :compulsory, :forbidden, :ignored]
    result_map.each_pair do |usage, type|
      @ivd.usage_type(usage).should eql type
      types.each do |test_type|
        @ivd.send("#{test_type.to_s}?", usage).should eql(test_type == type)
      end
    end
    @ivd.usage_type('unknownUsage').should == :optional
#    @ivd.choices.should == ['true', 'false']
#    @ivd.type.should == 'data'
  end

end