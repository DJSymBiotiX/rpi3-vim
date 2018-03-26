" Fix a bug where crontab doesn't save properly on some systems when
" using a vim backup directory.
" This is because vim moved the old file to the backup directory before
" writing a new file, and crontab was monitoring that file specifically
" for changes.
au BufEnter crontab.* setl backupcopy=yes
