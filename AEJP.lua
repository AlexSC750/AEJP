
--Creates an atlas for cards to use
SMODS.Atlas {
	-- Key for code to find it with
	key = "temp",
	-- The name of the file, for the code to pull the atlas from
	path = "temp.png",
	-- Width of each sprite in 1x size
	px = 71,
	-- Height of each sprite in 1x size
	py = 95
}

SMODS.Atlas({ key = "blindtemp", atlas_table = "ANIMATION_ATLAS", path = "blindtemp.png", px = 34, py = 34, frames = 21 })

local lc = loc_colour
function loc_colour(_c, _default)
	if not G.ARGS.LOC_COLOURS then
		lc()
	end
	G.ARGS.LOC_COLOURS.weird = HEX("a28cff")
	G.ARGS.LOC_COLOURS.full_black = HEX("000000")
	G.ARGS.LOC_COLOURS.full_red = HEX("FF0000")
	G.ARGS.LOC_COLOURS.crimson_red = HEX("AC3232")
	return lc(_c, _default)
end

SMODS.Sound({
	key = "speeddemon_refill",
	path = "WarTimerUp.wav"
})

SMODS.Sound({
	key = "speeddemon_spawn",
	path = "WarTimer.wav"
})

SMODS.Blind {
	key = "unknown",
	boss = {showdown = true},
	dollars = 8,
	mult = 1,
    atlas = "blindtemp",
	pos = { x = 0, y = 0 },
	boss_colour = HEX('635147'),
	modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
		if to_big(mult) <= to_big(0) then
			return mult, hand_chips, false
		end
		return G.GAME.hands[text].level * -1, hand_chips, true
    end
}

SMODS.Rarity({
	key = "unreasonable",
	loc_txt = {
		name = "Unreasonable"
	},
	badge_colour = HEX("5107fe"),
})

SMODS.Rarity({
	key = "lunatic",
	loc_txt = {
		name = "Lunatic"
	},
	badge_colour = HEX("ae2701"),
})

SMODS.Joker {
	key = 'quasilinear',
	rarity = 3,
	atlas = 'temp',
	discovered = true,
	blueprint_compat = true,
	pos = { x = 0, y = 0 },
	cost = 7,
	calculate = function(self, card, context)
		if context.joker_main and to_big(mult) > to_big(0) and not context.debuffed_hand then
			local mlog = math.log(mult, 10) + 1
			return {
				Xmult_mod = mlog,
				message = localize { type = 'variable', key = 'a_xmult', vars = { mlog } }
			}
		end
	end
}

G.aejp_tsarlist = {}

SMODS.Joker { -- we get there when we get there (WE GOT THERE)
	key = 'bell',
	rarity = "aejp_unreasonable",
	atlas = 'temp',
	blueprint_compat = false,
	discovered = true,
	pos = { x = 1, y = 0 },
	cost = 25,
}

SMODS.Joker {
	key = 'dropdown',
	rarity = 3,
	atlas = 'temp',
	discovered = true,
	blueprint_compat = true,
	pos = { x = 2, y = 0 },
	cost = 8,
	calculate = function(self, card, context)
	 	if context.just_before and not context.debuffed_hand then
			local list = {}
			for k, v in pairs(G.GAME.hands) do
				list[v.order] = {hand = k, chips = v.chips, mult = v.mult}
			end
			for i,v in ipairs(list) do
				if i > G.GAME.hands[context.scoring_name].order and G.GAME.hands[v.hand].visible then
					SMODS.calculate_effect({
						colour = G.C.FILTER,
						message = localize { type = 'variable', key = 'a_hand_chipmult', vars = { v.hand } },
						chip_mod = v.chips,
						mult_mod = v.mult,
						pitch = 1.0,
						sound = "generic1"
					}, card)
					delay(0.2)
				end
			end
	 	end
	end
}

function walkAndDecay(card, m, substract, delta)
	for k,v in pairs(m) do
		if substract[k] then
			if type(v) == "table" then
				walkAndDecay(card, v, substract[k], delta)
			else
				local t = substract[k]
				m[k] = m[k] - (t.decay * delta)
				if m[k] <= t.threshold then
					m[k] = math.max(t.threshold, m[k])
					if not t.has_hit then
						t.has_hit = t.callback(card)
					end
				end
			end
		end
	end
end

-- Converts seconds to a formatted min:sec string
function secondsToMins(seconds)
	return string.format("%02d", math.floor(seconds/60))..":"..string.format("%02d", math.floor(math.fmod(seconds, 60)))
end

function get_stickers(card)
	if SMODS.Mods["Cryptid"] then
		return {
			eternal = card.ability.eternal,
			perishable = card.ability.perishable,
			rental = card.ability.rental,
			absolute = card.ability.cry_absolute,
			banana = card.ability.banana,
		}
	else
		return {
			eternal = card.ability.eternal,
			perishable = card.ability.perishable,
			rental = card.ability.rental,
			absolute = false,
			banana = false
		}
	end
end

function set_stickers(card, slist)
	card:set_eternal(slist.eternal and not slist.absolute)
	card.ability.perishable = slist.perishable
	card:set_rental(slist.rental)
	if SMODS.Mods["Cryptid"] then
		card.ability.cry_absolute = slist.absolute
		card.ability.banana = slist.banana
	end
end

-- update fork for rta jokers
local upd = Game.update
function Game:update(dt)
	upd(self, dt)
	if G.GAME and G.jokers then
		for _,v in ipairs(G.jokers.cards) do
			if v.config.center.config_decay then
				walkAndDecay(v, v.ability, v.config.center.config_decay, dt)
			end
		end
	end
end

SMODS.Joker {
	key = 'speeddemon',
	rarity = "aejp_lunatic",
	atlas = 'temp',
	discovered = true,
	blueprint_compat = true,
	immutable = true,
	pos = { x = 0, y = 1 },
	config = { extra = { emult = 1.5 , emult_gain = 0.5, time_left = 180, max_time = 180, done_for = false} },
	config_decay = {extra = { time_left = {
		decay = 1,
		threshold = 0,
		has_hit = false,
		callback = function (card)
			local isDone = false
			if not card.ability.extra.done_for then
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0,
					blockable = false,
					func = function()
						if card and not card.ability.extra.done_for then
							card.ability.extra.done_for = true
							card.ability.extra.emult = 0.1
							G.E_MANAGER:add_event(Event({
								func = function()
									local ded = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_aejp_speeddemonded")
									ded:set_edition(nil, true, true)
									if SMODS.Mods["Cryptid"] then
										ded.ability.cry_absolute = true
									else
										ded:set_eternal(true)
									end
									ded:add_to_deck()
									G.jokers:emplace(ded)
									ded.ability.extra.sticker_table = get_stickers(card)
									card_eval_status_text( ded, "extra", nil, nil, nil, {
											message = localize { type = 'variable', key = 'speed_demon_timeout', vars = { } },
											sound = "talisman_eeemult",
											colour = G.ARGS.LOC_COLOURS.full_black
										})
									G.E_MANAGER:add_event(Event({
										trigger = "after",
										delay = 0,
										blockable = false,
										func = function()
											isDone = true
											G.jokers:remove_card(card)
											card:remove()
											card = nil
											return true
										end,
									}))
									return true
								end
							}))
						end
						return true
					end
				}))
			end
			return isDone
		end
	}}},
	loc_vars = function(self, info_queue, card)
		return { vars = { 
			secondsToMins(card.ability.extra.time_left),
			card.ability.extra.emult,
			card.ability.extra.emult_gain,
		} }
	end,
	cost = 8,
	add_to_deck = function ()
		play_sound("aejp_speeddemon_spawn")
	end,
	calculate = function(self, card, context)
	 	if context.joker_main and not context.debuffed_hand then
			return {
				Emult_mod = card.ability.extra.emult,
				message = localize { type = 'variable', key = 'a_powmult', vars = { card.ability.extra.emult } },
				colour = G.C.DARK_EDITION,
			}
		end
		if context.end_of_round and context.cardarea == G.jokers and not context.retrigger_joker then
			if G.GAME.blind:get_type() == "Boss" then
				card.ability.extra.emult = card.ability.extra.emult + card.ability.extra.emult_gain
				card.ability.extra.time_left = card.ability.extra.max_time
				return {
					sound = "aejp_speeddemon_refill",
					message = localize('k_upgrade_ex'),
					colour = G.C.DARK_EDITION,
					pitch = 1.0
				}
			else
				return {
					sound = "aejp_speeddemon_spawn",
					message = "["..secondsToMins(card.ability.extra.time_left).."]",
					colour = G.ARGS.LOC_COLOURS.full_red,
					pitch = 1.0
				}
			end
	 	end
		if context.skip_blind and not context.retrigger_joker then
			card.ability.extra.emult = math.max(card.ability.extra.emult - card.ability.extra.emult_gain, 1)
			return {
				message = localize {type = "variable", key = "a_emult_minus", vars = {card.ability.extra.emult_gain}},
				colour = G.ARGS.LOC_COLOURS.crimson_red
			}
		end
		if context.setting_blind then
			local tag = nil
			local type = G.GAME.blind:get_type()
			if type ~= "Boss" then
				tag = Tag(G.GAME.round_resets.blind_tags[type])
				add_tag(tag)
				play_sound("generic1", 0.9 + math.random() * 0.1, 0.8)
				play_sound("holo1", 1.2 + math.random() * 0.1, 0.4)
			end
		end
	end
}

SMODS.Joker {
	key = 'speeddemonded', --speed demon fucking dies (tragic)
	rarity = 3,
	atlas = 'temp',
	discovered = true,
	blueprint_compat = true,
	pos = { x = 1, y = 1 },
	cost = 8,
	no_collection = true,
	in_pool = function(self,args)
		return false
	end,
	config = {extra = {
		sticker_table = {}
	}},
	calculate = function(self, card, context)
		if context.joker_main and not context.debuffed_hand then
			return {
				Emult_mod = 0.1,
				message = localize { type = 'variable', key = 'a_powmult', vars = { 0.1 } },
				colour = G.C.crimson_red,
			}
		end
		if context.end_of_round and G.GAME.blind:get_type() == "Boss" and context.cardarea == G.jokers and context.main_eval then
			G.E_MANAGER:add_event(Event({
				func = function()
					local new = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_aejp_speeddemon")
					if SMODS.Mods["Cryptid"] then
						card.ability.cry_absolute = false
					end
					card:set_eternal(false)
					set_stickers(new, card.ability.extra.sticker_table)
					new:add_to_deck()
					G.jokers:emplace(new)
					G.E_MANAGER:add_event(Event({
						blockable = false,
						func = function()
							G.jokers:remove_card(card)
							card:remove()
							card = nil
							return true
						end,
					}))
					return true
				end
			}))
			return {
				message = localize { type = 'variable', key = 'speed_demon_avenge', vars = { } },
				colour = G.ARGS.LOC_COLOURS.full_black,
				volume = 0.65
			}
		end
	end
}

SMODS.Joker {
	key = 'lollipop',
	rarity = "aejp_lunatic",
	atlas = 'temp',
	discovered = true,
	blueprint_compat = true,
	pos = { x = 2, y = 1 },
	cost = 8,
	config = {extra = {emult = 3}},
	config_decay = {extra = {emult = {
		decay = 0.01,
		threshold = 1,
		has_hit = false,
		callback = function (card)
			local isDone = false
			if not card.ability.extra.done_for then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound("tarot1")
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							delay = 0.3,
							blockable = false,
							func = function()
								isDone = true
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true
							end,
						}))
						return true
					end,
				}))
				end
			return isDone
		end
	}}},
	loc_vars = function(self, info_queue, card)
		local a = card.ability.extra.emult
		local b = card.config.center.config_decay.extra.emult.decay
		return { vars = { 
			a,
			b,
			secondsToMins((a-1)/b)
		} }
	end,
	calculate = function(self, card, context)
		if context.joker_main and not context.debuffed_hand then
			return {
				colour = G.C.DARK_EDITION,
				Emult_mod = card.ability.extra.emult,
				message = localize { type = 'variable', key = 'a_powmult', vars = { card.ability.extra.emult } }
			}
		end
		if card.config.center.queued_to_die then
			card.config.center.queued_to_die = false
			G.E_MANAGER:add_event(Event({
				func = function()
					play_sound("tarot1")
					card.T.r = -0.2
					card:juice_up(0.3, 0.4)
					card.states.drag.is = true
					card.children.center.pinch.x = true
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						delay = 0.3,
						blockable = false,
						func = function()
							G.jokers:remove_card(card)
							card:remove()
							card = nil
							return true
						end,
					}))
					return true
				end,
			}))
			return {
				message = localize("k_eaten_ex"),
				colour = G.C.FILTER,
			}
		end
	end
}