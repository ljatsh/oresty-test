local module = module
local _G = _G
local sdp = require 'sdp'

local M_ = {}

M_.info = sdp.SdpStruct('info')
M_.info.Definition = {
  'id', 'name', 'changes', 'scores', 
  id = {0, 1, 8, 0},
  name = {1, 0, 13, ''},
  changes = {2, 0, sdp.SdpVector(8), nil},
  scores = {3, 0, sdp.SdpMap(13, 8), nil},
}

return M_
