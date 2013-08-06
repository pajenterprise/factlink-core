require 'pavlov_helper'
require_relative '../../../app/interactors/commands/elastic_search_index_user_for_text_search'

describe Commands::ElasticSearchIndexUserForTextSearch do
  include PavlovSupport

  let(:user) do
    double(id: 1, username: 'codinghorror', first_name: 'Sjaak', last_name: 'afhaak')
  end

  before do
    stub_classes 'HTTParty', 'FactlinkUI::Application'
  end

  describe '#call' do
    it 'correctly' do
      url = 'localhost:9200'
      config = double
      config.stub elasticsearch_url: url
      FactlinkUI::Application.stub config: config
      url = "http://#{url}/user/#{user.id}"
      command = described_class.new(object: user)

      hashie = {}
      json_document = double
      Commands::ElasticSearchIndexForTextSearch.any_instance.stub(:document).and_return(hashie)
      hashie.stub(:to_json).and_return(json_document)

      HTTParty.should_receive(:put).with(url, { body: json_document })

      command.call
    end
  end
end
