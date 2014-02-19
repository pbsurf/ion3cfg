-- $Id: statusd_meminfo.lua 59 2006-11-14 11:17:02Z tibi $

-- statusd_meminfo.lua -- memory and swap usage monitor for Ion3's statusbar

-- version : 0.1
-- date    : 2006-11-14
-- author  : Tibor Csögör <tibi@tiborius.net>

-- Shows the memory and swap usage of the system.
-- This script depends on the /proc filesystem and thus only works on Linux.
-- Tested with kernel 2.6.16.

-- Configuration:
-- The placeholders `mem_total', `mem_used', `mem_free', `mem_buffers',
-- `mem_cached', `swap_total', `swap_used' and `swap_free' hold the same
-- information as the corresponding fieds in top(1).  `mem_used_adj' and
-- `mem_free_adj' are adjusted values, here buffers and cached memory count as
-- free.  Placeholders suffixed with `_p' yield percentage values.

-- Example usage:
-- "MEM: %meminfo_mem_free_adj free, SWAP: %meminfo_swap_used used".

-- This software is in the public domain.

--------------------------------------------------------------------------------


local defaults = {
   update_interval = 3000, -- in milliseconds
}

local settings = table.join(statusd.get_config("meminfo"), defaults)

local meminfo_timer = statusd.create_timer()

function math.round(num, idp)
   local mult = 10^(idp or 0)
   return math.floor(num  * mult + 0.5) / mult
end

local function guess_mem_unit(amount)
   amount = tonumber(amount)
   if (amount < 1024) then
      return amount .. "k"
   elseif (amount >= 1024) and (amount < 1048576) then
      return math.round((amount / 1024)) .. "M"
   elseif (amount > 1048576) then
      return math.round((amount / 1048576), 1) .. "G"
   end
end

local function get_meminfo()
   local meminfo_table = {}
   local f = io.open('/proc/meminfo', 'r')
   if (f == nil) then return nil end
   local s = f:read("*a")
   f:close()
   local i = 0
   while (i < string.len(s)) do
      local j, k, v
      i, j, k, v = string.find(s, "([%w_]+):%s+(%d+) kB\n", i)
      if (i == nil) then return nil end	 
      meminfo_table[k] = tonumber(v)
      i = j+1
   end
   return meminfo_table
end

-- get CPU info from proc stat
local lastcputot = 0
local lastcpuidle = 0
local function get_cpuinfo()
   local cputimes, cputot = {},0
   local f = io.open('/proc/stat', 'r')
   if (f == nil) then return nil end
   -- just need the first line (totals for all CPUs)
   local s = f:read("*l")
   f:close()
   for x in string.gmatch(s, "%d+") do
     table.insert(cputimes, tonumber(x))
   end
   for ii, val in ipairs(cputimes) do
     cputot = cputot + val
   end
   -- idle time is 4th number
   cpuidle_p = 100*((cputimes[4] - lastcpuidle)/(cputot - lastcputot))
   lastcputot, lastcpuidle = cputot, cputimes[4]
   return cpuidle_p
end

local function update_meminfo()
   local t = get_meminfo()
   local c = get_cpuinfo()
   if (t == nil or c == nil) then return nil end   
   -- HACK: include leading colon so ion3 doesn't strip the leading space and
   --  defeat our efforts to keep length of text from changing as CPU usage crosses
   --  10%.  To use in statusbar template: "CPU%meminfo_cpu_usage_p"
   statusd.inform("meminfo_cpu_idle_p", string.format(": %2d%%", math.round(c)))
   statusd.inform("meminfo_cpu_usage_p", string.format(": %2d%%", math.round(100-c)))   

   statusd.inform("meminfo_mem_total", guess_mem_unit(t.MemTotal))
   statusd.inform("meminfo_mem_used", guess_mem_unit(t.MemTotal - t.MemFree))
   statusd.inform("meminfo_mem_used_p",
		  math.round(((t.MemTotal-t.MemFree)/t.MemTotal)*100) .. "%")
   statusd.inform("meminfo_mem_used_adj",
		  guess_mem_unit(t.MemTotal-(t.MemFree+t.Buffers+t.Cached)))
   statusd.inform("meminfo_mem_used_adj_p", math.round(
		  ((t.MemTotal-(t.MemFree+t.Buffers+t.Cached))/t.MemTotal)*100)
		  .. "%")
   statusd.inform("meminfo_mem_free", guess_mem_unit(t.MemFree))
   statusd.inform("meminfo_mem_free_p", math.round((t.MemFree/t.MemTotal)*100)
		  .. "%")
   statusd.inform("meminfo_mem_free_adj",
		  guess_mem_unit(t.MemFree+t.Buffers+t.Cached))
   statusd.inform("meminfo_mem_free_adj_p",
		  math.round(((t.MemFree+t.Buffers+t.Cached)/t.MemTotal)*100)
		  .. "%")
   statusd.inform("meminfo_mem_buffers", guess_mem_unit(t.Buffers))
   statusd.inform("meminfo_mem_cached", guess_mem_unit(t.Cached))
   statusd.inform("meminfo_swap_total", guess_mem_unit(t.SwapTotal))
   statusd.inform("meminfo_swap_free", guess_mem_unit(t.SwapFree))
   statusd.inform("meminfo_swap_free_p",
		  math.round((t.SwapFree/t.SwapTotal)*100) .. "%")
   statusd.inform("meminfo_swap_used", guess_mem_unit(t.SwapTotal-t.SwapFree))
   statusd.inform("meminfo_swap_used_p",
		  math.round(((t.SwapTotal-t.SwapFree)/t.SwapTotal)*100) .. "%")

   meminfo_timer:set(settings.update_interval, update_meminfo)
end

update_meminfo()

-- EOF
