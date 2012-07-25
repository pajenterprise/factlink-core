class AddCreatedChannelCountToMixpanel < Mongoid::Migration
  def self.up
    mixpanel = FactlinkUI::Application.config.mixpanel.new({}, true)

    User.active.each do |user|
      gu = user.graph_user

      mixpanel.set_person_event user.id.to_s, channels_created: gu.channels.length
    end
  end

  def self.down
  end
end
