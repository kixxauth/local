HOME = File.expand_path('~')
REFDIR = "#{HOME}/Rprojects/Reference"
RX_REPO = /(?<dir>[^\/]+)\.git$/
LIBDIR = File.dirname(__FILE__)
ROOTDIR = File.dirname(LIBDIR)
CONFDIR = File.join(ROOTDIR, 'conf')
REPO_LIST = File.join(CONFDIR, 'git_repository.list')

begin
    fd = File.open(REPO_LIST, 'r')
rescue
    puts "It looks like #{REPO_LIST} does not exist yet."
    Process.exit 1
end

if not File.directory? REFDIR
    Dir.mkdir REFDIR
end

fd.each do |line|
    if RX_REPO =~ line
        dirname = "#{REFDIR}/#{$~[:dir]}"

        Dir.chdir(REFDIR)
        if File.directory?(dirname)
            Dir.chdir(dirname)
            if %x[ git pull origin master ]
                puts "git pulled #{line}"
            else
                puts "! ERROR: unable to git pull #{line}"
            end
        elsif %x[ git clone #{line}]
            puts "git cloned #{line}"
        else
            puts "! ERROR: unable to git clone #{line}"
        end
    end
end
