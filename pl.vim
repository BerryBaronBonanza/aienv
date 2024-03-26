nmap <leader>m :wall!:silent :!tmux send-keys -t0 $'nodebug, make.\n':redraw!
nmap <leader>h :wall!:silent :!tmux send-keys -t0 $'help(=expand('<cword>')).\n':!tmux select-pane -t0:redraw!
nmap <leader>a :wall!:silent :!tmux send-keys -t0 $'apropos(=expand('<cword>')).\n':redraw!
