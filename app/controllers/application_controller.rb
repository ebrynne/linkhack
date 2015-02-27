class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def redirector
    short, args = request.fullpath[1..-1].split('/', 2).reject { |s| s.empty? }
    link = Link.find_by_shortlink(short)
    if link
      url = link.url
      if link.argsstr && args
        url = url + link.argsstr.sub('%s', args)
      end
      redirect_to url
    else
      redirect_to :controller => 'links',
        :action => 'new',
        :link => {:shortlink => short, :argsstr => args}
    end
  end
end
