HOME = File.expand_path('~')
REFDIR = "#{HOME}/Rprojects/Reference"
REPO_LIST = "#{REFDIR}/git_repository.list"
RX_REPO = /(?<dir>[^\/]+)\.git$/

File.open(REPO_LIST, 'r').each do |line|
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
