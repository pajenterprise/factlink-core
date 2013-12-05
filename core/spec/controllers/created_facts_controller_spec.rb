require 'spec_helper'

describe CreatedFactsController do
  render_views

  let (:user) { create :user }

  # TODO: Move to somewhere where there are still facts
  it "facts json should stay the same" do
    # not doing the whole time cop thing, since the dates in the
    # timestamped set are generated by redis (This is: Jan's guess (TM))
    FactoryGirl.reload # hack because of fixture in check

    f1 = create :fact, created_by: user.graph_user
    f2 = create :fact, created_by: user.graph_user
    f3 = create :fact, created_by: user.graph_user

    channel = create :channel, created_by: user.graph_user
    [f1,f2,f3].each do |f|
      Interactors::Channels::AddFact.new(fact: f, channel: channel, pavlov_options: { no_current_user: true }).call
    end

    authenticate_user!(user)

    get :index, username: user.username, format: :json
    response.should be_success

    response_body = response.body.to_s
    # strip mongo id, since otherwise comparison will always fail
    response_body.gsub!(/"id":\s*"[^"]*"/, '"id": "<STRIPPED>"')
    response_body.gsub!(/"timestamp":\s*\d*\.0/, '"timestamp": 0')
    Approvals.verify(response_body, format: :json, name: 'channels#facts should keep the same content')
  end

end
