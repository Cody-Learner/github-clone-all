# github-clone-all											<br>
Clones all github [author] non forked or archived repos.						<br>
Note: [author] is part of the url. ie: 'Cody-Learner' from 'github.c<span>om/Cody-Learner'		<br>
													<br>
**Usage:** `github-ca.sh` [`-D` author] [`-I` /path/repos-dir] [`-R` /path/repos-dir]			<br>
*"Generic operation:"* `-D`  Download 'git clone' all authors repos.					<br>
*"Cody specific op :"* `-I`  Install 'copy' all scripts in repos with `.sh` suffix to `instdir` var.	<br>
*"Cody specific op :"* `-R`  Run all scripts in repos with `.inst` suffix.				<br>
													<br>
**Examples:**												<br>
Clone all repos        :  `./github-ca.sh -D Cody-Learner`						<br>
Copy all '.sh' scripts :  `./github-ca.sh -I ~/GitHub.XXX`						<br>
Run all '.inst' scripts:  `./github-ca.sh -R ~/GitHub.XXX`						<br>
													<br>
The default directory the repos are cloned into, is created at `$HOME/GitHub.XXX`			<br>
The `XXX` will be replaced with a random three letter/digit sequence.					<br>
													<br>
Running `github-ca.sh` with no op/args will create and list the git clone destination dir.		<br>
													<br>
**Example:** `github-ca.sh`										<br>
....													<br>
...													<br>
..													<br>
 `Download directory: /home/jeff/GitHub.V3r`								<br>
													<br>
If running more than once, manually remove `/tmp/downloaddir` to prevent overwriting.			<br>
													<br>
**Fetch/Use without git:**										<br>
`curl -O https://raw.githubusercontent.com/Cody-Learner/github-clone-all/main/github-ca.sh`		<br>
													<br>
Check the script integrity: `sha256sum github-ca.sh`							<br>
sha256sum: `4984325cdaa92f1092c7c6163cc60f2d775fdb5e6d3420b8b0aa95d5ae5ba49e`				<br>
													<br>
Set the x bit: `chmod +x github-ca.sh`									<br>
													<br>
To run: `./github-ca.sh`										<br>
													<br>