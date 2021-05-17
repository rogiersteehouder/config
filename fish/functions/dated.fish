function dated -d "Like echo, but with the date and time in front"
	string join " " (date +'%Y-%m-%d %H:%M:%S') ">" $argv
end
