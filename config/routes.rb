DiscourseWellfed::Engine.routes.draw do
  resources :feed_settings, path: '/', constraints: StaffConstraint.new, only: [:index]
end
