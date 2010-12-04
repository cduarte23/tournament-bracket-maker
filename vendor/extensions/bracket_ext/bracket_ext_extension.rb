# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

class BracketExtExtension < Radiant::Extension
  version "1.0"
  description "Add's Bracket making"
  url "http://shawnlindsey.com"
  
  # extension_config do |config|
  #   config.gem 'some-awesome-gem
  #   config.after_initialize do
  #     run_something
  #   end
  # end

  # See your config/routes.rb file in this extension to define custom routes
  
  def activate
    # tab 'Content' do
    #   add_item "Bracket Ext", "/admin/bracket_ext", :after => "Pages"
    # end
  end
end
