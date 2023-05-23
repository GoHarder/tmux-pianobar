# tmux-pianobar

A convenient status and menu to play [pianobar](https://github.com/PromyLOPh/pianobar) in [`tmux`](https://tmux.github.io/).

![screen shot](/docs/png/screenshot_0%20.png)

## Installing

### Via TPM (recommended)

The easiest way to install `tmux-pianobar` is via the [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm).

1. Add plugin to the list of TPM plugins in `.tmux.conf`:

   ```tmux
   set -g @plugin 'GoHarder/tmux-pianobar'
   ```

2. Use <kbd>prefix</kbd>–<kbd>I</kbd> install `tmux-pianobar`. You should now
   be ready to connect `tmux-pianobar`.
3. When you want to update `tmux-pianobar` use <kbd>prefix</kbd>–<kbd>U</kbd>.

### Manual Installation

1. Clone the repository

   ```sh
   $ git clone https://github.com/tmux-plugins/tmux-pianobar ~/clone/path
   ```

2. Add this line to the bottom of `.tmux.conf`

   ```tmux
   run-shell ~/clone/path/yank.tmux
   ```

3. Reload the `tmux` environment

   ```sh
   # type this inside tmux
   $ tmux source-file ~/.tmux.conf
   ```

You should now be ready to connect `tmux-pianobar`.

### Connection to pianobar

This plugin uses pianobar's events feature to update player information. This is to prevent constant buffer copying.

Inside the pianobar config file there is an option called `event_command` insert the location of the plugins events script.

```config
event_command = [your home directory]/.tmux/plugins/pianobar/scripts/radio/scripts/events.sh
```

## Requirements

In order for `tmux-pianobar` to work, you must have pianobar installed.

## Configuration

### Status

To view the song information insert `#{radio}` inside status right.

```sh
st_radio="#[bg=color248#,fg=black]#{radio}"
st_time="#[bg=white,fg=black]  %I:%M%p "
st_date="#[bg=color208,fg=black]  %m/%d/%Y #[default]"

set -g status-right "$st_radio$st_time$st_date"
```

### Key bindings

Currently the menu is bound to <kbd>Alt</kbd>–<kbd>/</kbd>. Hopefully in future updates there will be options to rebind this inside the tmux config file

## TODO

There are plenty of upgrades that can be done to this plugin. There are some pianobar controls that are not inserted into the menu. If you need advanced options currently you can view the feed from the radio menu.

Theres also the option to put the track data in other places than the right status.
<!---
## Help

I am currently looking for a new position. If you know or you need someone to make applications with node.js, svelte, mongodb and some kubernetes knowledge please spread the word. Thanks.
--->