local cbi = require "luci.cbi"
local i18n = require "luci.i18n"
local uci = luci.model.uci.cursor()
local site = require 'gluon.site_config'

local M = {}

function M.section(form)
  local s = form:section(cbi.SimpleSection, nil, i18n.translate(
      "Please agree with the <a href=\"http://www.picopeer.net/\" target=\"_blank\">"
      .. "Picopeering Agreement (PPA)</a> and be available."
    )
  )

  local o = s:option(cbi.Flag, "_ppa", i18n.translate("I agree with the PPA"))
  o.default = uci:get_first("gluon-node-info", "owner", "ppa", "")
  o.rmempty = false
end

function M.handle(data)
  if data._ppa ~= nil then
    uci:set("gluon-node-info", uci:get_first("gluon-node-info", "owner"), "ppa", data._ppa)
  else
    uci:delete("gluon-node-info", uci:get_first("gluon-node-info", "owner"), "ppa")
  end
  uci:save("gluon-node-info")
  uci:commit("gluon-node-info")
end

return M
