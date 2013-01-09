require_relative '../../../../app/interactors/queries/channels/handpicked'
require 'pavlov_helper'

describe Queries::Channels::Handpicked do
  include PavlovSupport

  before do
    Queries::Channels::Handpicked.any_instance.stub(:authorized?).and_return(true)
  end

  describe '.execute' do
    before do
      stub_classes 'Channel'
    end

    it 'should retrieve the array of handpicked channels from redis' do
      channel_id = mock
      channel = mock

      handpicked_channel_ids = [channel_id]
      channels = [channel]

      query = Queries::Channels::Handpicked.new {}
      query.should_receive(:handpicked_channel_ids).and_return(handpicked_channel_ids)

      Channel.should_receive(:[]).with(channel_id).and_return(channel)

      expect(query.execute).to eq channels
    end
  end

  describe '.handpicked_channel_ids' do
    before do
      stub_classes 'TopChannels'
    end

    it 'should retrieve an array of handpicked channel ids' do
      top_channels_instance = mock
      channel_ids = mock

      query = Queries::Channels::Handpicked.new {}

      TopChannels.should_receive(:new).and_return(top_channels_instance)
      top_channels_instance.should_receive(:ids).and_return(channel_ids)

      expect(query.handpicked_channel_ids).to eq channel_ids
    end
  end
end