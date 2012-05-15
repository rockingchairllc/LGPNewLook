module ApplicationHelper

def shorten (string, count = 210)
	if string.length >= count
		shortened = string[0, count]
		splitted = shortened.split(/\s/)
		words = splitted.length
		(splitted[0, words-1].join(' ') + '&hellip;').html_safe
	else
		string
	end
end

def date_simple_format(date)
  date.strftime("%m/%d/%y")
end

def time_twelve_hour_format(date)
  date.strftime("%I:%M %P")
end

end
