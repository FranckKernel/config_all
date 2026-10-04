Arch install:
https://github.com/PoutineSyropErable/ArchInstall
( A subset of the install commands, and information to quickly load into the live environment from arch-installer.iso)

You should checkout the desktop or the laptop branch, as these are the branch for my personnal pc.
I recommend you use them, as this might not be updated at all
#You should also checkout the submodules, and their install readmes (should work with copy and paste)

nvim, zsh, tmux are the main one. They should have all the install commands together.
lf has one too.

1. Hyprland(hypr) and i3 are the x11 and Wayland window managers (Everything visual needs it)
2. Kitty is the terminal
3. Tmux is inside the terminal to allow splits
4. zsh is the shell
5. lf is the file manager
6. neovim=nvim is the text editor/IDE.
7. ncmpcpp is the mpd+mpc tui (terminal user interface) music manager

    **(For hyprland):**

8. ironbar is the top bar
9. waybar is the bottom bar.

    **(For i3):**

10. polybar is both bars

11. cava is for music playing in terminal with a bar graph for frequency amplitude (The cool looking thing)
12. Xava is like cava, but embeded in the screen itself
13. Eww and conky are extra window that appears with widgets (conky is for performance monitoring, eww is general)

14. Kanata is for using asdf jkl; as control, alt, shift, windows/command/super,
15. rofi is an application launcher. You'll need rofi-wayland (for Linux only)

    Mac already has one

```bash
sudo pacman -S rofi-wayland
# linux only

```

<pre>
<a href="https://github.com/PoutineSyropErable/config_all">https://github.com/PoutineSyropErable/config_all</a>
# ^The parent, the children vv (They need more then just cloning to setup them up. go check their readmes. )
<a href="https://github.com/PoutineSyropErable/config_zsh">https://github.com/PoutineSyropErable/config_zsh</a>
<a href="https://github.com/PoutineSyropErable/config_lf">https://github.com/PoutineSyropErable/config_lf</a>
<a href="https://github.com/PoutineSyropErable/config_tmux">https://github.com/PoutineSyropErable/config_tmux</a>
<a href="https://github.com/PoutineSyropErable/config_nvim">https://github.com/PoutineSyropErable/config_nvim</a>
# You get it, config_{dirname}, you can also just click on the dir that are submodules (The blue ones on github) and you'll be moved there
</pre>

To install in one go, One simple command. Should work on Arch, Fedora and MacOS:
```bash 
curl -fsSL https://raw.githubusercontent.com/FranckKernel/config_all/desktop/install_scripts/install_all.sh | bash
```


```bash
if [[ "$(uname -s)" == "Darwin" ]]; then
    brew install coreutils
    alias mv='gmv'
fi


git clone --branch desktop --depth 1 https://github.com/PoutineSyropErable/config_all ~/.config_poutine/

# or write laptop, but i mostly work on the desktop branch, as due to submodules, those who need can be branched themselves.
#

# Step 2: Move into the cloned repo
cd ~/.config_poutine/

# Step 3: Try non-recursive submodule init/update
git submodule init && git submodule update || echo "Non-recursive submodule update failed"

# Step 4: Fallback to recursive update if needed
git submodule update --init --recursive || echo "Recursive submodule update failed"

# Step 4.5: rename ~/.config_poutine to ~/.config ( you should do that one yourself. But, it shouldn't fuck things up)
[ -d ~/.config ] && mv --backup=numbered ~/.config ~/.config_backup && mv ~/.config_poutine ~/.config
# maybe the line above isn't fully posix complient, idk. In which case, idc, just rename your old config to not nuke it

# Step 5. Get tmux sessionizer
# Clone the repo if it doesn't exist
[ ! -d "$HOME/.local/tmux-sessionizer" ] && git clone https://github.com/PoutineSyropErable/tmux-sessionizer "$HOME/.local/tmux-sessionizer" || git -C "$HOME/.local/tmux-sessionizer" pull

# Create or update the symlink
ln -sfn "$HOME/.local/tmux-sessionizer" "$HOME/.config/tmux-sessionizer-local"




# Step 5:
# Go check the urls and do the installation of every things in their readme.
# lf, zsh, nvim have specific readmes, with specific install guide
# tmux also, because you need to create a softlink to ~/.tmux.conf
```

** You should check the .git of nvim, zsh, and other to set them up **

Example For i3:
https://www.youtube.com/watch?v=_ZSJtvB35-E

![i3 screenshot](https://github.com/PoutineSyropErable/home_for_git_public/raw/master/Pictures/Screenshot.png)

Example for hyprland:
![Hyprland Screenshot](https://github.com/PoutineSyropErable/config_hypr/raw/master/Hyprland%20look.png)

For full usage, you'll need to also download:
https://github.com/PoutineSyropErable/home_for_git_public
And put that in your /home.

Then the major breaking point is that I was too dumb to put $HOME in and put /home/francois in a bunch of scripts because ~ doesn't always works. So, I'll need to modify that and upload gradually, in my free time. After that, you will need to
install the appropriate software.

If you aren't on Arch, it might be a nightmare just to get the dependancies. Ubuntu was horrible for that, it was legit quicker to switch distro and reinstall everything then get some dependancies.

update -- It's back!!!
Yeah at 3 am after hours of cleaning up and trying to add it to github, I had an non existant file that stop pushing. So I asked how to remove files from github history and i got how to remove, end of sentence.

here's a command you should never do: git filter-repo --path <path-to-remove> --invert-paths --force

Testdisk didn't help much, but luckily, i had a backup in hidden in my system partition somewhere that was rather recent.

---

I'm kinda doxing myself but hey... Let's rip the bandaid
My name is François, I live in Québec, Canada. If you didn't get the Poutine au Sirop D'érable name joke, here it is.

<details>
  <summary>Click to reveal spoiler</summary>
So basically I wanted people to know I speak french, more precisly Canadian French but there's a running gag that those who put QC in their username didn't pass highschool. I mean, imagine if 10% had USA in their username... So I went and mixed all the local stereotypes.

it's like an american called "Gun wielding bald Eagle", british->"Tea drinking coloniser", Australian->"Inverted Jailed Kangouroos".

</details>

<details>
  <summary>Click to reveal spoiler</summary>
https://en.wikipedia.org/wiki/Poutine
https://fr.wikipedia.org/wiki/Sirop_d%27%C3%A9rable
https://en.wikipedia.org/wiki/Flag_of_Quebec
</details>

So with that, my profile pic is explained.

So, I'll upload a ~/home directories so you can reproduce this.
Pictures, Videos, .mpd and other are needed. (Python_main_Environment)
Music Too

Though I'll have to remove the songs due to copy right reasons.

also main problem is lots of these files have /home/francois, at some point i might switch it to $HOME.

---

# End

Please github start tracking my contributions properly now that I have added my email to the email list.
