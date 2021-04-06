--***********************************************
--** BLOC4BUILDER by Philippe Romand 2019/2020 **
--***********************************************
minetest.register_lbm({
	name = "bloc4builder:replace_old_node",
	nodenames = {"bloc4builder:sas_hidden_mid","bloc4builder:switch_off", "bloc4builder:switch_on", "bloc4builder:light_up", "bloc4builder:light_off", "bloc4builder:glass", "bloc4builder:glass_angle", "bloc4builder:panneaux", "bloc4builder:rail_signal_green", "bloc4builder:rail_signal_red"},
	run_at_every_load = true,
	action = function (pos,node)
  local new_node=""
  if node.name=="bloc4builder:switch_off" then
    new_node="bloc4builder:keypad"
  elseif node.name=="bloc4builder:switch_on" then
    new_node="bloc4builder:keypad_on"
  elseif node.name=="bloc4builder:light_up" then
    new_node="bloc4builder:light_on"
  elseif node.name=="bloc4builder:light_off" then
    new_node="bloc4builder:light"
  elseif node.name=="bloc4builder:glass" then
    new_node="bloc4builder:guardrail_glass"
  elseif node.name=="bloc4builder:glass_angle" then
    new_node="bloc4builder:guardrail_glass_angle"
  elseif node.name=="bloc4builder:panneaux" then
    new_node="bloc4builder:rack"
  elseif node.name=="bloc4builder:switch2_off" then
    new_node="bloc4builder:switch2"
  elseif node.name=="bloc4builder:rail_signal_green" then
    new_node="bloc4builder:rail_signal"
  elseif node.name=="bloc4builder:rail_signal_red" then
    new_node="bloc4builder:rail_signal_on"
  elseif node.name=="bloc4builder:sas_hidden_mid" then
    new_node="bloc4builder:hidden"
  end

  minetest.swap_node(pos, {name = new_node,param2=node.param2})

end})
