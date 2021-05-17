function wttr --description "Weersvoorspelling"
	if test -n $argv
		set argv "Enschede"
	end
	set -l request "http://wttr.in/$argv"
	if test $COLUMNS -lt 125
		set request "$request?n"
	end
	curl -H "Accept-Language: nl" --compressed "$request"
end
