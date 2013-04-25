Recursively Operate on a Directory Tree
=======================================

From [SuperUser](http://superuser.com/questions/91935/how-to-chmod-755-all-directories-but-no-file-recursively).

	find /path/to/base/dir -type d -exec chmod 755 {} +
	find /path/to/base/dir -type f -exec chmod 644 {} +
	chmod 755 $(find /path/to/base/dir -type d)
	chmod 644 $(find /path/to/base/dir -type f)
	find /path/to/base/dir -type d -print0 | xargs -0 chmod 755 
	find /path/to/base/dir -type f -print0 | xargs -0 chmod 644
