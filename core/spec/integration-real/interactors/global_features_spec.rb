require 'spec_helper'

describe 'global_features' do
  include PavlovSupport

  let(:current_user) do
    double(
      agrees_tos: true,
      admin?: true,
      features: [],
      has_invitations_left?: false,
      identities: nil,
    )
  end

  it 'initial state is empty' do
    as(current_user) do |pavlov|
      features = pavlov.old_interactor :'global_features/all'
      expect(features).to eq []
    end
  end

  it 'retains set features' do
    as(current_user) do |pavlov|
      features = [ "foo", "bar" ]
      pavlov.old_interactor :'global_features/set', features
      read_features = pavlov.old_interactor :'global_features/all'
      expect(read_features.to_set).to eq features.to_set
    end
  end

  it 'removes previously set features on a new set' do
    as(current_user) do |pavlov|
      features = [ "foo", "bar" ]
      new_features = [ "foobar" ]
      pavlov.old_interactor :'global_features/set', features
      pavlov.old_interactor :'global_features/set', new_features
      read_features = pavlov.old_interactor :'global_features/all'
      expect(read_features.to_set).to eq new_features.to_set
    end
  end
end