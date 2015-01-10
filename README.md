#nginx-maintenance#
This is a maintenance site installer for nginx servers. Its designed for internal tools and not for public services. It shows a random Image from http://devopsreactions.tumblr.com/ and a video.

###This is a screenshot:###
![alt tag](https://raw.github.com/stvnwrgs/nginx-maintenance/master//screenshot.png)

###This is how to use###
```
git clone https://github.com/stvnwrgs/nginx-maintenance.git

http only:
./install.sh yourdomain.com

http with multiple hostnames:
.install.sh 'serv.yourdomain.com service.yourdomain.com'

https with multiple hostnames:
.install.sh 'serv.yourdomain.com service.yourdomain.com' /path/to/your/cert/file /path/to/your/key/file

service maintenance start/stop
```

###These are the known issues###
* Mixed content in https (not fixable thumblrs problem)
* Design is ugly. Yes. And now?
