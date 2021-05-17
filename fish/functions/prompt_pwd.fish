function prompt_pwd --description 'Print the current working directory, shortened to fit the prompt'
	echo $PWD | sed -e "s|^$HOME|~|" -e "s-\([^/.]\{$fish_prompt_pwd_dir_length\}\)[^/]*/-\1/-g"
end

