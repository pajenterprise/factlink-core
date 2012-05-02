module Topics
  class Topic < Mustache::Railstache
    def title
      self[:topic].title
    end

    def channels
    	self[:topic].top_users(3).map do |u|
    		ch = u.graph_user.channels.find(slug_title: self[:topic].slug_title).first
    		{channel: ch, user: u}
    	end.keep_if { |h| h[:channel] }.map do |h|
    		{
    			user_name: h[:user].username,
    			channel_url: channel_path(h[:user],h[:channel]),
    			avatar_url: h[:user].avatar_url,
    			authority: sprintf('%.1f',Authority.from(self[:topic],for: h[:user].graph_user).to_f+1.0)	
    		}
    	end
    end
  end
end
