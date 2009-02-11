require 'date'

module AMEE
  module Profile
    class Category < AMEE::Profile::Object

      def initialize(data = {})
        @children = data ? data[:children] : []
        @items = data ? data[:items] : []
        @total_amount = data[:total_amount]
        @total_amount_unit = data[:total_amount_unit]
        super
      end

      attr_reader :children
      attr_reader :items
      attr_reader :total_amount
      attr_reader :total_amount_unit

      def self.parse_json_profile_item(item)
        item_data = {}
        item_data[:values] = {}
        item.each_pair do |key, value|
          case key
            when 'dataItemLabel', 'dataItemUid', 'name', 'path', 'uid'
              item_data[key.to_sym] = value
            when 'created', 'modified', 'label' # ignore these
              nil
            when 'validFrom'
              item_data[:validFrom] = DateTime.strptime(value, "%Y%m%d")
            when 'end'
              item_data[:end] = (value == "true")
            when 'amountPerMonth'
              item_data[:amountPerMonth] = value.to_f
            else
              item_data[:values][key.to_sym] = value
          end
        end
        item_data[:path] ||= item_data[:uid] # Fill in path if not retrieved from response
        return item_data
      end

      def self.parse_json_profile_category(category)
        datacat = category['dataCategory'] ? category['dataCategory'] : category
        category_data = {}
        category_data[:name] = datacat['name']
        category_data[:path] = datacat['path']
        category_data[:uid] = datacat['uid']
        category_data[:totalAmountPerMonth] = category['totalAmountPerMonth'].to_f
        category_data[:children] = []
        category_data[:items] = []
        if category['children']
          category['children'].each do |child|
            if child[0] == 'dataCategories'
              child[1].each do |child_cat|
                category_data[:children] << parse_json_profile_category(child_cat)
              end
            end
            if child[0] == 'profileItems' && child[1]['rows']
              child[1]['rows'].each do |child_item|
                category_data[:items] << parse_json_profile_item(child_item)
              end
            end
          end
        end
        return category_data
      end

      def self.from_json(json)
        # Parse json
        doc = JSON.parse(json)
        data = {}
        data[:profile_uid] = doc['profile']['uid']
        data[:profile_date] = DateTime.strptime(doc['profileDate'], "%Y%m")
        data[:name] = doc['dataCategory']['name']
        data[:path] = doc['path']
        data[:total_amount] = doc['totalAmountPerMonth']
        data[:total_amount_unit] = "kg/month"
        data[:children] = []
        if doc['children'] && doc['children']['dataCategories']
          doc['children']['dataCategories'].each do |child|
            data[:children] << parse_json_profile_category(child)
          end
        end
        data[:items] = []
        profile_items = []
        profile_items.concat doc['children']['profileItems']['rows'] rescue nil
        profile_items << doc['profileItem'] unless doc['profileItem'].nil?
        profile_items.each do |item|
          data[:items] << parse_json_profile_item(item)
        end
        # Create object
        Category.new(data)
      rescue
        raise AMEE::BadData.new("Couldn't load ProfileCategory from JSON data. Check that your URL is correct.")
      end

      def self.parse_xml_profile_item(item)
        item_data = {}
        item_data[:values] = {}
        item.elements.each do |element|
          key = element.name
          value = element.text
          case key.downcase
            when 'dataitemlabel', 'dataitemuid', 'name', 'path'
              item_data[key.to_sym] = value
            when 'validfrom'
              item_data[:validFrom] = DateTime.strptime(value, "%Y%m%d")
            when 'end'
              item_data[:end] = (value == "true")
            when 'amountpermonth'
              item_data[:amountPerMonth] = value.to_f
            else
              item_data[:values][key.to_sym] = value
          end
        end
        item_data[:uid] = item.attributes['uid'].to_s
        item_data[:path] ||= item_data[:uid] # Fill in path if not retrieved from response
        return item_data
      end

      def self.parse_xml_profile_category(category)
        category_data = {}
        category_data[:name] = category.elements['DataCategory'].elements['Name'].text
        category_data[:path] = category.elements['DataCategory'].elements['Path'].text
        category_data[:uid] = category.elements['DataCategory'].attributes['uid'].to_s
        category_data[:totalAmountPerMonth] = category.elements['TotalAmountPerMonth'].text.to_f rescue nil
        category_data[:children] = []
        category_data[:items] = []
        if category.elements['Children']
          category.elements['Children'].each do |child|
            if child.name == 'ProfileCategories'
              child.each do |child_cat|
                category_data[:children] << parse_xml_profile_category(child_cat)
              end
            end
            if child.name == 'ProfileItems'
              child.each do |child_item|
                category_data[:items] << parse_xml_profile_item(child_item)
              end
            end
          end
        end
        return category_data
      end

      def self.from_xml(xml)
        # Parse XML
        doc = REXML::Document.new(xml)
        data = {}
        data[:profile_uid] = REXML::XPath.first(doc, "/Resources/ProfileCategoryResource/Profile/@uid").to_s
        data[:profile_date] = DateTime.strptime(REXML::XPath.first(doc, "/Resources/ProfileCategoryResource/ProfileDate").text, "%Y%m")
        data[:name] = REXML::XPath.first(doc, '/Resources/ProfileCategoryResource/DataCategory/Name').text
        data[:path] = REXML::XPath.first(doc, '/Resources/ProfileCategoryResource/Path').text || ""
        data[:total_amount] = REXML::XPath.first(doc, '/Resources/ProfileCategoryResource/TotalAmountPerMonth').text.to_f rescue nil
        data[:total_amount_unit] = "kg/month"
        data[:children] = []
        REXML::XPath.each(doc, '/Resources/ProfileCategoryResource/Children/ProfileCategories/DataCategory') do |child|
          category_data = {}
          category_data[:name] = child.elements['Name'].text
          category_data[:path] = child.elements['Path'].text
          category_data[:uid] = child.attributes['uid'].to_s
          data[:children] << category_data
        end
        REXML::XPath.each(doc, '/Resources/ProfileCategoryResource/Children/ProfileCategories/ProfileCategory') do |child|
          data[:children] << parse_xml_profile_category(child)
        end
        data[:items] = []
        REXML::XPath.each(doc, '/Resources/ProfileCategoryResource/Children/ProfileItems/ProfileItem') do |item|
          data[:items] << parse_xml_profile_item(item)
        end
        REXML::XPath.each(doc, '/Resources/ProfileCategoryResource/ProfileItem') do |item|
          data[:items] << parse_xml_profile_item(item)
        end
        # Create object
        Category.new(data)
      rescue
        raise AMEE::BadData.new("Couldn't load ProfileCategory from XML data. Check that your URL is correct.")
      end

      def self.parse_v2_xml_profile_item(item)
        item_data = {}
        item_data[:values] = {}
        item.elements.each do |element|
          key = element.name
          case key.downcase
            when 'name', 'path'
              item_data[key.downcase.to_sym] = element.text
            when 'dataitem'
              item_data[:dataItemLabel] = element.elements['Label'].text
              item_data[:dataItemUid] = element.attributes['uid'].to_s
            when 'validfrom'
              item_data[:validFrom] = DateTime.strptime(element.text, "%Y%m%d")
            when 'startdate'
              item_data[:startDate] = DateTime.parse(element.text)
            when 'enddate'
              item_data[:endDate] = DateTime.parse(element.text) if element.text
            when 'end'
              item_data[:end] = (element.text == "true")
            when 'amount'
              item_data[:amount] = element.text.to_f
              item_data[:amount_unit] = element.attributes['unit'].to_s
            when 'itemvalues'
              element.elements.each do |itemvalue|
                path = itemvalue.elements['Path'].text
                item_data[:values][path.to_sym] = {}
                item_data[:values][path.to_sym][:name] = itemvalue.elements['Name'].text
                item_data[:values][path.to_sym][:value] = itemvalue.elements['Value'].text
                item_data[:values][path.to_sym][:unit] = itemvalue.elements['Unit'].text
                item_data[:values][path.to_sym][:per_unit] = itemvalue.elements['PerUnit'].text
              end
            else
              item_data[:values][key.to_sym] = element.text
          end
        end
        item_data[:uid] = item.attributes['uid'].to_s
        item_data[:path] ||= item_data[:uid] # Fill in path if not retrieved from response
        return item_data
      end

      def self.from_v2_xml(xml)
        # Parse XML
        doc = REXML::Document.new(xml)
        data = {}
        data[:profile_uid] = REXML::XPath.first(doc, "/Resources/ProfileCategoryResource/Profile/@uid").to_s
        #data[:profile_date] = DateTime.strptime(REXML::XPath.first(doc, "/Resources/ProfileCategoryResource/ProfileDate").text, "%Y%m")
        data[:name] = REXML::XPath.first(doc, '/Resources/ProfileCategoryResource/DataCategory/Name').text
        data[:path] = REXML::XPath.first(doc, '/Resources/ProfileCategoryResource/Path').text || ""
        data[:total_amount] = REXML::XPath.first(doc, '/Resources/ProfileCategoryResource/TotalAmount').text.to_f rescue nil
        data[:total_amount_unit] = REXML::XPath.first(doc, '/Resources/ProfileCategoryResource/TotalAmount/@unit').to_s rescue nil
        data[:children] = []
        REXML::XPath.each(doc, '/Resources/ProfileCategoryResource/ProfileCategories/DataCategory') do |child|
          category_data = {}
          category_data[:name] = child.elements['Name'].text
          category_data[:path] = child.elements['Path'].text
          category_data[:uid] = child.attributes['uid'].to_s
          data[:children] << category_data
        end
        REXML::XPath.each(doc, '/Resources/ProfileCategoryResource/Children/ProfileCategories/ProfileCategory') do |child|
          data[:children] << parse_xml_profile_category(child)
        end
        data[:items] = []
        REXML::XPath.each(doc, '/Resources/ProfileCategoryResource/ProfileItems/ProfileItem') do |item|
          data[:items] << parse_v2_xml_profile_item(item)
        end
        REXML::XPath.each(doc, '/Resources/ProfileCategoryResource/ProfileItem') do |item|
          data[:items] << parse_v2_xml_profile_item(item)
        end
        # Create object
        Category.new(data)
      rescue
        raise AMEE::BadData.new("Couldn't load ProfileCategory from V2 XML data. Check that your URL is correct.")
      end

      def self.get_history(connection, path, num_months, end_date = Date.today, items_per_page = 10)
        month = end_date.month
        year = end_date.year
        history = []
        num_months.times do
          date = Date.new(year, month)
          data = self.get(connection, path, date, items_per_page)
          # If we get no data items back, there is no data at all before this date, so don't bother fetching it
          if data.items.empty?
            (num_months - history.size).times do
              history << Category.new(:children => [], :items => [])
            end
            break
          else
            history << data
          end
          month -= 1
          if (month == 0)
            year -= 1
            month = 12
          end
        end
        return history.reverse
      end

      def self.parse(connection, response)
        # Parse data from response
        if response.is_json?
          cat = Category.from_json(response)
        elsif response.is_v2_xml?
          cat = Category.from_v2_xml(response)
        elsif response.is_xml?
          cat = Category.from_xml(response)
        end
        # Store connection in object for future use
        cat.connection = connection
        # Done
        return cat
      end


      def self.get(connection, path, options = {})
        unless options.is_a?(Hash)
          raise AMEE::ArgumentError.new("Third argument must be a hash of options!")
        end
        # Convert to AMEE options
        amee_options = {}
        if options[:start_date] && connection.version < 2
          amee_options[:profileDate] = options[:start_date].amee1_month 
        elsif options[:start_date] && connection.version >= 2
          amee_options[:startDate] = options[:start_date].amee2schema
        end
        if options[:end_date] && connection.version >= 2
          amee_options[:endDate] = options[:end_date].amee2schema
        end
        if options[:duration] && connection.version >= 2
          amee_options[:duration] = "PT#{options[:duration] * 86400}S"
        end
        amee_options[:itemsPerPage] = options[:items_per_page] if options[:items_per_page]
        amee_options[:recurse] = options[:recurse] if options[:recurse]
        # Load data from path
        response = connection.get(path, amee_options)
        return Category.parse(connection, response)
      rescue
        raise AMEE::BadData.new("Couldn't load ProfileCategory. Check that your URL is correct.")
      end
      
      def child(child_path)
        AMEE::Profile::Category.get(connection, "#{full_path}/#{child_path}")
      end

      def item(options)
        # Search fields - from most specific to least specific
        item = items.find{ |x| x[:uid] == options[:uid] || x[:name] == options[:name] || x[:dataItemUid] == options[:dataItemUid] || x[:dataItemLabel] == options[:dataItemLabel] }
        item ? AMEE::Profile::Item.get(connection, "#{full_path}/#{item[:path]}") : nil
      end

    end
  end
end
