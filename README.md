# Zinit Configurations<a name="zinit-configurations"></a>

<!-- mdformat-toc start --slug=github --maxlevel=6 --minlevel=2 -->

- [Searching the repository](#searching-the-repository)
- [Submitting zshrc](#submitting-zshrc)
- [The repository structure](#the-repository-structure)
  - [Requirements](#requirements)
  - [fzf](#fzf)
  - [fzy](#fzy)
- [Running a configuration](#running-a-configuration)

<!-- mdformat-toc end -->

## Searching the repository<a name="searching-the-repository"></a>

Use the Github search interface – just enter a query (i.e., `trapd00r/LS_COLORS` like in the picture below, to find
zshrc with references to this plugin, and ensure that you activate the "*in this repository*" variant of the search:

![Starting search](https://raw.githubusercontent.com/zdharma-continuum/zinit-configs/img/srch.png)

Then, results should appear like below:

![Search results](https://raw.githubusercontent.com/zdharma-continuum/zinit-configs/img/srch-rslt.png)

## Submitting zshrc<a name="submitting-zshrc"></a>

Open a PR

## The repository structure<a name="the-repository-structure"></a>

The structure of the repository is very simple: in its main directory there are directories located, named after the
user-names of the submitting users. In those directories there are the zshrc files that the user decided to share.

### Requirements<a name="requirements"></a>

You should have [docker](https://docs.docker.com/install/) and `zsh` installed to use this functionality.

[fzf](https://github.com/junegunn/fzf) or [fzy](https://github.com/jhawthorn/fzy) in your `$PATH`. You might choose to
install any of them via zinit:

### fzf<a name="fzf"></a>

```zsh
zinit for \
    as"command" \
    from"gh-r" \
    load \
  @junegunn/fzf-bin
```

### fzy<a name="fzy"></a>

```zsh
zinit for \
    as"command" \
    atclone"cp contrib/fzy-* $ZPFX/bin/" \
    load \
    make"!PREFIX=$ZPFX install" \
    pick"$ZPFX/bin/fzy*" \
  @jhawthorn/fzy
```

Keep in mind you will need a few Gb of free space to store docker images.

## Running a configuration<a name="running-a-configuration"></a>

To try a configuration, you have to clone this repository and execute a `run.sh` script:

```zsh
git clone https://github.com/zdharma-continuum/zinit-configs
cd zinit-configs
./run.sh
```

Or you can install this repository as a `zsh` plugin!

```zsh
zinit load zdharma-continuum/zinit-configs
zinit configs
```

Now you will have to wait for a few minutes, while the required environment is being installed into the docker image.
The next time you will want to try a configuration, loading it will take less time.
