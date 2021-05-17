function edit_function
	argparse -n edit_function -N 1 -X 1 'e/editor=' -- $argv
	or return

	set funcname $argv[1]

	if not functions -q $funcname
		echo "$funcname is not a function"
		return 1
	end

	set -l editor
	if set -q _flag_editor
		set editor $_flag_editor
	else if set -q VISUAL
		set editor $VISUAL
	else if set -q EDITOR
		set editor $EDITOR
	else
		echo "Can't find an editor, set $EDITOR or specify with -e"
		return 1
	end

	set funcpath (functions -D $funcname)
	if string match "$__fish_config_dir*" $funcpath
		$editor $funcpath
	else
		echo "$funcname is found in $funcpath."
		echo "Save a copy in your config first: funcsave $funcname"
		return 1
	end
end
