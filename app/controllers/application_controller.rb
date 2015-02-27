class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def redirector
    segments = request.fullpath.split('/').reject { |s| s.empty? }
    shortlink = segments[0]
    link = Link.find_by_shortlink(shortlink)
    if link
      url = link.url
      if link.argsstr && segments.length > 1
        url = url + link.argsstr.sub('%s', segments[1])
      end
      redirect_to url
    else
      redirect_to :controller => 'links', :action => 'new'
    end
  end
end
