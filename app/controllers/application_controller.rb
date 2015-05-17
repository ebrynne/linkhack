class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def redirector
    # todo: holy shit this could be cleaned up a lot. As soon as I have some free time.
    short, args = request.fullpath[1..-1].split('/', 2).reject { |s| s.empty? }
    link = Link.find_by_shortlink(short)
    if link
      url = link.url
      if !link.argsstr.empty? && args
        url = url + link.argsstr.sub('%s', args)
      end
      redirect_to url
    else
      if RegexLink.all.map do |rlink|
        match = /#{rlink.shortlink}/.match(request.fullpath[1..-1])
        if match
          url = rlink.url
          args = if match.length > 1 then match[1] else match[0] end
          unless args.empty?
            unless rlink.argsstr.empty?
              url = rlink.argsstr.sub('%s', args)
            else
              url = url + args
            end
          end
          redirect_to url
        end
      end.compact.empty?
        redirect_to :controller => 'links',
          :action => 'new',
          :link => {:shortlink => short, :argsstr => args}
      end
    end
  end
end
