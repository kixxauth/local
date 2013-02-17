# Starting a "detached" process with nohup.
# If you tried this without nohup, the process would exit after you exit the
# remote shell.
sudo nohup "<command>" "<args>" > out.log 2> err.log &
