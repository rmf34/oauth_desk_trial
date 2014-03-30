# http://ruby-doc.org/core-2.0/Time.html#method-i-strftime

# other app wide formatting for time data can be easily added here
# Usage: <Date>.to_s(:normal_date_time) # => Mar 29, 2014 17:58PM

[Date, Time, DateTime].each do |klass|
  # klass::DATE_FORMATS[:short_full_date] = "%b %d, '%y"
  klass::DATE_FORMATS[:normal_date_time] = "%b %d, %Y %H:%M%p"
end
