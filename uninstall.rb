#!/usr/bin/env ruby

require 'fileutils'

puts 'This will DELETE YOUR ~/.VIM DIRECTORY and unlink your .vimrc file'
puts 'It will replace it with your .vimrc.old backup, if it exists'
puts 'Do you want to continue? (Y/N)'

prompt = STDIN.gets.chomp.downcase
unless prompt == 'y'
    puts 'Terminating...'
    exit
end

homedir = File.expand_path("~") + "/"
vimdir = homedir + ".vim/"

if File.symlink?(homedir + '.vimrc')
    puts 'Unlinking .vimrc ...'
    FileUtils.rm(homedir + '.vimrc')
elsif File.file?(homedir + '.vimrc')
    puts 'Error: .vimrc exists and is a file'
    puts 'Terminating...'
    exit
end

if File.file?(homedir + '.vimrc.old')
    puts 'Backup .vimrc found, restoring...'
    FileUtils.mv(homedir + '.vimrc.old', homedir + '.vimrc')
else
    puts 'No backup .vimrc found, continuing...'
end

if File.directory?(vimdir + 'bundle/')
    puts 'Deleting ~/.vim/bundle...'
    FileUtils.rm_r(vimdir + 'bundle/', :force=> true, :secure=>true)
end

if File.directory?(vimdir + 'autoload/')
    puts 'Deleting ~/.vim/autoload...'
    FileUtils.rm_r(vimdir + 'autoload/', :force=> true, :secure=>true)
end

if File.directory?(vimdir + 'bundle.old/')
    puts 'Backup ~/.vim/bundle directory found, restoring...'
    FileUtils.mv(vimdir + 'bundle.old/', vimdir + 'bundle/')
end

if File.directory?(vimdir + 'autoload.old/')
    puts 'Backup ~/.vim/autoload directory found, restoring...'
    FileUtils.mv(vimdir + 'autoload.old/', vimdir + 'autoload/')
end

puts 'Done.'


