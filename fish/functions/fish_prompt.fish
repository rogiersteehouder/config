function fish_prompt --description 'Write out the prompt'
	set last_status $status

	# hostname
	if not set -q __prompt_hostname
		set -g -x __prompt_hostname (string replace -r "\..*" "" $hostname)
	end

	# just in case
	if not set -q COLUMNS
		set -g -x COLUMNS 80
	end

	switch "$__prompt_mode"
	# Fancy prompt
	case "fancy"
		# ┌─┤error code├─┤username├─┤hostname├─┤path├─┤date├──
		# │ jobs
		# ├─┤git branch├─┤new│modified│new staged│modified staged│conflicts├──
		# └─>
		if test "$__prompt_dir" != "$PWD"
			set -g -x __prompt_pwd_git 1
			set -g __prompt_dir $PWD
		end

		set -l prompt
		for line in (jobs | prompt-fancy $last_status 1 1)
			if string match -q -e "# *" $line
				set var (string split -m 1 "=" (string sub -s 3 $line))
				set -g -x $var[1] $var[2]
			else
				set -a prompt $line
			end
		end
		if test (count $prompt) -gt 1
			for line in $prompt[1..-2]
				echo $line
			end
			echo -n $prompt[-1]
		else
			echo -n $prompt
		end

	# Powerline prompt
	case "powerline"
		powerline-shell --shell bare $last_status

	# Basic prompt
	case "basic"
		# [error|jobs] username{@hostname}: path >
		prompt-simple $last_status (count (jobs))

	# Fallback
	case "*"
		echo -s (set_color red) "==> " (set_color normal)
	end

	# Fallback if the script fails
	if test $status -gt 0
		echo -s (set_color red) "==> " (set_color normal)
	end
end
