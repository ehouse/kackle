---
title: Minifying HTML and CSS
date: September 30, 2016
author: Ethan House
summary: All of the methods I use to minify the footprint of my blog both on disk and over the wire.
---

### Minification
This is the easiest method I use to keep my websites footprint down. It takes
all of the code on disk and removes comments and indentation while keeping
everything properly formatted.

``` bash
find out \( -name "*.html" -or -name "*.css" \) \
-exec htmlcompressor --compress-js --compress-css {} -o {} \;
```

### Maximize Code Reuse
Frameworks makes this easy but don't use ones too bloated. Sure there is
bootstrap but skeleton does almost all of the same things at a fraction of the
size. I personally use a subset of skeleton with my own written code for the
theme of my blog.

### Keeping Image Size Down

I've used jpegoptim for compression of images. It should be available in most
repos and it's pretty easy to use. Important note to always `--strip-all` to
remove image headers which might contain personal information.

``` bash
jpegoptim --strip-all -m80 -o -p IMAGE.jpg
```

With a few tests I was able to get pretty excellent compression rations with
almost no visible differences. The `-m` flag can always be either raised or
lowered to your own preferences.

``` bash
[ehouse@myon Downloads]$ du -sh image1.jpg
2.5M       image1.jpg
[ehouse@myon Downloads]$ jpegoptim --strip-all -m80 -o -p image1.jpg
image1.jpg 2560x1600 24bit N JFIF  [OK] 2637491 --> 649431 bytes (75.38%), optimized.
[ehouse@myon Downloads]$ du -sh image1.jpg
636K       image1.jpg
```

### Webserver Gzip
In my examples I use nginx but most modern webservers car capable of doing
everything I did below in their own way.

##### Gzip on the Fly
This method will store plaintext files on disk and only compress the files as
they are sent over the wire. Nginx is pretty smart about how to handle gzip
compression for clients so all you need to do is enable it in the server config
block. Clients unable to utilize gzip will not be sent gzip'ed files.

```
server {
    gzip on;
    gzip_types      text/plain application/xml;
    gzip_proxied    no-cache no-store private expired auth;
    gzip_min_length 1000;
    ...
}
```

##### Serving Gzip'ed Files
The will tell nginx to distribute the `file.gz` version of the file only. If the
client doesn't support gzip compresses then nginx will decompress the file on
the fly rather then compressing it. Since most clients these days support gzip
this is a fair assumption to make.

```
server {
    ...
    gunzip on
}

location / {
    gzip_static on;
}
```
