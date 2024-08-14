# Starting a detached process with nohup

If you tried this without nohup, the process would exit after you exit the
remote shell. The STDOUT an STDERR can be logged separately like this:

	nohup "<command>" "<args>" > out.log 2> err.log &
