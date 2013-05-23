# set optional arguments to nil so we can easily check with if
channel  ||= nil
timestamp ||= 0
# TODO: set timestamp to nil, but this always defaulted to 0
# so check that nothing depends on it.

dead_fact = query :'facts/get_dead', fact.id.to_s

json.displaystring dead_fact.displaystring
json.id dead_fact.id

if current_graph_user
  channel_list = ChannelList.new(current_graph_user)
  containing_channel_ids = channel_list.containing_real_channel_ids_for_fact fact
  json.containing_channel_ids containing_channel_ids
end
json.url friendly_fact_path(dead_fact)

if channel
  deletable_from_channel = (user_signed_in? and
                           channel.is_real_channel? and
                           channel.created_by == current_graph_user)
  json.deletable_from_channel? deletable_from_channel

  timestamp_in_seconds = timestamp / 1000
  friendly_time = TimeFormatter.as_time_ago(timestamp_in_seconds)
  json.friendly_time friendly_time
end

json.created_by do |j|
  j.partial! partial: "users/user_authority_for_subject_partial",
                formats: [:json],
                handlers: [:jbuilder],
                locals: {
                  user: fact.created_by.user,
                  subject: dead_fact
                }
end

json.created_by_ago "Created #{TimeFormatter.as_time_ago dead_fact.created_at} ago"

json.fact_title dead_fact.title
json.fact_wheel do |j|
  j.partial! partial: 'facts/fact_wheel',
                formats: [:json], handlers: [:jbuilder],
                locals: {
                  dead_fact_wheel: query('facts/get_dead_wheel', dead_fact.id.to_s)
                }
end

if dead_fact.site_url
  json.fact_url dead_fact.site_url
  proxy_scroll_url = FactlinkUI::Application.config.proxy_url + "/?url=" + CGI.escape(dead_fact.site_url) + "&scrollto=" + URI.escape(dead_fact.id)
  json.proxy_scroll_url proxy_scroll_url
end

json.timestamp timestamp
