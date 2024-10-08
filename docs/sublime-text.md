# Sublime Text
Sublime has a command line invocation. To put this on my path I create a symlink to `/user/local/bin/subl`.

```
Usage: subl [arguments] [files]         Edit the given files
   or: subl [arguments] [directories]   Open the given directories
   or: subl [arguments] -- [files]      Edit files that may start with '-'
   or: subl [arguments] -               Edit stdin
   or: subl [arguments] - >out          Edit stdin and write the edit to stdout

Arguments:
  --project <project>:    Load the given project
  --command <command>:    Run the given command
  -n or --new-window:     Open a new window
  --launch-or-new-window: Only open a new window if the application is open
  -a or --add:            Add folders to the current window
  -w or --wait:           Wait for the files to be closed before returning
  -b or --background:     Don't activate the application
  -s or --stay:           Keep the application activated after closing the file
  --safe-mode:            Launch using a sandboxed (clean) environment
  -h or --help:           Show help (this message) and exit
  -v or --version:        Show version and exit

--wait is implied if reading from stdin. Use --stay to not switch back
to the terminal when a file is closed (only relevant if waiting for a file).

Filenames may be given a :line or :line:column suffix to open at a specific
location.
```
