function please --description 'repeat last command with sudo'
	if not set -q argv[1]
		commandline -r (history search -1)
		set argv (commandline -o)
		commandline -r ""
	end
	sudo $argv
end
