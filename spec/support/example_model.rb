# frozen_string_literal: true

require "track_ballast/uuid_management"

class ExampleModel < ActiveRecord::Base
  include TrackBallast::UuidManagement
end
