---
title: Manage your dotfiles with ease
date: 2014-08-14 14:01 UTC
tags: dotfiles repo
---

There are mainly 2 steps to manage your dotfiles easily:

1. Keeping it in sync beetween computers with git repository

    Previously I synced my dotfiles using Copy (Dropbox clone)
    backup service, which caused problems with file permissions(every file had added `x` flag when synced to new computer).

2. Having script which takes care of linking files in dotfiles repo folder to their proper locations in the system.

While setting git repo for our dotfiles is simple, writing a linking script isn't so obvious.

Usually adding new files to dotfile folder imply modifying a script which makes it hard to manage over time.
My idea was to write a self-managable dotfile repo, which structure mirror the file structure on the local OS (repo has one `home` folder).
Additionally I decided to link only files, not directories, because you may want to have some files in shared dotfiles folder only on one local machine.

In result you don't have to change a script when you add new dotfiles as long as you keep file hierarchy in a repo the same as in the system.
Look at the source:

~~~ruby
#!/usr/bin/env ruby

require 'fileutils'
require 'pathname'

# Recursively link files from source to target directory
def linkify source_path, target_path
  Dir.glob( File.join(source_path, '*'), File::FNM_DOTMATCH ).each do |src_fn_path|
    src_pn = Pathname.new src_fn_path
    next if %w(. ..).include? src_pn.basename.to_s
    if src_pn.directory?
      FileUtils.mkdir_p File.join(target_path, src_pn.basename)
      linkify File.join(source_path, src_pn.basename), File.join(target_path, src_pn.basename)
    else
      FileUtils.ln_s src_pn, File.join(target_path, src_pn.basename), force: true
    end
  end
end


linkify File.join( File.dirname(__FILE__), 'home'), ENV['HOME']
~~~

Whenever you modify your dotfiles, just run this script and you're good to go.
Here is [my dotfiles repo](https://github.com/Gee-Bee/dotfiles).
