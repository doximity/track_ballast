# frozen_string_literal: true

require "track_ballast/uuid_management"

RSpec.describe TrackBallast::UuidManagement do
  it "generates a UUID before validation" do
    model = ExampleModel.new
    model.uuid = nil
    expect(model.uuid).not_to be

    model.valid?

    expect(model.uuid).to be
  end
end
