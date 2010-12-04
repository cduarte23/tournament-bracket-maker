ActionController::Routing::Routes.draw do |map|
  # map.namespace :admin, :member => { :remove => :get } do |admin|
     map.resources :brackets
     map.with_options(:controller => 'brackets') do |link|
      link.link_print_brackets 'brackets/print_bracket/:id', :action => 'print_brackets'
     end
  # end
end
