#!/bin/bash
# github-ca 2024-08-10
# Dependencies: curl jq git findutils bash coreutils ncurses sudo
# Clones all github authors non forked or archived repos.
# Optionally, copies scripts ( *.sh) to 'instdir' and creates symlinks without the .sh ie: coolscript -> coolscript.sh
# Optionally, runs install script ( *.inst) for repos having it.

set -euo pipefail

author=${2-}
repopath=${2-}
instdir="/usr/local/bin/"							# Scripts installed into this directory.
[[ -s  /tmp/downloaddir ]] && downloaddir=$(cat /tmp/downloaddir)		# Do not edit this line.
[[ ! -v downloaddir ]] && downloaddir=$(mktemp -d "${HOME}"/GitHub.XXX)		# GitHub repos downloaded to this directory.

printf '%s\n' "${downloaddir}" >/tmp/downloaddir

usage(){
	printf '\f%s\f\n' " Usage: github-ca.sh [-D author] [-I /path/repos-dir] [-R /path/repos-dir]"
	printf '%s\n'   " -D = Download 'clone' github repos"
	printf '%s\n'	" -I = Install '*.sh' to variable 'instdir' set to: ${instdir}"
	printf '%s\f\n'	" -R = Run install script '*.inst' for repos having it."
	printf '%s\n'   " IE Download          :  ./github-ca.sh -D Cody-Learner"
	printf '%s\n'	" IE Install           :  ./github-ca.sh -I ~/GitHub.XXX"
	printf '%s\f\n'	" IE Run install script:  ./github-ca.sh -R ~/GitHub.XXX"
	[[ -s  /tmp/downloaddir ]] &&
	printf '%s\f\n' " Download directory: ${downloaddir}"
	exit
}

if	! type curl jq git xargs bash printf tput sudo git &>/dev/null; then
	printf '\f%s\f\n' " Checking/Installing missing dependencies with pacman."
	sudo pacman -S --needed which curl jq git findutils bash coreutils ncurses sudo
fi

download(){

	cd "${downloaddir}"

	printf '\f%s\f\n' " Cloning repos...."

	curl -s "https://api.github.com/users/${author}/repos?per_page=100" |
	jq -r '.[] | select(.fork == false) |
	select(.name).clone_url' |
	xargs -L1 git clone

	printf '\f%s\n' " Downloaded repos location: ${downloaddir}"
	printf '%s\f\n' " To install: ./github-ca -I ${downloaddir}"
}

install(){

	rm -f /tmp/scripts
	rm -f /tmp/scripts2

	#  Reversed the logic on the following two if statements with ':'.
	#  Using '!' + 'set -eou pipefail', the script exits before message is printed.

if	find "${repopath}" -maxdepth 0 -type d &>/dev/null; then
	:
   else
	printf '\f%s\f\n'	" Repo path ${repopath} does not exist."
	exit
fi
	cd "${repopath}"

if	find -- * -maxdepth 0 -maxdepth 0 -type d &>/dev/null; then
	:
    else
	printf '\f%s\f\n' " The directory ${repopath} is empty."
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

	printf '\f%s\n' " Copied the following list of scripts into ${instdir}"
	printf '%s\f\n' " Re/set owner:group metadata of scripts to $(id -un):$(id -gn)"

	sed -e 's/^/  /' /tmp/scripts

	echo
	column -t /tmp/scripts2 | sed -e 's/^/  /'
}

run_inst(){

	cd "${repopath}"

for	directories in "${repopath}"/* ; do

	cd "${directories}" || { echo "Cant find dir" ; exit ; }

	script=$(find -- * -maxdepth 0 -type f -name "*.inst")

	if	[[ -n ${script} ]]; then
		./"${script}"
		printf '\f%s\f\n' "#==================================================================#"
	fi
done

}
	[[ ! -v 1 ]] && usage

while :; do
	case "${1-}" in
	-D |--download)	download 			;;
	-I |--install)	install 			;;
	-R |--runins)   run_inst			;;
	-?*)		echo " Input Error."; usage	;;
	*)		break
        esac
    shift
done
