module FactlinksHelper

  # Sorting results on search page
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:s => params[:s], :sort => column, :direction => direction}, {:class => css_class}
  end

  # Popups
  def potential_childs_popup(potential_childs)
    render :partial => 'factlinks/client_popups/potential_childs', :locals => { :potential_childs => potential_childs }
  end

  def potential_parents_popup(potential_parents)
    render :partial => 'factlinks/client_popups/potential_parents', :locals => { :potential_parents => potential_parents }
  end


  # Listitem for in factlink client overview
  def factlink_source_partial_as_li(factlink, parent)
    render :partial => 'factlinks/source_as_li', :locals => { :factlink => factlink, :parent => parent }
  end
  
  # Score block of the top factlink in client
  def factlink_score_partial(factlink)
    render :partial => 'factlinks/score', :locals => { :factlink => factlink }
  end

  # The vote options for a fact: believe, doubt, disbelieve
  def vote_options(factlink, parent)
    render :partial => 'factlinks/vote_options', :locals => { :factlink => factlink, :parent => parent }
  end

end
