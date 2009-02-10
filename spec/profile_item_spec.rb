require File.dirname(__FILE__) + '/spec_helper.rb'

describe AMEE::Profile::Item do
  
  before(:each) do
    @item = AMEE::Profile::Item.new
  end
  
  it "should have common AMEE object properties" do
    @item.is_a?(AMEE::Profile::Object).should be_true
  end

  it "should have values" do
    @item.should respond_to(:values)
  end

  it "should initialize AMEE::Object data on creation" do
    uid = 'ABCD1234'
    @item = AMEE::Profile::Item.new(:uid => uid)
    @item.uid.should == uid
  end

  it "can be created with hash of data" do
    values = ["one", "two"]
    @item = AMEE::Profile::Item.new(:values => values)
    @item.values.should == values
  end

  it "should be able to create new profile items (XML)" do
    connection = flexmock "connection"
    connection.should_receive(:get).with("/profiles/E54C5525AA3E/home/energy/quantity", {:itemsPerPage => 10, :profileDate=>Date.today.strftime("%Y%m")}).and_return('<?xml version="1.0" encoding="UTF-8"?><Resources><ProfileCategoryResource><Path>/home/energy/quantity</Path><ProfileDate>200901</ProfileDate><Profile uid="E54C5525AA3E"/><DataCategory uid="A92693A99BAD"><Name>Quantity</Name><Path>quantity</Path></DataCategory><Children><ProfileCategories/><ProfileItems/><Pager><Start>0</Start><From>0</From><To>0</To><Items>0</Items><CurrentPage>1</CurrentPage><RequestedPage>1</RequestedPage><NextPage>-1</NextPage><PreviousPage>-1</PreviousPage><LastPage>1</LastPage><ItemsPerPage>10</ItemsPerPage><ItemsFound>0</ItemsFound></Pager></Children><TotalAmountPerMonth>0.000</TotalAmountPerMonth></ProfileCategoryResource></Resources>')
    connection.should_receive(:post).with("/profiles/E54C5525AA3E/home/energy/quantity", :dataItemUid => '66056991EE23', :kWhPerMonth => "10").and_return('<?xml version="1.0" encoding="UTF-8"?><Resources><ProfileCategoryResource><Path>/home/energy/quantity</Path><ProfileDate>200901</ProfileDate><Profile uid="E54C5525AA3E"/><DataCategory uid="A92693A99BAD"><Name>Quantity</Name><Path>quantity</Path></DataCategory><ProfileItem uid="62BCC8C84D0C"><Name>62BCC8C84D0C</Name><ItemValues><ItemValue uid="D281CE71180D"><Path>kgPerMonth</Path><Name>kg Per Month</Name><Value>0</Value><ItemValueDefinition uid="51D072825D41"><Path>kgPerMonth</Path><Name>kg Per Month</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="36A771FC1D1A"><Name>kg</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="67DD1D3A00C4"><Path>kWhPerMonth</Path><Name>kWh Per Month</Name><Value>10</Value><ItemValueDefinition uid="4DF458FD0E4D"><Path>kWhPerMonth</Path><Name>kWh Per Month</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="26A5C97D3728"><Name>kWh</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="2BEEF89EFCAB"><Path>litresPerMonth</Path><Name>Litres Per Month</Name><Value>0</Value><ItemValueDefinition uid="C9B7E19269A5"><Path>litresPerMonth</Path><Name>Litres Per Month</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="06B8CFC5A521"><Name>litre</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="7C8968300299"><Path>kWhReadingCurrent</Path><Name>kWh reading current</Name><Value>0</Value><ItemValueDefinition uid="8A468E75C8E8"><Path>kWhReadingCurrent</Path><Name>kWh reading current</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="45433E48B39F"><Name>amount</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="F68E3F8F988B"><Path>kWhReadingLast</Path><Name>kWh reading last</Name><Value>0</Value><ItemValueDefinition uid="2328DC7F23AE"><Path>kWhReadingLast</Path><Name>kWh reading last</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="45433E48B39F"><Name>amount</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="1932882328F0"><Path>paymentFrequency</Path><Name>Payment frequency</Name><Value/><ItemValueDefinition uid="E0EFED6FD7E6"><Path>paymentFrequency</Path><Name>Payment frequency</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="CCEB59CACE1B"><Name>text</Name><ValueType>TEXT</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="826512435B43"><Path>greenTariff</Path><Name>Green tariff</Name><Value/><ItemValueDefinition uid="63005554AE8A"><Path>greenTariff</Path><Name>Green tariff</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="CCEB59CACE1B"><Name>text</Name><ValueType>TEXT</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="4D2D471F2F04"><Path>season</Path><Name>Season</Name><Value/><ItemValueDefinition uid="527AADFB3B65"><Path>season</Path><Name>Season</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="CCEB59CACE1B"><Name>text</Name><ValueType>TEXT</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="583D56F63CD5"><Path>includesHeating</Path><Name>Includes Heating</Name><Value>false</Value><ItemValueDefinition uid="1740E500BDAB"><Path>includesHeating</Path><Name>Includes Heating</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="CCEB59CACE1B"><Name>text</Name><ValueType>TEXT</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="95DF5F127142"><Path>numberOfDeliveries</Path><Name>Number of deliveries</Name><Value/><ItemValueDefinition uid="AA1D1C349119"><Path>numberOfDeliveries</Path><Name>Number of deliveries</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="45433E48B39F"><Name>amount</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue></ItemValues><AmountPerMonth>2.060</AmountPerMonth><ValidFrom>20090101</ValidFrom><End>false</End><DataItem uid="66056991EE23"/></ProfileItem></ProfileCategoryResource></Resources>')
    connection.should_receive(:get).with("/profiles/E54C5525AA3E/home/energy/quantity/62BCC8C84D0C", {:profileDate=>Date.today.strftime("%Y%m")}).and_return('<?xml version="1.0" encoding="UTF-8"?><Resources><ProfileItemResource><ProfileItem created="2009-01-28 23:35:00.0" modified="2009-01-28 23:35:00.0" uid="62BCC8C84D0C"><Name>62BCC8C84D0C</Name><ItemValues><ItemValue uid="95DF5F127142"><Path>numberOfDeliveries</Path><Name>Number of deliveries</Name><Value/><ItemValueDefinition uid="AA1D1C349119"><Path>numberOfDeliveries</Path><Name>Number of deliveries</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="45433E48B39F"><Name>amount</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="4D2D471F2F04"><Path>season</Path><Name>Season</Name><Value/><ItemValueDefinition uid="527AADFB3B65"><Path>season</Path><Name>Season</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="CCEB59CACE1B"><Name>text</Name><ValueType>TEXT</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="583D56F63CD5"><Path>includesHeating</Path><Name>Includes Heating</Name><Value>false</Value><ItemValueDefinition uid="1740E500BDAB"><Path>includesHeating</Path><Name>Includes Heating</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="CCEB59CACE1B"><Name>text</Name><ValueType>TEXT</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="826512435B43"><Path>greenTariff</Path><Name>Green tariff</Name><Value/><ItemValueDefinition uid="63005554AE8A"><Path>greenTariff</Path><Name>Green tariff</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="CCEB59CACE1B"><Name>text</Name><ValueType>TEXT</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="1932882328F0"><Path>paymentFrequency</Path><Name>Payment frequency</Name><Value/><ItemValueDefinition uid="E0EFED6FD7E6"><Path>paymentFrequency</Path><Name>Payment frequency</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="CCEB59CACE1B"><Name>text</Name><ValueType>TEXT</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="F68E3F8F988B"><Path>kWhReadingLast</Path><Name>kWh reading last</Name><Value>0</Value><ItemValueDefinition uid="2328DC7F23AE"><Path>kWhReadingLast</Path><Name>kWh reading last</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="45433E48B39F"><Name>amount</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="7C8968300299"><Path>kWhReadingCurrent</Path><Name>kWh reading current</Name><Value>0</Value><ItemValueDefinition uid="8A468E75C8E8"><Path>kWhReadingCurrent</Path><Name>kWh reading current</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="45433E48B39F"><Name>amount</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="D281CE71180D"><Path>kgPerMonth</Path><Name>kg Per Month</Name><Value>0</Value><ItemValueDefinition uid="51D072825D41"><Path>kgPerMonth</Path><Name>kg Per Month</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="36A771FC1D1A"><Name>kg</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="67DD1D3A00C4"><Path>kWhPerMonth</Path><Name>kWh Per Month</Name><Value>10</Value><ItemValueDefinition uid="4DF458FD0E4D"><Path>kWhPerMonth</Path><Name>kWh Per Month</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="26A5C97D3728"><Name>kWh</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="2BEEF89EFCAB"><Path>litresPerMonth</Path><Name>Litres Per Month</Name><Value>0</Value><ItemValueDefinition uid="C9B7E19269A5"><Path>litresPerMonth</Path><Name>Litres Per Month</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="06B8CFC5A521"><Name>litre</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue></ItemValues><Environment uid="5F5887BCF726"/><ItemDefinition uid="212C818D8F16"/><DataCategory uid="A92693A99BAD"><Name>Quantity</Name><Path>quantity</Path></DataCategory><AmountPerMonth>2.060</AmountPerMonth><ValidFrom>20090101</ValidFrom><End>false</End><DataItem uid="66056991EE23"/><Profile uid="E54C5525AA3E"/></ProfileItem><Path>/home/energy/quantity/62BCC8C84D0C</Path><Profile uid="E54C5525AA3E"/></ProfileItemResource></Resources>')
    category = AMEE::Profile::Category.get(connection, "/profiles/E54C5525AA3E/home/energy/quantity")
    item = AMEE::Profile::Item.create(category, '66056991EE23', :kWhPerMonth => "10")
    item.total_amount_per_month.should be_close(2.06, 1e-9)
  end

  it "should be able to create new profile items (JSON)" do
    connection = flexmock "connection"
    connection.should_receive(:get).with("/profiles/E54C5525AA3E/home/energy/quantity", {:itemsPerPage => 10, :profileDate=>Date.today.strftime("%Y%m")}).and_return('{"totalAmountPerMonth":0,"dataCategory":{"uid":"A92693A99BAD","path":"quantity","name":"Quantity"},"profileDate":"200901","path":"/home/energy/quantity","profile":{"uid":"E54C5525AA3E"},"children":{"pager":{"to":0,"lastPage":1,"start":0,"nextPage":-1,"items":0,"itemsPerPage":10,"from":0,"previousPage":-1,"requestedPage":1,"currentPage":1,"itemsFound":0},"dataCategories":[],"profileItems":{"rows":[],"label":"ProfileItems"}}}')
    connection.should_receive(:post).with("/profiles/E54C5525AA3E/home/energy/quantity", :dataItemUid => '66056991EE23', :kWhPerMonth => "10").and_return('{"dataCategory":{"uid":"A92693A99BAD","path":"quantity","name":"Quantity"},"profileDate":"200901","path":"/home/energy/quantity","profile":{"uid":"E54C5525AA3E"},"profileItem":{"validFrom":"20090101","amountPerMonth":2.06,"itemValues":[{"value":"0","uid":"01591644B296","path":"kgPerMonth","name":"kg Per Month","itemValueDefinition":{"valueDefinition":{"valueType":"DECIMAL","uid":"36A771FC1D1A","name":"kg"},"uid":"51D072825D41","path":"kgPerMonth","name":"kg Per Month"}},{"value":"10","uid":"94B617C13137","path":"kWhPerMonth","name":"kWh Per Month","itemValueDefinition":{"valueDefinition":{"valueType":"DECIMAL","uid":"26A5C97D3728","name":"kWh"},"uid":"4DF458FD0E4D","path":"kWhPerMonth","name":"kWh Per Month"}},{"value":"0","uid":"1F5AF1A6BD65","path":"litresPerMonth","name":"Litres Per Month","itemValueDefinition":{"valueDefinition":{"valueType":"DECIMAL","uid":"06B8CFC5A521","name":"litre"},"uid":"C9B7E19269A5","path":"litresPerMonth","name":"Litres Per Month"}},{"value":"0","uid":"B2FBB1BFF60F","path":"kWhReadingCurrent","name":"kWh reading current","itemValueDefinition":{"valueDefinition":{"valueType":"DECIMAL","uid":"45433E48B39F","name":"amount"},"uid":"8A468E75C8E8","path":"kWhReadingCurrent","name":"kWh reading current"}},{"value":"0","uid":"A97ADD0FCB82","path":"kWhReadingLast","name":"kWh reading last","itemValueDefinition":{"valueDefinition":{"valueType":"DECIMAL","uid":"45433E48B39F","name":"amount"},"uid":"2328DC7F23AE","path":"kWhReadingLast","name":"kWh reading last"}},{"value":"","uid":"1D96093AD6D7","path":"paymentFrequency","name":"Payment frequency","itemValueDefinition":{"valueDefinition":{"valueType":"TEXT","uid":"CCEB59CACE1B","name":"text"},"uid":"E0EFED6FD7E6","path":"paymentFrequency","name":"Payment frequency"}},{"value":"","uid":"ED12DF35A1C3","path":"greenTariff","name":"Green tariff","itemValueDefinition":{"valueDefinition":{"valueType":"TEXT","uid":"CCEB59CACE1B","name":"text"},"uid":"63005554AE8A","path":"greenTariff","name":"Green tariff"}},{"value":"","uid":"9494FB0F7DE8","path":"season","name":"Season","itemValueDefinition":{"valueDefinition":{"valueType":"TEXT","uid":"CCEB59CACE1B","name":"text"},"uid":"527AADFB3B65","path":"season","name":"Season"}},{"value":"false","uid":"ECB936330FEF","path":"includesHeating","name":"Includes Heating","itemValueDefinition":{"valueDefinition":{"valueType":"TEXT","uid":"CCEB59CACE1B","name":"text"},"uid":"1740E500BDAB","path":"includesHeating","name":"Includes Heating"}},{"value":"","uid":"C85E51E8D26C","path":"numberOfDeliveries","name":"Number of deliveries","itemValueDefinition":{"valueDefinition":{"valueType":"DECIMAL","uid":"45433E48B39F","name":"amount"},"uid":"AA1D1C349119","path":"numberOfDeliveries","name":"Number of deliveries"}}],"end":"false","uid":"8C7BD1AB69D3","dataItem":{"uid":"66056991EE23"},"name":"8C7BD1AB69D3"}}')
    connection.should_receive(:get).with("/profiles/E54C5525AA3E/home/energy/quantity/8C7BD1AB69D3", {:profileDate=>Date.today.strftime("%Y%m")}).and_return('{"path":"/home/energy/quantity/8C7BD1AB69D3","profile":{"uid":"E54C5525AA3E"},"profileItem":{"created":"2009-01-29 00:11:33.0","itemValues":[{"value":"","uid":"9494FB0F7DE8","path":"season","name":"Season","itemValueDefinition":{"valueDefinition":{"valueType":"TEXT","uid":"CCEB59CACE1B","name":"text"},"uid":"527AADFB3B65","path":"season","name":"Season"}},{"value":"false","uid":"ECB936330FEF","path":"includesHeating","name":"Includes Heating","itemValueDefinition":{"valueDefinition":{"valueType":"TEXT","uid":"CCEB59CACE1B","name":"text"},"uid":"1740E500BDAB","path":"includesHeating","name":"Includes Heating"}},{"value":"","uid":"C85E51E8D26C","path":"numberOfDeliveries","name":"Number of deliveries","itemValueDefinition":{"valueDefinition":{"valueType":"DECIMAL","uid":"45433E48B39F","name":"amount"},"uid":"AA1D1C349119","path":"numberOfDeliveries","name":"Number of deliveries"}},{"value":"","uid":"ED12DF35A1C3","path":"greenTariff","name":"Green tariff","itemValueDefinition":{"valueDefinition":{"valueType":"TEXT","uid":"CCEB59CACE1B","name":"text"},"uid":"63005554AE8A","path":"greenTariff","name":"Green tariff"}},{"value":"","uid":"1D96093AD6D7","path":"paymentFrequency","name":"Payment frequency","itemValueDefinition":{"valueDefinition":{"valueType":"TEXT","uid":"CCEB59CACE1B","name":"text"},"uid":"E0EFED6FD7E6","path":"paymentFrequency","name":"Payment frequency"}},{"value":"0","uid":"A97ADD0FCB82","path":"kWhReadingLast","name":"kWh reading last","itemValueDefinition":{"valueDefinition":{"valueType":"DECIMAL","uid":"45433E48B39F","name":"amount"},"uid":"2328DC7F23AE","path":"kWhReadingLast","name":"kWh reading last"}},{"value":"0","uid":"B2FBB1BFF60F","path":"kWhReadingCurrent","name":"kWh reading current","itemValueDefinition":{"valueDefinition":{"valueType":"DECIMAL","uid":"45433E48B39F","name":"amount"},"uid":"8A468E75C8E8","path":"kWhReadingCurrent","name":"kWh reading current"}},{"value":"0","uid":"01591644B296","path":"kgPerMonth","name":"kg Per Month","itemValueDefinition":{"valueDefinition":{"valueType":"DECIMAL","uid":"36A771FC1D1A","name":"kg"},"uid":"51D072825D41","path":"kgPerMonth","name":"kg Per Month"}},{"value":"0","uid":"1F5AF1A6BD65","path":"litresPerMonth","name":"Litres Per Month","itemValueDefinition":{"valueDefinition":{"valueType":"DECIMAL","uid":"06B8CFC5A521","name":"litre"},"uid":"C9B7E19269A5","path":"litresPerMonth","name":"Litres Per Month"}},{"value":"10","uid":"94B617C13137","path":"kWhPerMonth","name":"kWh Per Month","itemValueDefinition":{"valueDefinition":{"valueType":"DECIMAL","uid":"26A5C97D3728","name":"kWh"},"uid":"4DF458FD0E4D","path":"kWhPerMonth","name":"kWh Per Month"}}],"dataCategory":{"uid":"A92693A99BAD","path":"quantity","name":"Quantity"},"end":"false","uid":"8C7BD1AB69D3","environment":{"uid":"5F5887BCF726"},"profile":{"uid":"E54C5525AA3E"},"modified":"2009-01-29 00:11:33.0","validFrom":"20090101","amountPerMonth":2.06,"itemDefinition":{"uid":"212C818D8F16"},"dataItem":{"uid":"66056991EE23"},"name":"8C7BD1AB69D3"}}')
    category = AMEE::Profile::Category.get(connection, "/profiles/E54C5525AA3E/home/energy/quantity")
    item = AMEE::Profile::Item.create(category, '66056991EE23', :kWhPerMonth => "10")
    item.total_amount_per_month.should be_close(2.06, 1e-9)
  end

end

describe AMEE::Profile::Item, "with an authenticated XML connection" do

  it "should load Profile Item" do
    connection = flexmock "connection"
    connection.should_receive(:get).with("/profiles/92C8DB30F46B/home/energy/quantity/6E9B1517D753", {:profileDate=>Date.today.strftime("%Y%m")}).and_return('<?xml version="1.0" encoding="UTF-8"?><Resources><ProfileItemResource><ProfileItem created="2008-09-12 17:20:32.0" modified="2008-09-12 17:20:32.0" uid="6E9B1517D753"><Name>6E9B1517D753</Name><ItemValues><ItemValue uid="0A671BF3D593"><Path>kgPerMonth</Path><Name>kg Per Month</Name><Value>10</Value><ItemValueDefinition uid="51D072825D41"><Path>kgPerMonth</Path><Name>kg Per Month</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="36A771FC1D1A"><Name>kg</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="0E4CF565A5AB"><Path>kWhPerMonth</Path><Name>kWh Per Month</Name><Value>0</Value><ItemValueDefinition uid="4DF458FD0E4D"><Path>kWhPerMonth</Path><Name>kWh Per Month</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="26A5C97D3728"><Name>kWh</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="D58700708731"><Path>litresPerMonth</Path><Name>Litres Per Month</Name><Value>0</Value><ItemValueDefinition uid="C9B7E19269A5"><Path>litresPerMonth</Path><Name>Litres Per Month</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="06B8CFC5A521"><Name>litre</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="BD1267F2D001"><Path>kWhReadingCurrent</Path><Name>kWh reading current</Name><Value>0</Value><ItemValueDefinition uid="8A468E75C8E8"><Path>kWhReadingCurrent</Path><Name>kWh reading current</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="45433E48B39F"><Name>amount</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="B199A908A259"><Path>kWhReadingLast</Path><Name>kWh reading last</Name><Value>0</Value><ItemValueDefinition uid="2328DC7F23AE"><Path>kWhReadingLast</Path><Name>kWh reading last</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="45433E48B39F"><Name>amount</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue></ItemValues><Environment uid="5F5887BCF726"/><ItemDefinition uid="212C818D8F16"/><DataCategory uid="A92693A99BAD"><Name>Quantity</Name><Path>quantity</Path></DataCategory><AmountPerMonth>25.200</AmountPerMonth><ValidFrom>20080901</ValidFrom><End>false</End><DataItem uid="A70149AF0F26"/><Profile uid="92C8DB30F46B"/></ProfileItem><Path>/home/energy/quantity/6E9B1517D753</Path><Profile uid="92C8DB30F46B"/></ProfileItemResource></Resources>')
    @item = AMEE::Profile::Item.get(connection, "/profiles/92C8DB30F46B/home/energy/quantity/6E9B1517D753")
    @item.profile_uid.should == "92C8DB30F46B"
    @item.uid.should == "6E9B1517D753"
    @item.name.should == "6E9B1517D753"
    @item.path.should == "/home/energy/quantity/6E9B1517D753"
    @item.total_amount_per_month.should be_close(25.2, 1e-9)
    @item.valid_from.should == DateTime.new(2008, 9, 1)
    @item.end.should be_false
    @item.full_path.should == "/profiles/92C8DB30F46B/home/energy/quantity/6E9B1517D753"
  end

  it "should parse values" do
    connection = flexmock "connection"
    connection.should_receive(:get).with("/profiles/92C8DB30F46B/home/energy/quantity/6E9B1517D753", {:profileDate=>Date.today.strftime("%Y%m")}).and_return('<?xml version="1.0" encoding="UTF-8"?><Resources><ProfileItemResource><ProfileItem created="2008-09-12 17:20:32.0" modified="2008-09-12 17:20:32.0" uid="6E9B1517D753"><Name>6E9B1517D753</Name><ItemValues><ItemValue uid="0A671BF3D593"><Path>kgPerMonth</Path><Name>kg Per Month</Name><Value>10</Value><ItemValueDefinition uid="51D072825D41"><Path>kgPerMonth</Path><Name>kg Per Month</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="36A771FC1D1A"><Name>kg</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="0E4CF565A5AB"><Path>kWhPerMonth</Path><Name>kWh Per Month</Name><Value>0</Value><ItemValueDefinition uid="4DF458FD0E4D"><Path>kWhPerMonth</Path><Name>kWh Per Month</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="26A5C97D3728"><Name>kWh</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="D58700708731"><Path>litresPerMonth</Path><Name>Litres Per Month</Name><Value>0</Value><ItemValueDefinition uid="C9B7E19269A5"><Path>litresPerMonth</Path><Name>Litres Per Month</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="06B8CFC5A521"><Name>litre</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="BD1267F2D001"><Path>kWhReadingCurrent</Path><Name>kWh reading current</Name><Value>0</Value><ItemValueDefinition uid="8A468E75C8E8"><Path>kWhReadingCurrent</Path><Name>kWh reading current</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="45433E48B39F"><Name>amount</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="B199A908A259"><Path>kWhReadingLast</Path><Name>kWh reading last</Name><Value>0</Value><ItemValueDefinition uid="2328DC7F23AE"><Path>kWhReadingLast</Path><Name>kWh reading last</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="45433E48B39F"><Name>amount</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue></ItemValues><Environment uid="5F5887BCF726"/><ItemDefinition uid="212C818D8F16"/><DataCategory uid="A92693A99BAD"><Name>Quantity</Name><Path>quantity</Path></DataCategory><AmountPerMonth>25.200</AmountPerMonth><ValidFrom>20080901</ValidFrom><End>false</End><DataItem uid="A70149AF0F26"/><Profile uid="92C8DB30F46B"/></ProfileItem><Path>/home/energy/quantity/6E9B1517D753</Path><Profile uid="92C8DB30F46B"/></ProfileItemResource></Resources>')
    @item = AMEE::Profile::Item.get(connection, "/profiles/92C8DB30F46B/home/energy/quantity/6E9B1517D753")
    @item.values.size.should be(5)
    @item.values[0][:uid].should == "0A671BF3D593"
    @item.values[0][:name].should == "kg Per Month"
    @item.values[0][:path].should == "kgPerMonth"
    @item.values[0][:value].should == "10"
    @item.values[1][:uid].should == "0E4CF565A5AB"
    @item.values[1][:name].should == "kWh Per Month"
    @item.values[1][:path].should == "kWhPerMonth"
    @item.values[1][:value].should == "0"
  end

  it "should fail gracefully with incorrect data" do
    connection = flexmock "connection"
    connection.should_receive(:get).with("/profiles/92C8DB30F46B/home/energy/quantity/6E9B1517D753", {:profileDate=>Date.today.strftime("%Y%m")}).and_return('<?xml version="1.0" encoding="UTF-8"?><Resources></Resources>')
    lambda{AMEE::Profile::Item.get(connection, "/profiles/92C8DB30F46B/home/energy/quantity/6E9B1517D753")}.should raise_error(AMEE::BadData, "Couldn't load ProfileItem from XML data. Check that your URL is correct.")
  end

end

describe AMEE::Profile::Item, "with an authenticated JSON connection" do

  it "should load Profile Item" do
    connection = flexmock "connection"
    connection.should_receive(:get).with("/profiles/92C8DB30F46B/home/energy/quantity/6E9B1517D753", {:profileDate=>Date.today.strftime("%Y%m")}).and_return('{"path":"/home/energy/quantity/6E9B1517D753","profile":{"uid":"92C8DB30F46B"},"profileItem":{"created":"2008-09-12 17:20:32.0","itemValues":[{"value":"10","uid":"0A671BF3D593","path":"kgPerMonth","name":"kg Per Month","itemValueDefinition":{"valueDefinition":{"valueType":"DECIMAL","uid":"36A771FC1D1A","name":"kg"},"uid":"51D072825D41","path":"kgPerMonth","name":"kg Per Month"}},{"value":"0","uid":"0E4CF565A5AB","path":"kWhPerMonth","name":"kWh Per Month","itemValueDefinition":{"valueDefinition":{"valueType":"DECIMAL","uid":"26A5C97D3728","name":"kWh"},"uid":"4DF458FD0E4D","path":"kWhPerMonth","name":"kWh Per Month"}},{"value":"0","uid":"D58700708731","path":"litresPerMonth","name":"Litres Per Month","itemValueDefinition":{"valueDefinition":{"valueType":"DECIMAL","uid":"06B8CFC5A521","name":"litre"},"uid":"C9B7E19269A5","path":"litresPerMonth","name":"Litres Per Month"}},{"value":"0","uid":"BD1267F2D001","path":"kWhReadingCurrent","name":"kWh reading current","itemValueDefinition":{"valueDefinition":{"valueType":"DECIMAL","uid":"45433E48B39F","name":"amount"},"uid":"8A468E75C8E8","path":"kWhReadingCurrent","name":"kWh reading current"}},{"value":"0","uid":"B199A908A259","path":"kWhReadingLast","name":"kWh reading last","itemValueDefinition":{"valueDefinition":{"valueType":"DECIMAL","uid":"45433E48B39F","name":"amount"},"uid":"2328DC7F23AE","path":"kWhReadingLast","name":"kWh reading last"}}],"dataCategory":{"uid":"A92693A99BAD","path":"quantity","name":"Quantity"},"end":"false","uid":"6E9B1517D753","environment":{"uid":"5F5887BCF726"},"profile":{"uid":"92C8DB30F46B"},"modified":"2008-09-12 17:20:32.0","validFrom":"20080901","amountPerMonth":25.2,"itemDefinition":{"uid":"212C818D8F16"},"dataItem":{"uid":"A70149AF0F26"},"name":"6E9B1517D753"}}')
    @item = AMEE::Profile::Item.get(connection, "/profiles/92C8DB30F46B/home/energy/quantity/6E9B1517D753")
    @item.profile_uid.should == "92C8DB30F46B"
    @item.uid.should == "6E9B1517D753"
    @item.name.should == "6E9B1517D753"
    @item.path.should == "/home/energy/quantity/6E9B1517D753"
    @item.total_amount_per_month.should be_close(25.2, 1e-9)
    @item.valid_from.should == DateTime.new(2008, 9, 1)
    @item.end.should be_false
    @item.full_path.should == "/profiles/92C8DB30F46B/home/energy/quantity/6E9B1517D753"
  end

  it "should parse values" do
    connection = flexmock "connection"
    connection.should_receive(:get).with("/profiles/92C8DB30F46B/home/energy/quantity/6E9B1517D753", {:profileDate=>Date.today.strftime("%Y%m")}).and_return('{"path":"/home/energy/quantity/6E9B1517D753","profile":{"uid":"92C8DB30F46B"},"profileItem":{"created":"2008-09-12 17:20:32.0","itemValues":[{"value":"10","uid":"0A671BF3D593","path":"kgPerMonth","name":"kg Per Month","itemValueDefinition":{"valueDefinition":{"valueType":"DECIMAL","uid":"36A771FC1D1A","name":"kg"},"uid":"51D072825D41","path":"kgPerMonth","name":"kg Per Month"}},{"value":"0","uid":"0E4CF565A5AB","path":"kWhPerMonth","name":"kWh Per Month","itemValueDefinition":{"valueDefinition":{"valueType":"DECIMAL","uid":"26A5C97D3728","name":"kWh"},"uid":"4DF458FD0E4D","path":"kWhPerMonth","name":"kWh Per Month"}},{"value":"0","uid":"D58700708731","path":"litresPerMonth","name":"Litres Per Month","itemValueDefinition":{"valueDefinition":{"valueType":"DECIMAL","uid":"06B8CFC5A521","name":"litre"},"uid":"C9B7E19269A5","path":"litresPerMonth","name":"Litres Per Month"}},{"value":"0","uid":"BD1267F2D001","path":"kWhReadingCurrent","name":"kWh reading current","itemValueDefinition":{"valueDefinition":{"valueType":"DECIMAL","uid":"45433E48B39F","name":"amount"},"uid":"8A468E75C8E8","path":"kWhReadingCurrent","name":"kWh reading current"}},{"value":"0","uid":"B199A908A259","path":"kWhReadingLast","name":"kWh reading last","itemValueDefinition":{"valueDefinition":{"valueType":"DECIMAL","uid":"45433E48B39F","name":"amount"},"uid":"2328DC7F23AE","path":"kWhReadingLast","name":"kWh reading last"}}],"dataCategory":{"uid":"A92693A99BAD","path":"quantity","name":"Quantity"},"end":"false","uid":"6E9B1517D753","environment":{"uid":"5F5887BCF726"},"profile":{"uid":"92C8DB30F46B"},"modified":"2008-09-12 17:20:32.0","validFrom":"20080901","amountPerMonth":25.2,"itemDefinition":{"uid":"212C818D8F16"},"dataItem":{"uid":"A70149AF0F26"},"name":"6E9B1517D753"}}')
    @item = AMEE::Profile::Item.get(connection, "/profiles/92C8DB30F46B/home/energy/quantity/6E9B1517D753")
    @item.values.size.should be(5)
    @item.values[0][:uid].should == "0A671BF3D593"
    @item.values[0][:name].should == "kg Per Month"
    @item.values[0][:path].should == "kgPerMonth"
    @item.values[0][:value].should == "10"
    @item.values[1][:uid].should == "0E4CF565A5AB"
    @item.values[1][:name].should == "kWh Per Month"
    @item.values[1][:path].should == "kWhPerMonth"
    @item.values[1][:value].should == "0"
  end

  it "should fail gracefully with incorrect data" do
    connection = flexmock "connection"
    connection.should_receive(:get).with("/profiles/92C8DB30F46B/home/energy/quantity/6E9B1517D753", {:profileDate=>Date.today.strftime("%Y%m")}).and_return('{}')
    lambda{AMEE::Profile::Item.get(connection, "/profiles/92C8DB30F46B/home/energy/quantity/6E9B1517D753")}.should raise_error(AMEE::BadData, "Couldn't load ProfileItem from JSON data. Check that your URL is correct.")
  end

end

describe AMEE::Profile::Item, "should be able to update profile items" do

  it " given an existing item" do
    connection = flexmock "connection"
    connection.should_receive(:get).with("/profiles/92C8DB30F46B/home/energy/quantity/6E9B1517D753", {:profileDate=>Date.today.strftime("%Y%m")}).and_return('<?xml version="1.0" encoding="UTF-8"?><Resources><ProfileItemResource><ProfileItem created="2008-09-12 17:20:32.0" modified="2008-09-12 17:20:32.0" uid="6E9B1517D753"><Name>6E9B1517D753</Name><ItemValues><ItemValue uid="0A671BF3D593"><Path>kgPerMonth</Path><Name>kg Per Month</Name><Value>10</Value><ItemValueDefinition uid="51D072825D41"><Path>kgPerMonth</Path><Name>kg Per Month</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="36A771FC1D1A"><Name>kg</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="0E4CF565A5AB"><Path>kWhPerMonth</Path><Name>kWh Per Month</Name><Value>0</Value><ItemValueDefinition uid="4DF458FD0E4D"><Path>kWhPerMonth</Path><Name>kWh Per Month</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="26A5C97D3728"><Name>kWh</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="D58700708731"><Path>litresPerMonth</Path><Name>Litres Per Month</Name><Value>0</Value><ItemValueDefinition uid="C9B7E19269A5"><Path>litresPerMonth</Path><Name>Litres Per Month</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="06B8CFC5A521"><Name>litre</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="BD1267F2D001"><Path>kWhReadingCurrent</Path><Name>kWh reading current</Name><Value>0</Value><ItemValueDefinition uid="8A468E75C8E8"><Path>kWhReadingCurrent</Path><Name>kWh reading current</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="45433E48B39F"><Name>amount</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="B199A908A259"><Path>kWhReadingLast</Path><Name>kWh reading last</Name><Value>0</Value><ItemValueDefinition uid="2328DC7F23AE"><Path>kWhReadingLast</Path><Name>kWh reading last</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="45433E48B39F"><Name>amount</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue></ItemValues><Environment uid="5F5887BCF726"/><ItemDefinition uid="212C818D8F16"/><DataCategory uid="A92693A99BAD"><Name>Quantity</Name><Path>quantity</Path></DataCategory><AmountPerMonth>25.200</AmountPerMonth><ValidFrom>20080901</ValidFrom><End>false</End><DataItem uid="A70149AF0F26"/><Profile uid="92C8DB30F46B"/></ProfileItem><Path>/home/energy/quantity/6E9B1517D753</Path><Profile uid="92C8DB30F46B"/></ProfileItemResource></Resources>')
    connection.should_receive(:put).with("/profiles/92C8DB30F46B/home/energy/quantity/6E9B1517D753", {}).and_return('<?xml version="1.0" encoding="UTF-8"?><Resources><ProfileItemResource><ProfileItem created="2008-09-12 17:20:32.0" modified="2008-09-12 17:20:32.0" uid="6E9B1517D753"><Name>6E9B1517D753</Name><ItemValues><ItemValue uid="0A671BF3D593"><Path>kgPerMonth</Path><Name>kg Per Month</Name><Value>10</Value><ItemValueDefinition uid="51D072825D41"><Path>kgPerMonth</Path><Name>kg Per Month</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="36A771FC1D1A"><Name>kg</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="0E4CF565A5AB"><Path>kWhPerMonth</Path><Name>kWh Per Month</Name><Value>0</Value><ItemValueDefinition uid="4DF458FD0E4D"><Path>kWhPerMonth</Path><Name>kWh Per Month</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="26A5C97D3728"><Name>kWh</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="D58700708731"><Path>litresPerMonth</Path><Name>Litres Per Month</Name><Value>0</Value><ItemValueDefinition uid="C9B7E19269A5"><Path>litresPerMonth</Path><Name>Litres Per Month</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="06B8CFC5A521"><Name>litre</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="BD1267F2D001"><Path>kWhReadingCurrent</Path><Name>kWh reading current</Name><Value>0</Value><ItemValueDefinition uid="8A468E75C8E8"><Path>kWhReadingCurrent</Path><Name>kWh reading current</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="45433E48B39F"><Name>amount</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="B199A908A259"><Path>kWhReadingLast</Path><Name>kWh reading last</Name><Value>0</Value><ItemValueDefinition uid="2328DC7F23AE"><Path>kWhReadingLast</Path><Name>kWh reading last</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="45433E48B39F"><Name>amount</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue></ItemValues><Environment uid="5F5887BCF726"/><ItemDefinition uid="212C818D8F16"/><DataCategory uid="A92693A99BAD"><Name>Quantity</Name><Path>quantity</Path></DataCategory><AmountPerMonth>25.200</AmountPerMonth><ValidFrom>20080901</ValidFrom><End>false</End><DataItem uid="A70149AF0F26"/><Profile uid="92C8DB30F46B"/></ProfileItem><Path>/home/energy/quantity/6E9B1517D753</Path><Profile uid="92C8DB30F46B"/></ProfileItemResource></Resources>')
    item = AMEE::Profile::Item.get(connection, "/profiles/92C8DB30F46B/home/energy/quantity/6E9B1517D753")
    item.update()
  end
  
  it "without having an existing item" do
    connection = flexmock "connection"
    connection.should_receive(:put).with("/profiles/92C8DB30F46B/home/energy/quantity/6E9B1517D753", {}).and_return('<?xml version="1.0" encoding="UTF-8"?><Resources><ProfileItemResource><ProfileItem created="2008-09-12 17:20:32.0" modified="2008-09-12 17:20:32.0" uid="6E9B1517D753"><Name>6E9B1517D753</Name><ItemValues><ItemValue uid="0A671BF3D593"><Path>kgPerMonth</Path><Name>kg Per Month</Name><Value>10</Value><ItemValueDefinition uid="51D072825D41"><Path>kgPerMonth</Path><Name>kg Per Month</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="36A771FC1D1A"><Name>kg</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="0E4CF565A5AB"><Path>kWhPerMonth</Path><Name>kWh Per Month</Name><Value>0</Value><ItemValueDefinition uid="4DF458FD0E4D"><Path>kWhPerMonth</Path><Name>kWh Per Month</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="26A5C97D3728"><Name>kWh</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="D58700708731"><Path>litresPerMonth</Path><Name>Litres Per Month</Name><Value>0</Value><ItemValueDefinition uid="C9B7E19269A5"><Path>litresPerMonth</Path><Name>Litres Per Month</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="06B8CFC5A521"><Name>litre</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="BD1267F2D001"><Path>kWhReadingCurrent</Path><Name>kWh reading current</Name><Value>0</Value><ItemValueDefinition uid="8A468E75C8E8"><Path>kWhReadingCurrent</Path><Name>kWh reading current</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="45433E48B39F"><Name>amount</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue><ItemValue uid="B199A908A259"><Path>kWhReadingLast</Path><Name>kWh reading last</Name><Value>0</Value><ItemValueDefinition uid="2328DC7F23AE"><Path>kWhReadingLast</Path><Name>kWh reading last</Name><FromProfile>true</FromProfile><FromData>false</FromData><ValueDefinition uid="45433E48B39F"><Name>amount</Name><ValueType>DECIMAL</ValueType></ValueDefinition></ItemValueDefinition></ItemValue></ItemValues><Environment uid="5F5887BCF726"/><ItemDefinition uid="212C818D8F16"/><DataCategory uid="A92693A99BAD"><Name>Quantity</Name><Path>quantity</Path></DataCategory><AmountPerMonth>25.200</AmountPerMonth><ValidFrom>20080901</ValidFrom><End>false</End><DataItem uid="A70149AF0F26"/><Profile uid="92C8DB30F46B"/></ProfileItem><Path>/home/energy/quantity/6E9B1517D753</Path><Profile uid="92C8DB30F46B"/></ProfileItemResource></Resources>')
    AMEE::Profile::Item.update(connection, "/profiles/92C8DB30F46B/home/energy/quantity/6E9B1517D753")
  end

end
