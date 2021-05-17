function edit --description "Edit files in the prefered text editor"
	if test -z "$VISUAL"
		$EDITOR $argv
	else
		$VISUAL $argv
	end
end
