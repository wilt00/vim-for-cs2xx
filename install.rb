#!/usr/bin/env ruby

# Installation script for Vim for CS2xx
# Written in Ruby, because it's more maintainable than Bash, and besides I
# couldn't figure out how to install Shellcheck and GHC on Bertvm

require 'fileutils'

def greenprint(txt)
    green = "\033[32m"
    greenend = "\033[0m\n"
    printf green + txt + greenend
end

homedir = File.expand_path("~") + "/"
vimdir = homedir + ".vim/"
ctags_tar = "ctags-5.8.tar.gz"
ctags_url = "http://prdownloads.sourceforge.net/ctags/#{ctags_tar}"

plugins = [
    'mbbill/undotree',
    'junegunn/vim-peekaboo',
    'vim-syntastic/syntastic',
    'Rip-Rip/clang_complete',
    'ajh17/VimCompletesMe',
    'ctrlpvim/ctrlp.vim',
    'scrooloose/nerdtree',
    'shiracamus/vim-syntax-x86-objdump-d',
    'wilt00/vim-y86-syntax',
    'tpope/vim-repeat',
    'tpope/vim-surround',
    'tpope/vim-commentary',
    'godlygeek/tabular',
    'vim-scripts/nextval',
    'airblade/vim-gitgutter',
    'itchyny/lightline.vim',
    'flazz/vim-colorschemes',
    'tomasr/molokai',
    'majutsushi/tagbar',
]
# tagbar handled separately, see below

force = false
ARGV.each do |arg|
    if arg == "--force"
        force = true
    end
end

# If ~/.vimrc.old exists, this is probably not the first time this script is
# running, and we should abort to avoid overwriting backups
if File.file?(homedir + '.vimrc.old')
    unless force
        greenprint('Vimrc backup file (~/.vimrc.old) found from previous installation; cancelling installation')
        greenprint('To override, pass \'--force\' argument and make sure your current .vimrc is backed up. (~/.vimrc.old will not be altered)')
        exit
    end
    greenprint('Forcing installation:')
    greenprint('Deleting existing .vimrc, if any...')
    FileUtils.rm(homedir + '.vimrc')
    greenprint('Deleting existing .vim subdirectories, if any...')
    if File.directory?(vimdir + 'bundle')
        FileUtils.remove_dir(vimdir + 'bundle')
    end
    if File.directory?(vimdir + 'autoload')
        FileUtils.remove_dir(vimdir + 'autoload')
    end
end

# Back up existing .vimrc, .vim/bundle, and .vim/autoload
if File.symlink?(homedir + '.vimrc')
    greenprint("Found symlinked .vimrc; deleting link")
    FileUtils.rm(homedir + '.vimrc')
elsif File.file?(homedir + '.vimrc')
    greenprint("Found existing .vimrc file; backing up to ~/.vimrc.old")
    FileUtils.mv(homedir + '.vimrc', homedir + '.vimrc.old')
end

# Symlink .vimrc to ~
greenprint("Creating symlink from ./vimrc to ~/.vimrc ...")
File.symlink(File.expand_path('./vimrc'), homedir + '.vimrc')

if File.directory?(vimdir + 'bundle/')
    greenprint("Found existing bundle directory; backing up to ~/.vim/bundle.old")
    FileUtils.mv(vimdir + 'bundle/', vimdir + 'bundle.old/')
end
if File.directory?(vimdir + 'autoload/')
    greenprint("Found existing autoload directory; backing up to ~/.vim/autoload.old")
    FileUtils.mv(vimdir + 'autoload/', vimdir + 'autoload.old/')
end

# Add tmp directory for backups
unless File.directory?(vimdir + 'tmp/')
    FileUtils.mkdir_p(vimdir + 'tmp/')
end

# Install Pathogen
greenprint("Creating ~/.vim and subdirectories ...")
`mkdir -p ~/.vim/autoload ~/.vim/bundle`
greenprint("Downloading and installing Pathogen package manager ...")
`curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim`

# git clone all plugins into ~/.vim/bundle
cmd = "cd " + vimdir + "bundle && git clone https://github.com/"
plugins.each do |plugin|
    greenprint("Installing plugin " + plugin)
    %x[ #{cmd + plugin} ]
end

# Special handling for tagbar - for compatibility with bertvm, cannot exceed
#  certain version
`cd #{vimdir}bundle/tagbar && git checkout d4a08c33e516314f35c541b34fe7f909c2ff4381 .`

# Tagbar syntax highlighting is broken in this version, so nuke it
FileUtils.rm(vimdir + 'bundle/tagbar/syntax/tagbar.vim')

# Download and compile exuberant-ctags
`wget #{ctags_url}`
`tar -xf #{ctags_tar} -C #{vimdir}ctags`
`cd #{vimdir}ctags && ./configure && make`

