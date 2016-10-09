config = dofile('./data/config.lua')
URL = require "socket.url"
http = require "socket.http"
https = require "ssl.https"
ltn12 = require "ltn12"
serpent = (loadfile "./libs/serpent.lua")()
feedparser = (loadfile "./libs/feedparser.lua")()
json = (loadfile "./libs/JSON.lua")()
mimetype = (loadfile "./libs/mimetype.lua")()
redis = (loadfile "./libs/redis.lua")()
JSON = (loadfile "./libs/dkjson.lua")()
help = (loadfile "./data/help.lua")()
http.TIMEOUT = 10

function load_data(filename)
	local f = io.open(filename)
	if not f then
	    return {}
	end
	local s = f:read('*all')
	f:close()
	local data = JSON.decode(s)
	return data
end
function save_data(filename, data)
	local s = JSON.encode(data)
	local f = io.open(filename, 'w')
	f:write(s)
	f:close()
end

function backward_msg_format (msg)
  for k,name in pairs({'from', 'to'}) do
    local longid = msg[name].id
    msg[name].id = msg[name].peer_id
    msg[name].peer_id = longid
    msg[name].type = msg[name].peer_type
  end
  if msg.action and (msg.action.user or msg.action.link_issuer) then
    local user = msg.action.user or msg.action.link_issuer
    local longid = user.id
    user.id = user.peer_id
    user.peer_id = longid
    user.type = user.peer_type
  end
  return msg
end

require("./bot/helper")
local now = os.time()
math.randomseed(now)
-----------------------------------------------------------#RUNNING
function on_msg_receive(msg)
  if not started then
    return 
  end
  if type(msg) == 'boolean' then
  return false
  end
 
  --print(os.time().."|"..msg.date)
  local msghash = 'msghash:'

        redis:incr(msghash)
  msg = backward_msg_format(msg)
  if type(msg) ~= 'boolean' then
  receiver = get_receiver(msg)
  end
  if msg.date < now - 5 then
    return false
  end
   if msg.service then
      local action = msg.action or {type=""}
      msg.text = "!!tgservice " .. action.type

      if msg.from.id == our_id then
         msg.from.id = 0
      end
   end

if msg.out then
  local mmsghash = 'mmsghash:'

   redis:incr(mmsghash)
    return false
  end
    if msg then
      pre_process_msg(msg)
  end
end

function ok_cb(extra, success, result)
end

function on_binlog_replay_end()
  started = true
  postpone (cron_plugins, false, 60)
  reload_bot()
  _config = load_config()
  plugins = {}
  load_plugins()

end
function reload_bot() 
  print("Loading bot module")
  send_msg("user#id"..148617896, "test", ok_cb, false)
end

function pre_process_msg(msg)
  for name,plugin in pairs(plugins) do
    if plugin.pre_process and msg then
      msg = plugin.pre_process(msg)
    end
	match_plugin(plugin, name, msg)
  end
  return msg
end

local function is_plugin_disabled_on_chat(plugin_name, receiver)
  local disabled_chats = _config.disabled_plugin_on_chat
  if disabled_chats and disabled_chats[receiver] then
    for disabled_plugin,disabled in pairs(disabled_chats[receiver]) do
      if disabled_plugin == plugin_name and disabled then
        local warning = 'Plugin '..disabled_plugin..' is disabled on this chat'
        return true
      end
    end
  end
  return false
end

function match_plugin(plugin, plugin_name, msg)
if type(msg) == 'boolean' then
  return false
  end
local receiver = get_receiver(msg)
  for k, pattern in pairs(plugin.patterns) do
 
  if msg and msg.text then
   matches = match_pattern(pattern, msg.text:lower())
  else
   matches = match_pattern(pattern, msg.text)
  end
    if matches then
	local commands = 'commands:'

    redis:incr(commands)
      print("msg matches: ", pattern)
      if is_plugin_disabled_on_chat(plugin_name, receiver) then
        return nil
      end
      if plugin.run then
        -- If plugin is for privileged users only
        if not warns_user_not_allowed(plugin, msg) then
          local result = plugin.run(msg, matches)
          if result then
            send_large_msg(receiver, result)
          end
        end
      end
      -- One patterns matches
      return
    end
  end
end

function _send_msg(destination, text)
  send_large_msg(destination, text)
end


function save_config( )
  serialize_to_file(_config, './data/config.lua')
  print ('saved config into ./data/config.lua')
end

function load_config( )
  local f = io.open('./data/config.lua', "r")

  local config = loadfile ("./data/config.lua")()
  for v,user in pairs(config.sudo_users) do
    print("Sudo user: "..'\27[36m'..user..'\27[39m')
  end
  return config
end

function on_our_id (id)
  our_id = id
end

function on_user_update (user, what)
--vardump(user)
end

function on_chat_update (chat, what)
  --vardump (chat)
end

function on_secret_chat_update (schat, what)
  --vardump (schat)
end

function on_get_difference_end ()
end

-- Enable plugins in config.json
function load_plugins()
name = {}
  for i,v in ipairs(_config.enabled_plugins) do
    local p = v
    table.insert(name, p)
    end
print('\27[36m'..#name..'\27[39m'.." plugins loaded")
  for k, v in pairs(_config.enabled_plugins) do
    local ok, err =  pcall(function()
      local t = loadfile("plugins/"..v..'.lua')()
      plugins[v] = t
    end)
    if not ok then
      print('\27[31mError loading plugin '..'\27[33m\27[3m'..v..'\27[33m\27[3m'..'\27[39m')
	  print(tostring(io.popen("lua plugins/"..v..".lua"):read('*all')))
      print('\27[31m'..err..'\27[39m')
    end
  end
end

function cron_plugins()
  for name, plugin in pairs(plugins) do
    if plugin.cron ~= nil then
      plugin.cron()
    end
  end
  postpone(cron_plugins, false, 120)
end

-- Start and load values
our_id = 0
started = false
