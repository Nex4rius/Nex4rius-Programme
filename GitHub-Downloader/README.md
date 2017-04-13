<h1>GitHub-Downloader</h1>

<h2>Download</h2>
<hr>
<code>pastebin run -f MHq2tN5B name repo tree [link]</code>
<hr>
<code>wget -f https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/master/GitHub-Downloader/github.lua /bin/github.lua</code><br />
<code>github name repo tree [link]</code>
<hr><br />
Benutzung: github name repo tree [link]<br />
Beispiele:<br />
github Nex4rius Nex4rius-Programme master Stargate-Programm<br />
github Nex4rius Nex4rius-Programme master<br />
<br />
Hilfetext:<br />
github ?<br />
<br />
Einbindung in Programme:<br />
1) loadfile("/bin/github.lua")(name: string, repo: string, tree: string[, link: string])
2) os.execute("github name: string, repo: string, tree: string[, link: string]")
3) loadfile("/bin/pastebin.lua")("-f", "run", "MHq2tN5B", name: string, repo: string, tree: string[, link: string])
4) os.execute("pastebin run -f MHq2tN5B name: string, repo: string, tree: string[, link: string]")
