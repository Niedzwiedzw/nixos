-- Example: auto-connect soundcard AUX ports to Reaper ports
local reaper_input_pattern  = "REAPER:in(%d+)"   -- for example, created by Reaper via JACK shim
local reaper_output_pattern = "REAPER:out(%d+)"
local capture_pattern       = "capture_AUX(%d+)"
local playback_pattern      = "playback_AUX(%d+)"

function auto_route_reaper()
  -- iterate over all nodes in the graph
  for _, node in ipairs(pipewire.get_nodes()) do
    local node_name = node:get_property("node.name")
    local channel_idx = node_name:match(capture_pattern)
    if channel_idx  then
      -- find matching Reaper input (you might match based on index)
      local target = pipewire.find_node("REAPER:in" .. channel_idx)
      if target then
        pipewire.connect_nodes(node, target)
      end
    end

    channel_idx = node_name:match(playback_pattern)
    if channel_idx then
      -- find matching Reaper output
      local target = pipewire.find_node("REAPER:out" .. channel_idx)
      if target then
        pipewire.connect_nodes(target, node)
      end
    end
  end
end

-- Trigger the auto routing when Reaper is detected in the graph.
pipewire.on("node-added", function(node)
  local name = node:get_property("node.name")
  if name and name:find("REAPER:") then
    auto_route_reaper()
  end
end)
