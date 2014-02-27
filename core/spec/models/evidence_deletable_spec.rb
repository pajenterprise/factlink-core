require 'spec_helper'

describe EvidenceDeletable do

  context 'Comment' do
    let(:created_by_user) { create :full_user }
    let(:other_user)      { create :full_user }
    let(:fact_user)       { create :full_user }
    let(:fact)            { create :fact }

    let(:comment) do
      pavlov_options = {
        current_user: created_by_user,
        ability: Ability.new(created_by_user)
      }
      interactor = Interactors::Comments::Create.new(fact_id: fact.id.to_i,
                                                     type: 'believes', content: 'content', pavlov_options:pavlov_options )
      dead_comment = interactor.call
      Comment.find(dead_comment.id)
    end

    def deletable comment
      EvidenceDeletable.new(comment).deletable?
    end

    def add_opinion comment, opinion, graph_user
      believable_of(comment).add_opiniated(opinion, graph_user)
    end

    def believable_of comment
      Believable::Commentje.new(comment)
    end

    it "should be true initially" do
      deletable(comment).should be_true
    end
    it "should be false after someone comments on it" do
      pavlov_options = {
        current_user: comment.created_by,
        ability: Ability.new(comment.created_by)
      }

      interactor = Interactors::SubComments::Create.new(comment_id: comment.id.to_s,
                                                        content: 'hoi', pavlov_options: pavlov_options)
      interactor.execute
      deletable(comment).should be_false
    end
  end

end
