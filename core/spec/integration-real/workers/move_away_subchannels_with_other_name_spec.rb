require 'spec_helper'

describe MoveAwaySubchannelsWithOtherName do
  include PavlovSupport

  let(:user1) {create :user}
  let(:user2) {create :user}
  let(:user3) {create :user}
  let(:user4) {create :user}
  let(:channel_user) {create :user}

  describe '#subchannels_with_other_name' do
    it "returns all subchannels which don't have the same title as the top channel" do
      channel, ch1, ch2, ch3, ch4 = ()

      as(user1) do |pavlov|
        ch1 = pavlov.command :'channels/create', 'Foo'
      end
      as(user2) do |pavlov|
        ch2 = pavlov.command :'channels/create', 'Bar'
      end
      as(user3) do |pavlov|
        ch3 = pavlov.command :'channels/create', 'Baz'
      end
      as(user4) do |pavlov|
        ch4 = pavlov.command :'channels/create', 'Foo'
      end
      as(channel_user) do |pavlov|
        channel = pavlov.command :'channels/create', 'Foo'
        [ch1, ch2, ch3, ch4].each do |ch|
          pavlov.command 'channels/add_subchannel', channel, ch
        end
      end

      worker = MoveAwaySubchannelsWithOtherName.new(channel.id)

      subchannel_ids = worker.subchannels_with_other_name
                             .map(&:id)

      expect(subchannel_ids).to match_array [ch2.id, ch3.id]

    end
  end
  describe '#reassign_subchannel' do
    it 'follows a subchannel in a channel which has the same name, and removes from this one' do
      channel, ch1, ch2 = ()

      as(user1) do |pavlov|
        ch1 = pavlov.command :'channels/create', 'Foo'
      end
      as(user2) do |pavlov|
        ch2 = pavlov.command :'channels/create', 'Bar'
      end
      as(channel_user) do |pavlov|
        channel = pavlov.command :'channels/create', 'Foo'
        [ch1, ch2].each do |ch|
          pavlov.command :'channels/add_subchannel', channel, ch
        end
      end

      worker = MoveAwaySubchannelsWithOtherName.new(channel.id)

      worker.reassign_subchannel ch2

      as(channel_user) do |pavlov|
        channel_bar = pavlov.query :'channels/get_by_slug_title', ch2.slug_title
        expect(channel_bar).not_to be_nil
        expect(channel_bar.contained_channels.ids).to match_array [ch2.id]

        expect(channel.contained_channels.ids).to match_array [ch1.id]
      end
    end
  end
  describe '#perform' do
    it "moves away all subchannels which don't belong here" do
            channel, ch1, ch2, ch3, ch4 = ()

      as(user1) do |pavlov|
        ch1 = pavlov.command :'channels/create', 'Foo'
      end
      as(user2) do |pavlov|
        ch2 = pavlov.command :'channels/create', 'Bar'
      end
      as(user3) do |pavlov|
        ch3 = pavlov.command :'channels/create', 'Baz'
      end
      as(user4) do |pavlov|
        ch4 = pavlov.command :'channels/create', 'Foo'
      end
      as(channel_user) do |pavlov|
        channel = pavlov.command :'channels/create', 'Foo'
        pavlov.command :'channels/create', 'Bar'
        [ch1, ch2, ch3, ch4].each do |ch|
          pavlov.command 'channels/add_subchannel', channel, ch
        end
      end

      worker = MoveAwaySubchannelsWithOtherName.new(channel.id)
      worker.perform

      as(channel_user) do |pavlov|
        channel_bar = pavlov.query :'channels/get_by_slug_title', ch2.slug_title
        channel_baz = pavlov.query :'channels/get_by_slug_title', ch3.slug_title

        expect(channel_bar).not_to be_nil
        expect(channel_bar.contained_channels.ids).to match_array [ch2.id]

        expect(channel_baz).not_to be_nil
        expect(channel_baz.contained_channels.ids).to match_array [ch3.id]

        expect(channel.contained_channels.ids).to match_array [ch1.id, ch4.id]
      end

    end
  end
end
