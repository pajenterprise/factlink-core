class FactsController < ApplicationController

  layout "client"

  before_filter :set_layout, :only => [:new]

  respond_to :json, :html

  before_filter :load_fact,
    :only => [
      :show,
      :edit,
      :destroy,
      :get_channel_listing,
      :update,
      :bubble,
      :opinion,
      :evidence_search,
      :add_supporting_evidence,
      :add_weakening_evidence
      ]
  before_filter :potential_evidence,
    :only => [
      :show,
      :evidence_search,
      :edit]

  around_filter :allowed_type,
    :only => [:set_opinion ]


  def show
    authorize! :show, @fact
    @title = @fact.data.displaystring # The html <title>
    @modal = true
    @hide_links_for_site = @modal && @fact.site

    respond_with(lazy {Facts::Fact.for(fact: @fact, view: view_context)})
  end

  def index
    @facts = Fact.all

    respond_with(@facts.map {|f| Facts::Fact.for(fact: f,view: view_context)})
  end

  def intermediate
    render layout: nil
  end

  def new
    render layout: @layout
  end

  def create
    authorize! :create, Fact
    @fact = create_fact(params[:url], params[:fact], params[:title])

    if params[:opinion] and [:beliefs, :believes, :doubts, :disbeliefs, :disbelieves].include?(params[:opinion].to_sym)
      @fact.add_opinion(params[:opinion].to_sym, current_user.graph_user)
      @fact.calculate_opinion(1)
    end

    respond_to do |format|
      if @fact.save
        format.html do
           flash[:notice] = 'Factlink successfully added. <a href="#{channel_path(current_user.username, current_graph_user.created_facts_channel_id)}" target="_blank">Click here</a>'.html_safe
           redirect_to controller: 'facts', action: 'new', url: params[:url], title: params[:title], layout: params[:layout]
         end
        format.json { render json: @fact, status: :created, location: @fact.id }
      else
        format.html { render :new }
        format.json { render json: @fact.errors, status: :unprocessable_entity }
      end
    end
  end

  def get_channel_listing
    authorize! :index, Channel
    @channels = current_user.graph_user.editable_channels_for(@fact)
    respond_to do |format|
      format.json { render :json => @channels, :callback => params[:callback], :content_type => "text/javascript" }
      format.html { render 'channel_listing', layout: nil }
    end
  end

  def create_fact_as_evidence
    evidence = create_fact(params[:url], params[:fact], params[:title])
    @fact_relation = add_evidence(evidence.id, params[:type].to_sym, params[:fact_id])
  end

  def add_supporting_evidence() ; add_evidence_internal(:supporting)  end
  def add_weakening_evidence()  ; add_evidence_internal(:weakening)   end

  def add_evidence_internal(type)
    authorize! :add_evidence, @fact
    add_evidence_internal_internal(type, success: "add_source_to_factlink", fail: "adding_evidence_not_possible")
  end

  def add_evidence_internal_internal(type,render_params)
    @fact_relation = add_evidence(params[:evidence_id], type, @fact.id)

    # A FactRelation will not get created if it will cause a loop
    if @fact_relation.nil?
      render render_params[:fail]
    else
      render render_params[:success]
    end
  end

  def add_new_evidence
    type = params[:type].to_sym
    if type == :weakening
      self.add_weakening_evidence
    elsif type == :supporting
      self.add_supporting_evidence
    end
  end

  def destroy
    if current_user.graph_user == @fact.created_by
      @fact_id = @fact.id
      @fact.delete

      respond_with(@fact)
    end
  end

  def update
    @fact = Fact[params[:id]]
    respond_to do |format|
      if @fact.update_attributes(params[:factlink])
        format.html { redirect_to(@fact,
          :notice => 'Fact was successfully updated.') }
      else
        format.html { render :edit }
      end
    end
  end

  def update_title
    # Gets 'title-[id]' 'cuz it must be unique and Jeditable is using the elements 'id'
    # Strip first six characters to find the ID
    id = params[:id].slice(6..(params[:id].length - 1))
    @fact = Fact[id]
    authorize! :update, @fact

    @fact.data.title = params[:value]
    @fact.data.save

    render :text => @fact.data.title
  end

  def opinion
    render :json => {"opinions" => @fact.get_opinion(3).as_percentages}, :callback => params[:callback], :content_type => "text/javascript"
  end

  def set_opinion
    type = params[:type].to_sym
    @basefact = Basefact[params[:id]]

    authorize! :opinionate, @basefact

    @basefact.add_opinion(type, current_user.graph_user)
    @basefact.calculate_opinion(2)

    render json: [@basefact]
  end

  def remove_opinions
    @basefact = Basefact[params[:id]]

    authorize! :opinionate, @fact

    @basefact.remove_opinions(current_user.graph_user)
    @basefact.calculate_opinion(2)

    render json: [@basefact]
  end

  def evidence_search
    pe = @potential_evidence.to_a.map { |fact|
      fact.id.to_s
    }

    solr_result = Sunspot.search FactData do
      fulltext params[:s] do
        highlight :displaystring
      end

      with(:fact_id).any_of(pe)
    end

    facts = solr_result.results.map do |result|
      Facts::FactRelationSearchResult.for(fact: result, view: view_context)
    end

    render json: facts
  end

  private
    def potential_evidence
      @potential_evidence = Fact.all.except(:data_id => @fact.data_id).sort(:order => "DESC")
    end

    def load_fact
      id = params[:fact_id] || params[:id]

      @fact = Fact[id] || raise_404
    end

    def add_evidence(evidence_id, type, fact_id) # private
      type     = type.to_sym
      fact     = Fact[fact_id]
      evidence = Fact[evidence_id]

      # Create FactRelation
      fact_relation = fact.add_evidence(type, evidence, current_user)
      evidence.add_opinion(:believes, current_user.graph_user)
      fact_relation.add_opinion(:believes, current_user.graph_user)
      fact_relation
    end

    def create_fact(url, displaystring, title) # private
      @site = url && (Site.find(:url => url).first || Site.create(:url => url))

      fact_params = {created_by: current_user.graph_user}
      fact_params[:site] = @site if @site
      @fact = Fact.create fact_params

      @fact.data.displaystring = displaystring
      @fact.data.title = title
      @fact.data.save
      @fact
    end

    def allowed_type
      allowed_types = [:beliefs, :doubts, :disbeliefs,:believes, :disbelieves]
      type = params[:type].to_sym
      if allowed_types.include?(type)
        yield
      else
        render :json => {"error" => "type not allowed"}, :status => 500
        false
      end
    end

    def set_layout
      allowed_layouts = ['popup']
      allowed_layouts.include?(params[:layout]) ? @layout = params[:layout] : @layout = 'frontend'
    end
end
