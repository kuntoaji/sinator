module Melodiest
  module Auth

    # http://www.sinatrarb.com/faq.html#auth
    module Http
      def authorized!(username="admin", password="admin")
        return if authorized?(username, password)
        headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
        halt 401, "Not authorized\n"
      end

      def authorized?(username, password)
        @auth ||=  Rack::Auth::Basic::Request.new(request.env)
        @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == [username, password]
      end
    end

  end
end
