#!/usr/bin/env lua

local socket = require("socket")

local cfg = {}
local reload_cfg_interval = 2
local status_file = "agent_status.txt"

local port = tonumber(os.getenv("PORT")) or 9090
local sock = socket.bind("0.0.0.0", port)

--[[
--example config
ready up maxconn:30 0% # test
myservice.paulbsd.com: ready up 93% maxconn:15
--]]--

local cfg_loader = coroutine.create(function()
  while true do
    cfg = get_cfg()
    coroutine.yield()
  end
end)
local runner = coroutine.create(function() run() end)

function get_cfg()
  local res = {}
  local lines = io.lines(status_file)
  for line in lines do
    local s, e, key, value = string.find(line,"([%w%p]+): ([%w %p]+)")
    if value then
      res[key] = value
    else
      local s, e, value = string.find(line,"([%w %p]+)")
      if value then
        res["all"] = value
      end
    end
  end
  return res
end

function run()
  while true do
    while true do
      local conn = sock:accept()
      conn:settimeout(0.2)
      local s, e = conn:receive("*l")
      if e == 'timeout' then break end
      if s and e ~= 'closed' then
        local send = ""
        if cfg[s] then
          send = cfg[s]
        elseif cfg["all"] then
          send = cfg["all"]
        end
        conn:send(send.."\n")
        conn:close()
      end
      conn:shutdown()
      coroutine.yield()
    end
  end
end

local last_time = os.time()
coroutine.resume(cfg_loader)
while true do
  if os.time()-last_time > reload_cfg_interval then
    coroutine.resume(cfg_loader)
    last_time = os.time()
  end
  coroutine.resume(runner)
end
