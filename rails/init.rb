require 'amee'
require 'amee/rails'

# Load config/amee.yml
amee_config = "#{RAILS_ROOT}/config/amee.yml"
if File.exist?(amee_config)
  # Load config
  $AMEE_CONFIG = YAML.load_file(amee_config)[RAILS_ENV]
  # Create a global AMEE connection that we can use from anywhere in this app
  AMEE::Rails.establish_connection($AMEE_CONFIG['server'], $AMEE_CONFIG['username'], $AMEE_CONFIG['password'])
end

# Add AMEE extensions into ActiveRecord::Base
ActiveRecord::Base.class_eval { include AMEE::Rails }
