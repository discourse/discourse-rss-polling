DiscourseWellfed::Engine.routes.draw do
  root 'feed_settings#show'

  resource :feed_settings, constraints: StaffConstraint.new, only: [:show]
end
