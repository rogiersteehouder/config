function list_remove --description 'Remove item from shell variable list'
	argparse -n list_remove -N 2 'a/all' -- $argv
	or return

	set -l var $argv[1]
	set -l i

	for value in $argv[2..-1]
		set i (eval "contains -i \$value \$$var")
		while test -n "$i"
			eval "set -e $var\[\$i\]"
			set i ''
			if set -q _flag_all
				set i (eval "contains -i \$value \$$var")
			else
				break
			end
		end
	end
end
