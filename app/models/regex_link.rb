class RegexLink < Link
  def matches_path?(path)
    /#{shortlink}/.match(path).present?
  end

  def url_for(path)
    regex_match = /#{shortlink}/.match(path)

    target_url = url

    args = regex_match.length > 1 ? regex_match[1] : regex_match[0]

    return target_url if args.empty?

    if argsstr.empty?
      target_url += args
    else
      target_url += argsstr.sub('%s', args)
    end

    target_url
  end
end

# == Schema Information
#
# Table name: links
#
#  id          :integer          not null, primary key
#  shortlink   :string
#  url         :string
#  argsstr     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :text
#  type        :text
#
