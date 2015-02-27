class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def redirector
    path = request.fullpath.split('/').reject { |s| s.empty? }
    puts path[0]
    link = Link.find_by_shortlink(path[0])
    redirect_to link.url
  end
end
