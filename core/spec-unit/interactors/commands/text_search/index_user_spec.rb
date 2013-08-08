require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/text_search/index_user'

describe Commands::TextSearch::IndexUser do
  include PavlovSupport

  describe '#call' do
    it 'correctly' do
      user = double
      changed = double
      command = described_class.new(user: user, changed: changed)

      Pavlov.should_receive(:old_command)
            .with :'text_search/index',
                    user,
                    :user,
                    [:username, :first_name, :last_name],
                    changed

      command.call
    end
  end
end