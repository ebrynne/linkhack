class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def redirector
    fullpath = request.fullpath[1..-1]
    short, args = fullpath.split('/', 2).reject(&:empty?)

    link = Link.find_by_shortlink(short)

    if link.present?
      url = link.url

      url += link.argsstr.sub('%s', args) if !link.argsstr.empty? && args

      redirect_to url
      return
    end

    link = RegexLink.all.find { |regex_link| regex_link.matches_path? fullpath }

    if link.present?
      redirect_to link.url_for(fullpath)
      return
    end

    redirect_to(
      controller: :links,
      action: :new,
      link: {
        shortlink: short,
        argsstr: args
      }
    )
  end
end
