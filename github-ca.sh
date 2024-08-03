#!/bin/bash
# github-ca 2024-08-02
# Dependencies: curl jq git findutils bash coreutils ncurses sudo
# Clones all github authors non forked or archived repos.

set -euo pipefail

BC=$(tput bold; tput setaf 6)
OFF=$(tput sgr0)
author=${2-}
repopath=${2-}
downloaddir=""						# GitHub repos downloaded to this directory.
instdir="/usr/local/bin/"				# Scripts installed into this directory.

usage(){
	printf '\f%s\n' "${BC} Usage: github-clone-all [-D author] [-I /path/repos-dir] ${OFF}"
	printf '%s\n'   "${BC} IE download:  github-ca -D Cody-Learner ${OFF}"
	printf '%s\f\n' "${BC} IE install :  github-ca -I ~/GitHub.XXX ${OFF}"
	exit
}

download(){

downloaddir=$(mktemp -d "${HOME}"/GitHub.XXX)

	cd "${downloaddir}"

if	! type curl jq git xargs bash printf tput sudo git &>/dev/null; then
	printf '\f%s\f\n' "${BC}  Checking/Installing missing dependencies. ${OFF}"
	sudo pacman -S --needed which curl jq git findutils bash coreutils ncurses sudo
fi
	printf '\f%s\f\n' "${BC}  Cloning repos.... ${OFF}"

	curl -s "https://api.github.com/users/${author}/repos?per_page=100" |
	jq -r '.[] | select(.fork == false) |
	select(.name).clone_url' |
	xargs -L1 git clone

	printf '\f%s\n' "${BC} Downloaded repos location: ${downloaddir} ${BC}"
	printf '%s\f\n' "${BC} To install:${BC} github-ca -I ${downloaddir}"
}

install(){

	rm -f /tmp/scripts
	rm -f /tmp/scripts2

	#  Reversed the logic on the following two if statements with 'break'.
	#  Using '!' + 'set -eou pipefail', the script exits before message is printed.

if	find "${repopath}" -maxdepth 0 -type d &>/dev/null; then
	:
   else
	printf '\f%s\f\n'	"${BC}  Repo path ${repopath} does not exist. ${OFF}"
	exit
fi
	cd "${repopath}"

if	find -- * -maxdepth 0 -maxdepth 0 -type d &>/dev/null; then
	:
    else
	printf '\f%s\f\n' "${BC}  The directory ${repopath} is empty. ${OFF}"
	exit
fi

for	directories in "${repopath}"/* ; do

	cd "${directories}"
	readarray -t scripts < <(find -- * -maxdepth 0 -type f -name "*.sh" | tee -a /tmp/scripts)

	if	[[ -n "${scripts[*]}" ]]; then
		sudo cp -- *.sh "${instdir}"
	fi
done

while	read -r scripts; do

	sudo chown "$(id -un):$(id -gn)" "${instdir}${scripts}"
	sudo ln -s "${instdir}${scripts}" "${instdir}${scripts:0:-3}"
	ls -la "${instdir}${scripts}" >>/tmp/scripts2
	ls -la "${instdir}${scripts:0:-3}" >>/tmp/scripts2
done </tmp/scripts

	printf '\f%s\n' "${BC} Copied the following list of scripts into ${instdir} ${OFF}"
	printf '%s\f\n' "${BC} Re/set owner:group metadata of scripts to $(id -un):$(id -gn) ${OFF}"

	sed -e 's/^/  /' /tmp/scripts

	echo
	column -t /tmp/scripts2 | sed -e 's/^/  /' 

}
	[[ ! -v 1 ]] && usage

while :; do
	case "${1-}" in
	-D |--download)	download 			;;
	-I |--install)	install 			;;
	-?*)		echo "Input Error."; usage	;;
	*)		break
        esac
    shift
done
