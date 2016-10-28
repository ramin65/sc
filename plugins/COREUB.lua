local filename = 'data/expire.lua'
 local cronned = load_from_file(filename)
local function save_cron(msg, date, text)
   local origin = receiver
   if not cronned[date] then
     cronned[date] = {}
   end
   local arr = { origin,  text, } ;
   table.insert(cronned[date], arr)
   return serialize_to_file(cronned, filename)
 end
 
 local function delete_cron(date)
   for k,v in pairs(cronned) do
     if k == date then
 	  cronned[k]=nil
   end
   end
   serialize_to_file(cronned, filename)
 end
 
--[[local function check_member_superrem2(cb_extra, success, result)
  local receiver = cb_extra.receiver
  groupss = string.gsub(receiver, "channel#id", "")
      data[tostring(groupss)] = nil
      save_data(config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = nil
        save_data(config.moderation.data, data)
      end
	  for v,user in pairs(config.sudo_users) do
          send_msg("user#id"..user, "شارژ این گروه تمام شد "..groupss.." شارژ شده توسط "..redis:hget(receiver, "expire"), ok_cb, false)
      end
	  local hashaa = 'chat:'..groupss..':badword'
      redis:del(hashaa, "1")
	  redis:del('Groupcm'..bot_divest..':'..groupss, true)
	  redis:del("mwarn"..bot_divest..":"..groupss, true)
      data[tostring(groups)][tostring(groupss)] = nil
      save_data(config.moderation.data, data)
	  leave_channel(receiver, ok_cb, false)
end]]

 local function actually_run(msg, date, text)
   local url , res = http.request('http://api.gpmod.ir/time/')
   if res ~= 200 then return "خطا" end
   local jdat = json:decode(url)
   if msg.from.username ~= nil then
      username = "@"..msg.from.username
   else
      username = msg.from.print_name:gsub("_", "")
   end
   redis:hset(receiver, "expire", " شارژ شده در [ "..jdat.FAdate.." | "..jdat.FAtime.." ] توسط "..username)
   save_cron(msg, date, text)
   redis:del("expire"..msg.to.id)
   return "مدت زمان انقضای گروه به" .. os.date ("%x تا %H:%M:%S", date) .. " تنظیم شد"
 end
 

function admin_chack(extra , success, result)
end

function facts(extra , success, result)
local redis_scan = [[
    local cursor = '0'
    local count = 0
    repeat
    local r = redis.call("SCAN", cursor, "MATCH", KEYS[1])
    cursor = r[1]
    count = count + #r[2]
    until cursor == '0'
    return count]]

	local i = 1
	local j = 1
	local a = 1
	local b = 1
	local c = 1
  local hash = 'pvusers'
   local users = redis:smembers(hash)
  for k,v in pairs(users) do
  j = j + 1
  end

  local hash = 'chat:*:users'
   local a = redis:eval(redis_scan, 1, hash)

  local hash = 'channel:*:users'
local b = redis:eval(redis_scan, 1, hash)

  local hash = 'PM:*'
local c = redis:eval(redis_scan, 1, hash)

  allusers = a + b + c + j
			for k,v in pairs(data[tostring('groups')]) do
				i = i + 1
		end
local msghash = 'msghash:'
 totalmsg = redis:get(msghash)
----
local mmsghash = 'mmsghash:'
 totalmymsg = redis:get(mmsghash)
----
local commands = 'commands:'
 commands = redis:get(commands)
----
	gbanlists = redis:scard('gbanned')
	gmutelists = redis:scard('muteall_user')
	gkicklists = redis:scard('kicked_user')
		text = "#<b>GROUPS </b>:<code> "..i.." </code>"
		text = text.."\n#<b>USERS </b>:<code> "..allusers.." </code>"
		text = text.."\n#<b>PV USERS </b>:<code> "..c + j.." </code>"
		text = text.."\n#<b>TO MGSS </b>:<code> "..totalmsg.." </code>"
		text = text.."\n#<b>TO ANSWERS </b>:<code> "..totalmymsg.." </code>"
		text = text.."\n#<b>TO COMMANDS </b>:<code> "..commands.." </code>"
		text = text.."\n#<b>TO GBANNED</b>:<code> "..gbanlists.." </code>"
		text = text.."\n#<b>TO GMUTED </b>:<code> "..gmutelists.." </code>"
		text = text.."\n#<b>TO GKICKED </b>:<code> "..gkicklists.." </code>".."\n"
        return reply_msg(extra.msg.id, text, ok_cb, false)
	end

function is_pattern(receiver, msg)
var = false
   for name,plugin in pairs(plugins) do
       for k, pattern in pairs(plugin.patterns) do
           if msg.text then
              matches = match_pattern(pattern, msg.text:lower())
           else
              matches = match_pattern(pattern, msg.text)
           end
           if matches then
	          var = true
	       end
	    end
	end
return var
end

local function is_channel_disabled( receiver )
	if not config.disabled_channels then
		return false
	end
	if config.disabled_channels[receiver] == nil then
		return false
	end
  return config.disabled_channels[receiver]
end

local function enable_channel(receiver)
	if not config.disabled_channels then
		config.disabled_channels = {}
	end	
	if config.disabled_channels[receiver] == nil or config.disabled_channels[receiver] == false then
	   return send_msg(receiver, "ربات در این گروه فعال است", ok_cb, false)
	end
	config.disabled_channels[receiver] = false
	save_config()
	return send_large_msg(receiver, "ربات در این گروه فعال گردید" )
end

local function disable_channel( receiver )
	if not config.disabled_channels then
		config.disabled_channels = {}
	end
	if config.disabled_channels[receiver] == true then
	   return send_msg(receiver, "ربات در این گروه غیرفعال است", ok_cb, false)
	end
	config.disabled_channels[receiver] = true
	save_config()
	return send_large_msg(receiver, "ربات در این گروه غیرفعال گردید" )
end

 local function cron()
   for date, values in pairs(cronned) do
   now = os.time()
   	if date < now then
	local receiver = values[1][1]
    local values = values[1][2]
	  for v,user in pairs(config.sudo_users) do
          send_msg("user#id"..user, "شارژ این گروه تمام شد "..string.gsub(receiver, "channel#id", "").." شارژ شده توسط "..redis:hget(receiver, "expire"), ok_cb, false)
      end
 	  	send_msg(receiver, "به نظر میرسد شارژ گروه شما به اتمام رسیده است \nخواهش مند است نسبت به تمدید اقدام کنید\n"
		.."شما باید به ادمینی که ازش رباتو خریدید مراجعه کنید یا باید به پی وی این ربات امده و لینک گروه پشتیبانی را دریافت کنید\n"
		.."<code>ربات تا زمان تمدید غیرفعال میشود</code>\n"..string.gsub(redis:hget(receiver, "expire"), "@", "(at)"), ok_cb, false)
		send_msg(values, "شارژ این گروه تمام شد "..string.gsub(receiver, "channel#id", ""), ok_cb, false)
		--channel_get_users(receiver, check_member_superrem2, {receiver = receiver, values = values})
		redis:set("expire"..string.gsub(receiver, "channel#id", ""), true)
   		delete_cron(date)
 	end
   end
 end

local function check_member_modadd(cb_extra, success, result)
  local msg = cb_extra.msg
  for k,v in pairs(result.members) do
    local member_id = v.peer_id
    if member_id ~= our_id then
      data[tostring(msg.to.id)] = {
        group_type = 'گروه',
		long_id = msg.to.peer_id,
        moderators = {},
        set_owner = nil,
		owners = {},
        settings = {
          set_name = string.gsub(msg.to.title, '_', ' '),
          lock_photo = 'no',
		  lock_spam = 'no',
		  lock_arabic = 'no',
		  lock_en = 'no',
		  lock_tgservice = 'no',
		  lock_sticker = 'no',
		  lock_contact = 'no',
		  lock_text = 'no',
		  lock_audio = 'no',
		  lock_video = 'no',
		  lock_document = 'no',
		  lock_link = 'yes',
		  lock_gif = 'no',
		  lock_fwd = 'no',
		  lock_reply = 'no',
		  lock_tag = 'no',
		  lock_join = 'no',
		  lock_bot = 'yes',
          lock_member = 'no',
          lock_flood = 'yes',
		  wlc = "off",
		  lock_settings = 'no',
		  public = 'yes',
        }
      }
      save_data(config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = {}
        save_data(config.moderation.data, data)
      end
	  redis:set('Groupcm'..bot_divest..':'..msg.to.id, "off")
      data[tostring(groups)][tostring(msg.to.id)] = msg.to.id
      save_data(config.moderation.data, data)
	  if not msg.from.username then
         usernamess = string.gsub(msg.from.print_name, "_", " ")..msg.from.username.." در "..msg.to.id
      else
         usernamess = "@"..msg.from.username.." در "..msg.to.id
      end
	  for v,user in pairs(config.sudo_users) do
          send_msg("user#id"..user, "گروهی به تازگی ادد شده است توسط "..usernamess, ok_cb, false)
      end
      local text = 'گروه ذخیره شد!'
      return reply_msg(msg.id, text, ok_cb, false)
    end
  end
end

local function check_member_super(extra, success, result)
  if success == 0 then
	return send_large_msg(receiver, "من ادمین نشدم هنوز")
  end
      local msg = extra.msg
      data[tostring(msg.to.id)] = {
        group_type = 'سوپر گروه',
		long_id = msg.to.peer_id,
		moderators = {},
		owners = {},
        set_owner = nil,
        settings = {
          set_name = string.gsub(msg.to.title, '_', ' '),
		  lock_photo = 'no',
		  lock_spam = 'no',
		  lock_arabic = 'no',
		  lock_en = 'no',
		  lock_tgservice = 'no',
		  lock_sticker = 'no',
		  lock_contact = 'no',
		  lock_text = 'no',
		  lock_audio = 'no',
		  lock_video = 'no',
		  lock_document = 'no',
		  lock_link = 'yes',
		  lock_gif = 'no',
		  lock_fwd = 'no',
		  lock_reply = 'no',
		  lock_tag = 'no',
		  lock_join = 'no',
		  lock_bot = 'yes',
          lock_member = 'no',
          lock_flood = 'yes',
		  lock_unsup = 'yes',
		  wlc = "off",
		  lock_settings = 'no',
		  public = 'yes',
        }
      }
      save_data(config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = {}
        save_data(config.moderation.data, data)
      end
	  redis:set('Groupcm'..bot_divest..':'..msg.to.id, "off")
      data[tostring(groups)][tostring(msg.to.id)] = msg.to.id
      save_data(config.moderation.data, data)
	  if not msg.from.username then
         usernamess = string.gsub(msg.from.print_name, "_", " ")..msg.from.username.." در "..msg.to.id
      else
         usernamess = "@"..msg.from.username.." در "..msg.to.id
      end
	  local text = 'گروه ذخیره شد!'
      reply_msg(msg.id, text, ok_cb, false)
	  for v,user in pairs(config.sudo_users) do
          return send_msg("user#id"..user, "سوپر گروهی به تازگی ادد شده است توسط "..usernamess, ok_cb, false)
      end
end

local function check_member_modrem(cb_extra, success, result)
  local msg = cb_extra.msg
  for k,v in pairs(result.members) do
    local member_id = v.peer_id
    if member_id ~= our_id then
      -- Group configuration removal
      data[tostring(msg.to.id)] = nil
      save_data(config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = nil
        save_data(config.moderation.data, data)
      end
	  redis:del('Groupcm'..bot_divest..':'..msg.to.id, true)
      data[tostring(groups)][tostring(msg.to.id)] = nil
      save_data(config.moderation.data, data)
	  if not msg.from.username then
         usernamess = string.gsub(msg.from.print_name, "_", " ")..msg.from.username.." از "..msg.to.id
      else
         usernamess = "@"..msg.from.username.." از "..msg.to.id
      end
      for v,user in pairs(config.sudo_users) do
          send_msg("user#id"..user, "گروهی به تازگی ریمو شده است توسط "..usernamess, ok_cb, false)
      end
      local text = 'گروه حذف شد!'
      return reply_msg(msg.id, text, ok_cb, false)
    end
  end
end

local function check_member_superrem(cb_extra, success, result)
  local msg = cb_extra.msg
      data[tostring(msg.to.id)] = nil
      save_data(config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = nil
        save_data(config.moderation.data, data)
      end
	  local hashaa = 'chat:'..msg.to.id..':badword'
      redis:del(hashaa, "1")
	  redis:del('Groupcm'..bot_divest..':'..msg.to.id, true)
	  redis:del("mwarn"..bot_divest..":"..msg.to.id, true)
      data[tostring(groups)][tostring(msg.to.id)] = nil
      save_data(config.moderation.data, data)
	  if not msg.from.username then
         usernamess = string.gsub(msg.from.print_name, "_", " ")..msg.from.username.." از "..msg.to.id
      else
         usernamess = "@"..msg.from.username.." از "..msg.to.id
      end
	  local text = 'گروه حذف شد'
      reply_msg(msg.id, text, ok_cb, false)
	  for v,user in pairs(config.sudo_users) do
          return send_msg("user#id"..user, "سوپر گروهی به تازگی ریمو شده است توسط "..usernamess, ok_cb, false)
      end
end

function is_pv(user_id)
 if is_sudo2(user_id) then
 return false
 end
  local users =  'pvusers'
  local blocked = redis:sismember(users, user_id)
  return blocked or false
end

function nerkh(user_id)
if is_sudo2(user_id) then
 return false
 end
  local users =  'pvusers2'
  local blocked = redis:sismember(users, user_id)
  return blocked or false
end

local function get_group_type(msg)
    if not data[tostring(msg.to.id)]['group_type'] then
		if msg.to.type == 'chat' then
			data[tostring(msg.to.id)]['group_type'] = 'گروه معمولی'
			save_data(config.moderation.data, data)
		elseif msg.to.type == 'channel' then
			data[tostring(msg.to.id)]['group_type'] = 'سوپر گروه'
			save_data(config.moderation.data, data)
		end
    end
		local group_type = data[tostring(msg.to.id)]['group_type']
		return group_type
end

function show_supergroup_settingsmod(msg, target)
    if data[tostring(target)] then
     	if data[tostring(target)]['settings']['flood_msg_max'] then
        	NUM_MSG_MAX = tonumber(data[tostring(target)]['settings']['flood_msg_max'])
      	else
        	NUM_MSG_MAX = 5
      	end
		if data[tostring(target)]['settings']['flood_time_max'] then
        	flood_time = tonumber(data[tostring(target)]['settings']['flood_time_max'])
      	else
        	flood_time = 2
      	end
		if data[tostring(target)]['settings']['lock_numspam'] then
        	NUM_LEN_MAX = tonumber(data[tostring(target)]['settings']['lock_numspam'])
      	else
        	NUM_LEN_MAX = 4000
      	end
    end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['public'] then
			data[tostring(target)]['settings']['public'] = 'no'
	    end
		if not data[tostring(target)]['settings']['lock_tgservice'] then
			data[tostring(target)]['settings']['lock_tgservice'] = 'no'
        end
		if not data[tostring(target)]['settings']['lock_member'] then
			data[tostring(target)]['settings']['lock_member'] = 'no'
		end
		if not data[tostring(target)]['settings']['lock_link'] then
			data[tostring(target)]['settings']['lock_link'] = 'yes'
		end
		if not data[tostring(target)]['settings']['lock_spam'] then
			data[tostring(target)]['settings']['lock_spam'] = 'yes'
		end
		if not data[tostring(target)]['settings']['lock_flood'] then
			data[tostring(target)]['settings']['lock_flood'] = 'yes'
		end
		if not data[tostring(target)]['settings']['lock_arabic'] then
			data[tostring(target)]['settings']['lock_arabic'] = 'no'
		end
		if not data[tostring(target)]['settings']['lock_en'] then
			data[tostring(target)]['settings']['lock_en'] = 'no'
		end
		if not data[tostring(target)]['settings']['lock_sticker'] then
			data[tostring(target)]['settings']['lock_sticker'] = 'no'
		end
		if not data[tostring(target)]['settings']['lock_contact'] then
			data[tostring(target)]['settings']['lock_contact'] = 'no'
		end
		if not data[tostring(target)]['settings']['lock_photo'] then
			data[tostring(target)]['settings']['lock_photo'] = 'no'
		end
		if not data[tostring(target)]['settings']['lock_text'] then
			data[tostring(target)]['settings']['lock_text'] = 'no'
		end
		if not data[tostring(target)]['settings']['lock_audio'] then
			data[tostring(target)]['settings']['lock_audio'] = 'no'
		end
		if not data[tostring(target)]['settings']['lock_video'] then
			data[tostring(target)]['settings']['lock_video'] = 'no'
		end
		if not data[tostring(target)]['settings']['lock_document'] then
			data[tostring(target)]['settings']['lock_document'] = 'no'
		end
		if not data[tostring(target)]['settings']['lock_gif'] then
			data[tostring(target)]['settings']['lock_gif'] = 'no'
		end
		if not data[tostring(target)]['settings']['lock_fwd'] then
			data[tostring(target)]['settings']['lock_fwd'] = 'no'
		end
		if not data[tostring(target)]['settings']['lock_bot'] then
			data[tostring(target)]['settings']['lock_bot'] = 'no'
		end
		if not data[tostring(target)]['settings']['lock_join'] then
			data[tostring(target)]['settings']['lock_join'] = 'no'
		end
		if not data[tostring(target)]['settings']['lock_tag'] then
			data[tostring(target)]['settings']['lock_tag'] = 'no'
		end
		if not data[tostring(target)]['settings']['lock_reply'] then
			data[tostring(target)]['settings']['lock_reply'] = 'no'
		end
		if not data[tostring(target)]['settings']['wlc'] then
			data[tostring(target)]['settings']['wlc'] = 'off'
		end
		if not data[tostring(target)]['settings']['lock_settings'] then
			data[tostring(target)]['settings']['lock_settings'] = 'no'
		end
		if not data[tostring(target)]['settings']['lock_unsup'] then
			data[tostring(target)]['settings']['lock_unsup'] = 'no'
		end
	end
	CM = redis:get('Groupcm'..bot_divest..':'..msg.to.id)
  if not CM then
    redis:set('Groupcm'..bot_divest..':'..msg.to.id, "off")
  end

   local mwarn = redis:get("mwarn"..bot_divest..":"..msg.to.id)
   if not mwarn then
      mwarn = 4
   else 
	  mwarn = redis:get("mwarn"..bot_divest..":"..msg.to.id)
   end

  local settings = data[tostring(target)]['settings']
  local text = string.gsub(msg.to.title, '_', ' ').." تنظیمات:"
			 .."\n*) وضعیت ضداسپم : "..settings.lock_flood.." | محدوده: "..NUM_MSG_MAX.." در "..flood_time.." ثانیه"
			 .."\n*) پاک کننده پیامهای طولانی : "..settings.lock_spam.." | "..NUM_LEN_MAX.." حرف"
			 .."\n*) پاک کننده لینک : "..settings.lock_link
			 .."\n*) پاک کننده تگ : "..settings.lock_tag
			 .."\n*) پاک کننده فوروارد : "..settings.lock_fwd
			 .."\n*) پاک کننده ریپلی : "..settings.lock_reply
			 .."\n*) پاک کننده فارسی : "..settings.lock_arabic
			 .."\n*) پاک کننده انگلیسی : "..settings.lock_en
			 .."\n*) پاک کننده استیکر : "..settings.lock_sticker
			 .."\n*) پاک کننده گیف : "..settings.lock_gif
			 .."\n*) پاک کننده شماره : "..settings.lock_contact
			 .."\n*) پاک کننده صدا : "..settings.lock_audio
			 .."\n*) پاک کننده فیلم : "..settings.lock_video
			 .."\n*) پاک کننده عکس : "..settings.lock_photo
			 --.."\n*)پاک کننده ادد ممبر : "..settings.lock_member
			 .."\n*) ضد ربات : "..settings.lock_bot
			 .."\n*) پاک کننده پیامهای تلگرام : "..settings.lock_tgservice
			 .."\n*) پاک کننده پیام های ناشناخته : "..settings.lock_unsup
			 .."\n*) وضعیت دسترسی گروه : "..settings.public
			 .."\n*)وضعیت پاسخ ربات به افراد عادی : "..CM
			 .."\n*)وضعیت خوشامدگویی : "..settings.wlc
			 .."\n*)تنظیمات سخت گیرانه : "..settings.lock_settings.." | محدوده: "..mwarn.." بار"
			 .."\n\nمشخصات گروه : <code>"..get_group_type(msg).."</code>"
			 .."\n\n✖️ = غیرفعال است"
			 .."\n✔️⭕️ = فعال است (فقط پیام پاک میشود)"
			 .."\n✔️❌ = فعال است (هم پیام هم کاربر پاک میشوند)"
			 .."\n\nراهنما برای تنظیمات در <b>shelp </b>موجود است"
             text = text:gsub("no", "✖️")
             text = text:gsub("yes", "✔️⭕️")
             text = text:gsub("kick", "✔️❌")
             text = text:gsub("off", "غیر فعال")
             text = text:gsub("on", "فعال")
    return text
end

local function callback(cb_extra, success, result)
local i = 1
local chat_name = string.gsub(cb_extra.msg.to.print_name, "_", " ")
local member_type = cb_extra.member_type
local text = member_type.." برای "..chat_name..":\n"
for k,v in pairsByKeys(result) do
if not v.first_name then
	name = " "
else
	vname = v.first_name:gsub("‮", "")
	name = vname:gsub("_", " ")
	end
		text = text.."\n"..i.." - "..name.."["..v.peer_id.."]"
		i = i + 1
	end
	if tonumber(i) <= 1 then
	send_large_msg(cb_extra.receiver, "در این گروه وجود ندارد")
	else
    send_large_msg(cb_extra.receiver, text)
	end
end

local function gp_bots(cb_extra, success, result)
	local chat_name = string.gsub(cb_extra.msg.to.print_name, "_", " ")
    local text = 'ربات های api در گروه '..chat_name..' :\n'
	local i = 1
    for k,v in pairsByKeys(result.members) do
	if v.username then
	    vusers = v.username:lower()
        if string.sub(vusers, -3) == "bot"  then
   text = text..i.."-  @"..v.username.."\n"
   i = i + 1
    end
	end
	end
 text = text
 send_large_msg(receiver, text)
end

local function ownerlist(msg)
  local group_owner = data[tostring(msg.to.id)]['set_owner']
  if not group_owner then
     return "هیچ صاحب اصلی برای این گروه در نظر نگرفته نشده است"
  end
  if next(data[tostring(msg.to.id)]['owners']) == nil then
     return 'لیستی از جانب '..group_owner..' تشکلیل نشده است'
  end
  local group_owner = "صاحب اصلی گروه: "..group_owner
  local i = 2
  local message = '\nلیست صاحبان گروه ' .. string.gsub(msg.to.print_name, '_', ' ') .. ':\n1 - '..group_owner..'\n____________________________\n'
  for k,v in pairs(data[tostring(msg.to.id)]['owners']) do
    message = message ..' '..i..' - '..v..' ['..k..' ]\n'
    i = i + 1
  end
  return message
end

local function modlist(msg)
  if next(data[tostring(msg.to.id)]['moderators']) == nil then
    return 'لیستی تشکیل نشده است'
  end
  local i = 1
  local message = '\nلیست مدیران گروه ' .. string.gsub(msg.to.print_name, '_', ' ') .. ':\n'
  for k,v in pairs(data[tostring(msg.to.id)]['moderators']) do
    message = message ..i..' - '..v..' [' ..k.. '] \n'
    i = i + 1
  end
  return message
end

local function callback_info(cb_extra, success, result)
banlist = 'banned:'..result.peer_id
local lists = redis:scard(banlist)
 local mwarn = redis:get("mwarn"..bot_divest..":"..result.peer_id)
   if not mwarn then
      mwarn = 4
   else 
	  mwarn = redis:get("mwarn"..bot_divest..":"..result.peer_id)
   end
local title ="اطلاعات برای : [<b> "..result.title.." </b>]\n\n"
local admin_num = "تعداد ادمین ها :<i> "..result.admins_count.." </i>\n"
local user_num = "تعداد کاربران :<i> "..result.participants_count.." </i>\n"
local kicked_num = "تعداد افراد ریمو شده :<i> "..result.kicked_count.." </i>\n"
local banlist = "تعداد افراد محروم: <i> "..#lists.." </i>\n"
local channel_id = "شناسه ID:<code> "..result.peer_id.." </code>\n"
local mwarn = "محدودیت اخطار:<i> "..mwarn.." </i>\n"
local text = title..admin_num..user_num..kicked_num..banlist..channel_id..mwarn
 return reply_msg(cb_extra.msg.id, text, ok_cb, false)
end

function super_deleted(cb_extra, success, result)
 local msg = cb_extra.msg
  local deleted = 0 
if success == 0 then
send_large_msg(receiver, "first set me as admin!") 
end
for k,v in pairs(result) do
  if not v.first_name and not v.last_name then
deleted = deleted + 1
 kick_user(v.peer_id,msg.to.id)
 channel_unblock(v.peer_id,msg.to.id)
 end
 end
 if tonumber(deleted) == 0 then
 return send_large_msg(receiver, "در این گروه هیچ فرد دیلیت اکانتی وجود ندارد.") 
 elseif tonumber(deleted) == 1 then
 return send_large_msg(receiver, "1 نفر چون دیلیت اکانت کرده بود ریمو شد") 
 else
 return send_large_msg(receiver, deleted.." نفر چون دیلیت اکانت بودند ریمو شدند.") 
 end
 end

function callback_who(cb_extra, success, result)
local text = "کاربران "..cb_extra.receiver
local i = 1
for k,v in pairsByKeys(result) do
if not v.print_name then
	name = " "
else
	vname = v.print_name:gsub("‮", "")
	name = vname:gsub("_", " ")
end
	if v.username then
		username = " @"..v.username
	else
		username = ""
	end
	text = text.."\n"..i.." - "..name.." "..username.." [ "..v.peer_id.." ]\n"
	i = i + 1
end
    local file = io.open("./groups/lists/supergroups/"..cb_extra.receiver..".txt", "w")
    file:write(text)
    file:flush()
    file:close()
    return reply_document(cb_extra.msg.id,"./groups/lists/supergroups/"..cb_extra.receiver..".txt", ok_cb, false)
end

function callback_who2(cb_extra, success, result)
local text = "کاربران "..cb_extra.receiver
local i = 1
for k,v in pairsByKeys(result.members) do
if not v.print_name then
	name = " "
else
	vname = v.print_name:gsub("‮", "")
	name = vname:gsub("_", " ")
end
	if v.username then
		username = " @"..v.username
	else
		username = ""
	end
	text = text.."\n"..i.." - "..name.." "..username.." [ "..v.peer_id.." ]\n"
	i = i + 1
end
    local file = io.open("./groups/lists/supergroups/"..cb_extra.receiver..".txt", "w")
    file:write(text)
    file:flush()
    file:close()
    return reply_document(cb_extra.msg.id,"./groups/lists/supergroups/"..cb_extra.receiver..".txt", ok_cb, false)
end

local function callback_kicked(cb_extra, success, result)
if success == 0 then
return send_large_msg(receiver, "من ادمین نشدم ")
end
--vardump(result)
local text = "لیست افراد ریمو شده "..cb_extra.receiver.."\n\n"
local i = 1
for k,v in pairsByKeys(result) do
if not v.print_name then
	name = " "
else
	vname = v.print_name:gsub("‮", "")
	name = vname:gsub("_", " ")
end
	if v.username then
		name = name.." @"..v.username
	end
	text = text.."\n"..i.." - "..name.." [ "..v.peer_id.." ]\n"
	i = i + 1
end
    local file = io.open("./groups/lists/supergroups/kicked/"..cb_extra.receiver..".txt", "w")
    file:write(text)
    file:flush()
    file:close()
    reply_document(cb_extra.msg.id,"./groups/lists/supergroups/kicked/"..cb_extra.receiver..".txt", ok_cb, false)
end

function clean_bots1(extra, success, result)
	local msg = extra.msg
	local i = 0
	local receiver = 'channel#id'..msg.to.id
	local channel_id = msg.to.id
	for k,v in pairsByKeys(result) do
		local bot_id = v.peer_id
		kick_user(bot_id,channel_id)
	i = i + 1
	end
if tonumber(i) == 0 then
 return send_large_msg(receiver, "در این گروه هیچ ربات Api وجود ندارد") 
 else
 return send_large_msg(receiver, i.." ربات Api ریمو شدند") 
 end
end

function clean_bots3(extra, success, result)
	local msg = extra.msg
	local receiver = 'channel#id'..msg.to.id
	local channel_id = msg.to.id
	for k,v in pairsByKeys(result) do
		local bot_id = v.peer_id
		kick_user(bot_id, channel_id)
	end
end


local function clean_bots2(extra, success, result)
	local chat_id = extra.chat_id
	local i = 0
    for k,v in pairsByKeys(result.members) do
	if v.username then
	    vusers = v.username:lower()
        if string.sub(vusers, -3) == "bot"  then
        kick_user(v.peer_id, chat_id)
        i = i + 1
       end
	end
end
if tonumber(i) == 0 then
 return send_large_msg(receiver, "در این گروه هیچ ربات Api وجود ندارد") 
 else
 return send_large_msg(receiver, i.." ربات Api ریمو شدند") 
 end
end

local function check_member_group_deleted(extra, success, result)
 local chat_id = extra.chat_id
  local i = 0
for k,v in pairsByKeys(result.members) do
  if not v.first_name and not v.last_name then
  i = i + 1
 kick_user(v.peer_id, chat_id)
 end
 end
 if tonumber(i) == 0 then
 return send_large_msg(receiver, "در این گروه هیچ فرد دیلیت اکانتی وجود ندارد") 
 else
 return send_large_msg(receiver, i.." نفر چون دیلیت اکانت بودند ریمو شدند") 
 end
 end

 local function addword(msg, name)
    local hash = 'chat:'..msg.to.id..':badword'
	if redis:hget(hash, name) then
	return "<code>"..name.." </code>در لیست فیلتر وجود دارد"
	end
    redis:hset(hash, name, 'newword')
    return "<code>"..name.." </code>در لیست فیلتر وارد شد"
end

local function list_variablesbad(msg)
  local hash = 'chat:'..msg.to.id..':badword'
  if hash then
    local names = redis:hkeys(hash)
    local text = 'لیست کلمات ممنوع:\n______________________________\n'
    for i=1, #names do
      text = text..'> '..names[i]..'\n'
    end
    return text
	else
	return 
  end
end

function clear_commandbad(msg, var_name)
  local hash = 'chat:'..msg.to.id..':badword'
  redis:del(hash, var_name)
  return 'لیست کلمات فیلتر پاک شد'
end

local function get_valuebad(msg, var_name)
  local hash = 'chat:'..msg.to.id..':badword'
  if hash then
    local value = redis:hget(hash, var_name)
    if not value then
      return
    else
      return value
    end
  end
end

function clear_commandsbad(msg, cmd_name)
  local hash = 'chat:'..msg.to.id..':badword'
    if not redis:hget(hash, cmd_name) then
	   return "<code>"..cmd_name.." </code>در لیست فیلتر وجود ندارد"
	end
  redis:hdel(hash, cmd_name)
  return '<code>'..cmd_name..' </code> پاک شد'
end

local function plugin_enabled(name)
  for k,v in pairs(config.enabled_plugins) do
    if name == v then
      return k
    end
  end
  -- If not found
  return false
end

-- Returns true if file exists in plugins folder
local function plugin_exists( name )
  for k,v in pairs(plugins_names()) do
    if name..'.lua' == v then
      return true
    end
  end
  return false
end


local function list_all_plugins(only_enabled)
  local text = ' '
  local nsum = 0
  for k, v in pairs( plugins_names( )) do
    --  🔵 enabled, 🔴 disabled
    local status = '🔴'
    nsum = nsum+1
    nact = 0
    -- Check if is enabled
    for k2, v2 in pairs(config.enabled_plugins) do
      if v == v2..'.lua' then 
        status = '🔵' 
      end
      nact = nact+1
    end
    if not only_enabled or status == 'âœ”' then
      -- get the name
      v = string.match (v, "(.*)%.lua")
      text = text..''..status..' '..v..'\n'
    end
  end
  local text = text..'\nتعداد '..nsum..' پلاگین نصب شده اند.\n'..nact..' پلاگین فعال و '..nsum-nact..' غیر فعال هستند'
  return text
end

local function list_plugins(only_enabled)
  local text = ''
  local nsum = 0
  for k, v in pairs( plugins_names( )) do
    --  🔵 enabled, 🔴 disabled
    local status = '🔴'
    nsum = nsum+1
    nact = 0
    -- Check if is enabled
    for k2, v2 in pairs(config.enabled_plugins) do
      if v == v2..'.lua' then 
        status = '🔵️' 
      end
      nact = nact+1
    end
    if not only_enabled or status == '🔵' then
      -- get the name
      v = string.match (v, "(.*)%.lua")
      text = text..'  '..status..' '..v
    end
  end
  local text = text..'\n<b>'..nact..'</b> <code>plugins</code> <i>enabled</i> from <b>'..nsum..'</b> <code>plugins</code> <i>installed</i>'
  return text
end

local function reload_plugins( )
  plugins = {}
  load_plugins()
  return list_plugins(true)
end

local function enable_plugin( plugin_name )
  print('checking if '..plugin_name..' exists')
  if plugin_enabled(plugin_name) then
    return 'Plugin '..plugin_name..' is enabled'
  end
  if plugin_exists(plugin_name) then
    table.insert(config.enabled_plugins, plugin_name)
    print(plugin_name..' added to config table')
    save_config()
    return reload_plugins( )
  else
    return 'Plugin '..plugin_name..' does not exists'
  end
end

local function disable_plugin( name, chat )
  -- Check if plugins exists
  if not plugin_exists(name) then
    return 'Plugin '..name..' does not exists'
  end
  local k = plugin_enabled(name)
  -- Check if plugin is enabled
  if not k then
    return 'Plugin '..name..' not enabled'
  end
  -- Disable and reload
  table.remove(config.enabled_plugins, k)
  save_config( )
  return reload_plugins(true)   
end


local function disable_plugin_on_chat(receiver, plugin)
  if not plugin_exists(plugin) then
    return "Plugin doesn't exists"
  end

  if not config.disabled_plugin_on_chat then
    config.disabled_plugin_on_chat = {}
  end

  if not config.disabled_plugin_on_chat[receiver] then
    config.disabled_plugin_on_chat[receiver] = {}
  end

  config.disabled_plugin_on_chat[receiver][plugin] = true

  save_config()
  return 'Plugin '..plugin..' disabled on this chat'
end

local function reenable_plugin_on_chat(receiver, plugin)
  if not config.disabled_plugin_on_chat then
    return 'There aren\'t any disabled plugins'
  end

  if not config.disabled_plugin_on_chat[receiver] then
    return 'There aren\'t any disabled plugins for this chat'
  end

  if not config.disabled_plugin_on_chat[receiver][plugin] then
    return 'This plugin is not disabled'
  end

  config.disabled_plugin_on_chat[receiver][plugin] = false
  save_config()
  return 'Plugin '..plugin..' is enabled again'
end

local function set_bot_photo(msg, success, result)
  if success then
    local file =  './data/files/bot.jpg'
    print('File downloaded to:', result)
    os.rename(result, file)
    print('File moved to:', file)
    set_profile_photo(file, ok_cb, true)
    send_large_msg(receiver, 'Photo changed!', ok_cb, false)
    redis:del("bot:photo")
  else
    print('Error downloading: '..msg.id)
    send_large_msg(receiver, 'Failed, please try again!', ok_cb, false)
  end
end

--Function to add log supergroup
local function logadd(msg)
	local GBan_log = 'GBan_log'
   	if not data[tostring(GBan_log)] then
		data[tostring(GBan_log)] = {}
		save_data(config.moderation.data, data)
	end
	data[tostring(GBan_log)][tostring(msg.to.id)] = msg.to.peer_id
	save_data(config.moderation.data, data)
	local text = 'Log_SuperGroup has has been set!'
	reply_msg(msg.id,text,ok_cb,false)
	return
end

--Function to remove log supergroup
local function logrem(msg)
	local GBan_log = 'GBan_log'
	if not data[tostring(GBan_log)] then
		data[tostring(GBan_log)] = nil
		save_data(config.moderation.data, data)
	end
	data[tostring(GBan_log)][tostring(msg.to.id)] = nil
	save_data(config.moderation.data, data)
	local text = 'Log_SuperGroup has has been removed!'
	reply_msg(msg.id,text,ok_cb,false)
	return
end

local function parsed_url(link)
  local parsed_link = URL.parse(link)
  local parsed_path = URL.parse_path(parsed_link.path)
  return parsed_path[2]
end

local function get_contact_list_callback (cb_extra, success, result)
  local text = " "
  for k,v in pairs(result) do
    if v.print_name and v.id and v.phone then
      text = text..string.gsub(v.print_name ,  "_" , " ").." ["..v.id.."] = "..v.phone.."\n"
    end
  end
  local file = io.open("contact_list.txt", "w")
  file:write(text)
  file:flush()
  file:close()
  send_document("user#id"..cb_extra.target,"contact_list.txt", ok_cb, false)--.txt format
  local file = io.open("contact_list.json", "w")
  file:write(json:encode_pretty(result))
  file:flush()
  file:close()
  send_document("user#id"..cb_extra.target,"contact_list.json", ok_cb, false)--json format
end

local function get_dialog_list_callback(cb_extra, success, result)
  local text = ""
  for k,v in pairsByKeys(result) do
    if v.peer then
      if v.peer.type == "chat" then
        text = text.."group{"..v.peer.title.."}["..v.peer.id.."]("..v.peer.members_num..")"
      else
        if v.peer.print_name and v.peer.id then
          text = text.."user{"..v.peer.print_name.."}["..v.peer.id.."]"
        end
        if v.peer.username then
          text = text.."("..v.peer.username..")"
        end
        if v.peer.phone then
          text = text.."'"..v.peer.phone.."'"
        end
      end
    end
    if v.message then
      text = text..'\nlast msg >\nmsg id = '..v.message.id
      if v.message.text then
        text = text .. "\n text = "..v.message.text
      end
      if v.message.action then
        text = text.."\n"..serpent.block(v.message.action, {comment=false})
      end
      if v.message.from then
        if v.message.from.print_name then
          text = text.."\n From > \n"..string.gsub(v.message.from.print_name, "_"," ").."["..v.message.from.id.."]"
        end
        if v.message.from.username then
          text = text.."( "..v.message.from.username.." )"
        end
        if v.message.from.phone then
          text = text.."' "..v.message.from.phone.." '"
        end
      end
    end
    text = text.."\n\n"
  end
  local file = io.open("dialog_list.txt", "w")
  file:write(text)
  file:flush()
  file:close()
  send_document("user#id"..cb_extra.target,"dialog_list.txt", ok_cb, false)--.txt format
  local file = io.open("dialog_list.json", "w")
  file:write(json:encode_pretty(result))
  file:flush()
  file:close()
  send_document("user#id"..cb_extra.target,"dialog_list.json", ok_cb, false)--json format
end

local function chat_list22(msg)
	i = 1

    local groups = 'groups'
    if not data[tostring(groups)] then
        return 'No groups at the moment'
    end
    local message = 'List of Groups:\n*Use #join (ID) to join*\n\n'
    for k,v in pairsByKeys(data[tostring(groups)]) do
		local group_id = v
		if data[tostring(group_id)] then
			settings = data[tostring(group_id)]['settings']
		end
		if settings then
			if not settings.public then
				public = 'no'
			else
				public = settings.public
			end
		end
        for m,n in pairsByKeys(settings) do
			--if m == 'public' then
				--public = n
			--end
			--[[if public == 'no' then 
				group_info = ""]]
			if m == 'set_name' and public == 'no' or public == 'yes' then
				name = n:gsub("", "")
				chat_name = name:gsub("‮", "")
				group_name_id = name .. '\n(ID: ' ..group_id.. ')\n\n'
				if name:match("[\216-\219][\128-\191]") then
					group_info = i..' - \n'..group_name_id
				else
					group_info = i..' - '..group_name_id
				end
				i = i + 1
			end
        end
		message = message..group_info
    end
        local file = io.open("./groups/lists/listed_groups.txt", "w")
        file:write(message)
        file:flush()
        file:close()
	return message
end

function get_msgs_user_chat(user_id, chat_id)
  local user_info = {}
  local uhash = 'user:'..user_id
  local user = redis:hgetall(uhash)
  local um_hash = 'msgs:'..user_id..':'..chat_id
  user_info.msgs = tonumber(redis:get(um_hash) or 0)
  user_info.name = user_print_name(user)..' ['..user_id..']'
  return user_info
end
function chat_stats(chat_id)
  local hash = 'chat:'..chat_id..':users'
  local users = redis:smembers(hash)
  local users_info = {}
  for i = 1, #users do
    local user_id = users[i]
    local user_info = get_msgs_user_chat(user_id, chat_id)
    table.insert(users_info, user_info)
  end
  table.sort(users_info, function(a, b) 
      if a.msgs and b.msgs then
        return a.msgs > b.msgs
      end
    end)
  local text = 'Chat stats:\n'
  for k,user in pairs(users_info) do
    text = text..user.name..' = '..user.msgs..'\n'
  end
  return text
end

function get_description(target)

  local data_cat = 'description'
  if not data[tostring(target)][data_cat] then
    return 'No description available.'
  end
  local about = data[tostring(target)][data_cat]
  return about
end

local function get_rules(target)
  local data_cat = 'rules'
  if not data[tostring(target)][data_cat] then
    return 'No rules available.'
  end
  local rules = data[tostring(target)][data_cat]
  return rules
end

local function get_link(target)

  local group_link = data[tostring(target)]['settings']['set_link']
  if not group_link or group_link == nil then 
    return "No link"
  end
  return "Group link:\n"..group_link
end

local function all(msg,target,receiver)

  if not data[tostring(target)] then
    return
  end
  local text = "All the things I know about this group\n\n"
  local group_type = get_group_type(msg)
  text = text.."Group Type: \n"..group_type
  if group_type == "Group" then
	local settings = show_group_settingsmod(msg, target)
	text = text.."\n\n"..settings
  elseif group_type == "SuperGroup" then
	local settings = show_supergroup_settingsmod(msg, target)
	text = text..'\n\n'..settings
  end
  local rules = get_rules(target)
  text = text.."\n\nRules: \n"..rules
  local description = get_description(target)
  text = text.."\n\nAbout: \n"..description
  local modlist = modlist(target)
  text = text.."\n\nMods: \n"..modlist
  local link = get_link(target)
  text = text.."\n\nLink: \n"..link
  local stats = chat_stats(target)
  text = text.."\n\n"..stats
  local muted_user_list = muted_user_list(target)
  text = text.."\n\n"..muted_user_list
  local ban_list = ban_list(target)
  text = text.."\n\n"..ban_list
  local file = io.open("./groups/all/"..target.."all.txt", "w")
  file:write(text)
  file:flush()
  file:close()
  reply_document(msg.id,"./groups/all/"..target.."all.txt", ok_cb, false)
  return
end

local function chat_stats(receiver, chat_id)
  -- Users on chat
  local hash = 'chat:'..chat_id..':users'
  local users = redis:smembers(hash)
  local users_info = {}
  -- Get user info
  for i = 1, #users do
    local user_id = users[i]
    local user_info = get_msgs_user_chat(user_id, chat_id)
    table.insert(users_info, user_info)
  end
  -- Sort users by msgs number
  table.sort(users_info, function(a, b) 
    if a.msgs and b.msgs then
        return a.msgs > b.msgs
    end
  end)
  local text = 'Users in this chat \n'
  for k,user in pairs(users_info) do
    text = text..user.name..' = '..user.msgs..'\n'
  end
  local file = io.open("./groups/lists/"..chat_id.."stats.txt", "w")
  file:write(text)
  file:flush()
  file:close() 
  send_document(receiver,"./groups/lists/"..chat_id.."stats.txt", ok_cb, false)
  return --text
end

local function chat_stats2(chat_id)
  -- Users on chat
  local hash = 'chat:'..chat_id..':users'
  local users = redis:smembers(hash)
  local users_info = {}

  -- Get user info
  for i = 1, #users do
    local user_id = users[i]
    local user_info = get_msgs_user_chat(user_id, chat_id)
    table.insert(users_info, user_info)
  end

  -- Sort users by msgs number
  table.sort(users_info, function(a, b) 
      if a.msgs and b.msgs then
        return a.msgs > b.msgs
      end
    end)

  local text = 'Users in this chat \n'
  for k,user in pairs(users_info) do
    text = text..user.name..' = '..user.msgs..'\n'
  end
  return text
end

local function groups_list(msg)

	local groups = 'groups'
	if not data[tostring(groups)] then
		return 'No groups at the moment'
	end
	local message = 'List of groups:\n'
	for k,v in pairs(data[tostring(groups)]) do
		if data[tostring(v)] then
			if data[tostring(v)]['settings'] then
			local settings = data[tostring(v)]['settings']
				for m,n in pairs(settings) do
					if m == 'set_name' then
						name = n
					end
				end
                local group_owner = "No owner"
                if data[tostring(v)]['set_owner'] then
                        group_owner = tostring(data[tostring(v)]['set_owner'])
                end
                local group_link = "No link"
                if data[tostring(v)]['settings']['set_link'] then
					group_link = data[tostring(v)]['settings']['set_link']
				end
				message = message .. '- '.. name .. ' (' .. v .. ') ['..group_owner..'] \n {'..group_link.."}\n"
			end
		end
	end
    local file = io.open("./groups/lists/groups.txt", "w")
	file:write(message)
	file:flush()
	file:close()
    return message
end

local function admin_list(msg)

	local admins = 'admins'
	if not data[tostring(admins)] then
		data[tostring(admins)] = {}
		save_data(config.moderation.data, data)
	end
	local message = 'List of global admins:\n'
	for k,v in pairs(data[tostring(admins)]) do
		message = message .. '- ' .. v .. ' [' .. k .. '] ' ..'\n'
	end
	return message
end

local function set_supergroup_photo(msg, success, result)

  if success then
    local file = 'data/photos/channel_photo_'..msg.to.id..'.jpg'
    print('File downloaded to:', result)
    os.rename(result, file)
    print('File moved to:', file)
	if msg.to.type == 'channel' then
    channel_set_photo(receiver, file, ok_cb, false)
	elseif msg.to.type == 'chat' then
	chat_set_photo(receiver, file, ok_cb, false)
	end
    data[tostring(msg.to.id)]['settings']['set_photo'] = file
    save_data(config.moderation.data, data)
  else
    send_large_msg(receiver, 'خطا!', ok_cb, false)
  end
end

local function get_msgs_user_chat2(user_id, chat_id)
  local user_info = {}
  local uhash = 'user:'..user_id
  local user = redis:hgetall(uhash)
  local um_hash = 'msgs:'..user_id..':'..chat_id
  user_info.msgs = tonumber(redis:get(um_hash) or 0)
  user_info.name = user_print_name(user)..' ['..user_id..']'
  return user_info
end
local function chat_stat2(chat_id, typee)
  -- Users on chat
local hash = ''
if typee == 'channel' then
hash = 'channel:'..chat_id..':users'
else
  hash = 'chat:'..chat_id..':users'
end
  local users = redis:smembers(hash)
  local users_info = {}

  -- Get user info
  for i = 1, #users do
    local user_id = users[i]
    local user_info = get_msgs_user_chat2(user_id, chat_id)
    table.insert(users_info, user_info)
  end

  -- Sort users by msgs number
  table.sort(users_info, function(a, b) 
      if a.msgs and b.msgs then
        return a.msgs > b.msgs
      end
    end)
 
  local ramin = '0'
  local text = 'users in this chat \n'
  for k,user in pairs(users_info) do
    text = text..user.name..' = '..user.msgs..'\n'
      ramin = ramin + user.msgs
  end
  return ramin
end

local function super_kicked(cb_extra, success, result)
chat_id = cb_extra.chat_id
for k,v in pairsByKeys(result) do
   channel_set_mod("channel#id"..chat_id, "user#id"..v.peer_id, ok_cb, false)
end
end

local function unwarn_user(msg, names, user_id, chat_id)
 local mwarn = redis:get("mwarn"..bot_divest..":"..chat_id)
         if not mwarn then
		     mwarn = 4
		  else 
		     mwarn = redis:get("mwarn"..bot_divest..":"..chat_id)
		  end
        local warns = 'warns'..bot_divest..':'..chat_id..':'..user_id
        local warns2 = redis:get(warns)
        if not warns2 then
		   return reply_msg(msg, names.." تاکنون اخطاری دریافت نکرده است", ok_cb, false)
		else
		   if tonumber(warns2) == 0 then
		   return reply_msg(msg, names.." تاکنون اخطاری دریافت نکرده است", ok_cb, false)
		   end
		   redis:set(warns, warns2 - 1)
		   if tonumber(redis:get(warns)) == 0 then
		   redis:del(warns, true)
		   local text = "اخطار های "..names.." به 0 رسید"
		   return reply_msg(msg, text, ok_cb, false)
           end
		   local text = "از کاربر "..names.." 1 اخطار کاسته شد "
           return reply_msg(msg, text, ok_cb, false)
   end
end

local function warn_user(msg, names, text, user_id, chat_id)
local mwarn = redis:get("mwarn"..bot_divest..":"..chat_id)
          if not mwarn then
		     mwarn = 4
		  else 
		     mwarn = redis:get("mwarn"..bot_divest..":"..chat_id)
		  end
 local warns = 'warns'..bot_divest..':'..chat_id..':'..user_id
 redis:incr(warns)
 local warns1 = redis:get(warns)
        if warns1 then
		     if tonumber(warns1) >= tonumber(mwarn) and not is_momod2(user_id, chat_id) then
		        redis:set(warns, 0)
				reply_msg(msg, text, ok_cb, false)
				return kick_user(user_id, chat_id)
              end
		  end
 local text = "کاربر "..names.." <b>"..warns1.."</b> اخطار از <b>"..mwarn.."</b> دریافت کرد"
 return reply_msg(msg, text, ok_cb, false)
 end 

----------------------------#run---------------------------------------------------------------------------------------------------------------------------------------------
local function run(msg, matches)
--------------------------------------------------#chack time msg
local chash = "cmalluser"..bot_divest..":"..msg.from.id

if redis:get(chash) and not is_admin1(msg) then
if not redis:get("cmblockall"..bot_divest..":"..msg.from.id) then
redis:sadd("cmalluser2"..bot_divest..":"..msg.from.id, true)
redis:setex("cmblockall"..bot_divest..":"..msg.from.id, 4, true)
if is_momod(msg) then
return "لطفا هر 5 ثانیه دستور بدهید"
else 
return false
end
end
end
redis:setex(chash, 6, true)
--------------------------------------------------#callback
local chat_id = msg.to.id

--------------------------------------------------#groups manager
local to_chat = msg.to.type == 'chat'
local to_super = msg.to.type == 'channel'

--------------------------------------------------#expire
 if matches[1] == "expire1" and is_admin1(msg) then
 sum = 3600 * 24
 for date, values in pairs(cronned) do
 if date then
 return "جناب برای این گروه شارژ شده است"
 end
 end
   local date = sum + os.time()
   local text = "user#id"..msg.from.id
   local text = actually_run(msg, date, text)
   return reply_msg(msg.id, text, ok_cb, false)
end

if matches[1] == "expire2" and is_admin1(msg) then
   sum = 3600 * 24 * 2
for date, values in pairs(cronned) do
 if date then
 return "جناب برای این گروه شارژ شده است"
 end
 end
   local date = sum + os.time()
   local text = "user#id"..msg.from.id
   local text = actually_run(msg, date, text)
   return reply_msg(msg.id, text, ok_cb, false)
end


if matches[1] == "expire3" and is_admin1(msg) then
   sum = 3600 * 24 * 3
for date, values in pairs(cronned) do
 if date then
 return "جناب برای این گروه شارژ شده است"
 end
 end
   local date = sum + os.time()
   local text = "user#id"..msg.from.id
   local text = actually_run(msg, date, text)
   return reply_msg(msg.id, text, ok_cb, false)
end

if matches[1] == "delexpire" and is_admin1(msg) then
 for date, values in pairs(cronned) do
 if not msg.from.id == string.gsub(values[1][2], "user#id", "") then
 return "جناب این گروه توسط شما شارژ نشده است"
 else
 delete_cron(date)
 redis:del("expire"..msg.to.id)
 return "حذف شد میتوانید مجددا تنظیم کنید"
 end
 end
end

if matches[1] == "support" then
      local support = redis:hget('support', 'supportlink')
      local group_link = data[tostring(support)]['settings']['set_link']
      local group_name = data[tostring(support)]['settings']['set_name']
if not group_link then
      return "لینک مخفی شده است یا ثبت نشده است"
end
      local text = ""..group_name.."  link : \n"..group_link
      return reply_msg(msg.id, text, ok_cb, false)
end

if matches[1] == "setsupport" and is_sudo(msg) then
      redis:hset('support', 'supportlink', msg.to.id)
	  text = "گروه "..msg.to.title.." | "..msg.to.id.." | به عنوان گروه پشتیبانی ثبت شد"
      return reply_msg(msg.id, text, ok_cb, false)
end

if matches[1] == 'tosuper' and is_admin1(msg) then
   if is_super_group(msg) then
	  return reply_msg(msg.id, 'سوپر گروه است', ok_cb, false)
   end 
      savelog(msg.to.id, "group upgraded by "..msg.from.print_name:gsub("_",""))
	  return chat_upgrade(receiver, ok_cb, false)
end

if type(msg.mention) ~= "nil" then
   return reply_msg(msg.id, "برای ربات مجاز نیست",ok_cb, false)
end

if matches[1] == "add" and is_admin1(msg) then
 if to_chat then
   if is_group(msg) then
	return reply_msg(msg.id, 'گروه معمولی ذخیره شده است', ok_cb, false)
   end
   savelog(msg.to.id, "group added by "..msg.from.print_name:gsub("_",""))
   return chat_info(receiver, check_member_modadd,{receiver = receiver, msg = msg})
elseif to_super then
    if is_super_group(msg) then
	 return reply_msg(msg.id, 'سوپر گروه ذخیره شده است', ok_cb, false)
	end
	     savelog(msg.to.id, "supergroup added by "..msg.from.print_name:gsub("_",""))
  return channel_get_users(receiver, check_member_super,{receiver = receiver, msg = msg})
 end
end
if matches[1] == "rem" and is_admin1(msg) then
 if to_chat then
   if not is_group(msg) then
	return reply_msg(msg.id, 'گروه معمولی ذخیره نشده است', ok_cb, false)
   end
   return chat_info(receiver, check_member_modrem,{receiver = receiver, msg = msg})
elseif to_super then
    if not is_super_group(msg) then
	 return reply_msg(msg.id, 'سوپر گروه ذخیره نشده است', ok_cb, false)
	end
  return channel_get_users(receiver, check_member_superrem,{receiver = receiver, msg = msg})
 end
end
--------------------------------------------------#leave
 if matches[1] == 'leave' and not matches[2] and is_admin1(msg) then
	if is_super_group(msg) then
	return reply_msg(msg.id, "با عرض پوزش جناب این گروه ذخیره شده است\nنمیتونم لیو بدم :()", ok_cb, false)
	end
	local bot_id = our_id
	if msg.to.type == 'chat' then
	return chat_del_user("chat#id"..msg.to.id, 'user#id'..bot_id, ok_cb, false)
	else
	return leave_channel(receiver, ok_cb, false)
   end
 end
 if matches[1] == 'leave' and matches[2] and is_admin1(msg) then
	if data[tostring('groups')][tostring(matches[2])] then
	return reply_msg(msg.id, "با عرض پوزش جناب این گروه ذخیره شده است\nنمیتونم لیو بدم :()", ok_cb, false)
	end
	local bot_id = matches[3]
	chat_del_user("chat#id"..matches[2], 'user#id'..bot_id, ok_cb, false)
	chat_del_user("channel#id"..matches[2], 'user#id'..bot_id, ok_cb, false)
   end

--------------------------------------------------#plugin manager
  if matches[1] == 'p' and not matches[2] and is_sudo(msg) then
    return list_all_plugins()
  end
  if matches[1] == 'p' and  matches[2] == '+' and is_sudo(msg) then
    local plugin_name = matches[3]
    return enable_plugin(plugin_name)
  end
   if matches[1] == 'p' and  matches[2] == '-' and is_sudo(msg) then
    if matches[3] == 'COREUB' then
    	return 'پلاگین مادر را نمیتوانید غیرفعال کنید.'
    end
    local plugin_name = matches[3]
    return disable_plugin(plugin_name)
  end
  if matches[1] == 'p' and  matches[2] == 'r' and is_admin1(msg) then
    return reload_plugins(true)
  end
        if matches[1] == "gplog" and is_momod(msg) then
                  savelog(msg.to.id, "لوگ گروه درخواست شد توسط "..msg.from.print_name:gsub("_",""))
		   return reply_document(msg.id,"./groups/logs/"..msg.to.id.."log.txt", ok_cb, false)
        end
        if matches[1] == "gpinfo" and is_momod(msg) then
		  if to_chat then
		    return "فقط در سوپرگروه"
		  end
		    savelog(msg.to.id, "اطلاعات گروه درخواست شد توسط "..msg.from.print_name:gsub("_",""))
			channel_info(receiver, callback_info, {receiver = receiver, msg = msg})
		end
		if matches[1] == "admins" and is_momod(msg) then
		   if to_chat then
		    return "فقط در سوپرگروه"
		  end
		    savelog(msg.to.id, "لیست ادمینهای گروه درخواست شد توسط "..msg.from.print_name:gsub("_",""))
			member_type = 'ادمین های'
			return channel_get_admins(receiver, callback, {receiver = receiver, msg = msg, member_type = member_type})
		end
		--[[if matches[1] == "owner" then
			local group_owner = data[tostring(msg.to.id)]['set_owner']
			if not group_owner then
	        for v,user in pairs(config.sudo_users) do
                send_msg("user#id"..user, "سوپر گروه اونر ندارد |"..msg.to.id, ok_cb, false)
            end
				return "صاحب اصلی برای این گروه انتخاب نشده است با پشتیبانی ربات تماس بگیرید"
			end
			return "صاحب اصلی گروه [ "..group_owner..' ] است'
		end]]

		if matches[1] == "owner" then
		    local group_owner = data[tostring(msg.to.id)]['set_owner']
			if not group_owner then

	        for v,user in pairs(config.sudo_users) do
                send_msg("user#id"..user, "سوپر گروه اونر ندارد |"..msg.to.id, ok_cb, false)
            end
				return "صاحب اصلی برای این گروه انتخاب نشده است با پشتیبانی ربات تماس بگیرید"
			end
	    local function owner_info(extra, success, result)
		if success == 0 then
		return reply_msg(extra.msg.id, "test", ok_cb, false)
		end
		 if result.username then
			names = "@"..result.username
		else
			names = string.gsub(result.print_name, '_', ' ')
		end
		
		 local text = "صاحب گروه "..names
		 return reply_msg(extra.msg.id, text, ok_cb, false)
          end
		        savelog(msg.to.id, "صاحبا اصلی گروه درخواست شد توسط "..msg.from.print_name:gsub("_",""))
		 return user_info("user#id"..group_owner, owner_info, {chat_id = chat_id, msg = msg})
		end
		if matches[1] == "modlist" then
		    savelog(msg.to.id, "لیست مدیران گروه درخواست شد توسط "..msg.from.print_name:gsub("_",""))
			return modlist(msg)
		end

		if matches[1] == "mutelist" and is_momod(msg) then
		    savelog(msg.to.id, "لیست افراد نامجاز از چت گروه درخواست شد توسط "..msg.from.print_name:gsub("_",""))
			return muted_user_list(chat_id)
		end

		if matches[1] == "owners" or matches[1] == "ownerlist" then
		    savelog(msg.to.id, "صاحبان گروه درخواست شد توسط "..msg.from.print_name:gsub("_",""))
			return ownerlist(msg)
		end

		if matches[1] == "bots" and is_momod(msg) then
		   if to_chat then
		    return chat_info(receiver, gp_bots, {receiver = receiver, msg = msg})
		  end
		    savelog(msg.to.id, "لیست رباتهای گروه درخواست شد توسط "..msg.from.print_name:gsub("_",""))
			member_type = 'رباتها'
			return channel_get_bots(receiver, callback, {receiver = receiver, msg = msg, member_type = member_type})
		end

		if matches[1] == "who" and not matches[2] and is_momod(msg) then
		   if to_chat then
		    return chat_info(receiver, callback_who2, {receiver = receiver, msg = msg})
		   end
		    savelog(msg.to.id, "لیست کاربران گروه درخواست شد توسط "..msg.from.print_name:gsub("_",""))
			return channel_get_users(receiver, callback_who, {receiver = receiver, msg = msg})
		end

		if matches[1] == "kicked" and is_momod(msg) then
		   if to_chat then
		    return "فقط در سوپرگروه"
		  end
			return channel_get_kicked(receiver, callback_kicked, {receiver = receiver, msg = msg})
		end
		if matches[1] == 'del' and is_momod(msg) then
		if to_chat then
		    return "فقط در سوپرگروه"
		  end
			if type(msg.reply_id) ~= "nil" then
				local function del_reply(extra , success, result)
                      delete_msg(result.id, ok_cb, false)
                end
				delete_msg(msg.id, ok_cb, false)
				return get_message(msg.reply_id, del_reply, false)
			end
		end
     if matches[1] == 'newlink' and is_momod(msg)then
			local function callback_link(extra , success, result)
				if success == 0 then
					reply_msg(extra.msg.id, 'خطا\nمن سازنده این گروه نیستم\n با setlink لینک رو ثبت کن!', ok_cb, false)
				else
					send_large_msg(receiver, "لینک جدید ساخته شد")
					data[tostring(msg.to.id)]['settings']['set_link'] = result
					save_data(config.moderation.data, data)
				end
			end
			if to_super then
			return export_channel_link(receiver, callback_link, {msg=msg})
			else
			return export_chat_link(receiver, callback_link, true)
			end
			savelog(msg.to.id, "لینک جدید گروه درخواست شد توسط "..msg.from.print_name:gsub("_",""))
		end
		if matches[1] == 'link' and is_momod(msg) then
			local group_link = data[tostring(msg.to.id)]['settings']['set_link']
			if group_link == 'waiting' then
			    return reply_msg(msg.id, 'شما قبلا درخواست setlink داده ایید\nلطفا متن دارای لینک گروه خود را ارسال کنید', ok_cb, false)
		    end
			if not group_link then
				return reply_msg(msg.id, "خطا\nلینکی ثبت نشده است ، با /setlink یا /newlink لینک جدیدو بگیر یا ثبت کن", ok_cb, false)
			end
			savelog(msg.to.id, "لینک گروه درخواست شد توسط "..msg.from.print_name:gsub("_",""))
			local text = "لینک گروه "..msg.to.title.." :\n"..group_link
			return reply_msg(msg.id, text, ok_cb, false)
		end
--------------------------------------------------#setadmin
if matches[1] == 'setadmin' and is_owner1(msg) then
       if to_chat then
		    return "فقط در سوپرگروه"
	   end
    if type(msg.reply_id)~="nil" then
	   local function setadmin_reply(extra , success, result)
	      if success == 0 then
			return reply_msg(extra.msg.reply_id, "من سازنده گروه نیستم", ok_cb, false)
		  end
		  if not result.from.username then
		  names = result.from.print_name:gsub("_", " ")
		  else
		  names = "@"..result.from.username
		  end
		  local user_id = result.from.peer_id
		  local chat_id = result.to.peer_id
          channel_set_admin("channel#id"..chat_id, "user#id"..user_id, admin_chack, false)
          local text = names.." [ "..result.from.peer_id.." ] ادمین گروه شد"
          return reply_msg(extra.msg.reply_id, text, ok_cb, false)
        end
         return get_message(msg.reply_id, setadmin_reply, {msg = msg})
    elseif matches[1] == 'setadmin' and matches[2] and string.match(matches[2], '^%d+$') then
         channel_set_admin("channel#id"..chat_id, "user#id"..matches[2], ok_cb, false)
		 return '[ '..matches[2]..' ] ادمین گروه شد'
     elseif matches[1] == 'setadmin' and matches[2] and not string.match(matches[2], '^%d+$') then
		 local function setadmin_username(extra , success, result)
		 if success == 0 then
		return false
	  end
		 local names = "@"..result.username
		 local user_id = result.peer_id
		 channel_set_admin("channel#id"..extra.chat_id, "user#id"..user_id, ok_cb, false)
         local text = names.." ادمین گروه شد"
         return reply_msg(extra.msg.id, text, ok_cb, false)
         end
         local username = string.gsub(matches[2], '@', '')
	 	 return resolve_username(username, setadmin_username, {msg = msg, chat_id = chat_id})
     end
  end
--------------------------------------------------#setadmin
if matches[1] == 'demoteadmin' and is_owner1(msg) then
       if to_chat then
		    return "فقط در سوپرگروه"
	   end
    if type(msg.reply_id)~="nil" then
	   local function demoteadmin_reply(extra , success, result)
	      if success == 0 then
			return reply_msg(extra.msg.reply_id, "من سازنده گروه نیستم", ok_cb, false)
		  end
		  if not result.from.username then
		  names = result.from.print_name:gsub("_", " ")
		  else
		  names = "@"..result.from.username
		  end
		  local user_id = result.from.peer_id
		  local chat_id = result.to.peer_id
          channel_demote("channel#id"..chat_id, "user#id"..user_id, ok_cb, false)
          local text = names.." [ "..result.from.peer_id.." ] از ادمینی گروه خارج شد"
          return reply_msg(extra.msg.reply_id, text, ok_cb, false)
        end
          msgr = get_message(msg.reply_id, demoteadmin_reply, {msg = msg})
    elseif matches[1] == 'demoteadmin' and matches[2] and string.match(matches[2], '^%d+$') then
         channel_set_admin("channel#id"..chat_id, "user#id"..matches[2], ok_cb, false)
		 send_large_msg(receiver, '[ '..matches[2]..' ] از ادمینی گروه خارج شد')
     elseif matches[1] == 'demoteadmin' and matches[2] and not string.match(matches[2], '^%d+$') then
		 local function demoteadmin_username(extra , success, result)
		 if success == 0 then
		return false
	  end
		 local names = "@"..result.username
		 local user_id = result.peer_id
		 channel_demote("channel#id"..extra.chat_id, "user#id"..user_id, ok_cb, false)
         local text = names.." از ادمینی گروه خارج شد"
         return reply_msg(extra.msg.id, text, ok_cb, false)
         end
         local username = string.gsub(matches[2], '@', '')
	 	 return resolve_username(username, demoteadmin_username, {msg = msg, chat_id = chat_id})
     end
  end
--------------------------------------------------#setowner
if matches[1] == 'setowner' and is_owner1(msg) then 
        if type(msg.reply_id) ~= "nil" then
		 local function setowner_reply(extra , success, result)
		  if not result.from.username then
		  names = result.from.print_name:gsub("_", " ")
		  else
		  names = "@"..result.from.username
		  end

          data[tostring(result.to.peer_id)]['set_owner'] = tostring(result.from.peer_id) 
          save_data(config.moderation.data, data)
          local text = names.." [ "..result.from.peer_id.." ] از این به بعد صاحب اصلی گروه هستند\nلطفا help را وارد کنید"
          return reply_msg(extra.msg.reply_id, text, ok_cb, false)
        end
		  return get_message(msg.reply_id, setowner_reply, {msg = msg})
	elseif matches[1] == 'setowner' and matches[2] and string.match(matches[2], '^%d+$') then
			data[tostring(msg.to.id)]['set_owner'] = tostring(matches[2])
			save_data(config.moderation.data, data)
			local text = "[ "..matches[2].." ] از این به بعد صاحب اصلی گروه هستند"
			return text
   elseif matches[1] == 'setowner' and matches[2] and not string.match(matches[2], '^%d+$') then
        local function setowner_username(extra , success, result)
		if success == 0 then
		return false
	  end

          data[tostring(extra.chat_id)]['set_owner'] = tostring(result.peer_id)
          save_data(config.moderation.data, data)
          local text = "@"..result.username.." [ "..result.peer_id.." ] از این به بعد صاحب اصلی گروه هستند\nلطفا help را وارد کند"
          return reply_msg(extra.msg.id, text, ok_cb, false)
        end
				local username = string.gsub(matches[2], '@', '')
		 return resolve_username(username, setowner_username, {chat_id = chat_id, msg = msg})
			end
		end
--------------------------------------------------#setowners
if matches[1] == 'setowners' and is_owner1(msg) then 
		local group_owner = data[tostring(msg.to.id)]['set_owner']
			if not group_owner then
				return "صاحب اصلی برای این گروه انتخاب نشده است با پشتیبانی ربات تماس بگیرید"
			end
          if type(msg.reply_id) ~= "nil" then
		  local function setowners_reply(extra , success, result)

		  if not result.from.username then
		  names = result.from.print_name:gsub("_", " ")
		  else
		  names = "@"..result.from.username
		  end
		  local user_id = result.from.peer_id
		  if data[tostring(extra.chat_id)]['owners'][tostring(user_id)] then
		  return send_large_msg(receiver, names..' جزء صاحبان گروه است')
		  end
          data[tostring(extra.chat_id)]['owners'][tostring(user_id)] = names
          save_data(config.moderation.data, data)
          local text = names.." [ "..result.from.peer_id.." ] جزء صاحبان گروه گردید\nلطفا help را وارد کنید"
          return reply_msg(extra.msg.reply_id, text, ok_cb, false)
        end
		 return get_message(msg.reply_id, setowners_reply, {chat_id = chat_id, msg = msg})
   elseif matches[1] == 'setowners' and matches[2] and string.match(matches[2], '^%d+$') then
		 function setowners_id(extra, success, result)
		 local user_id = result.peer_id
		 if result.username then
			names = "@"..result.username
		 else
			names = string.gsub(result.print_name, '_', ' ')
		 end

		if data[tostring(extra.chat_id)]['owners'][tostring(user_id)] then
        return send_large_msg(receiver, names..'  جزء صاحبان گروه است')
        end
		 data[tostring(extra.chat_id)]['owners'][tostring(user_id)] = names
		 save_data(config.moderation.data, data)
		 local text = names.." [ "..user_id.." ] جزء صاحبان گروه گردید"
		 return reply_msg(extra.msg.id, text, ok_cb, false)
		 end
		 local user_id = "user#id"..matches[2]
		 return user_info(user_id, setowners_id, {chat_id = chat_id, msg = msg})
		 elseif matches[1] == 'setowners' and matches[2] and not string.match(matches[2], '^%d+$') then
               function setowners_username(extra , success, result)
	  if success == 0 then
		return false
	  end

		  local user_id = result.peer_id
		  if data[tostring(extra.chat_id)]['owners'][tostring(user_id)] then
          return reply_msg(extra.msg.id, "@"..result.username..' جزء صاحبان گروه است', ok_cb, false)
          end
		  data[tostring(extra.chat_id)]['owners'][tostring(user_id)] = "@"..result.username
		  save_data(config.moderation.data, data)
          local text = "@"..result.username.." [ "..result.peer_id.." ] جزء صاحبان گروه گردید\nلطفا help را وارد کند"
          return reply_msg(extra.msg.id, text, ok_cb, false)
        end
				local username = string.gsub(matches[2], '@', '')
		  return resolve_username(username, setowners_username, {chat_id = chat_id, msg = msg})
			end
		end
--------------------------------------------------#remowners
if matches[1] == 'remowners' and is_owner1(msg) then 
        if type(msg.reply_id) ~= "nil" then
		 local function remowners_reply(extra , success, result)

		  if not result.from.username then
		  names = result.from.print_name:gsub("_", " ")
		  else
		  names = "@"..result.from.username
		  end
          local name_log = msg.from.print_name:gsub("_", " ")
		  local user_id = result.from.peer_id
          if not data[tostring(extra.chat_id)]['owners'][tostring(user_id)] then
          return reply_msg(extra.msg.id, names..' در لیست صاحبان گروه نیست', ok_cb, false)
          end
          data[tostring(extra.chat_id)]['owners'][tostring(user_id)] = nil
          save_data(config.moderation.data, data)
          local text = names.." [ "..result.from.peer_id.." ] از سمت صاحب گروه تنزل یافت"
          return reply_msg(extra.msg.reply_id, text, ok_cb, false)
        end
		  return get_message(msg.reply_id, remowners_reply, {chat_id = chat_id, msg = msg})
		 elseif matches[1] == 'remowners' and matches[2] and string.match(matches[2], '^%d+$') then
		 local function remowners_id(extra, success, result)
		 local user_id = result.peer_id
		 if result.username then
			names = "@"..result.username
		else
			names = string.gsub(result.print_name, '_', ' ')
		end
		if not data[tostring(extra.chat_id)]['owners'][tostring(user_id)] then
        return send_large_msg(receiver, names..' در لیست صاحبان گروه نیست')
        end
		 data[tostring(extra.chat_id)]['owners'][tostring(user_id)] = nil
		 save_data(config.moderation.data, data)
		 local text = names.." [ "..user_id.." ] از سمت صاحب گروه تنزل یافت"
		 return reply_msg(extra.msg.id, text, ok_cb, false)
		 end
		 local user_id = "user#id"..matches[2]
		 return user_info(user_id, remowners_id, {chat_id = chat_id, msg = msg})
         elseif matches[1] == 'remowners' and matches[2] and not string.match(matches[2], '^%d+$') then
         local function remowners_username(extra , success, result)
		 if success == 0 then
		return false
	  end
		  local user_id = result.peer_id
		  if not data[tostring(extra.chat_id)]['owners'][tostring(user_id)] then
          return reply_msg(extra.msg.id, "@"..result.username..' در لیست صاحبان گروه نیست', ok_cb, false)
          end
		  data[tostring(extra.chat_id)]['owners'][tostring(user_id)] = nil
		  save_data(config.moderation.data, data)
          local text = "@"..result.username.." [ "..result.peer_id.." ] از سمت صاحب گروه تنزل یافت"
          return reply_msg(extra.msg.id, text, ok_cb, false)
        end
				local username = string.gsub(matches[2], '@', '')
		  return resolve_username(username, remowners_username, {chat_id = chat_id, msg = msg})
			end
		end
--------------------------------------------------#promote
if matches[1] == 'promote' and is_owner(msg) then 
        if type(msg.reply_id) ~= "nil" then
		 local function promote_reply(extra , success, result)

          local group = tostring(extra.chat_id)
		  if not result.from.username then
		  names = result.from.print_name:gsub("_", " ")
		  else
		  names = "@"..result.from.username
		  end
          local name_log = msg.from.print_name:gsub("_", " ")
		  local user_id = result.from.peer_id
		  if data[group]['moderators'][tostring(user_id)] then
		  return send_large_msg(receiver, names..' مدیر است')
		  end
          data[group]['moderators'][tostring(user_id)] = names
          save_data(config.moderation.data, data)
          local text = names.." [ "..result.from.peer_id.." ] مدیر شد\nلطفا help را وارد کنید"
          return reply_msg(extra.msg.reply_id, text, ok_cb, false)
        end
          return get_message(msg.reply_id, promote_reply, {chat_id = chat_id, msg = msg})
		 elseif matches[1] == 'promote' and matches[2] and string.match(matches[2], '^%d+$') then
		 local function promote_id(extra, success, result)
		 local user_id = result.peer_id
		 if result.username then
			names = "@"..result.username
		else
			names = string.gsub(result.print_name, '_', ' ')
		end

        local group = tostring(extra.chat_id)
		if data[group]['moderators'][tostring(user_id)] then
        return send_large_msg(receiver, names..'  مدیر است ')
        end
		 data[group]['moderators'][tostring(user_id)] = names
		 save_data(config.moderation.data, data)
		 local text = names.." [ "..user_id.." ] مدیر شد"
		 return reply_msg(extra.msg.id, text, ok_cb, false)
		 end
		 local user_id = "user#id"..matches[2]
		 return user_info(user_id, promote_id, {chat_id = chat_id,msg = msg})
		 elseif matches[1] == 'promote' and matches[2] and not string.match(matches[2], '^%d+$') then
         local function promote_username(extra , success, result)
		 if success == 0 then
		return false
	  end
         local group = tostring(extra.chat_id)

		  local user_id = result.peer_id
		  if data[group]['moderators'][tostring(user_id)] then
          return reply_msg(extra.msg.id, "@"..result.username..' مدیر است', ok_cb, false)
          end
		  data[group]['moderators'][tostring(user_id)] = "@"..result.username
		  save_data(config.moderation.data, data)
          local text = "@"..result.username.." [ "..result.peer_id.." ] مدیر شد\nلطفا help را وارد کند"
          return reply_msg(extra.msg.id, text, ok_cb, false)
        end
				local username = string.gsub(matches[2], '@', '')
		   return resolve_username(username, promote_username, {chat_id = chat_id, msg = msg})
			end
		end
--------------------------------------------------#demote
if matches[1] == 'demote' and is_owner(msg) then 
        if type(msg.reply_id) ~= "nil" then
		 local function demote_reply(extra , success, result)

          local group = tostring(extra.chat_id)
		  if not result.from.username then
		  names = result.from.print_name:gsub("_", " ")
		  else
		  names = "@"..result.from.username
		  end
          local name_log = msg.from.print_name:gsub("_", " ")
		  local user_id = result.from.peer_id
          if not data[group]['moderators'][tostring(user_id)] then
          return reply_msg(extra.msg.id, names..' مدیر نیست', ok_cb, false)
          end
          data[group]['moderators'][tostring(user_id)] = nil
          save_data(config.moderation.data, data)
          local text = names.." [ "..result.from.peer_id.." ] از مدیریت بر کنار شد"
          return reply_msg(extra.msg.reply_id, text, ok_cb, false)
        end
		  return get_message(msg.reply_id, demote_reply, {chat_id = chat_id, msg = msg})
		 elseif matches[1] == 'demote' and matches[2] and string.match(matches[2], '^%d+$') then
		 local function demote_id(extra, success, result)
		 local user_id = result.peer_id
		 if result.username then
			names = "@"..result.username
     	 else
			names = string.gsub(result.print_name, '_', ' ')
		 end

        local group = tostring(extra.chat_id)
		if not data[group]['moderators'][tostring(user_id)] then
        return send_large_msg(receiver, names..' مدیر نیست ')
        end
		 data[group]['moderators'][tostring(user_id)] = nil
		 save_data(config.moderation.data, data)
		 local text = names.." [ "..user_id.." ] از مقام خود تنزل یافت"
		 return reply_msg(extra.msg.id, text, ok_cb, false)
		 end
		 local user_id = "user#id"..matches[2]
		 return user_info(user_id, demote_id, {chat_id = chat_id, msg = msg})
         elseif matches[1] == 'demote' and matches[2] and not string.match(matches[2], '^%d+$') then
         local function demote_username(extra , success, result)
		 if success == 0 then
		return false
	  end
         local group = tostring(extra.chat_id)

		  local user_id = result.peer_id
		  if not data[group]['moderators'][tostring(user_id)] then
          return reply_msg(extra.msg.id, "@"..result.username..' مدیر نیست', ok_cb, false)
          end
		  data[group]['moderators'][tostring(user_id)] = nil
		  save_data(config.moderation.data, data)
          local text = "@"..result.username.." [ "..result.peer_id.." ] از مدیریت بر کنار شد"
          return reply_msg(extra.msg.id, text, ok_cb, false)
        end
		  local username = string.gsub(matches[2], '@', '')
		  return resolve_username(username, demote_username, {chat_id = chat_id, msg = msg})
			end
		end
--------------------------------------------------#mutealluser
if matches[1] == 'muteall' and is_admin1(msg)  then
    if type(msg.reply_id)~="nil" then
      local function muteall_reply(extra , success, result)
		  if not result.from.username then
		  names = result.from.print_name:gsub("_", " ")
		  else
		  names = "@"..result.from.username
		  end
		  local user_id = result.from.peer_id
		  local group_id = result.to.peer_id
		  if is_momod2(user_id, group_id) then
		  return reply_msg(extra.msg.id, names.." ایشان داری مقام است", ok_cb, false)
		  end
		  if is_muteall_user(user_id) then
		  return reply_msg(extra.msg.reply_id, names..' از چت در گروه های یوبی محروم است', ok_cb, false)
		  end
          muteall_user(user_id)
          local text = names.." [ "..result.from.peer_id.." ] از چت در گروه های یوبی محروم شد"
          return reply_msg(extra.msg.reply_id, text, ok_cb, false)
        end
          return get_message(msg.reply_id, muteall_reply, {msg = msg})
    elseif matches[1] == 'muteall' and matches[2] and string.match(matches[2], '^%d+$') then
        if tonumber(matches[2]) == tonumber(our_id) then
         	return
        end
        if not is_admin1(msg) and is_momod(msg) then
          	return "ایشان ادمین یا مدیر گروه است."
        end
        if tonumber(matches[2]) == tonumber(msg.from.id) then
          	return
        end
		if is_muteall_user(matches[2]) then
		  return reply_msg(msg.id, matches[2]..' از چت در گروه های یوبی محروم است', ok_cb, false)
		  end
        muteall_user(matches[2])
		return '[ '..matches[2]..' ] از چت در  گروه های یوبی محروم شد'
      elseif matches[1] == 'muteall' and matches[2] and not string.match(matches[2], '^%d+$') then
		 local function muteall_username(extra , success, result)
		 if success == 0 then
		return false
	  end
		 local names = "@"..result.username
		 local user_id = result.peer_id
		  if is_momod2(user_id, extra.chat_id) then
		  return reply_msg(extra.msg.id, names.." ایشان داری مقام است", ok_cb, false)
		  end
		  if is_muteall_user(user_id) then
		  return reply_msg(extra.msg.id, names..' از چت در گروه های یوبی محروم است', ok_cb, false)
		  end
		 muteall_user(user_id)
         local text = names.." از چت در گروه های یوبی محروم شد"
         return reply_msg(extra.msg.id, text, ok_cb, false)
        end

		local username = string.gsub(matches[2], '@', '')
		return resolve_username(username, muteall_username, {msg = msg, chat_id = chat_id})
    end
  end
--------------------------------------------------#unmutealluser
 if matches[1] == 'unmuteall' and is_admin1(msg)  then
    if type(msg.reply_id)~="nil" then
      local function unmuteall_reply(extra , success, result)
		  if not result.from.username then
		  names = result.from.print_name:gsub("_", " ")
		  else
		  names = "@"..result.from.username
		  end
		  local user_id = result.from.peer_id
		  local group_id = result.to.peer_id
		  if is_momod2(user_id, group_id) then
		  return reply_msg(extra.msg.id, names.." ایشان داری مقام است", ok_cb, false)
		  end
		  if not is_muteall_user(user_id) then
		  return reply_msg(extra.msg.reply_id, names..' از چت در گروه های یوبی محروم نیست', ok_cb, false)
		  end
          unmuteall_user(user_id)
          local text = names.." [ "..result.from.peer_id.." ] از چت در گروه های یوبی رفع محرومیت شد"
          return reply_msg(extra.msg.reply_id, text, ok_cb, false)
        end
          return get_message(msg.reply_id, unmuteall_reply, {msg = msg})
    elseif matches[1] == 'unmuteall' and matches[2] and string.match(matches[2], '^%d+$') then
        if tonumber(matches[2]) == tonumber(our_id) then
         	return
        end
        if not is_admin1(msg) and is_momod(msg) then
          	return "ایشان ادمین یا مدیر گروه است."
        end
        if tonumber(matches[2]) == tonumber(msg.from.id) then
          	return
        end
		if not is_muteall_user(matches[2]) then
		  return reply_msg(msg.id, matches[2]..' از چت در گروه های یوبی محروم است', ok_cb, false)
		  end
        unmuteall_user(matches[2])
		return '[ '..matches[2]..' ] از چت در گروه های یوبی رفع محرومیت شد'
      elseif matches[1] == 'unmuteall' and matches[2] and not string.match(matches[2], '^%d+$') then
		 local function unmuteall_username(extra , success, result)
		 if success == 0 then
		return false
	  end
		 local names = "@"..result.username
		 local user_id = result.peer_id
		  if is_momod2(user_id, extra.chat_id) then
		  return reply_msg(extra.msg.id, names.." ایشان داری مقام است", ok_cb, false)
		  end
		  if not is_muteall_user(user_id) then
		  return reply_msg(extra.msg.id, names..' از چت در گروه های یوبی محروم نیست', ok_cb, false)
		  end
		 unmuteall_user(user_id)
         local text = names.." از چت در گروه های یوبی رفع محرومیت شد."
         return reply_msg(extra.msg.id, text, ok_cb, false)
        end

		local username = string.gsub(matches[2], '@', '')
		resolve_username(username, unmuteall_username, {msg = msg, chat_id = chat_id})
    end
  end
--------------------------------------------------#setname
if matches[1] == "setname" and is_momod(msg) then
local hash = 'setname:'..msg.to.id
      local enable = redis:get(hash)
      if enable and not is_admin1(msg) then
      return "مجاز نیستید"
      end
	  if msg.text:gsub("setname", "") == msg.to.print_name:gsub("_", " ") then
	  return "اسم تکراری مجاز نیست"
	  end
         if to_super then 
			local set_name = string.gsub(msg.text:gsub("[Ss][Ee][Tt][Nn][Aa][Mm][Ee]", " "), '_', '')
			redis:setex(hash, 3600, true)
			savelog(msg.to.id, "اسم گروه عوض شد توسط "..msg.from.print_name:gsub("_"," "))
			return rename_channel(receiver, set_name, ok_cb, false)
		 elseif to_chat then
			local set_name = string.gsub(msg.text:gsub("[Ss][Ee][Tt][Nn][Aa][Mm][Ee]", " "), '_', '')
			redis:setex(hash, 3600, true)
			savelog(msg.to.id, "اسم گروه عوض شد توسط "..msg.from.print_name:gsub("_"," "))
			return rename_chat(receiver, set_name, ok_cb, false)
         end
		
end

--------------------------------------------------#setphoto
if matches[1] == 'setphoto' and is_momod(msg) then
   local setphoto = "setphoto:"..msg.to.id
   local setphoto2 = redis:get(setphoto)
   if setphoto2 then
   return " مجاز به عوض کردن عکس در 1 ساعت 2 بار نیستید"
   end
   redis:setex(setphoto, 3600, true)
   data[tostring(msg.to.id)]['settings']['set_photo'] = 'waiting'
   save_data(config.moderation.data, data)
   savelog(msg.to.id, "عکس گروه عوض شد توسط "..msg.from.print_name:gsub("_",""))
   return 'عکس مورد نظر خود را ارسال کنید'
end
--------------------------------------------------#clean center
if matches[1] == 'clean' and is_momod(msg) then
			if matches[2] == 'modlist' then
			    if not is_owner(msg) then
				       return "برای اجرای این دستور به مقام صاحب گروه(اونر) نیاز است"
			    end
				if next(data[tostring(msg.to.id)]['moderators']) == nil then
					return 'لیستی تشکیل نشده است'
				end
				for k,v in pairs(data[tostring(msg.to.id)]['moderators']) do
					data[tostring(msg.to.id)]['moderators'][tostring(k)] = nil
					save_data(config.moderation.data, data)
				end
				savelog(msg.to.id, "لیست مدیران گروه پاک شد توسط "..msg.from.print_name:gsub("_",""))
				return 'لیست مدیران گروه خالی شد'
			end
			if matches[2] == 'rules' then
				local data_cat = 'rules'
				if data[tostring(msg.to.id)][data_cat] == nil then
					return "ثوانینی تنظیم نگردیده است"
				end
				data[tostring(msg.to.id)][data_cat] = nil
				save_data(config.moderation.data, data)
				savelog(msg.to.id, "قوانین گروه پاک شد توسط "..msg.from.print_name:gsub("_",""))
				return 'قوانین گروه گروه پاک شد'
			end
			if matches[2] == 'about' then
				local about_text = ' '
				local data_cat = 'description'
				if data[tostring(msg.to.id)][data_cat] == nil then
					return 'توضیحی تنظیم نشده است'
				end
				data[tostring(msg.to.id)][data_cat] = nil
				save_data(config.moderation.data, data)
				channel_set_about(receiver, about_text, ok_cb, false)
				savelog(msg.to.id, "توضیحات گروه پاک شد توسط "..msg.from.print_name:gsub("_",""))
				return "توضیحات گروه پاک شد"
			end
			if matches[2] == 'mutelist' then
			if to_chat then
				return "مجاز برای سوپرگروه ها"
			end
			if not is_owner(msg) then
				return "برای اجرای این دستور به مقام صاحب گروه(اونر) نیاز است"
			end
				local hash =  'mute_user:'..chat_id
				redis:del(hash)
				savelog(msg.to.id, "لیست افراد غیر مجاز در چت گروه پاک شد توسط "..msg.from.print_name:gsub("_",""))
				return "لیست افراد غیر مجاز در چت خالی شد"
			end

			if matches[2] == 'ownerlist' then
			if not is_owner1(msg) then
				return "برای اجرای این دستور به مقام صاحب اصلی گروه(اونر اصلی) نیاز است "
			end
				if next(data[tostring(msg.to.id)]['owners']) == nil then
					return 'لیستی تشکیل نشده است'
				end
				for k,v in pairs(data[tostring(msg.to.id)]['owners']) do
					data[tostring(msg.to.id)]['owners'][tostring(k)] = nil
					return save_data(config.moderation.data, data)
				end
				savelog(msg.to.id, "لیست صاحبان گروه پاک شد توسط "..msg.from.print_name:gsub("_",""))
				return 'لیست صاحبان گروه خالی شد'
			end

			if matches[2] == "bots" then
                if to_super then
				savelog(msg.to.id, "رباتهای گروه پاک شدند توسط "..msg.from.print_name:gsub("_",""))
				channel_get_bots(receiver, clean_bots1, {msg = msg})
				elseif to_chat then
				savelog(msg.to.id, "رباتهای گروه پاک شدند توسط "..msg.from.print_name:gsub("_",""))
				chat_info(receiver, clean_bots2, {receiver = receiver, msg = msg, chat_id = chat_id})
				end
			end

			if matches[2] == "deleted" then
				if to_super then
				savelog(msg.to.id, "افراد دیلیت اکانت گروه پاک شدند توسط "..msg.from.print_name:gsub("_",""))
                channel_get_users(receiver, super_deleted,{receiver = receiver, msg = msg})
				elseif to_chat then
				savelog(msg.to.id, "افراد دیلیت اکانت گروه پاک شدند توسط "..msg.from.print_name:gsub("_",""))
				chat_info(receiver, group_deleted, {receiver = receiver, msg = msg, chat_id = chat_id})
			 end
		   end
		   if matches[2] == "kicked" then
		   if not to_super then
				return "مجاز برای سوپرگروه ها"
			end
               channel_get_kicked(receiver, super_kicked,{chat_id = chat_id, msg = msg})
		   end
			if matches[2] == 'filterlist' and is_momod(msg) then
             local asd = '1'
			 savelog(msg.to.id, "فیلتر لیست گروه پاک شد توسط "..msg.from.print_name:gsub("_",""))
             return clear_commandbad(msg, asd)
			end
		--------------------------------------------------#clean lists
            if matches[2] == "banlist" and is_owner(msg)  then
               local hash = 'banned:'..chat_id
			   if redis:scard(hash) == 0 then
			   return send_large_msg(receiver, "لیست افراد بن شده خالی است")
			   end
               redis:del(hash)
			   savelog(msg.to.id, "لیست افراد محروم از گروه درخواست شد توسط "..msg.from.print_name:gsub("_",""))
               send_large_msg(receiver, "لیست افراد بن شده خالی شد")
			end
            if matches[2] == "gbanlist" and is_sudo(msg) then
               local hash = 'gbanned'
			   if redis:scard(hash) == 0 then
			   return send_large_msg(receiver, "لیست افراد بن ال شده خالی است")
			   end
               redis:del(hash)
               send_large_msg(receiver, "لیست افراد بن ال شده در یوبی خالی شد")
			end
            if matches[2] == "gmutelist" and is_sudo(msg) then
               local hash = 'muteall_user'
			   if redis:scard(hash) == 0 then
			   return send_large_msg(receiver, "لیست افراد محروم از چت در گروه های یوبی خالی است")
			   end
               redis:del(hash)
               send_large_msg(receiver, "لیست افراد محروم از چت در گروه های یوبی خالی شد")
            end
	end
--------------------------------------------------#flood set settings
if matches[1] == 'setflood' and is_momod(msg) then
			if tonumber(matches[2]) < 2 or tonumber(matches[2]) > 10 then
				return "عدد انتخابی باید بین 0 تا 10 باشد\nبرای باز کردن کلی ان از دستور unlock flood بهره ببرید"
			end
			data[tostring(msg.to.id)]['settings']['flood_msg_max'] = matches[2]
			save_data(config.moderation.data, data)
			savelog(msg.to.id, "تعداد پیام های گروه به "..matches[2].." تغییر کرد توسط "..msg.from.print_name:gsub("_",""))
			return reply_msg(msg.id, 'تعداد پیام های مکرر به '..matches[2]..' محدود شد', ok_cb, false)
		end
		if matches[1] == 'settimeflood' and is_momod(msg) then
			if tonumber(matches[2]) < 1 or tonumber(matches[2]) > 5 then
				return "عدد انتخابی باید بین 1 تا 5 باشد"
			end
			data[tostring(msg.to.id)]['settings']['flood_time_max'] = matches[2]
			save_data(config.moderation.data, data)
			savelog(msg.to.id, "زمان پیام های گروه به "..matches[2].." تغییر کرد توسط "..msg.from.print_name:gsub("_",""))
			return reply_msg(msg.id, 'زمان تعداد پیام های مکرر '..matches[2]..' محدود شد', ok_cb, false)
end
--------------------------------------------------#public settings
if matches[1] == 'public' and is_momod(msg) then
            if not is_owner1(msg) then
				return "برای اجرای این دستور به مقام صاحب اصلی گروه(اونر اصلی) نیاز است "
			end
			local target = chat_id
			if matches[2] == 'yes' then
				return set_public_membermod(msg, data, target)
			end
			if matches[2] == 'no' then
				return unset_public_membermod(msg, data, target)
			end
end
--------------------------------------------------#muteallgroup
if matches[1] == 'mute' and matches[2] == "all" and is_momod(msg) and matches[3] and not matches[4] then
 if  tonumber(matches[3]) < 1 or tonumber(matches[3]) > 120 then
		return "فقط بین 1 دقیقه تا 120 دقیقه مجاز به میوت همه پیام ها میباشید."
end
    		local hash = 'muteall:'..msg.to.id
			local time = matches[3] * 60
    		redis:setex(hash, tonumber(time), true)
			savelog(msg.to.id, "پاک کننده همه پیام های گروه برای "..matches[3].." دقیقه فعال شد توسط "..msg.from.print_name:gsub("_",""))
            return 'پاک کننده همه پیام ها برای <b>'..matches[3]..'</b> دقیقه فعال گردید'
elseif matches[1] == 'mute' and matches[2] == "all" and is_momod(msg) and matches[3] and matches[4] then
if  tonumber(matches[3]) < 1 or tonumber(matches[3]) > 120 then
		return "فقط بین 1 دقیقه تا 120 دقیقه مجاز به میوت همه پیام ها بصورت ساعتی میباشید"
end
local value = matches[4]
local hash = 'muteall:'..msg.to.id
local time = matches[3] * 60
redis:setex(hash, tonumber(time), true)
savelog(msg.to.id, "پاک کننده همه پیام های گروه برای "..matches[3].." دقیقه فعال شد توسط "..msg.from.print_name:gsub("_",""))
return 'پاک کننده همه پیام ها برای '..matches[3]..' دقیقه فعال گردید'.."\n\nتوضیحات اضافه: "..value
end
if matches[1] == 'stats' and is_momod(msg) then
if matches[2] == "mute all" or matches[2] == "mute" then
local hash = 'muteall:'..msg.to.id
muteall = redis:pttl(hash)
local enable = redis:get(hash)
base = math.floor(muteall / 1000)

if not enable then
return "پاک کننده همه پیام ها غیر فعال است"
elseif enable then
if math.floor(base / 60) == 0 then
min = ""
else 
min = "یا "..math.floor(base / 60).."دقیقه "
end
if math.floor(base / 3600) == 0 then
hor = ""
else
hor = "یا "..math.floor(base / 3600).." ساعت"
end
savelog(msg.to.id, "مدت زمان باقی مانده برای پاک کننده پیام های گروه درخواست شد توسط "..msg.from.print_name:gsub("_",""))
return "پاک کننده همه پیام ها برای "..base.." ثانیه "..min..hor.." فعال است"
end
end
end
if matches[1] == "mute" and matches[2] == "all" and is_momod(msg) then
            local hash = 'muteall:'..msg.to.id
            local time = 18000
            redis:setex(hash, time, true)
			savelog(msg.to.id, "پاک کننده همه پیام های گروه برای 5 ساعت فعال شد توسط "..msg.from.print_name:gsub("_",""))
            return 'پاک کننده همه پیام ها فعال گردید'
end
if matches[1] == 'unmute' and matches[2] == "all" and is_momod(msg) then
    		local hash = 'muteall:'..msg.to.id
    		redis:del(hash)
			savelog(msg.to.id, "پاک کننده همه پیام های گروه غیر فعال شد توسط "..msg.from.print_name:gsub("_",""))
            return "پاک کننده همه پیام ها غیر فعال گردید."
end
--------------------------------------------------#muteusers
if matches[1] == "mute" and is_momod(msg) then
if to_chat then
return "مجاز برای سوپر گروه ها میباشد"
end

if type(msg.reply_id) ~= "nil" then
         function mute_reply(extra , success, result)
		  if not result.from.username then
		  names = result.from.print_name:gsub("_", " ")
		  else
		  names = "@"..result.from.username
		  end
		  local user_id = result.from.peer_id
		  local group_id = result.to.peer_id
		  if is_momod2(user_id, group_id) then
		  return reply_msg(extra.msg.id, names.." ایشان داری مقام است", ok_cb, false)
		  end
		  if is_muted_user(chat_id, user_id) then
		  return reply_msg(extra.msg.reply_id, names.." در لیست افراد غیرمجاز در چت وجود دارد", ok_cb, false)
		  end
          mute_user(chat_id, user_id)
          local text = names.." [ "..result.from.peer_id.." ] به لیست افراد غیرمجاز اضافه شد"
          return reply_msg(extra.msg.reply_id, text, ok_cb, false)
          end
		  return get_message(msg.reply_id, mute_reply, {msg = msg})
elseif matches[1] == "mute" and matches[2] and string.match(matches[2], '^%d+$') then
				    local user_id = matches[2]
					if is_muted_user(chat_id, matches[2]) then
		              return reply_msg(msg.id, matches[2].." در لیست افراد غیرمجاز در چت وجود دارد", ok_cb, false)
		            end
					mute_user(chat_id, user_id)
					return "[ "..user_id.." ] به لیست افراد غیرمجاز اضافه شد"
elseif matches[1] == "mute" and matches[2] and not string.match(matches[2], '^%d+$') then
          if matches[2] == "all" then
		     return false
		  end
          function mute_username(extra , success, result)
		  if success == 0 then
		return false
	  end
		  local chat_id = extra.chat_id
          local user_id = result.peer_id
		  names = "@"..result.username
		  if is_muted_user(chat_id, user_id) then
		  return reply_msg(extra.msg.id, names.." در لیست افراد غیرمجاز در چت وجود دارد", ok_cb, false)
		  end
		  mute_user(chat_id, user_id)
          local text = names.." [ "..result.peer_id.." ] به لیست افراد غیرمجاز اضافه شد"
          return send_large_msg(receiver, text)
          end
		  local username = string.gsub(matches[2], '@', '')
		  return resolve_username(username, mute_username, {chat_id = chat_id,msg = msg})
   end
end
--------------------------------------------------#unmuteusers
if matches[1] == "unmute" and is_momod(msg) then
if to_chat then
return "مجاز برای سوپر گروه ها میباشد"
end
if type(msg.reply_id) ~= "nil" then
         function unmute_reply(extra , success, result)
		  if not result.from.username then
		  names = result.from.print_name:gsub("_", " ")
		  else
		  names = "@"..result.from.username
		  end
		  local user_id = result.from.peer_id
		  if not is_muted_user(extra.chat_id, user_id) then
		  return reply_msg(extra.msg.reply_id, names.." در لیست افراد غیرمجاز در چت وجود ندارد", ok_cb, false)
		  end
          unmute_user(extra.chat_id, user_id)
          local text = names.." [ "..result.from.peer_id.." ] از لیست افراد غیر مجاز خارج شد"
          return reply_msg(extra.msg.reply_id, text, ok_cb, false)
          end
		  return get_message(msg.reply_id, unmute_reply, {msg = msg, chat_id = chat_id})

elseif matches[1] == "unmute"  and matches[2] and string.match(matches[2], '^%d+$') then
		  local user_id = matches[2]
		  if not is_muted_user(chat_id, user_id) then
		  return reply_msg(msg.id, matches[2].." در لیست افراد غیرمجاز در چت وجود ندارد", ok_cb, false)
		  end
			unmute_user(chat_id, user_id)
		    return "[ "..user_id.." ] از لیست افراد غیر مجاز خارج شد"
elseif matches[1] == "unmute" and matches[2] and not string.match(matches[2], '^%d+$') then
          if matches[2] == "all" then
		     return false
		  end
        function unmute_username(extra , success, result)
		if success == 0 then
		return false
	  end
          local user_id = result.peer_id
		  names = "@"..result.username
		  if not is_muted_user(extra.chat_id, user_id) then
		  return reply_msg(extra.msg.id, names.." در لیست افراد غیرمجاز در چت وجود ندارد", ok_cb, false)
		  end
		  unmute_user(chat_id, user_id)
          local text = names.." [ "..result.peer_id.." ] از لیست افراد غیر مجاز خارج شد"
          return send_large_msg(receiver, text)
        end
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
		 return resolve_username(username, unmute_username, {msg = msg, chat_id = chat_id})
			end
end
--------------------------------------------------#settings
if matches[1] == 'settings' and not matches[2] and is_momod(msg) then
savelog(msg.to.id, "تنظیمات گروه درخواست شد توسط "..msg.from.print_name:gsub("_",""))
   return reply_msg(msg.id, show_supergroup_settingsmod(msg, chat_id), ok_cb, false)
end
--------------------------------------------------#rules and about
--------------------------------------------------#setabout
if matches[1] == "setabout" and is_momod(msg) then
		if to_chat then
			local about_text = msg.text:gsub("setabout", "")
			local data_cat = 'description'
			data[tostring(chat_id)][data_cat] = about_text
			save_data(config.moderation.data, data)
			savelog(msg.to.id, "توضیحات گروه عوض شد توسط "..msg.from.print_name:gsub("_",""))
			return "توضیحات برای "..msg.to.title.." تغییر کرد\nبرای مشاهده ان /about را تایپ کنید"
		end
		if to_super then
	     	local about_text = matches[2]
			local data_cat = 'description'
			data[tostring(chat_id)][data_cat] = about_text
			save_data(config.moderation.data, data)
			channel_set_about(receiver, about_text, admin_chack, false)
			savelog(msg.to.id, "توضیحات گروه عوض شد توسط "..msg.from.print_name:gsub("_",""))
			return "توضیحات برای "..msg.to.title.." تغییر کرد\nبرای مشاهده ان به پروفایل گروه نگاه کنید"
		end
end
--------------------------------------------------#setrules
if matches[1] == "setrules" and is_momod(msg) then
			local rules_text = msg.text:gsub("[Ss][Ee][Tt][Rr][Uu][Ll][Ee][Ss]", "")
			local data_cat = 'rules'
			data[tostring(chat_id)][data_cat] = rules_text
			save_data(config.moderation.data, data)
			savelog(msg.to.id, "قوانین گروه عوض شد توسط "..msg.from.print_name:gsub("_",""))
			return "قوانین برای "..msg.to.title.." تغییر کرد\nبرای مشاهده ان /rules را تایپ کنید"
end
--------------------------------------------------#getrules
if matches[1] == 'rules' then
local data_cat = 'rules'
  if not data[tostring(msg.to.id)][data_cat] then
    return 'قوانینی تنظیم نشده است'
  end
  local rules = data[tostring(msg.to.id)][data_cat]
  local rules = 'قوانین برای '..msg.to.title..' :\n\n'..rules:gsub("/n", " ")
  savelog(msg.to.id, "قوانین گروه درخواست شد توسط "..msg.from.print_name:gsub("_",""))
  return rules
end
--------------------------------------------------#getabout
if matches[1] == 'about' then
 if to_super then
 return reply_msg(msg.id, "برای مشاهده توضیحات میتوانید پروفایل گروه را نگاه کنید", ok_cb, false)
 end
 local data_cat = 'description'
  if not data[tostring(msg.to.id)][data_cat] then
    return 'توضیحی ثبت نشده است'
  end
  local about = data[tostring(msg.to.id)][data_cat]
  local about = 'توضیحات برای '..msg.to.title..':\n\n'..about:gsub("/n", " ")
  savelog(msg.to.id, "توضیحات گروه درخواست شد توسط "..msg.from.print_name:gsub("_",""))
      return about
 end
--------------------------------------------------#rmsg
if matches[1] == 'rmsg' and matches[2] and is_momod(msg) then
local function history(extra, suc, result)
  for i=1, #result do
    delete_msg(result[i].id, ok_cb, false)
  end
  if tonumber(extra.con) == #result then
    send_msg(extra.chatid, '"'..#result..'" عدد پیام اخر پاک شدند', ok_cb, false)
  else
    send_msg(extra.chatid, 'اخرین پیام ها پاک شدند', ok_cb, false)
  end
end
      local hash = 'spamrmsg:'..msg.from.id
      local enable = redis:get(hash)
      if enable then
      return 
      end
      if tonumber(matches[2]) > 100 or tonumber(matches[2]) < 10 then
        return "با عرض پوزش: عدد انتخابی باید بین 10 تا 100 باشد\nاین محدودیت از طرف تلگرام اعمال گردیده است\nهر 30 ثانیه این دستور را ارسال کنید"
      end
	  redis:setex(hash, tonumber(30), true)
	  savelog(msg.to.id, "پیام های گروه پاک شدند توسط "..msg.from.print_name:gsub("_",""))
      get_history(receiver, matches[2] + 1 , history, {chatid = receiver, con = matches[2]})
end

if matches[1] == 'rmsg' and not matches[2] and is_sudo(msg) then
local function history2(extra, suc, result)
  for i=1, #result do
    delete_msg(result[i].id, ok_cb, false)
if tonumber(i) > 99 then
    delete_msg(result[i].id, ok_cb, false)
else
if tonumber(i) > 99 then
    delete_msg(result[i].id, ok_cb, false)
else
if tonumber(i) > 99 then
    delete_msg(result[i].id, ok_cb, false)
else
if tonumber(i) > 99 then
    delete_msg(result[i].id, ok_cb, false)
else
if tonumber(i) > 99 then
    delete_msg(result[i].id, ok_cb, false)
else
if tonumber(i) > 99 then
    delete_msg(result[i].id, ok_cb, false)
else
if tonumber(i) > 99 then
    delete_msg(result[i].id, ok_cb, false)
  end
end
end
end
end
end
end
end
  if tonumber(extra.con) == #result then
    send_msg(extra.chatid, '"'..#result..'"done!', ok_cb, false)
  else
    send_msg(extra.chatid, 'done!', ok_cb, false)
  end
end

if to_super then
      savelog(msg.to.id, "پیام های گروه پاک شدند توسط "..msg.from.print_name:gsub("_",""))
      get_history(receiver, 500 + 1, history2, {chatid = receiver, con = 500})
end
end
--------------------------------------------------#id
if matches[1] == 'id' then 
     if type(msg.reply_id)~="nil" and not matches[2] then
	    local function id_reply(extra , success, result)
		  local user_id = result.from.peer_id
          return reply_msg(extra.msg.id, user_id, ok_cb, false)
        end
          return get_message(msg.reply_id, id_reply, {msg = msg})
     elseif type(msg.reply_id)~="nil" and matches[2] == "from" then
         local function idfrom_reply(extra , success, result)
		    local user_id = "شناسه شخص :\n"..result.fwd_from.peer_id
            return reply_msg(extra.msg.id, user_id, ok_cb, false)
         end
          return get_message(msg.reply_id, idfrom_reply, {msg = msg})
  elseif matches[1] == 'id' and matches[2] and not string.match(matches[2], '^%d+$') then
	     local function id_username(extra , success, result)
		 if success == 0 then
		return false
	  end
		   local user_id = "شناسه شخص :"..result.peer_id
           return reply_msg(extra.msg.id, user_id, ok_cb, false)
         end
         local username = string.gsub(matches[2], '@', '')
	 	 return resolve_username(username, id_username, {msg = msg})
    elseif matches[1] == 'id' and not matches[2] then
       if to_chat or to_super then
	     savelog(msg.to.id, "شناسه گروه درخواست شد توسط "..msg.from.print_name:gsub("_",""))
	     return reply_msg(msg.id, "<b>"..msg.to.title.." </b>: <code>"..msg.to.id.." </code>", ok_cb, false)
		else
		 return "شناسه ID شما: "..msg.from.id
       end
	end 
end

--------------------------------------------------#kick
if matches[1] == 'kick' and is_momod(msg) then
    if type(msg.reply_id)~="nil" then
	local function kick_reply(extra , success, result)
		  if not result.from.username then
		  names = result.from.print_name:gsub("_", " ")
		  else
		  names = "@"..result.from.username
		  end
		  local user_id = result.from.peer_id
		  local chat_id = result.to.peer_id
		  local group_id = result.to.peer_id
		  if is_momod2(user_id, chat_id) then
		  return reply_msg(extra.msg.id, names.." ایشان داری مقام است", ok_cb, false)
		  end
          kick_user(user_id, group_id)
          local text = names.." [ "..result.from.peer_id.." ] از این گروه حذف شد"
          return reply_msg(extra.msg.reply_id, text, ok_cb, false)
 end
         return get_message(msg.reply_id, kick_reply, {msg = msg})
    elseif matches[1] == 'kick' and matches[2] and string.match(matches[2], '^%d+$') then
         if tonumber(matches[2]) == tonumber(our_id) then
         	return
         end
          if is_momod2(tonumber(matches[2]), msg.to.id) then
          	return send_larg_msg(receiver, matches[2].." ایشان داری مقام است", ok_cb, false)
         end
         if tonumber(matches[2]) == tonumber(msg.from.id) then
          	return
         end
         kick_user(matches[2], msg.to.id)
		return '[ '..matches[2]..' ] از گروه حذف شد'
      elseif matches[1] == 'kick' and matches[2] and not string.match(matches[2], '^%d+$') then
		 local function kick_username(extra , success, result)
		 if success == 0 then
		return false
	  end
		 local names = "@"..result.username
		 local user_id = result.peer_id
		 if is_momod2(user_id, extra.chat_id) then
		 return reply_msg(extra.msg.id, names.." ایشان داری مقام است", ok_cb, false)
		 end
		 kick_user(user_id, extra.chat_id)
         local text = names.." از گروه حذف شد"
         return reply_msg(extra.msg.id, text, ok_cb, false)
         end
         local username = string.gsub(matches[2], '@', '')
	 	 return resolve_username(username, kick_username, {msg = msg, chat_id = chat_id})
     end
  end
--------------------------------------------------#kickme
if matches[1] == 'kickme' then
    if to_chat then
	   kick_user(msg.from.id, chat_id)
	elseif to_super then
	   reply_msg(msg.id, "فقط در گروه های معمولی مجاز میباشد", ok_cb, false)
    end
end
--------------------------------------------------#ban
  if matches[1] == 'ban' and is_momod(msg) then
    if type(msg.reply_id)~="nil" then
      function ban_reply(extra , success, result)
		  if not result.from.username then
		  names = result.from.print_name:gsub("_", " ")
		  else
		  names = "@"..result.from.username
		  end
		  local user_id = result.from.peer_id
		  local chat_id = result.to.peer_id
		  if is_momod2(user_id, group_id) then
		  return reply_msg(extra.msg.id, names.." ایشان داری مقام است", ok_cb, false)
		  end
		  if is_banned(user_id, chat_id) then 
		  return reply_msg(extra.msg.reply_id, names.." در لیست افراد بن وجود دارد", ok_cb, false)
		  end
          ban_user(user_id, chat_id)
          local text = names.." [ "..result.from.peer_id.." ] از این گروه محروم شد"
          return reply_msg(extra.msg.reply_id, text, ok_cb, false)
        end
        return get_message(msg.reply_id, ban_reply, {msg = msg})
    elseif matches[1] == 'ban' and matches[2] and string.match(matches[2], '^%d+$') then
        if tonumber(matches[2]) == tonumber(our_id) then
         	return
        end
        if is_momod2(tonumber(matches[2]), msg.to.id) then
          	return send_larg_msg(receiver, matches[2].." ایشان داری مقام است", ok_cb, false)
        end
        if tonumber(matches[2]) == tonumber(msg.from.id) then
          	return
        end
        if is_banned(matches[2], chat_id) then 
		  return reply_msg(msg.id, matches[2].." در لیست افراد بن وجود دارد", ok_cb, false)
		  end
        ban_user(matches[2], msg.to.id)
		return '[ '..matches[2]..' ] از گروه محروم شد'
      elseif matches[1] == 'ban' and matches[2] and not string.match(matches[2], '^%d+$') then
		  local function ban_username(extra , success, result)
		  if success == 0 then
		return false
	  end
		  local names = "@"..result.username
		  local user_id = result.peer_id
		  if is_momod2(user_id, extra.chat_id) then
		  return reply_msg(extra.msg.id, names.." ایشان داری مقام است", ok_cb, false)
		  end
		  if is_banned(user_id, extra.chat_id) then 
		  return reply_msg(extra.msg.id, names.." در لیست افراد بن وجود دارد", ok_cb, false)
		  end
		 ban_user(user_id, extra.chat_id)
         local text = names.." از گروه محروم شد."
         return reply_msg(extra.msg.id, text, ok_cb, false)
        end
		local username = string.gsub(matches[2], '@', '')
		return resolve_username(username, ban_username, {msg = msg, chat_id = chat_id})
    end
  end
--------------------------------------------------#unban
  if matches[1] == 'unban' and is_momod(msg)  then
    if type(msg.reply_id)~="nil" then
      local function unban_reply(extra , success, result)
		  if not result.from.username then
		  names = result.from.print_name:gsub("_", " ")
		  else
		  names = "@"..result.from.username
		  end
		  local user_id = result.from.peer_id
		  local chat_id = result.to.peer_id
          if not is_banned(user_id, chat_id) then 
		  return reply_msg(extra.msg.reply_id, names.." در لیست افراد بن وجود ندارد", ok_cb, false)
		  end
          unban_user(user_id, chat_id)
          local text = names.." [ "..result.from.peer_id.." ] محرومیت ایشان از این گروه پاک شد"
          return reply_msg(extra.msg.reply_id, text, ok_cb, false)
        end
          return get_message(msg.reply_id, unban_reply, {msg = msg})
    elseif matches[1] == 'unban' and matches[2] and string.match(matches[2], '^%d+$') then
        if not is_banned(matches[2], chat_id) then 
		  return reply_msg(msg.id, matches[2].." در لیست افراد بن وجود ندارد", ok_cb, false)
		  end
        unban_user(matches[2], msg.to.id)
		return '[ '..matches[2]..' ] محرومیت ایشان از این گروه پاک شد'
      elseif matches[1] == 'unban' and matches[2] and not string.match(matches[2], '^%d+$') then
		 local function unban_username(extra , success, result)
		 if success == 0 then
		return false
	  end
		 local names = "@"..result.username
		 local user_id = result.peer_id
		 if not is_banned(user_id, extra.chat_id) then 
		  return reply_msg(extra.msg.id, names.." در لیست افراد بن وجود ندارد", ok_cb, false)
		  end
		 unban_user(user_id, extra.chat_id)
         local text = names.."  محرومیت ایشان از این گروه پاک شد."
         return reply_msg(extra.msg.id, text, ok_cb, false)
        end

		local username = string.gsub(matches[2], '@', '')
		return resolve_username(username, unban_username, {msg = msg, chat_id = chat_id})
    end
  end
--------------------------------------------------#banall
   if matches[1] == 'banall' and is_admin1(msg)  then
   if not is_sudo(msg) then
      return " برای انجام این دستور به مقام سودو ربات نیاز است"
   end
    if type(msg.reply_id)~="nil" then
      local function banall_reply(extra , success, result)
		  if not result.from.username then
		  names = result.from.print_name:gsub("_", " ")
		  else
		  names = "@"..result.from.username
		  end
		  local user_id = result.from.peer_id
		  local group_id = result.to.peer_id
		  if is_momod2(user_id, group_id) then
		  return reply_msg(extra.msg.id, names.." ایشان داری مقام است", ok_cb, false)
		  end
          if is_gbanned(user_id) then
		  return reply_msg(extra.msg.reply_id, names.." در لیست بن گلوبال وجود دارد", ok_cb, false)
		  end
          banall_user(user_id)
		  kick_user(user_id, group_id)
          local text = names.." [ "..result.from.peer_id.." ] از گروه های یوبی محروم شد."
          return reply_msg(extra.msg.reply_id, text, ok_cb, false)
        end
        return get_message(msg.reply_id, banall_reply, {msg = msg})
    elseif matches[1] == 'banall' and matches[2] and string.match(matches[2], '^%d+$') then
        if tonumber(matches[2]) == tonumber(our_id) then
         	return
        end
        if not is_admin1(msg) and is_momod(msg) then
          	return "ایشان ادمین یا مدیر گروه است."
        end
        if tonumber(matches[2]) == tonumber(msg.from.id) then
          	return
        end
        if is_gbanned(matches[2]) then
		  return reply_msg(msg.id, matches[2].." در لیست بن گلوبال وجود دارد", ok_cb, false)
		end
        banall_user(matches[2])
		kick_user(msg.from.id, msg.to.id)
		return '[ '..matches[2]..' ] از گروه های یوبی محروم شد'
      elseif matches[1] == 'banall' and matches[2] and not string.match(matches[2], '^%d+$') then
		 local function banall_username(extra , success, result)
		 if success == 0 then
		return false
	  end
		 local names = "@"..result.username
		 local user_id = result.peer_id
		  if is_momod2(user_id, extra.chat_id) then
		  return reply_msg(extra.msg.id, names.." ایشان داری مقام است", ok_cb, false)
		  end
		  if is_gbanned(user_id) then
		  return reply_msg(extra.msg.id, names.." در لیست بن گلوبال وجود دارد", ok_cb, false)
		  end
		 banall_user(user_id)
		 kick_user(user_id, extra.chat_id)
         local text = names.." از گروه های یوبی محروم شد."
         return reply_msg(extra.msg.id, text, ok_cb, false)
        end
		local username = string.gsub(matches[2], '@', '')
		return resolve_username(username, banall_username, {msg = msg, chat_id = chat_id})
    end
  end
--------------------------------------------------#unbanall
  if matches[1] == 'unbanall' and is_admin1(msg)  then
  if not is_sudo(msg) then
      return " برای انجام این دستور به مقام سودو ربات نیاز است"
   end
    if type(msg.reply_id)~="nil" then
      local function unbanall_reply(extra , success, result)
		  if not result.from.username then
		  names = result.from.print_name:gsub("_", " ")
		  else
		  names = "@"..result.from.username
		  end
		  local user_id = result.from.peer_id
		  local group_id = result.to.peer_id
          if not is_gbanned(user_id) then
		  return reply_msg(extra.msg.reply_id, names.." در لیست بن گلوبال وجود ندارد", ok_cb, false)
		  end
          unbanall_user(user_id)
          local text = names.." [ "..result.from.peer_id.." ] از گروه های یوبی رفع محرومیت شد"
          return reply_msg(extra.msg.reply_id, text, ok_cb, false)
        end
       return get_message(msg.reply_id, unbanall_reply, {msg = msg})
    elseif matches[1] == 'unbanall' and matches[2] and string.match(matches[2], '^%d+$') then
        if not is_gbanned(matches[2]) then
		  return reply_msg(msg.id, matches[2].." در لیست بن گلوبال وجود ندارد", ok_cb, false)
		  end
        unbanall_user(matches[2])
		return '[ '..matches[2]..' ] از گروه های یوبی رفع محرومیت شد'
      elseif matches[1] == 'unbanall' and matches[2] and not string.match(matches[2], '^%d+$') then
		 local function unbanall_username(extra , success, result)
		 if success == 0 then
		return false
	  end
		 local names = "@"..result.username
		 local user_id = result.peer_id
		  if not is_gbanned(user_id) then
		  return reply_msg(extra.msg.id, names.." در لیست بن گلوبال وجود ندارد", ok_cb, false)
		  end
		 unbanall_user(user_id)
         local text = names.." از گروه های یوبی رفع محرومیت شد."
         return reply_msg(extra.msg.id, text, ok_cb, false)
        end
		local username = string.gsub(matches[2], '@', '')
		return resolve_username(username, unbanall_username, {msg = msg})
    end
  end
--------------------------------------------------#block
  if matches[1] == 'botblock' and is_sudo(msg) then
  if not is_sudo(msg) then
      return " برای انجام این دستور به مقام سودو ربات نیاز است"
   end
    if type(msg.reply_id)~="nil" then
      local function blockbot_reply(extra , success, result)
		  if not result.from.username then
		  names = result.from.print_name:gsub("_", " ")
		  else
		  names = "@"..result.from.username
		  end
		  local user_id = result.from.peer_id
          block_user("user#id"..user_id, ok_cb, false)
          local text = names.." [ "..result.from.peer_id.." ] از چت خصوصی ربات بلاک شد"
          return reply_msg(extra.msg.reply_id, text, ok_cb, false)
        end
        return get_message(msg.reply_id, blockbot_reply, {msg = msg})
    elseif matches[1] == 'botblock' and matches[2] and string.match(matches[2], '^%d+$') then
        block_user("user#id"..matches[2], ok_cb, false)
		return '[ '..matches[2]..' ] از چت خصوصی ربات بلاک شد'
      elseif matches[1] == 'botblock' and matches[2] and not string.match(matches[2], '^%d+$') then
		 local function blockbot_username(extra , success, result)
		 if success == 0 then
		return false
	  end
		 local names = "@"..result.username
		 local user_id = result.peer_id
		 block_user("user#id"..user_id, ok_cb, false)
         local text = names.." از چت خصوصی ربات بلاک شد"
         return reply_msg(extra.msg.id, text, ok_cb, false)
        end
		local username = string.gsub(matches[2], '@', '')
		return resolve_username(username, blockbot_username, {msg = msg})
    end
  end
--------------------------------------------------#unblock
  if matches[1] == 'botunblock' and is_sudo(msg) then
  if not is_sudo(msg) then
      return " برای انجام این دستور به مقام سودو ربات نیاز است"
   end
    if type(msg.reply_id)~="nil" then
      function unblockbot_reply(extra , success, result)
		  if not result.from.username then
		  names = result.from.print_name:gsub("_", " ")
		  else
		  names = "@"..result.from.username
		  end
		  local user_id = result.from.peer_id
          unblock_user("user#id"..user_id, ok_cb, false)
          local text = names.." [ "..result.from.peer_id.." ] از چت خصوصی ربات ان بلاک شد"
          return reply_msg(extra.msg.reply_id, text, ok_cb, false)
        end
        return get_message(msg.reply_id, unblockbot_reply, {msg = msg})
    elseif matches[1] == 'botunblock' and matches[2] and string.match(matches[2], '^%d+$') then
        unblock_user("user#id"..matches[2], ok_cb, false)
		return  '[ '..matches[2]..' ] از چت خصوصی ربات ان بلاک شد'
      elseif matches[1] == 'botunblock' and matches[2] and not string.match(matches[2], '^%d+$') then
		 local function unblockbot_username(extra , success, result)
		 if success == 0 then
		return false
	  end
		 local names = "@"..result.username
		 local user_id = result.peer_id
		 unblock_user("user#id"..user_id, ok_cb, false)
         local text = names.." از چت خصوصی ربات ان بلاک شد"
         return reply_msg(extra.msg.id, text, ok_cb, false)
        end
		local username = string.gsub(matches[2], '@', '')
		return resolve_username(username, unblockbot_username, {msg = msg})
    end
  end
--------------------------------------------------#addadmin by sudo
if matches[1] == 'addadmin' and is_sudo(msg) and matches[2] and string.match(matches[2], '^%d+$') then
      local function addadmin_id(extra, success, result)

		local user_id = result.peer_id
		if result.username then
			names = "@"..result.username
		else
			names = string.gsub(result.print_name, '_', ' ')
		end
		local admin_id = result.peer_id
		local admins = 'admins'
		if not data[tostring(admins)] then
		data[tostring(admins)] = {}
		save_data(config.moderation.data, data)
	    end

        if data[tostring(admins)][tostring(admin_id)] then
	 	 return admin_id..' is already an admin.'
	    end
	     data[tostring(admins)][tostring(admin_id)] = names
	     save_data(config.moderation.data, data)
		 local text = names..' has been promoted as admin.'
		 return reply_msg(extra.msg.id, text, ok_cb, false)
end
		 local user_id = "user#id"..matches[2]
		 return user_info(user_id, addadmin_id, {msg=msg})
 elseif matches[1] == 'addadmin' and is_sudo(msg) and matches[2] and not string.match(matches[2], '^%d+$') then
		 local function admin_username(extra , success, result)
		 if success == 0 then
		return 	false
	  end

	      local admins = 'admins'
		  local admin_id = result.peer_id
	      if not data['admins'] then
                data['admins'] = {}
            save_data(config.moderation.data, data)
        end
		 if data[tostring(admins)][tostring(admin_id)] then
		  return reply_msg(extra.msg.id, "@"..result.username..' is already an admin.', ok_cb, false)
	     end
           data[tostring(admins)][tostring(admin_id)] = "@"..result.username
	       save_data(config.moderation.data, data)
	       return reply_msg(extra.msg.id, "@"..result.username..' has been promoted as admin.', ok_cb, false)
        end
		local username = string.gsub(matches[2], '@', '')
		return resolve_username(username, admin_username, {msg = msg})
  end
--------------------------------------------------#removeadmin by sudo
if matches[1] == 'removeadmin' and is_sudo(msg) and matches[2] and string.match(matches[2], '^%d+$') then
      local function removeadmin_id(extra, success, result)

		local user_id = result.peer_id
		if result.username then
			names = "@"..result.username
		else
			names = string.gsub(result.print_name, '_', ' ')
		end
		local admin_id = result.peer_id
		local admins = 'admins'
		if not data[tostring(admins)] then
		data[tostring(admins)] = {}
		save_data(config.moderation.data, data)
	    end

        if not  data[tostring(admins)][tostring(admin_id)] then
	 	 return admin_id..' is not an admin.'
	    end
	     data[tostring(admins)][tostring(admin_id)] = nil
	     save_data(config.moderation.data, data)
		 local text = names..' has been demoted as admin.'
		 return reply_msg(extra.msg.id, text, ok_cb, false)
end
		 local user_id = "user#id"..matches[2]
		 return user_info(user_id, addadmin_id, {msg=msg})
 elseif matches[1] == 'removeadmin' and is_sudo(msg) and matches[2] and not string.match(matches[2], '^%d+$') then
		 local function removeadmin_username(extra , success, result)
		 if success == 0 then
		return false
	  end

	      local admins = 'admins'
		  local admin_id = result.peer_id
	      if not data['admins'] then
                data['admins'] = {}
            save_data(config.moderation.data, data)
        end
		 if not data[tostring(admins)][tostring(admin_id)] then
		  return reply_msg(extra.msg.id, "@"..result.username..' is not an admin.', ok_cb, false)
	     end
           data[tostring(admins)][tostring(admin_id)] = nil
	       save_data(config.moderation.data, data)
	       return reply_msg(extra.msg.id, "@"..result.username..' has been demoted as admin.', ok_cb, false)
        end
		local username = string.gsub(matches[2], '@', '')
		return resolve_username(username, removeadmin_username, {msg = msg})
  end
--------------------------------------------------#banlist
   if matches[1] == "banlist" and is_momod(msg) then
    if matches[2] and is_admin1(msg) then
      chat_id = matches[2]
    end
	 savelog(msg.to.id, "لیست افراد محروم از گروه درخواست شد توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, ban_list(chat_id), ok_cb, false)
  end
--------------------------------------------------#gbanlist
  if matches[1] == "gbanlist" and is_admin1(msg) then
    return reply_msg(msg.id, banall_list(), ok_cb, false)
  end
--------------------------------------------------#gmutelist
  if matches[1] == "gmutelist" and is_admin1(msg) then
    return reply_msg(msg.id, muteall_list(), ok_cb, false)
  end
--------------------------------------------------#kickedlist
  if matches[1] == "kicklist" and is_admin1(msg) then
    return reply_msg(msg.id, kick_list(), ok_cb, false)
  end
--------------------------------------------------#divestlist
  if matches[1] == "divestlist" and is_sudo(msg) then
    return divestlist()
  end
--------------------------------------------------#autoleave
if matches[1] == 'autoleave' and is_sudo(msg) then
     if matches[2] == 'en' then
	    if redis:get('addgroup:') == "on" then
	    return "اتو لیو فعال است"
     else
	    redis:set('addgroup:', "on")
        return "اتو لیو فعال گردید"
	  end
    elseif matches[2] == "dis" then
	    if redis:get('addgroup:') == "off" then
	    return "اتو لیو غیرفعال است"
    else
	   redis:set('addgroup:', "off")
       return "اتو لیو غیرفعال گردید"
      end
    end
end
--------------------------------------------------#bc
 if matches[1] == 'bc' and is_admin1(msg) then
		local response = matches[3]
		send_large_msg("chat#id"..matches[2], response)
		send_large_msg("channel#id"..matches[2], response)
		send_large_msg("user#id"..matches[2], response)
 end
--------------------------------------------------#broadcast
 if matches[1] == 'broadcast' and is_sudo(msg) then
			local i = 0
			for k,v in pairs(data[tostring('groups')]) do
				send_large_msg('chat#id'..v, matches[2])
				send_large_msg('channel#id'..v, matches[2])
				i = i + 1
		end
		       send_large_msg(receiver, "به "..i.." گروه ارسال شد")
	end
--------------------------------------------------#all
if matches[1] == "all" and matches[2] and is_owner2(msg.from.id, matches[2]) then
    local target = matches[2]
    return all(msg, target, receiver)
  end
  if matches[1] == "all" and not matches[2] and is_owner(msg) then
    return all(msg,msg.to.id,receiver)
  end
--------------------------------------------------#join
if matches[1] == 'join' and data[tostring(matches[2])] and is_admin1(msg) then
          local chat_id = "chat#id"..matches[2]
		  local channel_id = "channel#id"..matches[2]
          local user_id = "user#id"..msg.from.id
   	      chat_add_user(chat_id, user_id, ok_cb, false)
		  channel_invite(channel_id, user_id, ok_cb, false)
	      local group_name = data[tostring(matches[2])]['settings']['set_name']	
	      return "شما در گروه زیر ادد شدید:\n\n👥"..group_name.." (ID:"..matches[2]..")"
elseif matches[1] == 'join' and not data[tostring(matches[2])] then
     return "همچین گروهی وجود ندارد"
end
--------------------------------------------------#chatlist
if matches[1] == 'chatlist' then
		if is_admin1(msg) and msg.to.type == 'chat' or msg.to.type == 'channel' then
			chat_list22(msg)
			send_document("user#id"..msg.from.id, "./groups/lists/listed_groups.txt", ok_cb, false)
			send_msg(receiver, "لیست گروه ها در چت خصوصی شما ارسال شد", ok_cb, false)
		elseif msg.to.type == 'user' then
			chat_list22(msg)
			send_document("user#id"..msg.from.id, "./groups/lists/listed_groups.txt", ok_cb, false)
    end
end
--------------------------------------------------#about
if matches[1] == 'teleseed' or matches[1] == 'ub' then
    local about = [[تله یوبی (اولترا بوت)

ویرایش شده <a href="https://github.com/yagop/telegram-bot">تلگرام بوت</a> قدرت گرفته از <a href="https://github.com/SEEDTEAM/TeleSeed">تله سیید نسخه 4</a>

گروه منیجر و انتی اسپم نوشته شده به زبان لوا <b>Lua</b>

گرداورنده : <a href="telegram.me/valtman">Ｒａｍｉｎ ＵＢ</a>

کانال اختصاصی : <a href="telegram.me/ub_ch">ᑌᗷ ᑕᕼᗩᑎᑎᕮᒪ</a>
]]
    return reply_msg(msg.id, about, ok_cb, false)
  end
--------------------------------------------------#stats
if matches[1] == "statslist" and is_momod(msg) then
 savelog(msg.to.id, "استاتس لیست گروه درخواست شد توسط "..msg.from.print_name:gsub("_",""))
    return chat_stats2(chat_id)
 end
if matches[1] == "stats" and not matches[2] and is_momod(msg) then
 savelog(msg.to.id, "استاتس گروه درخواست شد توسط "..msg.from.print_name:gsub("_",""))
      return chat_stats(receiver, chat_id)
end
if matches[1] == "facts" and is_admin1(msg) then
   return get_message(msg.id, facts, {msg = msg})
    end
    if matches[1] == "stats" and matches[2] == "group" and is_admin1(msg) then
        return chat_stats(matches[3])
  end

--------------------------------------------------#admins or sudoers
--------------------------------------------------#markread
    if matches[1] == "markread" and is_sudo(msg) then
    	if matches[2] == "on" then
    		redis:set("bot:markread", "on")
    		return "<b>Bot read meesages</b> > <code>ON</code>"
    	end
    	if matches[2] == "off" then
    		redis:del("bot:markread")
    		return "<b>Bot read meesages</b> > <code>OFF</code>"
    	end
    	return
    end
	--------------------------------------------------#typing
    if matches[1] == "typing" and is_sudo(msg) then
    	if matches[2] == "on" then
    		redis:set("bot:typing", "on")
    		return "<b>Bot typing via pecipes</b> > <code>ON</code>"
    	end
    	if matches[2] == "off" then
    		redis:del("bot:typing")
    		return "<b>Bot typing via pecipes</b> > <code>OFF</code>"
    	end
    	return
    end
--------------------------------------------------#importbotbylink
    if matches[1] == "import" and is_admin1(msg) then
    	local LINK = parsed_url(matches[2])
    	import_chat_link(LINK, ok_cb, false)
		return "<b>Joned!</b>"
    end
--------------------------------------------------#contacts
    if matches[1] == "contactlist" and is_sudo(msg) then
      get_contact_list(get_contact_list_callback, {target = msg.from.id})
      return "I've sent contact list with both json and text format to your private"
    end
    if matches[1] == "delcontact" and is_sudo(msg) then
      del_contact("user#id"..matches[2],ok_cb,false)
      return "User "..matches[2].." removed from contact list"
    end
    if matches[1] == "addcontact" and is_sudo(msg) then
    phone = matches[2]
    first_name = matches[3]
    last_name = matches[4]
    add_contact(phone, first_name, last_name, ok_cb, false)
   return "User With Phone +"..matches[2].." has been added"
end
 if matches[1] == "sendcontact" and is_sudo(msg) then
    phone = matches[2]
    first_name = matches[3]
    last_name = matches[4]
    send_contact(receiver, phone, first_name, last_name, ok_cb, false)
end
 if matches[1] == "mycontact" and is_sudo(msg) then
	if not msg.from.phone then
		return "I must Have Your Phone Number!"
    end
    phone = msg.from.phone
    first_name = (msg.from.first_name or msg.from.phone)
    last_name = (msg.from.last_name or msg.from.id)
    send_contact(receiver, phone, "test", "test", ok_cb, false)
end
--------------------------------------------------#dialog
    if matches[1] == "dialoglist" and is_admin1(msg) then
      get_dialog_list(get_dialog_list_callback, {target = msg.from.id})
      return "I've sent a group dialog list with both json and text format to your private messages"
    end
--------------------------------------------------#LOGS
	if matches[1] == 'addlog' and not matches[2] and is_admin1(msg) then
		if is_log_group(msg) then
			return "Already a Log_SuperGroup"
		end
		print("Log_SuperGroup "..msg.to.title.."("..msg.to.id..") added")
		logadd(msg)
	end
	if matches[1] == 'remlog' and not matches[2] and is_admin1(msg) then
		if not is_log_group(msg) then
			return "Not a Log_SuperGroup"
		end
		print("Log_SuperGroup "..msg.to.title.."("..msg.to.id..") removed")
		logrem(msg)
	end
--------------------------------------------------#ping
  if matches[1] == 'ping' then
    return reply_msg(msg.id, [[<a href="telegram.me/ub_ch">PonG</a>]], ok_cb, false)
  end
--------------------------------------------------#command from normal users settings
   if matches[1] == 'cmuser' and is_momod(msg) then
     if matches[2] == 'lock' then
	    if redis:get('Groupcm'..bot_divest..':'..msg.to.id) == "on" then
	    return reply_msg(msg.id, "محدودیت پاسخ ربات برای افراد عادی فعال است", ok_cb, false)
     else
	     savelog(msg.to.id, "محدودت پاسخ ربات برای افراد عادی گروه فعال شد توسط "..msg.from.print_name:gsub("_",""))
	    redis:set('Groupcm'..bot_divest..':'..msg.to.id, "on")
        return reply_msg(msg.id, "محدودیت پاسخ ربات برای افراد عادی فعال گردید", ok_cb, false)
	  end

    elseif matches[2] == "unlock" then
	    if redis:get('Groupcm'..bot_divest..':'..msg.to.id) == "off" then
	    return reply_msg(msg.id, "محدودیت پاسخ ربات برای افراد عادی غیرفعال است", ok_cb, false)
    else
	    savelog(msg.to.id, "محدودت پاسخ ربات برای افراد عادی گروه غیرفعال شد توسط "..msg.from.print_name:gsub("_",""))
	   redis:set('Groupcm'..bot_divest..':'..msg.to.id, "off")
       return reply_msg(msg.id, "محدودیت پاسخ ربات برای افراد عادی غیرفعال گردید", ok_cb, false)
        end
     end
  end
--------------------------------------------------#type groups
if matches[1] == "type" then
 local text = "نوع گروه : "..get_group_type(msg)
  savelog(msg.to.id, "نوع گروه درخواست شد توسط "..msg.from.print_name:gsub("_",""))
 return reply_msg(msg.id, text, ok_cb, false)
end
if matches[1] == "settype" and matches[2] and is_owner1(msg) then

  data[tostring(msg.to.id)]['group_type'] = matches[2]
  save_data(config.moderation.data, data)
  if msg.to.type == 'chat' then
     savelog(msg.to.id, "نوع گروه عوض شد توسط "..msg.from.print_name:gsub("_",""))
    return 'نوع گروه به '..matches[2].." تغییر کرد"
  elseif msg.to.type == 'channel'then
   savelog(msg.to.id, "نوع گروه عوض شد توسط "..msg.from.print_name:gsub("_",""))
    return 'نوع سوپر گروه به '..matches[2].." تغییر کرد"
  end
end
--------------------------------------------------#remove groups by id
if matches[1] == 'rem' and matches[2] and is_admin1(msg) then
			data[tostring(matches[2])] = nil
			save_data(config.moderation.data, data)
			local groups = 'groups'
			if not data[tostring(groups)] then
				data[tostring(groups)] = nil
				save_data(config.moderation.data, data)
			end
			data[tostring(groups)][tostring(matches[2])] = nil
			save_data(config.moderation.data, data)
			send_large_msg(receiver, 'گروه '..matches[2]..' حذف شد')
end
--------------------------------------------------#list admins/groups
 if matches[1] == 'list' and is_admin1 then 
    if matches[2] == 'groups' then
		groups_list(msg)
		return reply_document(msg.id, "./groups/lists/groups.txt", ok_cb, false)
	elseif matches[2] == 'admins' then
		return reply_msg(msg.id, admin_list(msg), ok_cb, false)
	end
end
--------------------------------------------------#invite
if matches[1] == "invite" and is_admin1(msg) then
 if type(msg.reply_id)~="nil" then
      local function invite_reply(extra , success, result)
         local chat_id = "chat#id"..extra.chat_id
		 local channel_id = 'channel#id'..extra.chat_id
	   if is_banned(result.from.peer_id, extra.chat_id) and is_gbanned(result.from.peer_id) then 
        send_large_msg(receiver, 'User is banned and globaly banned')
	   elseif is_gbanned(result.from.peer_id) then
	    send_large_msg(receiver, 'User is globaly banned')
	   elseif is_banned(result.from.peer_id, extra.chat_id) then 
        send_large_msg(receiver, 'User is banned')
	   else
		 local user_id = "user#id"..result.from.peer_id
		 chat_add_user(chat_id, user_id, ok_cb, false)
		 channel_invite(channel_id, user_id, ok_cb, false)
        end
        end
        return get_message(msg.reply_id, invite_reply, {chat_id = chat_id, msg = msg})
elseif matches[1] == "invite" and not string.match(matches[2], '^%d+$') and is_admin1(msg) then
	 local function invite_username(extra , success, result)
	 if success == 0 then
		return false
	  end
         local chat_id = "chat#id"..extra.chat_id
		 local channel_id = 'channel#id'..extra.chat_id
	   if is_banned(result.peer_id, extra.chat_id) and is_gbanned(result.peer_id) then 
        send_large_msg(receiver, 'User is banned and globaly banned')
	   elseif is_gbanned(result.peer_id) then
	    send_large_msg(receiver, 'User is globaly banned')
	   elseif is_banned(result.peer_id, extra.chat_id) then 
        send_large_msg(receiver, 'User is banned')
	   else
		 local user_id = "user#id"..result.peer_id
		 chat_add_user(chat_id, user_id, ok_cb, false)
		 channel_invite(channel_id, user_id, ok_cb, false)
        end
		end
		local username = matches[2]
		local username = username:gsub('@', '')
		return resolve_username(username,  invite_username, {msg = msg, chat_id = chat_id})
end
end
--------------------------------------------------#3lock settings
if matches[1] == 'lock' and is_momod(msg) then
local target = msg.to.id
if matches[2] == 'link' and matches[3] == 'dis' then
    if data[tostring(target)]['settings']['lock_link'] == 'no' then
	return reply_msg(msg.id, 'پاک کننده لینک غیرفعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_link'] = 'no'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده لینک غیرفعال گردید', ok_cb, false)
	end
	end
if matches[2] == 'link' and matches[3] == 'del' then
if data[tostring(target)]['settings']['lock_link'] == 'yes' then
	return reply_msg(msg.id, 'پاک کننده(پاک کردن) لینک فعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_link'] = 'yes'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده(پاک کردن) لینک فعال گردید', ok_cb, false)
	end
	end
if matches[2] == 'link' and matches[3] == 'kick' then
if data[tostring(target)]['settings']['lock_link'] == 'kick' then
	return reply_msg(msg.id, 'پاک کننده(ریمو کردن) لینک فعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_link'] = 'kick'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده(ریمو کردن) لینک فعال گردید', ok_cb, false)
end
end

if matches[2] == 'spam' and matches[3] == 'dis' then
if not is_owner(msg) then
return reply_msg(msg.id, 'برای تنظیم این قفل به مقام صاحب گروه(owner) نیاز است', ok_cb, false)
end
    data[tostring(target)]['settings']['lock_spam'] = 'no'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده پیام های طولانی غیر فعال گردید', ok_cb, false)
	end
if matches[2] == 'spam' and matches[3] == 'del' then
if not is_owner(msg) then
return reply_msg(msg.id, 'برای تنظیم این قفل به مقام صاحب گروه(owner) نیاز است', ok_cb, false)
end
    data[tostring(target)]['settings']['lock_spam'] = 'yes'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده(پاک کردن) پیام های طولانی فعال گردید', ok_cb, false)
	end
if matches[2] == 'spam' and matches[3] == 'kick' then
if not is_owner(msg) then
return reply_msg(msg.id, 'برای تنظیم این قفل به مقام صاحب گروه(owner) نیاز است', ok_cb, false)
end
    data[tostring(target)]['settings']['lock_spam'] = 'kick'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده(ریمو کردن) پیام های طولانی فعال گردید', ok_cb, false)
end

if matches[2] == 'flood' and matches[3] == 'dis' then
if not is_admin1(msg) then
return reply_msg(msg.id, 'برای تنظیم این قفل به مقام ادمین ربات نیاز است', ok_cb, false)
end
    data[tostring(target)]['settings']['lock_flood'] = 'no'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده پیام های مکرر غیر فعال گردید', ok_cb, false)
	end
if matches[2] == 'flood' and matches[3] == 'del' then
if not is_admin1(msg) then
return reply_msg(msg.id, 'برای تنظیم این قفل به مقام ادمین ربات نیاز است', ok_cb, false)
end
    data[tostring(target)]['settings']['lock_flood'] = 'yes'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده(پاک کردن) پیام های مکرر فعال گردید', ok_cb, false)
	end
if matches[2] == 'flood' and matches[3] == 'kick' then
if not is_admin1(msg) then
return reply_msg(msg.id, 'برای تنظیم این قفل به مقام ادمین ربات نیاز است', ok_cb, false)
end
    data[tostring(target)]['settings']['lock_flood'] = 'yes'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده(ریمو کردن) پیام مکرر فعال گردید', ok_cb, false)
end

if matches[2] == 'fa' and matches[3] == 'dis' then
    data[tostring(target)]['settings']['lock_arabic'] = 'no'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده پیام های فارسی غیر فعال گردید', ok_cb, false)
	end
if matches[2] == 'fa' and matches[3] == 'del' then
    data[tostring(target)]['settings']['lock_arabic'] = 'yes'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده(پاک کردن) پیام های فارسی فعال گردید', ok_cb, false)
	end
if matches[2] == 'fa' and matches[3] == 'kick' then
    data[tostring(target)]['settings']['lock_arabic'] = 'kick'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده(ریمو کردن) پیام های فارسی فعال گردید', ok_cb, false)
end

if matches[2] == 'en' and matches[3] == 'dis' then
    data[tostring(target)]['settings']['lock_en'] = 'no'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده پیام های انگلیسی غیر فعال گردید', ok_cb, false)
	end
if matches[2] == 'en' and matches[3] == 'del' then
    data[tostring(target)]['settings']['lock_en'] = 'yes'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده(پاک کردن) پیام های انگلیسی فعال گردید', ok_cb, false)
	end
if matches[2] == 'en' and matches[3] == 'kick' then
    data[tostring(target)]['settings']['lock_en'] = 'kick'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده(ریمو کردن) پیام های انگلیسی فعال گردید', ok_cb, false)
end

if matches[2] == 'member' and matches[3] == 'dis' then
if to_super then
return reply_msg(msg.id, 'این عملکرد در سوپر گروه ها مجاز نیست', ok_cb, false)
end
    data[tostring(target)]['settings']['lock_member'] = 'no'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده افراد دعوت شده غیر فعال گردید', ok_cb, false)
	end
if matches[2] == 'member' and matches[3] == 'inv' then
if to_super then
return reply_msg(msg.id, 'این عملکرد در سوپر گروه ها مجاز نیست', ok_cb, false)
end
    data[tostring(target)]['settings']['lock_member'] = 'kickinv'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده افراد دعوت شده فعال گردید(فقط دعوت شده ریمو میشود)', ok_cb, false)
	end
if matches[2] == 'member' and matches[3] == 'both' then
if to_super then
return reply_msg(msg.id, 'این عملکرد در سوپر گروه ها مجاز نیست', ok_cb, false)
end
    data[tostring(target)]['settings']['lock_member'] = 'kickboth'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده افراد دعوت شده فعال گردید(دعوت کننده و دعوت شده ریمو میشوند)', ok_cb, false)
end

if matches[2] == 'tgservice' and matches[3] == 'dis' then
    data[tostring(target)]['settings']['lock_tgservice'] = 'no'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده پیام های جوین،دعوت،ریمو،عوض کردن اسم و... غیر فعال گردید', ok_cb, false)
	end
if matches[2] == 'tgservice' and matches[3] == 'del' then
    data[tostring(target)]['settings']['lock_tgservice'] = 'yes'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده(پاک کردن) پیام های جوین،دعوت،ریمو،عوض کردن اسم و... فعال گردید', ok_cb, false)
	end
if matches[2] == 'tgservice' and matches[3] == 'kick' then
    data[tostring(target)]['settings']['lock_tgservice'] = 'yes'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, '[امکان ریمو نیست]پاک کننده(پاک کردن) پیام های جوین،دعوت،ریمو،عوض کردن اسم و... فعال گردید', ok_cb, false)
end

if matches[2] == 'sticker' and matches[3] == 'dis' then
    data[tostring(target)]['settings']['lock_sticker'] = 'no'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده استیکر غیر فعال گردید', ok_cb, false)
	end
if matches[2] == 'sticker' and matches[3] == 'del' then
    data[tostring(target)]['settings']['lock_sticker'] = 'yes'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده(پاک کردن) استیکر فعال گردید', ok_cb, false)
	end
if matches[2] == 'sticker' and matches[3] == 'kick' then
    data[tostring(target)]['settings']['lock_sticker'] = 'kick'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده(ریمو کردن) استیکر فعال گردید', ok_cb, false)
end

if matches[2] == 'share' and matches[3] == 'dis' then
    data[tostring(target)]['settings']['lock_contact'] = 'no'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده شماره غیر فعال گردید', ok_cb, false)
	end
if matches[2] == 'share' and matches[3] == 'del' then
    data[tostring(target)]['settings']['lock_contact'] = 'yes'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده(پاک کردن) شماره فعال گردید', ok_cb, false)
	end
if matches[2] == 'share' and matches[3] == 'kick' then
    data[tostring(target)]['settings']['lock_contact'] = 'kick'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده(ریمو کردن) شماره فعال گردید', ok_cb, false)
end

if matches[2] == 'photo' and matches[3] == 'dis' then
    data[tostring(target)]['settings']['lock_photo'] = 'no'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده عکس غیر فعال گردید', ok_cb, false)
	end
if matches[2] == 'photo' and matches[3] == 'del' then
    data[tostring(target)]['settings']['lock_photo'] = 'yes'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده(پاک کردن) عکس فعال گردید', ok_cb, false)
	end
if matches[2] == 'photo' and matches[3] == 'kick' then
    data[tostring(target)]['settings']['lock_photo'] = 'kick'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده(ریمو کردن) عکس فعال گردید', ok_cb, false)
end

if matches[2] == 'text' and matches[3] == 'dis' then
    data[tostring(target)]['settings']['lock_text'] = 'no'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده چت(متن) غیر فعال گردید', ok_cb, false)
	end
if matches[2] == 'text' and matches[3] == 'del' then
    data[tostring(target)]['settings']['lock_text'] = 'yes'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده(پاک کردن) چت(متن) فعال گردید', ok_cb, false)
	end
if matches[2] == 'text' and matches[3] == 'kick' then
    data[tostring(target)]['settings']['lock_text'] = 'kick'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده(ریمو کردن) چت(متن) فعال گردید', ok_cb, false)
end

if matches[2] == 'audio' and matches[3] == 'dis' then
    data[tostring(target)]['settings']['lock_audio'] = 'no'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده صدا غیر فعال گردید', ok_cb, false)
	end
if matches[2] == 'audio' and matches[3] == 'del' then
    data[tostring(target)]['settings']['lock_audio'] = 'yes'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده(پاک کردن) صدا فعال گردید', ok_cb, false)
	end
if matches[2] == 'audio' and matches[3] == 'kick' then
    data[tostring(target)]['settings']['lock_audio'] = 'kick'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده(ریمو کردن) صدا فعال گردید', ok_cb, false)
end

if matches[2] == 'video' and matches[3] == 'dis' then
    data[tostring(target)]['settings']['lock_video'] = 'no'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده فیلم غیر فعال گردید', ok_cb, false)
	end
if matches[2] == 'video' and matches[3] == 'del' then
    data[tostring(target)]['settings']['lock_video'] = 'yes'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده(پاک کردن) فیلم فعال گردید', ok_cb, false)
	end
if matches[2] == 'video' and matches[3] == 'kick' then
    data[tostring(target)]['settings']['lock_video'] = 'kick'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده(ریمو کردن) فیلم فعال گردید', ok_cb, false)
end

if matches[2] == 'file' and matches[3] == 'dis' then
    data[tostring(target)]['settings']['lock_document'] = 'no'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده فایل غیر فعال گردید', ok_cb, false)
	end
if matches[2] == 'file' and matches[3] == 'del' then
    data[tostring(target)]['settings']['lock_document'] = 'yes'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده(پاک کردن) فایل فعال گردید', ok_cb, false)
	end
if matches[2] == 'file' and matches[3] == 'kick' then
    data[tostring(target)]['settings']['lock_document'] = 'kick'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده(ریمو کردن) فایل فعال گردید', ok_cb, false)
end

if matches[2] == 'gif' and matches[3] == 'dis' then
    data[tostring(target)]['settings']['lock_gif'] = 'no'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده گیف(عکس متحرک) غیر فعال گردید', ok_cb, false)
	end
if matches[2] == 'gif' and matches[3] == 'del' then
    data[tostring(target)]['settings']['lock_gif'] = 'yes'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده(پاک کردن) گیف(عکس متحرک) فعال گردید', ok_cb, false)
	end
if matches[2] == 'gif' and matches[3] == 'kick' then
    data[tostring(target)]['settings']['lock_gif'] = 'kick'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده(ریمو کردن) گیف(عکس متحرک) فعال گردید', ok_cb, false)
end

if matches[2] == 'fwd' and matches[3] == 'dis' then
    data[tostring(target)]['settings']['lock_fwd'] = 'no'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده پیام های فوروارد غیر فعال گردید', ok_cb, false)
	end
if matches[2] == 'fwd' and matches[3] == 'del' then
    data[tostring(target)]['settings']['lock_fwd'] = 'yes'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده(پاک کردن) پیام های فوروارد فعال گردید', ok_cb, false)
	end
if matches[2] == 'fwd' and matches[3] == 'kick' then
    data[tostring(target)]['settings']['lock_fwd'] = 'kick'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده(ریمو کردن) پیام های فوروارد فعال گردید', ok_cb, false)
end

if matches[2] == 'bot' and matches[3] == 'dis' then
    data[tostring(target)]['settings']['lock_bot'] = 'no'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'ضد ربات غیر فعال گردید', ok_cb, false)
	end
if matches[2] == 'bot' and matches[3] == 'inv' then
    data[tostring(target)]['settings']['lock_bot'] = 'kickinv'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'ضد ربات فعال شد(فقط ربات ریمو میشود)', ok_cb, false)
	end
if matches[2] == 'bot' and matches[3] == 'both' then
    data[tostring(target)]['settings']['lock_bot'] = 'kickboth'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'ضد ربات فعال شد(هم ربات و هم دعوت کننده ریمو میشوند)', ok_cb, false)
end

if matches[2] == 'join' and matches[3] == 'dis' then
if to_super then
return reply_msg(msg.id, 'این عملکرد در سوپر گروه ها مجاز نیست', ok_cb, false)
end
if not is_owner(msg) then
return reply_msg(msg.id, 'برای تنظیم این قفل به مقام صاحب گروه(owner) نیاز است', ok_cb, false)
end
    data[tostring(target)]['settings']['lock_join'] = 'no'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده افراد جوین دهنده با لینک غیر فعال گردید', ok_cb, false)
	end
if matches[2] == 'join' and matches[3] == 'del' then
if to_super then
return reply_msg(msg.id, 'این عملکرد در سوپر گروه ها مجاز نیست', ok_cb, false)
end
if not is_owner(msg) then
return reply_msg(msg.id, 'برای تنظیم این قفل به مقام صاحب گروه(owner) نیاز است', ok_cb, false)
end
    data[tostring(target)]['settings']['lock_join'] = 'kick'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده(ریمو کردن) افراد جوین دهنده با لینک فعال گردید[امکان پاک کردن نیست]', ok_cb, false)
	end
if matches[2] == 'join' and matches[3] == 'kick' then
if to_super then
return reply_msg(msg.id, 'این عملکرد در سوپر گروه ها مجاز نیست', ok_cb, false)
end
if not is_owner(msg) then
return reply_msg(msg.id, 'برای تنظیم این قفل به مقام صاحب گروه(owner) نیاز است', ok_cb, false)
end
    data[tostring(target)]['settings']['lock_join'] = 'kick'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده(ریمو کردن) افراد جوین دهنده با لینک فعال گردید', ok_cb, false)
end

if matches[2] == 'reply' and matches[3] == 'dis' then
    data[tostring(target)]['settings']['lock_reply'] = 'no'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده پیام های ریپلی(پاسخ) فعال گردید', ok_cb, false)
	end
if matches[2] == 'reply' and matches[3] == 'del' then
    data[tostring(target)]['settings']['lock_reply'] = 'yes'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده(پاک کردن) پیام های ریپلی(پاسخ) فعال گردید', ok_cb, false)
	end
if matches[2] == 'reply' and matches[3] == 'kick' then
    data[tostring(target)]['settings']['lock_reply'] = 'kick'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده(ریمو کردن) پیام های ریپلی(پاسخ) فعال گردید', ok_cb, false)
end

if matches[2] == 'tag' and matches[3] == 'dis' then
    data[tostring(target)]['settings']['lock_tag'] = 'no'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده پیام های دارای تگ غیر فعال گردید', ok_cb, false)
	end
if matches[2] == 'tag' and matches[3] == 'del' then
    data[tostring(target)]['settings']['lock_tag'] = 'yes'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده(پاک کردن) پیام های دارای تگ فعال گردید', ok_cb, false)
	end
if matches[2] == 'tag' and matches[3] == 'kick' then
    data[tostring(target)]['settings']['lock_tag'] = 'kick'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده(ریمو کردن) پیام های دارای تگ فعال گردید', ok_cb, false)
   end
end

--------------------------------------------------#unlock settings
if matches[1] == "unlock" and is_momod(msg) then
local target = msg.to.id
if matches[2] == 'link' then
if data[tostring(target)]['settings']['lock_link'] == 'no' then
	return reply_msg(msg.id, 'پاک کننده لینک غیرفعال است', ok_cb, false)
	else
	savelog(msg.to.id, "پاک کننده لینک غیرفعال گردید توسط "..msg.from.print_name:gsub("_",""))
    data[tostring(target)]['settings']['lock_link'] = 'no'
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده لینک غیرفعال گردید', ok_cb, false)
end

elseif matches[2] == 'spam' then
if data[tostring(target)]['settings']['lock_spam'] == 'no' then
	return reply_msg(msg.id, 'پاک کننده پیام های طولانی غیرفعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_spam'] = 'no'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده پیام های طولانی غیرفعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده پیام های طولانی غیرفعال گردید', ok_cb, false)
end

elseif matches[2] == 'flood' then
 if data[tostring(target)]['settings']['lock_flood'] == 'no' then
	return reply_msg(msg.id, 'پاک کننده پیامهای مکرر غیرفعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_flood'] = 'no'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده پیامهای مکرر غیرفعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده پیامهای مکرر غیرفعال گردید', ok_cb, false)
end

elseif matches[2] == 'fa' then
if data[tostring(target)]['settings']['lock_arabic'] == 'no' then
	return reply_msg(msg.id, 'پاک کننده پیام های فارسی غیر فعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_arabic'] = 'no'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده پیامهای فارسی غیرفعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده پیام های فارسی غیر فعال گردید', ok_cb, false)
end

elseif matches[2] == 'en' then
if data[tostring(target)]['settings']['lock_en'] == 'no' then
	return reply_msg(msg.id, 'پاک کننده پیام های انگلیسی غیر فعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_en'] = 'no'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده پیام های انگلیسی غیرفعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده پیام های انگلیسی غیر فعال گردید', ok_cb, false)
end

elseif matches[2] == 'member' then
if to_super then
return false
end
if data[tostring(target)]['settings']['lock_member'] == 'no' then
	return reply_msg(msg.id, 'پاک کننده افراد دعوت شده غیر فعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_member'] = 'no'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده افراد دعوت شده غیرفعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده افراد دعوت شده غیر فعال گردید', ok_cb, false)
end

elseif matches[2] == 'tgservice' then
if data[tostring(target)]['settings']['lock_tgservice'] == 'no' then
	return reply_msg(msg.id, 'پاک کننده پیام های جوین،دعوت،ریمو،عوض کردن اسم و... غیر فعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_tgservice'] = 'no'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده پیام های جوین،دعوت،ریمو،عوض کردن اسم و... غیر فعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده پیام های جوین،دعوت،ریمو،عوض کردن اسم و... غیر فعال گردید', ok_cb, false)
end

elseif matches[2] == 'sticker' then
if data[tostring(target)]['settings']['lock_sticker'] == 'no' then
	return reply_msg(msg.id, 'پاک کننده استیکر غیر فعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_sticker'] = 'no'
	savelog(msg.to.id, "پاک کننده استیکر غیرفعال گردید توسط "..msg.from.print_name:gsub("_",""))
    save_data(config.moderation.data, data)
    return reply_msg(msg.id, 'پاک کننده استیکر غیر فعال گردید', ok_cb, false)
end

elseif matches[2] == 'share' then
if data[tostring(target)]['settings']['lock_contact'] == 'no' then
	return reply_msg(msg.id, 'پاک کننده شماره غیر فعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_contact'] = 'no'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده شماره غیرفعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده شماره غیر فعال گردید', ok_cb, false)
end

elseif matches[2] == 'photo' then
if data[tostring(target)]['settings']['lock_photo'] == 'no' then
	return reply_msg(msg.id, 'پاک کننده عکس غیر فعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_photo'] = 'no'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده عکس غیرفعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده عکس غیر فعال گردید', ok_cb, false)
end

elseif matches[2] == 'text' then
if data[tostring(target)]['settings']['lock_text'] == 'no' then
	return reply_msg(msg.id, 'پاک کننده چت(متن) غیر فعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_text'] = 'no'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده چت(متن) غیرفعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده چت(متن) غیر فعال گردید', ok_cb, false)
end

elseif matches[2] == 'audio' then
if data[tostring(target)]['settings']['lock_audio'] == 'no' then
	return reply_msg(msg.id, 'پاک کننده صدا غیر فعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_audio'] = 'no'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده صدا غیرفعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده صدا غیر فعال گردید', ok_cb, false)
end

elseif matches[2] == 'video' then
if data[tostring(target)]['settings']['lock_video'] == 'no' then
	return reply_msg(msg.id, 'پاک کننده فیلم غیر فعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_video'] = 'no'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده فیلم غیرفعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده فیلم غیر فعال گردید', ok_cb, false)
end

elseif matches[2] == 'file' then
if data[tostring(target)]['settings']['lock_document'] == 'no' then
	return reply_msg(msg.id, 'پاک کننده فایل غیر فعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_document'] = 'no'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده فایل غیرفعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده فایل غیر فعال گردید', ok_cb, false)
end

elseif matches[2] == 'gif' then
if data[tostring(target)]['settings']['lock_gif'] == 'no' then
	return reply_msg(msg.id, 'پاک کننده گیف(عکس متحرک) غیر فعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_gif'] = 'no'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده گیف(عکس متحرک) غیرفعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده گیف(عکس متحرک) غیر فعال گردید', ok_cb, false)
end

elseif matches[2] == 'fwd' then
if data[tostring(target)]['settings']['lock_fwd'] == 'no' then
	return reply_msg(msg.id, 'پاک کننده پیام های فوروارد غیر فعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_fwd'] = 'no'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده پیام های فوروارد غیرفعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده پیام های فوروارد غیر فعال گردید', ok_cb, false)
end

elseif matches[2] == 'bot' then
if data[tostring(target)]['settings']['lock_bot'] == 'no' then
	return reply_msg(msg.id, 'ضد ربات غیر فعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_bot'] = 'no'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "ضد ربات غیرفعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'ضد ربات غیر فعال گردید', ok_cb, false)
end

elseif matches[2] == 'join' then
if to_super then
return false
end
if data[tostring(target)]['settings']['lock_join'] == 'no' then
	return reply_msg(msg.id, 'پاک کننده افراد جوین دهنده با لینک غیر فعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_join'] = 'no'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده افراد جوین دهنده با لینک غیرفعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده افراد جوین دهنده با لینک غیر فعال گردید', ok_cb, false)
end

elseif matches[2] == 'reply' then
if data[tostring(target)]['settings']['lock_reply'] == 'no' then
	return reply_msg(msg.id, 'پاک کننده پیام های ریپلی(پاسخ) فعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_reply'] = 'no'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده پیام های ریپلی(پاسخ) غیرفعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده پیام های ریپلی(پاسخ) فعال گردید', ok_cb, false)
end

elseif matches[2] == 'tag' then
if data[tostring(target)]['settings']['lock_tag'] == 'no' then
	return reply_msg(msg.id, 'پاک کننده پیام های دارای تگ غیر فعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_tag'] = 'no'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده پیام های دارای تگ غیرفعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده پیام های دارای تگ غیر فعال گردید', ok_cb, false)
end

elseif matches[2] == 'unsup' then
if data[tostring(target)]['settings']['lock_unsup'] == 'no' then
	return reply_msg(msg.id, 'پاک کننده پیام های ناشناخته غیرفعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_unsup'] = 'no'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده  پیام های ناشناخته غیرفعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده پیام های ناشناخته غیر فعال گردید', ok_cb, false)
end

elseif matches[2] == 'all' and is_owner(msg) then
local hash = "unlockall:"..msg.from.id..":"..msg.to.id
local time = 1800
if redis:get(hash) then --and not is_sudo(msg)
unlockall = redis:pttl(hash)
base = math.floor(unlockall / 60000)
if base < 1 then
base = "چند"
end
return reply_msg(msg.id, "جناب با عرض پوزش شما در هر (<code>30</code>) دقیقه قادر به انلاک کردن همه قفل ها هستید\n(<b>"..base.."</b>) دقیقه دیگه امتحان کنید", ok_cb, false)
end
redis:setex(hash, tonumber(time), true)
local target = msg.to.id
if data[tostring(target)]['settings'] then
data[tostring(target)]['settings']['lock_link'] = 'no'
data[tostring(target)]['settings']['lock_arabic'] = 'no'
data[tostring(target)]['settings']['lock_en'] = 'no'
data[tostring(target)]['settings']['lock_member'] = 'no'
data[tostring(target)]['settings']['lock_tgservice'] = 'no'
data[tostring(target)]['settings']['lock_sticker'] = 'no'
data[tostring(target)]['settings']['lock_contact'] = 'no'
data[tostring(target)]['settings']['lock_photo'] = 'no'
data[tostring(target)]['settings']['lock_text'] = 'no'
data[tostring(target)]['settings']['lock_audio'] = 'no'
data[tostring(target)]['settings']['lock_video'] = 'no'
data[tostring(target)]['settings']['lock_document'] = 'no'
data[tostring(target)]['settings']['lock_gif'] = 'no'
data[tostring(target)]['settings']['lock_fwd'] = 'no'
data[tostring(target)]['settings']['lock_bot'] = 'no'
data[tostring(target)]['settings']['lock_join'] = 'no'
data[tostring(target)]['settings']['lock_reply'] = 'no'
data[tostring(target)]['settings']['lock_tag'] = 'no'
save_data(config.moderation.data, data)
local target = msg.to.id
    savelog(msg.to.id, "همه ی پاک کننده ها غیر فعال شدند توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, "همه ی پاک کننده ها غیر فعال شدند", ok_cb, false)
      end
   end
end
--------------------------------------------------#spam limit
if matches[1] == "limspam" and matches[2] and is_momod(msg) then
if tonumber(matches[2]) < 500 or tonumber(matches[2]) > 4000 then
return "عدد ورودی باید بین 500 تا 4000 باشد در غیر اینصورت از /UNLOCK SPAM استفاده کنید"
end
    data[tostring(chat_id)]['settings']['lock_numspam'] = tonumber(matches[2])
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "محدودیت پاک کننده پیام های طولانی تغییر کرد توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'محدودیت پاک کننده پیام های طولانی محدود شد به '..matches[2], ok_cb, false)
end
--------------------------------------------------#local settings delmsg from
if matches[1] == "lock" and is_momod(msg) then
local target = msg.to.id
if matches[2] == 'link' then
 if data[tostring(target)]['settings']['lock_link'] == 'yes' then
	return reply_msg(msg.id, 'پاک کننده لینک فعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_link'] = 'yes'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده لینک فعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده لینک فعال گردید', ok_cb, false)
end

elseif matches[2] == 'spam' then
if data[tostring(target)]['settings']['lock_spam'] == 'yes' then
	return reply_msg(msg.id, 'پاک کننده پیام های طولانی فعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_spam'] = 'yes'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده پیام های طولانی فعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده پیام های طولانی فعال گردید', ok_cb, false)
end

elseif matches[2] == 'flood' then
if data[tostring(target)]['settings']['lock_flood'] == 'yes' then
	return reply_msg(msg.id, 'پاک کننده پیامهای مکرر فعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_flood'] = 'yes'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده  پیامهای مکرر فعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده پیامهای مکرر فعال گردید', ok_cb, false)
end

elseif matches[2] == 'fa' then
if data[tostring(target)]['settings']['lock_arabic'] == 'yes' then
	return reply_msg(msg.id, 'پاک کننده پیام های فارسی فعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_arabic'] = 'yes'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده پیام های فارسی فعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده پیام های فارسی فعال گردید', ok_cb, false)
end

elseif matches[2] == 'en' then
if data[tostring(target)]['settings']['lock_en'] == 'yes' then
	return reply_msg(msg.id, 'پاک کننده پیام های انگلیسی فعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_en'] = 'yes'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده پیام های انگلیسی فعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده پیام های انگلیسی فعال گردید', ok_cb, false)
end

elseif matches[2] == 'member' then
if to_super then
return reply_msg(msg.id, 'این عملکرد در سوپر گروه ها مجاز نیست', ok_cb, false)
end
if data[tostring(target)]['settings']['lock_member'] == 'yes' then
	return reply_msg(msg.id, 'پاک کننده افراد دعوت شده فعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_member'] = 'yes'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده افراد دعوت شده فعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده افراد دعوت شده فعال گردید', ok_cb, false)
end

elseif matches[2] == 'tgservice' then
if data[tostring(target)]['settings']['lock_tgservice'] == 'yes' then
	return reply_msg(msg.id, 'پاک کننده پیام های جوین،دعوت،ریمو،عوض کردن اسم و... فعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_tgservice'] = 'yes'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده پیام های جوین،دعوت،ریمو،عوض کردن اسم و... فعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده پیام های جوین،دعوت،ریمو،عوض کردن اسم و... فعال گردید', ok_cb, false)
end

elseif matches[2] == 'sticker' then
if data[tostring(target)]['settings']['lock_sticker'] == 'yes' then
	return reply_msg(msg.id, 'پاک کننده استیکر فعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_sticker'] = 'yes'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده استیکر فعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده استیکر فعال گردید', ok_cb, false)
end

elseif matches[2] == 'share' then
if data[tostring(target)]['settings']['lock_contact'] == 'yes' then
	return reply_msg(msg.id, 'پاک کننده شماره فعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_contact'] = 'yes'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده شماره فعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده شماره فعال گردید', ok_cb, false)
end

elseif matches[2] == 'photo' then
if data[tostring(target)]['settings']['lock_photo'] == 'yes' then
	return reply_msg(msg.id, 'پاک کننده عکس فعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_photo'] = 'yes'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده عکس فعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده عکس فعال گردید', ok_cb, false)
end

elseif matches[2] == 'text' then
if data[tostring(target)]['settings']['lock_text'] == 'yes' then
	return reply_msg(msg.id, 'پاک کننده چت(متن) فعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_text'] = 'yes'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده چت(متن) فعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده چت(متن) فعال گردید', ok_cb, false)
end

elseif matches[2] == 'audio' then
if data[tostring(target)]['settings']['lock_audio'] == 'yes' then
	return reply_msg(msg.id, 'پاک کننده صدا فعال است', ok_cb, false) 
	else
    data[tostring(target)]['settings']['lock_audio'] = 'yes'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده صدا فعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده صدا فعال گردید', ok_cb, false) 
end

elseif matches[2] == 'video' then
if data[tostring(target)]['settings']['lock_video'] == 'yes' then
	return reply_msg(msg.id, 'پاک کننده فیلم فعال است', ok_cb, false) 
	else
    data[tostring(target)]['settings']['lock_video'] = 'yes'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده فیلم فعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده فیلم فعال گردید', ok_cb, false) 
end

elseif matches[2] == 'file' then
if data[tostring(target)]['settings']['lock_document'] == 'yes' then
	return reply_msg(msg.id, 'پاک کننده فایل فعال است', ok_cb, false) 
	else
    data[tostring(target)]['settings']['lock_document'] = 'yes'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده فایل فعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده فایل فعال گردید', ok_cb, false) 
end

elseif matches[2] == 'gif' then
if data[tostring(target)]['settings']['lock_gif'] == 'yes' then
	return reply_msg(msg.id, 'پاک کننده گیف(عکس متحرک) فعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_gif'] = 'yes'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده گیف(عکس متحرک) فعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده گیف(عکس متحرک) فعال گردید', ok_cb, false) 
end

elseif matches[2] == 'fwd' then
if data[tostring(target)]['settings']['lock_fwd'] == 'yes' then
	return reply_msg(msg.id, 'پاک کننده پیام های فوروارد فعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_fwd'] = 'yes'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده پیام های فوروارد فعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده پیام های فوروارد فعال گردید', ok_cb, false)
end

elseif matches[2] == 'bot' then
if data[tostring(target)]['settings']['lock_bot'] == 'yes' then
	return reply_msg(msg.id, 'ضد ربات فعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_bot'] = 'yes'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "ضد ربات فعال گردید توسط "..msg.from.print_name:gsub("_",""))
	channel_get_bots(receiver, clean_bots3, {msg = msg})
    return reply_msg(msg.id, 'ضد ربات فعال گردید', ok_cb, false)
end

elseif matches[2] == 'join' then
if to_super then
return reply_msg(msg.id, 'این عملکرد در سوپر گروه ها مجاز نیست', ok_cb, false)
end
if data[tostring(target)]['settings']['lock_join'] == 'yes' then
	return reply_msg(msg.id, 'پاک کننده افراد جوین دهنده با لینک فعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_join'] = 'yes'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده افراد جوین دهنده با لینک فعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده افراد جوین دهنده با لینک فعال گردید', ok_cb, false)
end

elseif matches[2] == 'reply' then
if data[tostring(target)]['settings']['lock_reply'] == 'yes' then
	return reply_msg(msg.id, 'پاک کننده پیام های ریپلی(پاسخ) فعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_reply'] = 'yes'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده پیام های ریپلی(پاسخ) فعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده پیام های ریپلی(پاسخ) فعال گردید', ok_cb, false)
end

elseif matches[2] == 'tag' then
if data[tostring(target)]['settings']['lock_tag'] == 'yes' then
	return reply_msg(msg.id, 'پاک کننده پیام های دارای تگ فعال گردید', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_tag'] = 'yes'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده  پیام های دارای تگ فعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده پیام های دارای تگ فعال گردید', ok_cb, false)
end

elseif matches[2] == 'unsup' then
if data[tostring(target)]['settings']['lock_unsup'] == 'yes' then
	return reply_msg(msg.id, 'پاک کننده پیام های ناشناخته فعال است', ok_cb, false)
	else
    data[tostring(target)]['settings']['lock_unsup'] = 'yes'
    save_data(config.moderation.data, data)
	savelog(msg.to.id, "پاک کننده  پیام های ناشناخته فعال گردید توسط "..msg.from.print_name:gsub("_",""))
    return reply_msg(msg.id, 'پاک کننده پیام های ناشناخته فعال گردید', ok_cb, false)
   end
   end
end
--------------------------------------------------#echo 
if matches[1] == "echo" then
if msg.reply_id then
 local text = matches[2]
  local b = 1
  while b ~= 0 do
    text = text:trim()
    text,b = text:gsub('^!+','')
    text,b = text:gsub('^/+','')
    text,b = text:gsub('^#+','')
	text,b = text:gsub('kickme','نکن بچه :)')
  end
   savelog(msg.to.id, "درخواست تکرار متن شد توسط "..msg.from.print_name:gsub("_",""))
   reply_msg(msg.reply_id, "متن شما :\n\n"..text, ok_cb, false)
   end

 if not msg.reply_id then
  local text = matches[2]
  local b = 1
  while b ~= 0 do
    text = text:trim()
    text,b = text:gsub('^!+','')
    text,b = text:gsub('^/+','')
    text,b = text:gsub('^#+','')
	text,b = text:gsub('kickme','نکن بچه :)')
  end
  savelog(msg.to.id, "درخواست تکرار متن شد توسط "..msg.from.print_name:gsub("_",""))
  return "متن شما :\n\n"..text
  end
end
--------------------------------------------------#vardump
if matches[1] == "vardump" then
if type(msg.reply_id) ~= "nil" then
		 local function vardump_reply2(extra , success, result)
          return reply_msg(extra.msg.id, serpent.block(result, {comment = false}), ok_cb, false)
        end
		  get_message(msg.reply_id, vardump_reply2, {msg = msg})
else
   return reply_msg(msg.id, serpent.block(msg, {comment = false}), ok_cb, false)
end
end
if matches[1] == "vardump2" then
if type(msg.reply_id) ~= "nil" then
		 local function vardump_reply2(extra , success, result)
          return reply_msg(extra.msg.id, vardump2(result), ok_cb, false)
        end
		  get_message(msg.reply_id, vardump_reply2, {msg = msg})
else
   return reply_msg(msg.id, serpent.block(msg, {comment = false}), ok_cb, false)
end
end
--------------------------------------------------#welcome settings
  if matches[1] == 'wlc' and matches[2] == "on" and is_momod(msg) then
     if data[tostring(chat_id)]['settings']['wlc'] == 'on' then
        reply_msg(msg.id, 'پیام خوش امدگویی فعال است', ok_cb, false)
     else
        data[tostring(chat_id)]['settings']['wlc'] = 'on'
        save_data(config.moderation.data, data)
		savelog(msg.to.id, "پیام خوش امدگویی فعال گردید توسط "..msg.from.print_name:gsub("_",""))
        return reply_msg(msg.id, "پیام خوش امدگویی فعال گردید", ok_cb, false)
    end
  end
  if matches[1] == 'wlc' and matches[2] == "off" and is_momod(msg) then
	 if data[tostring(chat_id)]['settings']['wlc'] == 'off' then 
        reply_msg(msg.id, 'پیام خوش امدگویی غیرفعال است', ok_cb, false)
     else
        data[tostring(chat_id)]['settings']['wlc'] = 'off'
        save_data(config.moderation.data, data)
		savelog(msg.to.id, "پیام خوش امدگویی غیرفعال گردید توسط "..msg.from.print_name:gsub("_",""))
        return reply_msg(msg.id, "پیام خوش امدگویی غیرفعال گردید", ok_cb, false)
    end
end
 if matches[1] == 'setwlc' and matches[2] and is_momod(msg) then
        if data[tostring(chat_id)]['settings']['wlc'] == 'off' then
		return reply_msg(msg.id, 'پیام خوش امدگویی غیرفعال است\nبا <b>WLC ON </b> فعال کنید', ok_cb, false)
		end
        data[tostring(chat_id)]['group_wlc'] = string.gsub(msg.text:gsub("[!/#][Ss][Ee][Tt][Ww][Ll][Cc]", " "), '_', '') or string.gsub(msg.text:gsub("[Ss][Ee][Tt][Ww][Ll][Cc]", " "), '_', '')
        save_data(config.moderation.data, data)
		savelog(msg.to.id, "متن پیام خوش امدگویی تغییر کرد توسط "..msg.from.print_name:gsub("_",""))
        return reply_msg(msg.id, "متن پیام خوش امدگویی تغییر کرد", ok_cb, false)
end
 if matches[1] == 'delwlc' and is_momod(msg) then
        if data[tostring(chat_id)]['settings']['wlc'] == 'off' then
		   return reply_msg(msg.id, 'پیام خوش امدگویی غیرفعال است\nبا <b>WLC ON </b> فعال کنید', ok_cb, false)
		end
        data[tostring(chat_id)]['group_wlc'] = nil
        save_data(config.moderation.data, data)
		savelog(msg.to.id, "متن پیام خوش امدگویی حذف شد توسط "..msg.from.print_name:gsub("_",""))
        return reply_msg(msg.id, "متن پیام خوش امدگویی حذف شد", ok_cb, false)
end
--------------------------------------------------#warn
if matches[1] == 'warn' and is_momod(msg) then
    if type(msg.reply_id)~="nil" then
      local function warn_reply(extra , success, result)
		  if not result.from.username then
		  names = result.from.print_name:gsub("_", " ")
		  else
		  names = "@"..result.from.username
		  end
		  local user_id = result.from.peer_id
		  local chat_id = result.to.peer_id
		  if is_momod2(user_id, chat_id) then
		  return reply_msg(msg.id, names.." ایشان دارای مقام است", ok_cb, false)
		  end
		  text = "<code>شما بدلیل اخطار های مکرر و عدم توجه به آنها ریمو میشوید</code>"
          return warn_user(extra.msg.reply_id, names, text, user_id, chat_id)
        end
        return get_message(msg.reply_id, warn_reply, {msg = msg})
	  elseif matches[1] == 'warn' and matches[2] and string.match(matches[2], '^%d+$') then
	       text = "<code>بدلیل اخطار های مکرر و عدم توجه به آنها ریمو شد</code>"
        return warn_user(msg.id, matches[2], text, matches[2], msg.to.id)
      elseif matches[1] == 'warn' and matches[2] and not string.match(matches[2], '^%d+$') then
		 local function warn_username(extra , success, result)
		 if success == 0 then
		return false
	  end
		       if success == 0 then
                  return false
               end
		 local names = "@"..result.username
		 local user_id = result.peer_id
		 if is_momod2(user_id, extra.chat_id) then
		  return reply_msg(msg.id, names.." ایشان دارای مقام است", ok_cb, false)
		  end
		 text = "<code>بدلیل اخطار های مکرر و عدم توجه به آنها ریمو شد</code>"
         return warn_user(extra.msg.id, names, text, user_id, extra.chat_id)
        end
		local username = string.gsub(matches[2], '@', '')
		return resolve_username(username, warn_username, {msg = msg, chat_id = chat_id})
    end
  end
--------------------------------------------------#unwarn 
if matches[1] == 'unwarn' and is_momod(msg) then
    if type(msg.reply_id)~="nil" then
      local function unwarn_reply(extra , success, result)
		  if not result.from.username then
		  names = result.from.print_name:gsub("_", " ")
		  else
		  names = "@"..result.from.username
		  end
		  local user_id = result.from.peer_id
		  local chat_id = result.to.peer_id
          return unwarn_user(extra.msg.id, names, user_id, chat_id)
        end
        return get_message(msg.reply_id, unwarn_reply, {msg = msg})
	  elseif matches[1] == 'unwarn' and matches[2] and string.match(matches[2], '^%d+$') then
        return unwarn_user(msg.id, matches[2], matches[2], msg.to.id)
      elseif matches[1] == 'unwarn' and matches[2] and not string.match(matches[2], '^%d+$') then
		 local function unwarn_username(extra, success, result)
		       if success == 0 then
                  return false
               end
		 local names = "@"..result.username
		 local user_id = result.peer_id
		 local chat_id = extra.chat_id
         return unwarn_user(extra.msg.id, names, user_id, chat_id)
        end
		local username = string.gsub(matches[2], '@', '')
		return resolve_username(username, unwarn_username, {msg = msg, chat_id = chat_id})
    end
  end
--------------------------------------------------#unwarnall
if matches[1] == 'unwarnall' and is_momod(msg) then
    if type(msg.reply_id)~="nil" then
      local function unwarnall_reply(extra , success, result)
		  if not result.from.username then
		  names = result.from.print_name:gsub("_", " ")
		  else
		  names = "@"..result.from.username
		  end
		  local user_id = result.from.peer_id
		  local chat_id = result.to.peer_id
		  local warns = 'warns'..bot_divest..':'..chat_id..':'..user_id
		  local warns2 = redis:get(warns)
		  if not warns2 then
		   return reply_msg(extra.msg.reply_id, names.." تاکنون اخطاری دریافت نکرده است", ok_cb, false)
		else
		   if tonumber(warns2) == 0 then
		    return reply_msg(extra.msg.reply_id, names.." تاکنون اخطاری دریافت نکرده است", ok_cb, false)
		   end
           redis:del(warns)
		   local text = "<code>تمام اخطار های شما نادیده گرفته شدند</code>\nموفق باشید"
           return reply_msg(extra.msg.reply_id, text, ok_cb, false)
        end
	 end
        return get_message(msg.reply_id, unwarnall_reply, {msg = msg})
elseif matches[1] == 'unwarnall' and matches[2] and string.match(matches[2], '^%d+$') then
	      local user_id= tonumber(matches[2])
	      local warns = 'warns'..bot_divest..':'..chat_id..':'..user_id
		  local warns2 = redis:get(warns)
        if not warns2 then
		   return reply_msg(msg.id, user_id.." تاکنون اخطاری دریافت نکرده است", ok_cb, false)
		else
		   if tonumber(warns2) == 0 then
		    return reply_msg(msg.id, user_id.." تاکنون اخطاری دریافت نکرده است", ok_cb, false)
		   end
           redis:del(warns)
		  local text = "تمام اخطار های "..user_id.." نادیده گرفته شدند"
           return reply_msg(msg.id, text, ok_cb, false)
        end 
      elseif matches[1] == 'unwarnall' and matches[2] and not string.match(matches[2], '^%d+$') then
		 local function unwarnall_username(extra , success, result)
		       if success == 0 then
                  return false
               end
		 local names = "@"..result.username
		 local user_id = result.peer_id
          local warns = 'warns'..bot_divest..':'..chat_id..':'..user_id
		  local warns2 = redis:get(warns)
		  if not warns2 then
		   return reply_msg(msg.id, names.." تاکنون اخطاری دریافت نکرده است", ok_cb, false)
		else
		   if tonumber(warns2) == 0 then
		    return reply_msg(msg.id, names.." تاکنون اخطاری دریافت نکرده است", ok_cb, false)
		   end
          redis:del(warns)
		  local text = "<code>تمام اخطار های شما نادیده گرفته شدند</code>\nموفق باشید"
           return reply_msg(extra.msg.id, text, ok_cb, false)
          end
        end

		local username = string.gsub(matches[2], '@', '')
		return resolve_username(username, unwarnall_username, {msg = msg, chat_id = chat_id})
    end
  end
--------------------------------------------------#help bot
if matches[1] == "help" and is_momod(msg) then
   savelog(msg.to.id, "راهنمای اصلی درخواست شد توسط "..msg.from.print_name:gsub("_",""))
   return reply_msg(msg.id, help.help, ok_cb, false)
   elseif matches[1] == "shelp" and is_momod(msg) then
   savelog(msg.to.id, "راهنمای ستینگز درخواست شد توسط "..msg.from.print_name:gsub("_",""))
   return reply_msg(msg.id, help.shelp, ok_cb, false)
   elseif matches[1] == "lhelp" and is_momod(msg) then
   savelog(msg.to.id, "راهنمای لیست ها درخواست شد توسط "..msg.from.print_name:gsub("_",""))
   return reply_msg(msg.id, help.lhelp, ok_cb, false)
   elseif matches[1] == "mhelp" and is_momod(msg) then
   savelog(msg.to.id, "راهنمای مدیریتی درخواست شد توسط "..msg.from.print_name:gsub("_",""))
   return reply_msg(msg.id, help.mhelp, ok_cb, false)
   elseif matches[1] == "ahelp" and is_momod(msg) then
   savelog(msg.to.id, "راهنمای همه درخواست شد توسط "..msg.from.print_name:gsub("_",""))
   return reply_msg(msg.id, help.ahelp, ok_cb, false)
   elseif matches[1] == "fhelp" and is_momod(msg) then
   savelog(msg.to.id, "راهنمای سرگرمی درخواست شد توسط "..msg.from.print_name:gsub("_",""))
   return reply_msg(msg.id, help.fhelp, ok_cb, false)
end
-------------------------------------------#filter list
if matches[1] == "filter" and matches[2] == '+' and is_momod(msg) then
  local name = string.sub(matches[3], 1, 50)
  local text = addword(msg, name)
  savelog(msg.to.id, "ممنوعیت یک کلمه درخواست شد توسط "..msg.from.print_name:gsub("_",""))
  return text
  end
  if matches[1] == 'filterlist' and is_momod(msg) then
  savelog(msg.to.id, "لیست کلمات فیلتر لیست درخواست شد توسط "..msg.from.print_name:gsub("_",""))
  return list_variablesbad(msg)
  elseif matches[1] == "filter" and matches[2] == '-' and is_momod(msg) then
  savelog(msg.to.id, "رفع ممنوعیت یک کلمه درخواست شد توسط "..msg.from.print_name:gsub("_",""))
    return clear_commandsbad(msg, matches[3])
  end
--------------------------------------------------#center warn control
if matches[1] == "setwarn" and is_momod(msg) then
if not is_owner(msg) then
return reply_msg(msg.id, 'برای تنظیم این قفل به مقام صاحب گروه(owner) نیاز است', ok_cb, false)
end
local mwarn = tonumber(matches[2])
if mwarn < 2 or mwarn > 10 then
   return "خطا!!\nعدد ورودی باید بین 3 تا 10 باشد"
end
redis:set("mwarn"..bot_divest..":"..msg.to.id, mwarn)
savelog(msg.to.id, "محدودیت اخطار ها به کاربر تغییر کرد توسط "..msg.from.print_name:gsub("_",""))
return send_large_msg(receiver, 'محدودیت اخطار ها به کاربر تغییر کرد به <b>'..mwarn..'</b>\n<code>این مقدار محدودیت هم برای اخطار کاربر و اخطار هر قفل استفاده میشود</code>', ok_cb, false)
end

if matches[1] == 'warn' and is_momod(msg) and not matches[2] then
if type(msg.reply_id) ~= "nil" then
return 
end
local mwarn = redis:get("mwarn"..bot_divest..":"..chat_id)
if not mwarn then
		mwarn = 4
	else 
		mwarn = redis:get("mwarn"..bot_divest..":"..chat_id)
	end
return send_large_msg(receiver, 'محدودیت اخطار ها به کاربر<b> '..mwarn..' </b>میباشد', ok_cb, false)
end

if matches[1] == "settings" and matches[2] == "lock" then
  local gwarns = 'warnall'..bot_divest..'*'

local mwarn = redis:get("mwarn"..bot_divest..":"..chat_id)
	if not mwarn then
		mwarn = 4
	else 
		mwarn = redis:get("mwarn"..bot_divest..":"..chat_id)
	end
   if data[tostring(chat_id)]['settings']['lock_settings'] == 'yes' then 
      reply_msg(msg.id, 'تنظمات سختگیرانه فعال است', ok_cb, false)
   else
   data[tostring(chat_id)]['settings']['lock_settings'] = 'yes'
   save_data(config.moderation.data, data)
   redis:del(gwarns)
   savelog(msg.to.id, "تنظیمات سخت گیرانه فعال شد توسط "..msg.from.print_name:gsub("_",""))
   return reply_msg(msg.id, 'تنظیمات سخت گیرانه فعال شد \nکاربران بعد '..mwarn..' بار تکرار عدم رعایت تنظیمات ریمو میشوند\nبا setwarn مقدار را میتوانید تغییر دهید', ok_cb, false)
  end
end

if matches[1] == "settings" and matches[2] == "unlock" then
   if data[tostring(chat_id)]['settings']['lock_settings'] == 'no' then 
      reply_msg(msg.id, 'تنظمات سختگیرانه غیرفعال است', ok_cb, false)
   else
   data[tostring(chat_id)]['settings']['lock_settings'] = 'no'
   save_data(config.moderation.data, data)
   savelog(msg.to.id, "تنظیمات سخت گیرانه غیرفعال شد توسط "..msg.from.print_name:gsub("_",""))
   return reply_msg(msg.id, 'تنظیمات سخت گیرانه غیرفعال شد', ok_cb, false)
  end
end
--------------------------------------------------#HTML
if matches[1] == 'bold' then
local mtn = msg.text:gsub("bold", "")
  return reply_msg(msg.id, 'متن شما :\n\n <b>'..mtn..'</b>', ok_cb, false)

elseif matches[1] == 'code' then
local mtn = msg.text:gsub("code", "")
  return reply_msg(msg.id, 'متن شما :\n\n <code>'..mtn..'</code>', ok_cb, false)

elseif matches[1] == 'hyper' then
local mtn = matches[2]
local link = matches[3]
  return reply_msg(msg.id, 'متن شما :\n\n <a href="'..link..'">'..mtn..'</a>', ok_cb, false)
elseif matches[1] == 'italic' then
  return reply_msg(msg.id, 'متن شما :\n\n <i>'..mtn..'</i>', ok_cb, false)
end
--------------------------------------------------#info
if matches[1] == "info" and not msg.reply_id and not matches[2] then
local hashs = 'pic:'..msg.from.id
if msg.to.type == "user" then
return "فقط در گروه یا سوپر گروه فعال میباشد"
end
if redis:get(hashs) and not is_sudo(msg) then
return false
end

redis:setex(hashs, 60, true)
     local user_id = msg.from.id
    local chat_id = get_receiver(msg)
    local token = "235431064:AAGBQAJj9T070Kax_HB9Chwzf-w6fgqcTuU"
    local db = 'https://api.telegram.org/bot'..token..'/getUserProfilePhotos?user_id='..user_id
    local path = 'https://api.telegram.org/bot'..token..'/getFile?file_id='
    local img = 'https://api.telegram.org/file/bot'..token..'/'
    local res, code = https.request(db)
    local jdat = json:decode(res)
	 local count = jdat.result.total_count
	if tonumber(count) == 0 then
	photo = "./data/stickers/telegram.jpg"
elseif tonumber(count) > 0 then
	  local fileid = jdat.result.photos[1][3].file_id
      local count = jdat.result.total_count
      local pt, code = https.request(path..fileid)
      local jdat2 = json:decode(pt)
      local path2 = jdat2.result.file_path
      local link = img..path2
      photo = download_to_file(link,"ax"..user_id..".jpg")
end
      local name1 = string.gsub(msg.from.print_name, "_", " ")
	  if string.len(name1) > 100 then
	  name1 = "❌ Too long name ❌"
	  else
	  name1 = name1
	  end
      local name2 = name1:sub(0, 100)
      local value = redis:hget('rank:variables', msg.from.id)
      local RANK = ''
 		 if not value then
		 RANK = " "
		 else
		 RANK = "\nRank: "..value
         end
	 if is_sudo2(msg.from.id) then
	 Place = "\nPosition: ".."سازنده ربات"
	 elseif is_admin2(msg.from.id) then
	 Place = "\nPosition: ".."ادمین ربات"
	 elseif is_owner2(msg.from.id, msg.to.id) then
	 Place = "\nPosition: ".."صاحب گروه"
	 elseif is_momod2(msg.from.id, msg.to.id) then
	 Place = "\nPosition: ".."مدیر گروه"
	 else
	 Place = "\nPosition: ".."عادی"
	 end
     local uhash = 'user:'..msg.from.id
 	 local user = redis:hgetall(uhash)
  	 local um_hash = 'msgs:'..msg.from.id..':'..msg.to.id
	 usermsgs = tonumber(redis:get(um_hash) or 0)
      local msgss = tonumber(chat_stat2(msg.to.id, msg.to.type) or 0)
	  local tg = ((usermsgs / msgss) * 100)

	  local percent = tonumber(math.ceil(tg))
   if not msg.from.username then
   userns = " "
   else
   userns = "\nUsername: ".." @"..msg.from.username
   end
   if count == 0 then
   profs = ""
   else
   profs = "\nProfs: "..count
   end
   cap = "Name: "..name2
       .."\n\nID: "..msg.from.id
	   ..userns
	   ..RANK
	   ..Place
	   ..profs
	   .."\nMsgs: "..usermsgs
	   .." ("..percent.."%)".." of "..msgss
     return send_photo2(chat_id, photo, cap, ok_cb, false)
end
--------------------------------------------------#list owners groups
 if matches[1] == 'groups owner' and is_sudo(msg) then

	local groups = 'groups'
	if not data[tostring(groups)] then
		return 'No groups at the moment'
	end
	local message = '\n'
	for k,v in pairs(data[tostring(groups)]) do
		if data[tostring(v)] then
			if data[tostring(v)]['settings'] then
			local settings = data[tostring(v)]['settings']
				for m,n in pairs(settings) do
					if m == 'set_name' then
						name = n
					end
				end
                local group_owner = "\n"
                if data[tostring(v)]['set_owner'] then
                        group_owner = tostring(data[tostring(v)]['set_owner'])
                end

				message = message..group_owner
			end
		end
	end
	return message
end
--------------------------------------------------#hammer
   if matches[1] == 'hammer' and is_admin1(msg)  then
   if not is_sudo(msg) then
      return " برای انجام این دستور به مقام سودو ربات نیاز است"
   end
    if type(msg.reply_id)~="nil" then
      local function hammer_reply(extra , success, result)
		  if not result.from.username then
		  names = result.from.print_name:gsub("_", " ")
		  else
		  names = "@"..result.from.username
		  end
		  local user_id = result.from.peer_id
		  local group_id = result.to.peer_id
		  if is_admin2(user_id, group_id) then
		  return reply_msg(extra.msg.id, names.." ایشان داری مقام ادمین است", ok_cb, false)
		  end
          if is_divest(user_id) then
		  return reply_msg(extra.msg.reply_id, names.." در لیست خلع وجود دارد", ok_cb, false)
		  end
		  block_user("user#id"..user_id, ok_cb, false)
          divest(user_id)
		  kick_user(user_id, group_id)
          local text = names.." [ "..result.from.peer_id.." ] از یوبی خلع گردید"
          return reply_msg(extra.msg.reply_id, text, ok_cb, false)
        end
       return get_message(msg.reply_id, hammer_reply, {msg = msg})
    elseif matches[1] == 'hammer' and matches[2] and string.match(matches[2], '^%d+$') then
        if not is_admin1(msg) and is_momod(msg) then
          	return "ایشان ادمین یا مدیر گروه است."
        end
        if is_divest(matches[2]) then
		  return reply_msg(msg.id, matches[2].." در لیست خلع وجود دارد", ok_cb, false)
		end
		 block_user("user#id"..matches[2], ok_cb, false)
        divest(matches[2])
		kick_user(matches[2], msg.to.id)
		send_large_msg(receiver, '[ '..matches[2]..' ] از گروه های یوبی محروم شد')
      elseif matches[1] == 'hammer' and matches[2] and not string.match(matches[2], '^%d+$') then
		 local function hammer_username(extra , success, result)
		 if success == 0 then
		return send_large_msg(receiver, "❌ یوزرنیم مورد نظر یافت نشد یا اشتباه است ❌")
	  end
		 local names = "@"..result.username
		 local user_id = result.peer_id
		  if is_admin2(user_id, group_id) then
		  return reply_msg(extra.msg.id, names.." ایشان داری مقام ادمین است", ok_cb, false)
		  end
		  if is_divest(user_id) then
		  return reply_msg(extra.msg.id, names.." در لیست خلع وجود دارد", ok_cb, false)
		  end
		   block_user("user#id"..user_id, ok_cb, false)
		 divest(user_id)
		 kick_user(user_id, extra.chat_id)
         local text = names.." از یوبی خلع گردید"
         return reply_msg(extra.msg.id, text, ok_cb, false)
        end

		local username = string.gsub(matches[2], '@', '')
		return resolve_username(username, hammer_username, {msg = msg, chat_id = chat_id})
    end
  end
--------------------------------------------------#unhammer
  if matches[1] == 'unhammer' and is_admin1(msg) then
   if not is_sudo(msg) then
      return " برای انجام این دستور به مقام سودو ربات نیاز است"
   end
    if type(msg.reply_id)~="nil" then
      local function unhammer_reply(extra , success, result)
		  if not result.from.username then
		  names = result.from.print_name:gsub("_", " ")
		  else
		  names = "@"..result.from.username
		  end
		  local user_id = result.from.peer_id
          if not is_divest(user_id) then
		  return reply_msg(extra.msg.reply_id, names.." در لیست خلع وجود ندارد", ok_cb, false)
		  end
		   unblock_user("user#id"..user_id, ok_cb, false)
          undivest(user_id)
          local text = names.." [ "..result.from.peer_id.." ] از خلع خارج شد"
          return reply_msg(extra.msg.reply_id, text, ok_cb, false)
        end
        return get_message(msg.reply_id, unhammer_reply, {msg = msg})
    elseif matches[1] == 'unhammer' and matches[2] and string.match(matches[2], '^%d+$') then
        if not is_divest(matches[2]) then
		  return reply_msg(msg.id, matches[2].." در لیست خلع وجود ندارد", ok_cb, false)
		  end
		   unblock_user("user#id"..matches[2], ok_cb, false)
        undivest(matches[2])
		send_large_msg(receiver, '[ '..matches[2]..' ] از خلع خارج شد')
      elseif matches[1] == 'unhammer' and matches[2] and not string.match(matches[2], '^%d+$') then
		 local function unhammer_username(extra , success, result)
		 if success == 0 then
		return send_large_msg(receiver, "❌ یوزرنیم مورد نظر یافت نشد یا اشتباه است ❌")
	  end
		 local names = "@"..result.username
		 local user_id = result.peer_id
		  if not is_divest(user_id) then
		  return reply_msg(extra.msg.id, names.." در لیست خلع وجود ندارد", ok_cb, false)
		  end
		   block_user("user#id"..user_id, ok_cb, false)
		 undivest(user_id)
         local text = names.." از خلع خارج شد"
         return reply_msg(extra.msg.id, text, ok_cb, false)
        end

		local username = string.gsub(matches[2], '@', '')
		return resolve_username(username, unhammer_username, {msg = msg})
    end
  end
--------------------------------------------------#
if matches[1] == "pvclean" and is_sudo(msg) then
local hash = "pvusers"
redis:del(hash)
end
--------------------------------------------------#whois
if matches[1] == 'whois' and matches[2] and string.match(matches[2], '^%d+$') then
	local function whois(extra, success, result)
	if success == 0 then
	return reply_msg(extra.msg.id, "شناسه نامعتبر است", ok_cb, false)
   end
		if result.username then
			names = "نام کاربری شناسه @"..result.username
		else
	        names = "نام شناسه "..string.gsub(result.print_name, '_', ' ')
		end
		 return reply_msg(extra.msg.id, names, ok_cb, false)
   end
		 local user_id = "user#id"..matches[2]
		 return user_info(user_id, whois, {chat_id = chat_id, msg = msg})
end
--------------------------------------------------#kickmember
if matches[1] == 'kickmember' and is_momod(msg) and redis:get('kmember'..bot_divest..':'..msg.to.id) == nil then
       redis:set('kmember'..bot_divest..':'..msg.to.id, "waite")
       return send_large_msg(receiver, 'حالا پیام شخص مورد نظر را فوروارد کنید')
elseif matches[1] == 'kickmember' and is_momod(msg) and redis:get('kmember'..bot_divest..':'..msg.to.id) == "waite" then
       return send_large_msg(receiver,"شما قبلا در خواست کرده ایید لطفا پیام کاربر مورد نظر را فور وراد کنید دهید" )
end
--------------------------------------------------#setuwername
if matches[1] == "setusername" and is_admin1(msg) then
			local function ok_username_cb (extra, success, result)
				if success == 1 then
					send_large_msg(receiver, "انجام شد")
				elseif success == 0 then
					send_large_msg(receiver, "خطا")
				end
			end
			local username = string.gsub(matches[2], '@', '')
			channel_set_username(receiver, username, ok_username_cb, {receiver=receiver})
		end
--------------------------------------------------#nerkh
if matches[1] == "nerkh" and not nerkh(msg.from.id) then
local text = [[ربات ضد اسپم و ضد لینک یوبی

<b> تضمین 24 ساعت انلاینی ربات</b>

<code>دارای بهترین سورس و کامل ترین امکانات </code>

اگر قصد خرید این ربات را دارید به پی وی @ValtMan مراجعه کنید 

و اگر ریپورت هستید با @UBsupbot در ارتباط باشید

بات های معمولی به قیمت 8000 تومان 
بات های ویژه به قیمت 10000 تومان 
بات های VIP به قیمت 15000 تومان

<i>بصورت شارژ ایرانسل یا کارت به کارت قابل پرداخت است </i>

شماره حساب :
<b> 6037 9971 6923 1801 </b>
مالک حساب : رامین هرندی

<i>** اعتماد شما ، عمل ماست **</i>
]]
local users = 'pvusers2'
redis:sadd(users, msg.from.id)
if msg.reply_id then
return reply_msg(msg.reply_id, text, ok_cb, false)
else
return reply_msg(msg.id, text, ok_cb, false)
end
end
if matches[1] == "expire" and is_momod(msg) then
  for date, values in pairs(cronned) do
      return os.date("%x تا %H:%M:%S", date).."\n توسط "..redis:hget(receiver, "expire")
  end

end

if matches[1] == "nexpire" and is_sudo(msg) then
redis:del("expire"..msg.to.id, true)
return "گروه نامحدود شد"
end

if matches[1] == "feedback" and not msg.fwd_from then
      --[[if redis:get("feedback:"..msg.from.id) then
	  return "در هر 12 ساعت قادر به ارسال فیدبک برای سازنده هستید"
	  end]]
      if string.len(msg.text) < 100 then
	     return " متن فیدبک شما باید  دارای حداقل 100 کلمه باشد"
	  end
      for v,user in pairs(config.sudo_users) do
          --send_msg("user#id"..user, matches[2], ok_cb, false)
          fwd_msg("user#id"..user, msg.id, ok_cb, false)
      end
	  --redis:setex("feedback:"..msg.from.id, (3600 * 12), true)
	  return send_large_msg(receiver, "پیام شما برای سازنده ارسال شد\nبا تشکر از نظرات شما")
end
--------------------------------------------------#
--------------------------------------------------#
--------------------------------------------------#
--------------------------------------------------#
--------------------------------------------------#
--------------------------------------------------#
--------------------------------------------------#
--------------------------------------------------#
--------------------------------------------------#
--------------------------------------------------#
--------------------------------------------------#
--------------------------------------------------#
--------------------------------------------------#
--------------------------------------------------#





end
--------------------------------------------------#process -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function pre_process(msg)
 if not data[tostring(msg.to.id)] then
 return msg
 end
  if msg.from.id == our_id then
    return msg
  end

  if msg.to.type == 'chat' then
    redis:sadd('chat:'..msg.to.id..':users', msg.from.id)
  end
  if msg.to.type == 'channel' then
    redis:sadd('channel:'..msg.to.id..':users', msg.from.id)
  end

  if redis:get("expire"..msg.to.id) and data[tostring(msg.to.id)] and msg.to.type == "channel" and not is_admin1(msg) then
            if msg.text and is_momod(msg) and is_pattern(receiver, msg) then
		          return send_msg(receiver, "ربات در گروه شما به انقضا رسیده است و فقط ادمین های ربات قادر به فعال کردن هستند\nنسبت به تمدید اقدام کنید", ok_cb, false)
			end
      return false
  end

  if data[tostring(msg.to.id)] and msg.text and msg.text:lower() == "bot on" and is_owner(msg) then
  if redis:get("expire"..msg.to.id) == true and not is_admin1(msg) then
     return "ربات در گروه شما به انقضا رسیده است و فقط ادمین های ربات قادر به فعال کردن هستند\nنسبت به تمدید اقدام کنید"
  end
	                enable_channel(receiver)
  elseif data[tostring(msg.to.id)] and msg.text and msg.text:lower() == "bot off" and is_owner(msg) then
  if redis:get("expire"..msg.to.id) == true and not is_admin1(msg) then
     return "ربات در گروه شما به انقضا رسیده است و فقط ادمین های ربات قادر به فعال کردن هستند\nنسبت به تمدید اقدام کنید"
  end
                    disable_channel(receiver)
  end

  if is_channel_disabled(receiver) then
      if msg.text and msg.to.type == "channel" and is_owner(msg) then
         if is_pattern(receiver, msg) then
		 if redis:get("expire"..msg.to.id) then
		    return "ربات در گروه شما به انقضا رسیده است و فقط ادمین های ربات قادر به فعال کردن هستند\nنسبت به تمدید اقدام کنید"
		 end
            return send_msg(receiver, "لیدر عزیز ربات غیرفعال است\nمیتوانید با bot on فعال کنید", ok_cb, false)
	     end
	  end
  	return false
  end

------------------------------------------------------antispam
if not msg.service and not is_admin1(msg) then --1
  redis:incr('msgs:'..msg.from.id..':'..msg.to.id)
  local TIME_CHECK = 2
	if data[tostring(msg.to.id)] and data[tostring(msg.to.id)]['settings']['flood_time_max'] then
         TIME_CHECK = tonumber(data[tostring(msg.to.id)]['settings']['flood_time_max'])
    end
  local hash = 'user'..bot_divest..':'..msg.from.id..':msgs'
  local msgs = tonumber(redis:get(hash) or 0)
if msg.to.type == "user" then
 	 if msgs >= 4 then
	    send_large_msg("user#id"..msg.from.id, "به دلیل ارسال پیام مکرر بیش از 4 بار بلاک میشوید")
        block_user("user#id"..msg.from.id,ok_cb,false)
     end
end
if msg.to.type == "channel" or msg.to.type == "chat" then
if data[tostring(msg.to.id)] and not is_momod(msg) then --2

 if data[tostring(msg.to.id)] and data[tostring(msg.to.id)]['settings']['lock_flood'] == 'yes' then --4
    local NUM_MSG_MAX = 5
    if data[tostring(msg.to.id)]['settings']['flood_msg_max'] then
        NUM_MSG_MAX = tonumber(data[tostring(msg.to.id)]['settings']['flood_msg_max'])
    end

local spammers = "spammers"..bot_divest..":"..msg.to.id..":"..msg.from.id
local gbanspam = "gban"..bot_divest..":spam"..msg.from.id
local gbanspamonredis = redis:get(gbanspam)
local spammers1 = redis:get(spammers)

if msgs >= NUM_MSG_MAX then
      if msg.from.username ~= nil then
         username = "@"..msg.from.username
      else
         username = string.sub(msg.from.print_name:gsub("_"," "), 1, 100)
      end
    if gbanspamonredis then
        if tonumber(gbanspamonredis) >= 3 then
		   delete_msg(msg.id, ok_cb, false)
		   ban_user(msg.from.id, msg.to.id)
	       redis:del(gbanspam, true)
           return send_large_msg(receiver, "کاربر "..username.." بدلیل اسپم 3 بار اخراج و بن شد\nمدیران محترم میتوانند با زدن \n<b>unban </b>"..msg.from.id.." نسبت به رفع بن وی اقدام کنند ")
        end
   end
if spammers1 then
   delete_msg(msg.id, ok_cb, false)
   return kick_user(msg.from.id, msg.to.id)
end
      delete_msg(msg.id, ok_cb, false)
	  redis:incr(gbanspam)
      redis:setex(spammers, 35, true)
	  kick_user(msg.from.id, msg.to.id)
	  savelog(msg.to.id, "به دلیل ارسال پیام های مکرر بیش از حد ریمو شد "..msg.from.print_name:gsub("_"," "))
	  send_large_msg(receiver, "کاربر "..username.." به دلیل ارسال پیام های مکرر بیش از "..NUM_MSG_MAX.." بار ریمو شد")
end
end
end
end
redis:setex(hash, TIME_CHECK, msgs + 1)
end --flood_settings

----------------------------------------------------#chack privites
if msg.to.type == "user" then
admin_id = tonumber(148617896)
local hash = 'PM:'..msg.from.id
redis:sadd(hash, msg.from.id)
--[[if msg.text and not is_sudo(msg) then
if redis:get('pvusers2'..bot_divest..':'..msg.from.id) then
send_large_msg("user#id"..msg.from.id, "پیام شما برای ادمین ارسال شد لطفا صبر کنید")
return fwd_msg("user#id"..admin_id, msg.id, ok_cb, false)
end
else
if not is_sudo(msg) then 
return send_large_msg("user#id"..msg.from.id, "پیام شما باید متنی باشد")
end
end

if is_sudo(msg) and msg.reply_id then
function reply_pm(extra,success,result)
local receiver = result.from.id
local msg = extra
  if result.fwd_from and msg.text then
  mark_read(receiver, ok_cb, false)
  return fwd_msg(result.fwd_from.id, msg.id, ok_cb, false)
  else
    return send_large_msg("user#id"..msg.from.id, "پیام شما باید متنی باشد")
  end
end
get_message(msg.reply_id, reply_pm, msg)
end
]]
if msg.text then
if msg.text:lower() == "^id$" or msg.text:lower() == "^[!/#]id$" then
return send_msg("user#id"..msg.from.id, "شناسه شما: "..msg.from.id, ok_cb, false)
end
end
if redis:get('pvusers2'..bot_divest..':'..msg.from.id) then
return msg
end
local support = redis:hget('support', 'supportlink')
local group_link2 = data[tostring(support)]['settings']['set_link']
if not group_link2 then
group_link2 = "https://telegram.me/joinchat/CNu6qD7nHPkhBJtCN_NJsw"
else
group_link2 = group_link2
end
local text = "سلام "..msg.from.print_name:gsub("_"," ").." "..[[ به ربات ضد لینک و ضد اسپم یوبی خوش امدید
این ربات ساخته شده توسط @ValtMan میباشد که بسیار دقیق است

<b>با تضمین 24 ساعت انلاینی ربات</b>

<code>دارای بهترین سورس و کامل ترین امکانات </code>

اگر قصد خرید این ربات را دارید به پی وی ایشان مراجعه کنید 
و اگر ریپورت هستید با @UBsupBot در ارتباط باشید

قیمت ربات های ما به ترتیب زیر است :

بات های معمولی به قیمت 8000 تومان 
بات های ویژه به قیمت 10000 تومان 
بات های VIP به قیمت 15000 تومان

<i>بصورت شارژ ایرانسل یا کارت به کارت قابل پرداخت است </i>

شماره حساب :
<b> 6037 9971 6923 1801 </b>
مالک حساب : رامین هرندی

لینک ساپورت : ]]..group_link2..[[

ادرس کانال ربات : https://telegram.me/joinchat/CNu6qD7nHPkhBJtCN_NJsw

تمام بروز رسانی ها در این کانال قرار خواهد گرفت

ساعاتی خوش برایتان ارزومندیم 
]]
local users = 'pvusers'
local users2 = 'pvusers2'..bot_divest..':'..msg.from.id
redis:sadd(users, msg.from.id)
redis:setex(users2, 86400, true)
return send_msg(receiver, text, ok_cb, false)
end
-----------------------------------------------------
if msg.service and data[tostring(msg.to.id)] then
action = msg.action.type

if msg.action.type == "chat_rename" then
data[tostring(msg.to.id)]['settings']['set_name'] = msg.to.title
save_data(config.moderation.data, data)
return send_msg(receiver, "اسم جدید با موفقیت ثبت شد", ok_cb, false)
end

lock_tgservice = data[tostring(msg.to.id)]['settings']['lock_tgservice']
if lock_tgservice == "yes" then
      delete_msg(msg.id, ok_cb, false)
end

if action == "chat_add_user" or action == "channel_invite" or action == "chat_del_user" or action == "chat_add_user_link" or action == "channel_join" then
  if msg.action.type == "chat_add_user" or msg.action.type == "channel_invite" then
      if is_owner2(msg.action.user.id, msg.to.id) then
	    channel_set_admin(receiver, "user#id"..msg.action.user.id, ok_cb, false)
	  end
      if is_banned(msg.action.user.id, msg.to.id) or is_gbanned(msg.action.user.id) and not is_momod2(msg.action.user.id, msg.to.id) then
	  if is_momod2(msg.from.id, msg.to.id) then
	  send_msg(receiver, string.gsub(msg.action.user.print_name, "_", " ").." بن یا بن ال است", ok_cb, false)
	  end
	     local bhash = 'addedbanuser:'..msg.to.id..':'..msg.from.id
		 redis:incr(bhash)
		 -------
	     local banadder = redis:get(bhash)
	     if redis:get(banadder) then
          if tonumber(banadder) >= 2 and not is_momod(msg) then
            return kick_user(msg.from.id, msg.to.id)
          end
		  if tonumber(banadder) >= 4 and not is_momod(msg) then
		    redis:del('addedbanuser:'..msg.to.id..':'..msg.from.id, true)
			ban_user(msg.from.id, msg.to.id)
            return reply_msg(msg.id, msg.from.print_name:gsub("_"," ").."به دلیل ادد کردن فرد بن شده بیش از 3 بار بن شد ", ok_cb, false)
		  end
	    end
		return kick_user(msg.action.user.id, msg.to.id)
		-----
	  end
   if is_divest(msg.action.user.id) then
   return kick_user(msg.action.user.id, msg.to.id)
   end
   local hash = 'rank:variables'
   local about = ""
   local rules = ""
if data[tostring(msg.to.id)] then
	 if data[tostring(msg.to.id)]['settings'] and data[tostring(msg.to.id)]['settings']['lock_bot'] == "yes" or data[tostring(msg.to.id)]['settings']['lock_bots'] == "yes" and not is_momod(msg) then
	  if msg.action.user.username ~= nil then
	    if string.sub(msg.action.user.username:lower(), -3) == 'bot' then
		 local chash = 'addedbotuser:'..msg.to.id..':'..msg.from.id
		 redis:incr(chash)
		 -------
	     local botadder = redis:get(chash)
	     if redis:get(botadder) then
          if tonumber(botadder) >= 2 then
            return kick_user(msg.from.id, msg.to.id)
          end
		  if tonumber(botadder) >= 4 then
		    redis:set('addedbanuser:'..msg.to.id..':'..msg.from.id, 0)
            return ban_user(msg.from.id, msg.to.id)
		  end
	    end
		    if not msg.from.username then
			names = msg.from.print_name
			else
			names = "@"..msg.from.username
			end
		    --send_msg(receiver, "ربات @"..msg.action.user.username.." توسط "..names.." اضافه شد!!!!!!", ok_cb, false)
			savelog(msg.to.id, "به گروه اضافه شد @"..msg.action.user.username.." توسط "..msg.from.print_name:gsub("_",""))
	    	return kick_user(msg.action.user.id, msg.to.id)
		 end
	   end
	 end
	 if data[tostring(msg.to.id)]['settings'] and data[tostring(msg.to.id)]['settings']['lock_bot'] == "no" or data[tostring(msg.to.id)]['settings']['lock_bots'] == "no" then
	   if msg.action.user.username ~= nil then
	     if string.sub(msg.action.user.username:lower(), -3) == 'bot' then
		  return false
		 end
	   end
	 end
	 if data[tostring(msg.to.id)]['settings'] and data[tostring(msg.to.id)]['settings']['lock_member'] == "kick" and msg.to.type == "chat" then
	 savelog(msg.to.id, "به گروه اضافه شد "..string.gsub(msg.action.user.print_name, "_", " ").." توسط "..msg.from.print_name:gsub("_",""))
	 return kick_user(msg.action.user.id, msg.to.id)
	 end
	  if data[tostring(msg.to.id)]['settings']['wlc'] == 'off' or not data[tostring(msg.to.id)]['settings']['wlc'] then
        return false
      end
      if data[tostring(msg.to.id)]["description"] then
         about = data[tostring(msg.to.id)]["description"]
         about = "\n<code>توضیحات </code> :\n"..about.."\n"
      end
      if data[tostring(msg.to.id)]["rules"] then
         rules = data[tostring(msg.to.id)]["rules"]
         rules = "\n<code>قوانین </code> :\n"..rules.."\n"
      end
    end
   local value = redis:hget(hash, msg.action.user.id)
      if not msg.action.user.username then
          name = "<i> "..string.gsub(msg.action.user.print_name, "_", " ").." </i>"
      else 
          name = " @"..msg.action.user.username.." "
      end
	  if not msg.from.username then
          name2 = "<i> "..string.gsub(msg.from.print_name, "_", " ").." </i>"
      else 
          name2 = " @"..msg.from.username.." "
      end
      if value then
        name = "<i> "..value.." </i>"
      end
      --chat_new_user(msg)
	  if data[tostring(msg.to.id)]["group_wlc"] == nil then
	     savelog(msg.to.id, "به گروه اضافه شد "..string.gsub(msg.action.user.print_name, "_", " ").." توسط "..msg.from.print_name:gsub("_",""))
         local text = "درود"..name.."ورود شما را به واسطه"..name2.."در<code> "..msg.to.title.." </code>خوش امد میگوییم\n"..about..rules
         return reply_msg(msg.id, text, ok_cb, false)
	  else
         group_wlc = data[tostring(msg.to.id)]["group_wlc"]
         chat_name = "<code> "..msg.to.title.." </code>"
         user_name1 = "<i> "..string.gsub(msg.action.user.print_name, "_", " ").." </i>"
		 user_name2 = "<i> "..string.gsub(msg.from.print_name, "_", " ").." </i>"
		  if not msg.action.user.username then
             uname = " "
          else 
             uname = " @"..msg.action.user.username.." "
          end
		  if not msg.from.username then
             name2 = " "
          else 
             name2 = " @"..msg.from.username.." "
          end
         group_wlc = string.gsub(group_wlc, "$name", user_name1)
         group_wlc = string.gsub(group_wlc, "$gname", chat_name)
         group_wlc = string.gsub(group_wlc, "$uname", uname)
		 group_wlc = string.gsub(group_wlc, "$2name", user_name2)
		 group_wlc = string.gsub(group_wlc, "$u2name", u2name)
         group_wlc = string.gsub(group_wlc, "$rules", rules)
		 group_wlc = string.gsub(group_wlc, "$about", about)
		 return reply_msg(msg.id, group_wlc, ok_cb, false)
		 end
	end
	 if msg.action.type == "chat_add_user_link" or msg.action.type == "channel_join" then
	 if is_owner2(msg.from.id, msg.to.id) then
	    channel_set_admin(receiver, "user#id"..msg.from.id, ok_cb, false)
	  end
	  if is_banned(msg.from.id, msg.to.id) or is_gbanned(msg.from.id) and not is_momod2(msg.from.id, msg.to.id) then
	  return kick_user(msg.from.id, msg.to.id)
	  end
	  if is_divest(msg.from.id) then
         return kick_user(msg.from.id, msg.to.id)
      end
   local about = ""
   local rules = ""
   if data[tostring(msg.to.id)]['settings'] and data[tostring(msg.to.id)]['settings']['lock_bot'] == "yes" or data[tostring(msg.to.id)]['settings']['lock_bots'] == "yes" and not is_momod2(msg.from.id, msg.to.id) then
	  if msg.from.username ~= nil then
	    if string.sub(msg.from.username:lower(), -3) == 'bot' then
		 return kick_user(msg.from.id, msg.to.id)
		end
	  end
	end
	 if data[tostring(msg.to.id)]['settings'] and data[tostring(msg.to.id)]['settings']['lock_bot'] == "no" or data[tostring(msg.to.id)]['settings']['lock_bots'] == "no" then
	   if msg.from.username ~= nil then
	     if string.sub(msg.from.username:lower(), -3) == 'bot' then
		  return false
		 end
	   end
	 end
	  if data[tostring(msg.to.id)]['settings'] and data[tostring(msg.to.id)]['settings']['lock_join'] == "kick" and msg.to.type == "chat" then 
	     return kick_user(msg.from.id, msg.to.id)
	  end
	  if data[tostring(msg.to.id)]['settings']['wlc'] == 'off' or not data[tostring(msg.to.id)]['settings']['wlc'] then
        return false
      end
      if  data[tostring(msg.to.id)]["description"] then
         about = data[tostring(msg.to.id)]["description"]
         about = "\n<code>توضیحات </code> :\n"..about.."\n"
      end
      if data[tostring(msg.to.id)]["rules"] then
         rules = data[tostring(msg.to.id)]["rules"]
         rules = "\n<code>قوانین </code> :\n"..rules.."\n"
    end
     ------
	 local hash = 'rank:variables'
	 local value = redis:hget(hash, msg.from.id)
      if not msg.from.username then
          name = "<i> "..string.gsub(msg.from.print_name, "_", " ").." </i>"
      else 
          name = " @"..msg.from.username.." "
      end
          name2 = "<i> "..string.gsub(msg.action.link_issuer.print_name, "_", " ").." </i>"
      if value then
        name = "<i> "..value.." </i>"
      end
      if data[tostring(msg.to.id)]["group_wlc"] == nil then
	     savelog(msg.to.id, string.gsub(msg.from.print_name, "_", " ").. "وارد گروه شد ")
         local text = "درود"..name.."ورود شما را به گروه<code> "..msg.to.title.." </code>با مدیریت <i> "..name2.." </i>خوش امد میگوییم\n"..about..rules
         return reply_msg(msg.id, text, ok_cb, false)
	  else
	     group_wlc = data[tostring(msg.to.id)]["group_wlc"]
         chat_name = "<code> "..msg.to.title.." </code>"
         user_name1 = "<i> "..string.gsub(msg.from.print_name, "_", " ").." </i>"
		 user_name2 = "<i> "..string.gsub(msg.action.link_issuer.print_name, "_", " ").." </i>"
		  if not msg.from.username then
             uname = " "
          else 
             uname = " @"..msg.from.username.." "
          end
		  if not msg.from.username then
             name = " "
          else 
             name = " @"..msg.from.username.." "
          end
         group_wlc = string.gsub(group_wlc, "$name", user_name1)
         group_wlc = string.gsub(group_wlc, "$gname", chat_name)
         group_wlc = string.gsub(group_wlc, "$uname", uname)
		 group_wlc = string.gsub(group_wlc, "$2name", user_name2)
		 group_wlc = string.gsub(group_wlc, "$u2name", u2name)
         group_wlc = string.gsub(group_wlc, "$rules", rules)
		 group_wlc = string.gsub(group_wlc, "$about", about)
		 return reply_msg(msg.id, group_wlc, ok_cb, false)
		 end
	end
	if msg.action.type == "chat_del_user" then
	  if data[tostring(msg.to.id)]['settings']['wlc'] == 'off' or not data[tostring(msg.to.id)]['settings']['wlc'] then
        return false
      end
	  if is_banned(msg.action.user.id, msg.to.id) or is_gbanned(msg.action.user.id) and not is_momod2(msg.action.user.id, msg.to.id) then
	    return false
      end
	  local hash = 'rank:variables'
	  local value = redis:hget(hash, msg.action.user.id)
          name = string.gsub(msg.action.user.print_name, "_", " ")
		  if value then
		   name = "<i> "..value .." </i>"
		  else 
		   name = "<i> "..name.." </i>"
		  end
		if tonumber(msg.action.user.id) == tonumber(msg.from.id) then
		   savelog(msg.to.id, string.gsub(msg.from.print_name, "_", " ").. " ازگروه رفت شد ")
           return reply_msg(msg.id, "خدانگهدار "..name, ok_cb, false)
	    elseif tonumber(msg.action.user.id) ~= tonumber(msg.from.id) then
		   savelog(msg.to.id, string.gsub(msg.from.print_name, "_", " ").. " ازگروه ریمو شد ")
	       return false
        end
     end
end
end

----------------------------------------------------------------#checkusers
if msg.to.type == 'chat' or msg.to.type == 'channel' and data[tostring(msg.to.id)] then
    local user_id = msg.from.id
    local chat_id = msg.to.id
   if data[tostring(chat_id)]['settings']['lock_bot'] == "yes" or data[tostring(chat_id)]['settings']['lock_bots'] == "yes" and not is_momod(msg) then
   if msg.from.username ~= nil then
	    if string.sub(msg.from.username:lower(), -3) == 'bot' and not is_momod(msg) then
		   delete_msg(msg.id, ok_cb, false)
		   return kick_user(user_id, chat_id)
		end
	  end
	end
    if is_banned(user_id, chat_id) then
	if is_momod2(user_id, chat_id) then
    unban_user(user_id, chat_id)
	local text = 'جناب مدیر شما بن شده بودید :(\nاز بن درتون اوردم :)'
	return reply_msg(msg.id, text, ok_cb, false)
	end
      --local text = 'شما بن شده اید برای رفع این پیام را فوروارد کنید به @UBsupbot '..'[ '..msg.from.id..' ] '
      --reply_msg(msg.id, text, ok_cb, false)
      kick_user(user_id, chat_id)
    end
	if is_gbanned(user_id) then
	if is_momod2(user_id, chat_id) then
    unbanall_user(user_id)
	local text = 'جناب مدیر شما بن ال شده بودید :(\nاز بن درتون اوردم :)'
	return reply_msg(msg.id, text, ok_cb, false)
	end
	if not msg.from.username then
          name = string.gsub(msg.from.print_name, "_", " ").." | "..msg.from.id
      else 
          name = "@"..msg.from.username
      end
	  local spammers = "spammers"..bot_divest..":"..msg.to.id..":"..msg.from.id
	  local spammers1 = redis:get(spammers)
	  if not spammers1 then
     local text = 'کاربر '..name..' بدلایلی بن ال است و ریمو شد\nبرای رفع این مشکل باید این پیام را در @UBsupBOT فوروارد کند'
     reply_msg(msg.id, text, ok_cb, false)
	 redis:setex(spammers, 10, true)
	 delete_msg(msg.id, ok_cb, false)
     return kick_user(user_id, chat_id)
	 end
     end
	if is_divest(user_id) and not is_momod(msg) then
	local chat_id = msg.to.id
	delete_msg(msg.id, ok_cb, false)
	return kick_user(user_id, chat_id)
	end
 end
        if msg.from.username ~= nil then
	       if string.sub(msg.from.username:lower(), -3) == 'bot' and not is_momod(msg) then
		      return false
		   end
		end
------------------------------------------------#implementation settings
  if msg.text then
		--[[if is_momod(msg) and not is_admin1(msg) then
           if is_pattern(receiver, msg) then
              if data[tostring(msg.to.id)]['settings']['set_link'] == nil then
                 text = "جناب تا زمانی که شما لینک گروهتان را ثبت نکنید نمیتوانید از ربات استفاده کنید\n>>> با زدن <b>SETLINK</b> لینک گروه را ثبت کنید"
	             return reply_msg(msg.id, text, ok_cb, false)
              end
           end
        end]]
	    if data[tostring(msg.to.id)] and msg.text:match("^[Ss][Ee][Tt][Ll][Ii][Nn][Kk]$") or msg.text:match("^[!/#][Ss][Ee][Tt][Ll][Ii][Nn][Kk]$") and is_momod(msg) then
		    local group_link = data[tostring(msg.to.id)]['settings']['set_link']
			if group_link == 'waiting' then
			    return reply_msg(msg.id, 'شما قبلا درخواست setlink داده ایید\nلطفا متن دارای لینک گروه خود را ارسال کنید', ok_cb, false)
		    end
			data[tostring(msg.to.id)]['settings']['set_link'] = 'waiting'
			save_data(config.moderation.data, data)
			savelog(msg.to.id, "ثبت لینک جدید گروه درخواست شد توسط "..string.gsub(msg.from.print_name, "_", " "))
			return reply_msg(msg.id, 'لطفا متن دارای لینک خود را ارسال کنید', ok_cb, false)
		end
 		if data[tostring(msg.to.id)] and msg.text:match("(https://telegram.me/joinchat/%S+)") and data[tostring(msg.to.id)]['settings']['set_link'] == 'waiting' and is_momod(msg) then
			 	data[tostring(msg.to.id)]['settings']['set_link'] = string.match(msg.text, "https://telegram.me/joinchat/%S+")
				save_data(config.moderation.data, data)
				savelog(msg.to.id, "لینک جدید گروه ثبت شد توسط "..string.gsub(msg.from.print_name, "_", " "))
				reply_msg(msg.id, "بسیار خب لینک ثبت شد", ok_cb, false)
		end
		if data[tostring(msg.to.id)] and msg.text:match("^[Ss][Ee][Tt][Ll][Ii][Nn][Kk] (.*)") or msg.text:match("^[!/#][Ss][Ee][Tt][Ll][Ii][Nn][Kk] (.*)") and is_momod(msg) then
		    if msg.text:match("(https://telegram.me/joinchat/%S+)") then
			 	data[tostring(msg.to.id)]['settings']['set_link'] = string.match(msg.text, "https://telegram.me/joinchat/%S+")
				save_data(config.moderation.data, data)
				savelog(msg.to.id, "لینک جدید گروه ثبت شد توسط "..string.gsub(msg.from.print_name, "_", " "))
				reply_msg(msg.id, "بسیار خب لینک ثبت شد", ok_cb, false)
		    end
		end
   end
        if msg.media then
		    if data[tostring(msg.to.id)] and msg.media.type == 'photo' and data[tostring(msg.to.id)]['settings']['set_photo'] == 'waiting' and is_momod(msg) then
				   load_photo(msg.id, set_supergroup_photo, msg)
			end
			if data[tostring(msg.to.id)] and msg.media.caption then
			    if msg.media.type:match("photo") and is_momod(msg) then
				local is_link_cap = msg.media.caption:lower()
                local is_link_cap = is_link_cap:match("^setphoto$") or is_link_cap:match("^[!/#]setphoto$")
				      if is_link_cap then
				      local setphoto = "setphoto:"..msg.to.id
                      local setphoto2 = redis:get(setphoto)
                 if setphoto2 then
                    return reply_msg(msg.id, " مجاز به عوض کردن عکس در 1 ساعت 2 بار نیستید", ok_cb, false)
                 end
                    redis:setex(setphoto, 3600, true)
					savelog(msg.to.id, "عکس جدید گروه عوض شد توسط "..string.gsub(msg.from.print_name, "_", " "))
				    load_photo(msg.id, set_supergroup_photo, msg)
				 end
			 end
         end
     end

   if msg.fwd_from and data[tostring(msg.to.id)] and is_momod(msg) then
	  if redis:get('kmember'..bot_divest..':'..msg.to.id) then
	     if redis:get('kmember'..bot_divest..':'..msg.to.id) == "waite" then
		   if is_momod2(msg.fwd_from.peer_id, msg.to.id) then
		      return send_large_msg(receiver, 'ایشان دارای مقام است')
		   end
	       redis:del('kmember'..bot_divest..':'..msg.to.id, true)
           kick_user(msg.fwd_from.peer_id, msg.to.id)
           return send_large_msg(receiver, '❌کاربر '..msg.fwd_from.peer_id..' اخراج شد')
        end
	  end
	end

if msg.to.type == "channel" and data[tostring(msg.to.id)] and not is_momod(msg) then
if is_muted_user(msg.to.id, msg.from.id) or is_muteall_user(msg.from.id) or redis:get('muteall:'..msg.to.id) and not msg.service then
   return delete_msg(msg.id, ok_cb, false)
end
   local gwarns = 'warnall'..bot_divest..':'..msg.to.id..':'..msg.from.id
   local target = msg.to.id
   lock_link = data[tostring(target)]['settings']['lock_link']
   lock_spam = data[tostring(target)]['settings']['lock_spam']
   lock_arabic = data[tostring(target)]['settings']['lock_arabic']
   lock_en = data[tostring(target)]['settings']['lock_en']
   lock_sticker = data[tostring(target)]['settings']['lock_sticker']
   lock_share = data[tostring(target)]['settings']['lock_contact']
   lock_photo = data[tostring(target)]['settings']['lock_photo']
   lock_text = data[tostring(target)]['settings']['lock_text']
   lock_audio = data[tostring(target)]['settings']['lock_audio']
   lock_video = data[tostring(target)]['settings']['lock_video']
   lock_file = data[tostring(target)]['settings']['lock_document']
   lock_gif = data[tostring(target)]['settings']['lock_gif']
   lock_fwd = data[tostring(target)]['settings']['lock_fwd']
   lock_reply = data[tostring(target)]['settings']['lock_reply']
   lock_tag = data[tostring(target)]['settings']['lock_tag']
   lock_unsup = data[tostring(target)]['settings']['lock_unsup']
   setting = data[tostring(target)]['settings']['lock_settings'] 

chat_id = msg.to.id
user_id = msg.from.id
    local mwarn = redis:get("mwarn"..bot_divest..":"..chat_id)
	if not mwarn then
		mwarn = 4
	else
		mwarn = redis:get("mwarn"..bot_divest..":"..chat_id)
	end
local warn = 'warnall'..bot_divest..':'..user_id..':'..chat_id
local warn2 = redis:get(warn)
local gwarn = tonumber(redis:get(warn))
   if warn2 then
   if data[tostring(target)]['settings']['lock_settings'] == 'yes' then
      if gwarn >= tonumber(mwarn) then
	     redis:del(warn)
		 delete_msg(msg.id, ok_cb, false)
		 kick_user(user_id, chat_id)
		 savelog(msg.to.id, "کاربر  "..string.gsub(msg.from.print_name, "_", " ").." به دلیل عدم رعایت قوانین ریمو شد")
		 return send_large_msg(receiver, "کاربر "..string.gsub(msg.from.print_name, "_", " ").." به دلیل عدم رعایت قوانین ریمو شد", ok_cb, false)
		 end
      end
   end

if msg.text then
local hash = 'chat:'..msg.to.id..':badword'
  if hash then --2
    local names = redis:hkeys(hash)
    for i=1, #names do --3
	  if string.match(msg.text:lower(), names[i]) then --4
           return delete_msg(msg.id,ok_cb,false)
      end
    end
  end
local is_link_msg = (msg.text:lower()):match("(telegram.me/joinchat/%S+)")
	if lock_link == "yes" and is_link_msg then
	if setting == "yes" then
	    redis:incr(gwarns)
    end
		return delete_msg(msg.id, ok_cb, false)
    elseif lock_link == "kick" and is_link_msg then
	    delete_msg(msg.id, ok_cb, false)
		return kick_user(msg.from.id, msg.to.id)
end
local is_fars_msg = msg.text:match("[\216-\219][\128-\191]")
    if data[tostring(msg.to.id)]['settings']['lock_numspam'] then
        NUM_LEN_MAX = tonumber(data[tostring(msg.to.id)]['settings']['lock_numspam'])
    end
if lock_spam == "yes" and is_fars_msg and string.len(msg.text) > 6000 then
	if setting == "yes" then
	    redis:incr(gwarns)
    end
	    return delete_msg(msg.id, ok_cb, false)
    elseif lock_spam == "yes" and msg.text:match("[a-zA-Z]") and string.len(msg.text) > 4000 then
    if setting == "yes" then
	    redis:incr(gwarns)
    end
	    return delete_msg(msg.id, ok_cb, false)
    elseif lock_spam == "kick" and is_fars_msg and string.len(msg.text) > 6000 then
	    delete_msg(msg.id, ok_cb, false)
		return kick_user(msg.from.id, msg.to.id)
	elseif lock_spam == "kick" and msg.text:match("[a-zA-Z]") and string.len(msg.text) > 4000 then
	    delete_msg(msg.id, ok_cb, false)
	    return kick_user(msg.from.id, msg.to.id)
end

if lock_spam == "yes" and data[tostring(msg.to.id)]['settings']['lock_numspam'] and is_fars_msg and string.len(msg.text) > NUM_LEN_MAX then
	if setting == "yes" then
	    redis:incr(gwarns)
    end
	    return delete_msg(msg.id, ok_cb, false)
    elseif lock_spam == "yes" and data[tostring(msg.to.id)]['settings']['lock_numspam'] and msg.text:match("[a-zA-Z]") and string.len(msg.text) > NUM_LEN_MAX then
    if setting == "yes" then
	    redis:incr(gwarns)
    end
	    return delete_msg(msg.id, ok_cb, false)
    elseif lock_spam == "kick" and data[tostring(msg.to.id)]['settings']['lock_numspam'] and string.len(msg.text) > NUM_LEN_MAX then
	    delete_msg(msg.id, ok_cb, false)
		return kick_user(msg.from.id, msg.to.id)
	elseif lock_spam == "kick" and data[tostring(msg.to.id)]['settings']['lock_numspam'] and string.len(msg.text) > NUM_LEN_MAX then
	    delete_msg(msg.id, ok_cb, false)
	    return kick_user(msg.from.id, msg.to.id)
end

if lock_arabic == "yes" and is_fars_msg then
	if setting == "yes" then
	    redis:incr(gwarns)
    end
		return delete_msg(msg.id, ok_cb, false)
    elseif lock_arabic == "kick" and is_fars_msg then
	    delete_msg(msg.id, ok_cb, false)
		return kick_user(msg.from.id, msg.to.id)
end
local is_tag_msg = msg.text:match("#[%a%d]") or msg.text:match("@[%a%d]")
if lock_tag == "yes" and is_tag_msg then
	if setting == "yes" then
	    redis:incr(gwarns)
    end
		return delete_msg(msg.id, ok_cb, false)
    elseif lock_tag == "kick" and is_tag_msg then
	    delete_msg(msg.id, ok_cb, false)
		return kick_user(msg.from.id, msg.to.id)
end
--"[a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z]""[a-zA-Z]"
local is_en_msg = msg.text:match("[a-zA-Z]")
if lock_en == "yes" and is_en_msg then
	if setting == "yes" then
	    redis:incr(gwarns)
    end
		return delete_msg(msg.id, ok_cb, false)
    elseif lock_en == "kick" and is_en_msg then
	    delete_msg(msg.id, ok_cb, false)
		return kick_user(msg.from.id, msg.to.id)
end
if lock_text == "yes" then
	if setting == "yes" then
	    redis:incr(gwarns)
    end
		return delete_msg(msg.id, ok_cb, false)
    elseif lock_text == "kick" then
	    delete_msg(msg.id, ok_cb, false)
		return kick_user(msg.from.id, msg.to.id)
    end
end

if lock_fwd == "yes" and msg.fwd_from then
	if setting == "yes" then
	    redis:incr(gwarns)
    end
		return delete_msg(msg.id, ok_cb, false)
    elseif lock_fwd == "kick" and msg.fwd_from then
	    delete_msg(msg.id, ok_cb, false)
		return kick_user(msg.from.id, msg.to.id)
end
if lock_reply == "yes" and msg.reply_id then
    if setting == "yes" then
	    redis:incr(gwarns)
    end
		return delete_msg(msg.id, ok_cb, false)
    elseif lock_reply == "kick" and msg.reply_id then
	    delete_msg(msg.id, ok_cb, false)
		return kick_user(msg.from.id, msg.to.id)
end
if msg.media then
   if msg.media.caption then
   local hash = 'chat:'..msg.to.id..':badword'
       if hash then --3
             local names = redis:hkeys(hash)
             for i=1, #names do --4
                if string.match(msg.media.caption:lower(), names[i]) then --6
                   return delete_msg(msg.id,ok_cb,false)
                end
             end
        end
local is_link_cap = (msg.media.caption:lower()):match("(telegram.me/joinchat/%S+)")
if is_link_cap and lock_link == "yes" then
    if setting == "yes" then
	    redis:incr(gwarns)
    end
      return delete_msg(msg.id, ok_cb, false)
    elseif is_link_cap and lock_link == "kick" then
      delete_msg(msg.id, ok_cb, false)
      return kick_user(msg.from.id, msg.to.id)
end
local is_tag_cap = msg.media.caption:match("@[%a%d]") or msg.media.caption:match("#[%a%d]")
if lock_tag == "yes" and is_tag_cap then
    if setting == "yes" then
	    redis:incr(gwarns)
    end
      return delete_msg(msg.id, ok_cb, false)
    elseif lock_tag == "kick" and is_tag_cap then
      delete_msg(msg.id, ok_cb, false)
      return kick_user(msg.from.id, msg.to.id)
end
local is_fars_msg = msg.media.caption:match("[\216-\219][\128-\191]")
if lock_arabic == "yes" and is_fars_cap then
    if setting == "yes" then
	    redis:incr(gwarns)
    end
      return delete_msg(msg.id, ok_cb, false)
    elseif lock_arabic == "kick" and is_fars_cap then
      delete_msg(msg.id, ok_cb, false)
      return kick_user(msg.from.id, msg.to.id)
end
local is_en_msg = msg.media.caption:match("[a-zA-Z]")
if lock_en == "yes" and is_en_cap then
    if setting == "yes" then
	    redis:incr(gwarns)
    end
      return delete_msg(msg.id, ok_cb, false)
    elseif lock_en == "kick" and is_en_cap then
      delete_msg(msg.id, ok_cb, false)
      return kick_user(msg.from.id, msg.to.id)
end
local is_sticker = msg.media.caption:lower() == "sticker.webp"
if lock_sticker == "yes" and is_sticker then
    if setting == "yes" then
	    redis:incr(gwarns)
    end
      return delete_msg(msg.id, ok_cb, false)
    elseif lock_sticker == "kick" and is_sticker then
      delete_msg(msg.id, ok_cb, false)
      return kick_user(msg.from.id, msg.to.id)
end
local is_gif = msg.media.caption:lower() == ".mp4" or  msg.media.caption:lower() == ".gif" and msg.media.type == "document"
if lock_gif == "yes" and is_gif then
    if setting == "yes" then
	    redis:incr(gwarns)
    end
      return delete_msg(msg.id, ok_cb, false)
    elseif lock_gif == "kick" and is_gif then
      delete_msg(msg.id, ok_cb, false)
      return kick_user(msg.from.id, msg.to.id)
end
end
local is_photo = msg.media.type == "photo"
if lock_photo == "yes" and is_photo then
    if setting == "yes" then
	    redis:incr(gwarns)
    end
		return delete_msg(msg.id, ok_cb, false)
    elseif lock_photo == "kick" and is_photo then
	    delete_msg(msg.id, ok_cb, false)
		return kick_user(msg.from.id, msg.to.id)
end
local is_file = msg.media.type == "document"
if lock_file == "yes" and is_file then
    if setting == "yes" then
	    redis:incr(gwarns)
    end
		return delete_msg(msg.id, ok_cb, false)
    elseif lock_file == "kick" and is_file then
	    delete_msg(msg.id, ok_cb, false)
		return kick_user(msg.from.id, msg.to.id)
end
local is_audio = msg.media.type == "audio"
if lock_audio == "yes" and is_audio then
    if setting == "yes" then
	    redis:incr(gwarns)
    end
		return delete_msg(msg.id, ok_cb, false)
    elseif lock_audio == "kick" and is_audio then
	    delete_msg(msg.id, ok_cb, false)
		return kick_user(msg.from.id, msg.to.id)
end
local is_video = msg.media.type == "video"
if lock_video == "yes" and is_video then
    if setting == "yes" then
	    redis:incr(gwarns)
    end
      return delete_msg(msg.id, ok_cb, false)
    elseif lock_video == "kick" and is_video then
      delete_msg(msg.id, ok_cb, false)
      return kick_user(msg.from.id, msg.to.id)
end
local is_share = msg.media.type == "contact"
if lock_share == "yes" and is_share then
    if setting == "yes" then
	    redis:incr(gwarns)
    end
		return delete_msg(msg.id, ok_cb, false)
    elseif lock_share == "kick" and is_share then
	    delete_msg(msg.id, ok_cb, false)
		return kick_user(msg.from.id, msg.to.id)
end
if msg.media.type == "unsupported" then
if lock_unsup == "yes" then
	if setting == "yes" then
	    redis:incr(gwarns)
    end
		return delete_msg(msg.id, ok_cb, false)
    elseif lock_unsup == "kick" then
	    delete_msg(msg.id, ok_cb, false)
		return kick_user(msg.from.id, msg.to.id)
end
end
end

end

if redis:get('Groupcm'..bot_divest..':'..msg.to.id) == "on" then
 if not is_momod(msg) then
  return false
 end
end
  return msg
end

return {
  patterns = {
    "^[#!/](add)$","^(add)$",
    "^[#!/](rem)$","^(rem)$",
    "^[#!/](rem) (.*)$","^(rem) (.*)$",
    "^[#!/](settings)$","^(settings)$",
    "^[#!/](settings) (lock)$","^(settings) (lock)$",
    "^[#!/](settings) (unlock)$","^(settings) (unlock)$",
    "^[#!/](tosuper)$","^(tosuper)$",
    "^[#!/](gpinfo)$","^(gpinfo)$",
    "^[#!/](admins)$","^(admins)$",
    "^[#!/](owner)$","^(owner)$",
    "^[#!/](owners)$","^(owners)$",
    "^[#!/](ownerlist)$","^(ownerlist)$",
    "^[#!/](modlist)$","^(modlist)$",
    "^[#!/](bots)$","^(bots)$",
    "^[#!/](who)$","^(who)$",
    "^[#!/](kicked)$","^(kicked)$",
    "^[#!/](del)$","^(del)$",
    "^[#!/](newlink)$","^(newlink)$",
    "^[#!/](hlink)$","^(hlink)$",
    "^[#!/](link)$","^(link)$",
    "^[#!/](setadmin) (.*)$","^(setadmin) (.*)$",
    "^[#!/](setadmin)","^(setadmin)",
    "^[#!/](demoteadmin) (.*)$","^(demoteadmin) (.*)$",
    "^[#!/](demoteadmin)","^(demoteadmin)",
    "^[#!/](setowner) (.*)$","^(setowner) (.*)$",
    "^[#!/](setowner)$","^(setowner)$",
    "^[#!/](setowners)$","^(setowners)$",
    "^[#!/](setowners) (.*)$","^(setowners) (.*)$",
    "^[#!/](remowners)$","^(remowners)$",
    "^[#!/](remowners) (.*)$","^(remowners) (.*)$",
    "^[#!/](promote) (.*)$","^(promote) (.*)$",
    "^[#!/](promote)","^(promote)",
    "^[#!/](demote) (.*)$","^[#!/](demote) (.*)$",
    "^[#!/](demote)","^(demote)",
    "^[#!/](setname) (.*)$","^(setname) (.*)$",
    "^[#!/](setabout) (.*)$","^(setabout) (.*)$",
    "^[#!/](setrules) (.*)$","^(setrules) (.*)$",
    "^[#!/](setphoto)$","^(setphoto)$",
    "^[#!/](mute) (all) (%d+)$","^(mute) (all) (%d+)$",
    "^[#!/](mute) (all) (%d+) (.*)","^(mute) (all) (%d+) (.*)",
    "^[#!/](stats) (mute)","^(stats) (mute)",
    "^[#!/](stats) (mute all)","^(stats) (mute all)",
    "^[#!/](mute)$","^(mute)$",
    "^[#!/](mute) (.*)$","^(mute) (.*)$",
    "^[#!/](unmute)$","^(unmute)$",
    "^[#!/](unmute) (.*)$","^(unmute) (.*)$",
    "^[#!/](unmuteall)$","^(unmuteall)$",
    "^[#!/](muteall) (.*)$","^(muteall) (.*)$",
    "^[#!/](public) (.*)$","^(public) (.*)$",
    "^[#!/](rules)$","^(rules)$",
    "^[#!/](about)$","^(about)$",
    "^[#!/](setflood) (%d+)$","^(setflood) (%d+)$",
    "^[#!/](settimeflood) (%d+)$","^(settimeflood) (%d+)$",
    "^[#!/](clean) (.*)$","^(clean) (.*)$",
    "^[#!/](muteslist)$","^(muteslist)$",
    "^[#!/](mutelist)$","^(mutelist)$",
    "^[#!/](rmsg) (.*)$","^(rmsg) (.*)$",
    "^[#!/](rmsg)$","^(rmsg)$",
    "^[#!/](lock) (%a+) (%a+)$","^(lock) (%a+) (%a+)$",
    "^[#!/](lock) (.*)$","^(lock) (.*)$",
    "^[#!/](unlock) (.*)$","^(unlock) (.*)$",
    "^[#!/](vardump)$","^(vardump)$",
    "^[#!/](vardump2)$","^(vardump2)$",
    "^[#!/](help)$","^(help)$",
    "^[#!/](ahelp)$","^(ahelp)$",
    "^[#!/](lhelp)$","^(lhelp)$",
    "^[#!/](shelp)$","^(shelp)$",
	"^[#!/](gplog)$","^(gplog)$",
    "^[#!/](mhelp)$","^(mhelp)$",
	"^[#!/](fhelp)$","^(fhelp)$",
    "^[#!/](filter) (.*) (.*)$","^(filter) (.*) (.*)$",
    "^[#!/](filterlist)$", "^(filterlist)$",
    "^[#!/](setwarn) (%d+)$","^(setwarn) (%d+)$",
    "^[#!/](getwarn) (.*)$","^(getwarn) (.*)$",
    "^[#!/](getwarn)$","^(getwarn)$",
    "^[#!/](warn) (.*)$","^(warn) (.*)$",
    "^[#!/](warn)$","^(warn)$",
    "^[#!/](unwarn) (.*)$","^(unwarn) (.*)$",
    "^[#!/](unwarn)$", "^(unwarn)$",
    "^[#!/](unwarnall) (.*)$","^(unwarnall) (.*)$",
    "^[#!/](unwarnall)$", "^(unwarnall)$",
    "^[#!/](kickmember)$","^(kickmember)$",
    "^[#!/](setusername) (.*)$","^(setusername) (.*)$",
	"^[#!/](limspam) (%d+)$","^(limspam) (%d+)$",
	"^[#!/](setwlc) (.*)$","^(setwlc) (.*)$",
	"^[#!/](delwlc)$", "^(delwlc)$",
	---------------------------------#متفرقه
    "^[#!/](echo) +(.+)$","^(echo) +(.+)$",
    "^[#!/](code) (.*)$","^(code) (.*)$",
    "^[#!/](italic) (.*)$","^(italic) (.*)$",
    "^[#!/](bold) (.*)$","^(bold) (.*)$",
    "^[#!/](hyper) (.*) (.*)$","^(hyper) (.*) (.*)$",
    "^[#!/](list) (.*)$","^(list) (.*)$",
    "^[#!/](addadmin) (.*)$","^(addadmin) (.*)$",
    "^[#!/](removeadmin) (.*)$","^(removeadmin) (.*)$",
    "^[#!/](type)$","^(type)$",
    "^[#!/](settype) (.*)$","^(settype) (.*)$",
    "^[#!/](wlc) (.*)$","^(wlc) (.*)$",
    "^[#!/](cmuser) (.*)$","^(cmuser) (.*)$",
    "^[#!/](ping)$","^(ping)$",
    "^[#!/](p)$","^(p)$",
    "^[#!/](p) (r)$","^(p) (r)$",
    "^[#!/](broadcast) +(.+)$", "^([Bb]roadcast) +(.+)$",
    "^[#!/](bc) (%d+) (.*)$","^(bc) (%d+) (.*)$",
    "^[#!/](p) (+) ([%w_%.%-]+)$","^(p) (+) ([%w_%.%-]+)$",
    "^[#!/](p) (-) ([%w_%.%-]+)$","^(p) (-) ([%w_%.%-]+)$",
    "^[#!/](invite) (.*)$", "^(invite) (.*)$",
	"^[#!/](invite)$", "^(invite)$",
    "^[#!/](import) (.*)$","^(import) (.*)$",
    "^[#!/](pmunblock) (%d+)$","^(pmunblock) (%d+)$",
    "^[#!/](pmblock) (%d+)$","^(pmblock) (%d+)$",
    "^[#!/](typing) (on)$","^(typing) (on)$",
    "^[#!/](typing) (off)$","^(typing) (off)$",
    "^[#!/](markread) (on)$","^(markread) (on)$",
    "^[#!/](markread) (off)$","^(markread) (off)$",
    "^[#!/](setbotphoto)$","^(setbotphoto)$",
    "^[#!/](contactlist)$","^(contactlist)$",
    "^[#!/](dialoglist)$","^(dialoglist)$",
    "^[#!/](delcontact) (%d+)$","^(delcontact) (%d+)$",
    "^[#!/](addcontact) (.*) (.*) (.*)$","^(addcontact) (.*) (.*) (.*)$",
    "^[#!/](sendcontact) (.*) (.*) (.*)$","^(sendcontact) (.*) (.*) (.*)$",
    "^[#!/](mycontact)$","^(mycontact)$",
    "^[#!/](upid)$","^(upid)$",
    "^[#!/](addlog)$","^(addlog)$",
    "^[#!/](remlog)$","^(remlog)$",
    "^[#!/](leave)$","^(leave)$",
    "^[#!/](leave) (%d+) (%d+)$","^(leave) (%d+) (%d+)$",
    "^[#!/](stats)$","^(stats)$",
    "^[#!/](statslist)$","^(statslist)$",
    "^[#!/](stats) (group) (%d+)","^(stats) (group) (%d+)$",
    "^[#!/](facts)$","^(facts)$",
    "^[#!/](ub)$","^(ub)$",
    "^[#!/](teleseed)","^(teleseed)",
    "^[#!/](chatlist)$","^(chatlist)$",
    "^[#!/](join) (%d+)$","^(join) (%d+)$",
    "^[#!/](all)$","^(all)$",
    "^[#!/](all) (%d+)$","^(all) (%d+)$",
    "^[#!/](broadcast) +(.+)$", "^(broadcast) +(.+)$",
    "^[#!/](bc) (%d+) (.*)$","^(bc) (%d+) (.*)$",
    "^[#!/](autoleave) (.*)$","^(autoleave) (.*)$",
    "^[#!/](clean) (.*)$","^(clean) (.*)$",
    "^[#!/](banall) (.*)$","^(banall) (.*)$",
    "^[#!/](banall)$","^(banall)$",
    "^[#!/](hammer) (.*)$","^(hammer) (.*)$",
    "^[#!/](hammer)$","^(hammer)$",
    "^[#!/](unhammer) (.*)$","^(unhammer) (.*)$",
    "^[#!/](unhammer)$","^(unhammer)$",
    "^[#!/](muteall)$","^(muteall)$",
    "^[#!/](unmuteall) (.*)$","^(unmuteall) (.*)$",
    "^[#!/](banlist) (.*)$","^(banlist) (.*)$",
    "^[#!/](kicklist)$","^(kicklist)$",
    "^[#!/](banlist)$","^(banlist)$",
    "^[#!/](divestlist)$","^(divestlist)$",
    "^[#!/](gbanlist)$","^(gbanlist)$",
    "^[#!/](gmutelist)$","^(gmutelist)$",
    "^[#!/](kickme)$","^(kickme)$",
    "^[#!/](kick)$","^(kick)$",
    "^[#!/](kick) (.*)$","^(kick) (.*)$",
    "^[#!/](ban)$",	"^(ban)$",
    "^[#!/](ban) (.*)$","^(ban) (.*)$",
    "^[#!/](botblock)$","^(botblock)$",
    "^[#!/](botblock) (.*)$","^(botblock) (.*)$",
    "^[#!/](botunblock)$","^(botunblock)$",
    "^[#!/](botunblock) (.*)$","^(botunblock) (.*)$",
    "^[#!/](unban) (.*)$","^(unban) (.*)$",
    "^[#!/](unban)$","^(unban)$",
    "^[#!/](unbanall) (.*)$","^(unbanall) (.*)$",
    "^[#!/](unbanall)$","^(unbanall)$",
    "^[#!/](kick) (.*)$","^(kick) (.*)$",
    "^[#!/](kick)$","^(kick)$",
    "^[#!/](id)$","^(id)$",
    "^[#!/](id) (.*)$","^(id) (.*)$",
    "^[#!/](res) (.*)$","^(res) (.*)$",
    "^[#!/](me)$","^(me)$",
    "^[#!/](setrank) ([^%x]+)$","^(setrank) ([^%x]+)$",
    "^[#!/](setrank) ([^%s]+) (.*)","^(setrank) ([^%s]+) (.*)",
    "^[#!/](rank)$","^(rank)$",
    "^[#!/](delrank)$","^(delrank)$",
    "^[#!/](delrank) ([^%x]+)$","^(delrank) ([^%x]+)$",
    "^[#!/](info)$","^(info)$",
    --"^[#!/](info) (.*)$","^(info) (.*)$",
    "^[#!/](groups owner)$","^(groups owner)$",
    "^[#!/](pvclean)$","^(pvclean)$",
    "^[#!/](whois) (.*)$","^(whois) (.*)$",
    "^[#!/](nerkh)$","^(nerkh)$",
    "^[#!/](status) (.*)$","^(status) (.*)$",
	"^[#!/](support)$","^(support)$",
	"^[#!/](setsupport)$","^(setsupport)$",
	"^[#!/](expire1)$","^(expire1)$",
	"^[#!/](expire2)$","^(expire2)$",
	"^[#!/](expire3)$","^(expire3)$",
	"^[#!/](expire)$","^(expire)$",
	"^[#!/](nexpire)$","^(nexpire)$",
	"^[#!/](delexpire)$","^(delexpire)$",
	"^[#!/](feedback) (.*)$","^(feedback) (.*)$",
  },
  run = run,
  pre_process = pre_process,
  cron = cron,
}
