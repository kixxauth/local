HOME = File.expand_path('~')
REFDIR = "#{HOME}/Rprojects/Reference"
REPO_LIST = "#{REFDIR}/git_repository.list"
RX_REPO = /(?<dir>[^\/]+)\.git$/

File.open(REPO_LIST, 'r').each do |line|
    if RX_REPO =~ line
        dirname = "#{REFDIR}/#{$~[:dir]}"
        if File.directory?(dirname)
            puts 'its a directory'
        else
            puts 'its not a directory'
        end
    end
end
