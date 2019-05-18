# frozen_string_literal: true

DiscourseWellfed::Engine.routes.draw do
  root 'feed_settings#show'

  resource :feed_settings, constraints: StaffConstraint.new, only: [:show, :update]
end
