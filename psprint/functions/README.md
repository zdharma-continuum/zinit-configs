## Collection of Zsh functions

Listable by `pslist`:

```zsh
% pslist
-----------------------------------------------------------------------
pscopy_xauth       Copies xauth data to "$1" at "$2"
psffconv           Converts (ffmpeg) file $1 to $2, or $1 to ${1:r}.mp4
pslist             Lists ~/functions/* with their embedded descriptions
psls               `ls` or `ls -A`, depending on [[ -d .git ]]
psprobe_host       Checks "$1" is alive, outputs also timestamp
psrecompile        Recompiles ~/.zshrc, ~/.zcompdump
pssetup_ssl_cert   Creates certificate (files key,crt,pem), see -h
-----------------------------------------------------------------------
t1countdown        Wait "$1" seconds for Ctrl-C (animated progress bar)
t1fromhex          Converts hex-triplet into terminal color index
t1uncolor          Perl invocation to strip color codes (use in pipe)
-----------------------------------------------------------------------
f1biggest          Size-sorts all descent files - finds biggest ones
f1rechg            Finds files changed in last 15 minutes
f1rechg_x_min      Finds files changed in last "$1" minutes
-----------------------------------------------------------------------
g1all              Iterates over *.git directories, runs git "$@"
g1zip              Creates `basename $(pwd)`-$(date ...) archive
-----------------------------------------------------------------------
n1dict             Queries dict.pl with $@ (w3m)
n1diki             Queries diki.pl with $@ (w3m)
n1gglinks          Queries google.com with $@ (links)
n1ggw3m            Queries google.com with $@ (w3m)
n1ling             Queries ling.pl with $@ (w3m)
n1ssl_rtunnel      $0 <lstn_port> <trg_host> <trg_port> <cert> <cafile>
n1ssl_tunnel       $0 <lstn_port> <trg_host> <trg_port> <cert> <cafile>
-----------------------------------------------------------------------
x1iso2dmg          Converts file $1 (iso) to ${1:r}.dmg
-----------------------------------------------------------------------
is_macports        Tests if $PATH contains /opt/local/bin
localbin_off       Removes /usr/local/{bin,sbin} from $PATH
localbin_on        Adds /usr/local/{bin,sbin} to $PATH
mandelbrot         Draws mandelbrot fractal
optlbin_off        Removes /opt/local/{bin,sbin} from $PATH
optlbin_on         Adds /opt/local/bin to $PATH
setopt             A setopt wrapper with tracing to /tmp/setopt.log
zman               Searches zshall with special keyword ($1) matching
-----------------------------------------------------------------------
```
