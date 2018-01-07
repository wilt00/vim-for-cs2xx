#!/usr/bin/env ruby

require 'fileutils'

homedir = File.expand_path("~") + "/"
vimdir = homedir + ".vim/"

plugins = [
    'mbbill/undotree',
    'junegunn/vim-peekaboo',
    'vim-syntastic/syntastic',
    'Rip-Rip/clang_complete',
    'ajh17/VimCompletesMe',
    'shiracamus/vim-syntax-x86-objdump-d',
    'wilt00/vim-y86-syntax',
    'tpope/vim-repeat',
    'tpope/vim-surround',
    'tpope/vim-commentary',
    'godlygeek/tabular',
    'vim-scripts/nextval',
    'jreybert/vimagit',
    'airblade/vim-gitgutter',
    'flazz/vim-colorschemes',
    'tomasr/molokai',
]

# Back up existing .vimrc, .vim/bundle, and .vim/autoload
if File.symlink?(homedir + '.vimrc')
    puts "Found symlinked .vimrc; deleting link"
    FileUtils.rm(homedir + '.vimrc')
elsif File.file?(homedir + '.vimrc')
    puts "Found existing .vimrc file; backing up to ~/.vimrc.old"
    FileUtils.mv(homedir + '.vimrc', homedir + '.vimrc.old')
end

# Symlink .vimrc to ~
puts "Creating symlink from ./.vimrc to ~/.vimrc ..."
File.symlink(File.expand_path('./.vimrc'), homedir + '.vimrc')

if File.directory?(vimdir + 'bundle/')
    puts "Found existing bundle directory; backing up to ~/.vim/bundle.old"
    FileUtils.mv(vimdir + 'bundle/', vimdir + 'bundle.old/')
end
if File.directory?(vimdir + 'autoload/')
    puts "Found existing autoload directory; backing up to ~/.vim/autoload.old"
    FileUtils.mv(vimdir + 'autoload/', vimdir + 'autoload.old/')
end

# Install Pathogen
puts "Creating ~/.vim and subdirectories ..."
`mkdir -p ~/.vim/autoload ~/.vim/bundle`
puts "Downloading and installing Pathogen package manager ..."
`curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim`

# git clone all plugins into ~/.vim/bundle
cmd = "cd " + vimdir + "bundle && git clone https://github.com/"
plugins.each do |plugin|
    puts "Installing plugin " + plugin
    %x[ #{cmd + plugin} ]
end

