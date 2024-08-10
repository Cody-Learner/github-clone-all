# github-clone-all											<br>
Clones all github [author]s non forked or archived repos in pwd.					<br>
Note: [author] is part of the url. ie: 'Cody-Learner' from https://github.com/Cody-Learner		<br>
													<br>
**Usage:**												<br>
*"Generic github"* `github-clone-all -D` [author]							<br>
*"Cody specific"* `-I` option:  Installs Cody's scripts with .sh suffix.				<br>
													<br>
**Fetch/Use without git:**										<br>
Using either `wget` or `curl` and either URL:								<br>
													<br>
`curl -O https://raw.githubusercontent.com/Cody-Learner/github-clone-all/main/github-ca.sh`		<br>
`wget https://tinyurl.com/github-ca`									<br>
													<br>
Check the script integrity, run: `sha256sum github-ca*`							<br>
sha256sum: `0e9dd681007170cc7a06beb89fc9bb9d6d5c2f6a3ac36b17a65875b1b14ba16c`				<br>
													<br>
Set the x bit: `chmod +x github-ca*`									<br>
													<br>
To run: `./github-ca.sh` or `./github-ca`								<br>
													<br>