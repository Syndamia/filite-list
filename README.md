# filite-list

filite-list is a small script for helping users (administrators) manage all of the links in their [filite](https://github.com/raftario/filite) server.

It lists all created IDs (string IDs, the ones used in URLs or the numerical IDs, the ones used in the database and GET requests) of created entries and information about and their contents.

## Getting started

### Dependencies

- `curl`
- `jq`

You can also view them by running `filite-list.sh -d` or `filite-list.sh --dependencies`

### How to run

1. Clone the repository or get the `filite-list.sh` file from the latest release
2. Navigate to the folder in which `filite-list.sh` is located
3. Make it runnable: `chmod +x ./filite-list.sh`
4. Run `./filite-list.sh` with your desired parameters

**Note:** by default the host, e.g. the link it connects to, is the live example from the official GitHub repo: `https://filite.raphaeltheriault.com`. You can change it in the script *(line 29)* or use the `--host` parameter *(refer to the --help screen for more information)*

## Examples

**Note:** I've modified the host in the script, used in the following examples. All other functionality is the same.

1. Get the help message
```
$ ./filite-list.sh -h                                                                                                                                                      

filite-list.sh [OPTIONS] -- script to show you the IDs and their values of filite entries on a given server

Where:
	-v,   --version                Shows the vresion of the script
	-h,   --help, -?               Display this help message
	-d,   --dependencies           List required dependencies for the script
	-ho,  --host [LINK]            Use the given host. MUST be in the format of "https://example:port.com", without the trailing forward slash!
	-f,   --files                  Show only the file entries
	-l,   --links                  Show only the link entries
	-t,   --text                   Show only the text entries
	-oi,  --only-id                Show only IDs of entries (and NOT their values)
	-n,   --number-limit [AMOUNT]  Limit how many entries to show from each type
	-nid, --numerical-id           Show the numerical IDs, rather than the text IDs (the ones that are used in links)

```

2. Get the first 5 text string links and their values
```
$ ./filite-list.sh -n 5 -t                                                                                                              

Texts
------
yz6jeo : Test 
hqk7wh : Text 
c2zssy : Message 
xtla18 : Test 
nc8v5d : Test 

```

3. Get string links for all entries
```
$ ./filite-list.sh -oi                                                                                                                  

Files
------
hisans
math
gspec
ford

Links
------
rock

Texts
------
yz6jeo
hqk7wh
c2zssy
xtla18
nc8v5d

```

4. Get numerical IDs of all link entries and their values
```
$ ./filite-list.sh -nid -l                                                                                                              

Links
------
1291268    : https://www.youtube.com/watch?v=dQw4w9WgXcQ 

```

4. Get top three results from all entry types, from custom host
```
$ ./filite-list.sh -n 3 --host https://filite.syndamia.com                                                                                                                 

Files
------
hisans : /filite/files/qmf1fu.Камен.zip 
math   : /filite/files/qm9jij.math-proekt-kamen-mladenov-12b.pdf 
gspec  : /filite/files/qm2b5a.spectre.min.css 

Links
------
rock   : https://www.youtube.com/watch?v=dQw4w9WgXcQ 

Texts
------
yz6jeo : Test 
hqk7wh : Text 
c2zssy : Message 
```
