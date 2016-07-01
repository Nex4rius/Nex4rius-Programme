# Stargate-Programm for SG-Craft and OpenComputers

How to install:

1) Make an OpenComputer computer with an internet card.

2) copy / paste command

```lua
pastebin run -f fa9gu1GJ
```

3) Profit

Screenshots http://imgur.com/a/WnwiV

Some feature of my programm:

- autoclose iris on incoming wormhole (when iriscontrol is turned on)
- autoopen iris if correct IDC is received
- autoclose stargate after X seconds
- show all kinds of stats (local / remote address, state, direction, idc, iris state, energy, ...)
- multiple languages: right now german and english (because I don't speak anything else)
- displays energy in EU (or RF if you want that)
- displays up to 10 addresses on 1 page (unlimited pages)
- allows dialing from the address list
- check for updates on start
- emit redstone signals (right now for: state not idle, incoming, iris closed, idc accepted, wormhole connected)
- automatically adds new, unkown addresses when there is an open wormhole
- shows the required energy to dial an address (or error if invalid address)
- works with Computronics ColorfulLamps
- allows closing of incoming wormholes if its disabled in config AND there is a computer at either end

Usage: autorun [...]<br>
yes   -> update to stable version<br>
no    -> no update<br>
beta  -> update to beta version<br>
help  -> show this message again

computer requirements
- CPU T2
- GPU T2
- 12x Screen T2
- HDD T1
- 2x Memory T1
- (Internet Card)
- (Redstone Card)

Make pull requests if you want :)
