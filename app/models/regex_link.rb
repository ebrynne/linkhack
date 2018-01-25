class RegexLink < Link; end

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
