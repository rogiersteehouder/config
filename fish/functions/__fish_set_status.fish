# Set the return status
# Useful for restoring $status:
#   set -l last_status $status
#   ...
#   __fish_set_status $last_status
function __fish_set_status --argument retval
	return $retval
end
