#####
# Aliases
#####

alias ls "ls -GFh"
alias sudo "sudo -H"


#####
# Dynamic variables
#####

set -g __prompt_hostname (string replace -r "\..*" "" $hostname)


#####
# Startup
#####

if status --is-login
	## Basic prompt
	set -g __prompt_mode "basic"

	## tmux
	if not set -q TMUX
		read -ln1 -p 'echo -n "Connect to main tmux session [y/N]? "' answer
		switch $answer
		case "y" "Y"
			if not tmux has -t main > /dev/null 2>&1
				tmuxp load -d main
			end
			tmux attach -t main
		end
	end
end

