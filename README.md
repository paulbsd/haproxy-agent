# haproxy-agent

HAProxy agent in lua with luasocket

## prerequisites

* install luasocket (https://lunarmodules.github.io/luasocket/) (manual install or using luarocks)

## example config

in `agent_status.txt`
```
ready up maxconn:30 0% # test                                                                                                                      
myservice.paulbsd.com: ready up 93% maxconn:15   
```

## howto

```
PORT=7543 ./haproxy-agent.lua
```

## License

```
           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
                   Version 2, December 2004
 
Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>

Everyone is permitted to copy and distribute verbatim or modified
copies of this license document, and changing it is allowed as long
as the name is changed.
 
           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
  TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

 0. You just DO WHAT THE FUCK YOU WANT TO.
```
