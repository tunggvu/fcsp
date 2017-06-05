module Concerns::CheckPostTime
  extend ActiveSupport::Concern
  include ApplicationHelper

  def check_time post_time
    if post_time
      time = format_time post_time, :format_datetime
      date = format_time post_time, :format_date
      min_time = format_time Time.zone.now, :format_datetime
      max_date = format_time (Time.zone.now + 30.days), :format_date
      if time < min_time || date > max_date
        errors.add :error, I18n.t(".invalid_datetime")
      end
    end
  end
end
