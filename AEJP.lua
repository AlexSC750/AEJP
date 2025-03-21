-- hi there

--[[
------------------------------
### Atlases
------------------------------
--]]

SMODS.Atlas {
	key = "temp",
	path = "temp.png",
	px = 71,
	py = 95
}

SMODS.Atlas{
	key = "blindtemp",
	atlas_table = "ANIMATION_ATLAS",
	path = "blindtemp.png",
	px = 34,
	py = 34,
	frames = 21
}

SMODS.Atlas {
	key = "vouchertemp",
	path = "tempvoucher.png",
	px = 71,
	py = 95,
}

SMODS.Atlas {
	key = "planetarytravel",
	path = "planetarytravel.png",
	px = 65,
	py = 95,
}

--[[
------------------------------
### Sounds and music
------------------------------
--]]

SMODS.Sound({ --speed demon beeps
	key = "speeddemon_refill",
	path = "WarTimerUp.wav"
})
SMODS.Sound({
	key = "speeddemon_spawn",
	path = "WarTimer.wav"
})

local a = {}
if SMODS.Mods["Cryptid"] then
	a = {
		banned_cards = {
			{ id = "c_cry_analog" },
		},
		banned_other = {
			{ id = "bl_cry_joke", type = "blind" }
		}
	}
end

SMODS.Challenge {
	key = "speedrun",
	jokers = {
		{ id = "j_aejp_speeddemon2", edition = nil, eternal = true },
	},
	restrictions = a
}

SMODS.Sound { --time attack music
	key = "music_speedrun1",
	path = "music_speedrun1.wav",
	select_music_track = function ()
		return (G.GAME and G.GAME.challenge == "c_aejp_speedrun" and
		G.aejp_challenge_timer) and 10
	end,
	sync = {
		["aejp_music_speedrun2"] = true,
		["aejp_music_speedrun3"] = true
	}
}
SMODS.Sound {
	key = "music_speedrun2",
	path = "music_speedrun2.wav",
	select_music_track = function ()
		return (G.GAME and G.GAME.challenge == "c_aejp_speedrun" and
		G.aejp_challenge_timer and 
		G.aejp_challenge_timer.ability.extra.time_left <= 360) and 11
	end,
	sync = {
		["aejp_music_speedrun1"] = true,
		["aejp_music_speedrun3"] = true
	}
}
SMODS.Sound {
	key = "music_speedrun3",
	path = "music_speedrun3.wav",
	select_music_track = function ()
		return (G.GAME and G.GAME.challenge == "c_aejp_speedrun" and
		G.aejp_challenge_timer and 
		G.aejp_challenge_timer.ability.extra.time_left <= 180) and 12
	end,
	sync = {
		["aejp_music_speedrun1"] = true,
		["aejp_music_speedrun2"] = true
	}
}

--[[
------------------------------
### Blinds (there's only one)
------------------------------
--]]

SMODS.Blind {
	key = "unknown",
	boss = {showdown = true},
	dollars = 8,
	mult = 1,
    atlas = "blindtemp",
	pos = { x = 0, y = 0 },
	boss_colour = HEX('635147'),
	modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
		return G.GAME.hands[text].level * -1, hand_chips, true
    end
}

--[[
------------------------------
### Rarities
------------------------------
--]]

SMODS.Rarity{ --unreasonable
	key = "unreasonable",
	loc_txt = {
		name = "Unreasonable"
	},
	pools = { ["Joker"] = true },
	badge_colour = HEX("5107fe"),
	default_weight = 0,
	get_weight = function(self, weight, object_type)
		return 0
	end
}

SMODS.Rarity{ --lunatic
	key = "lunatic",
	loc_txt = {
		name = "Lunatic"
	},
	pools = { ["Joker"] = true },
	badge_colour = HEX("ae2701"),
	default_weight = 0,
	get_weight = function(self, weight, object_type)
		return 0
	end
}

SMODS.Rarity{ --exclusive (only for challenges)
	key = "exclusive",
	loc_txt = {
		name = "Exclusive"
	},
	badge_colour = HEX("6E065E"),
}

--[[
------------------------------
### Jokers
------------------------------
--]]

SMODS.Joker { --quasilinear
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

SMODS.Joker { --tsar bell
	key = 'bell',
	rarity = "aejp_unreasonable",
	atlas = 'temp',
	blueprint_compat = false,
	discovered = true,
	pos = { x = 1, y = 0 },
	cost = 97,
}

SMODS.Joker { --dropdown
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

SMODS.Joker { --speed demon
	key = 'speeddemon',
	rarity = "aejp_lunatic",
	atlas = 'temp',
	discovered = true,
	blueprint_compat = true,
	immutable = true,
	cost = 17,
	pos = { x = 0, y = 1 },
	config = { extra = { emult = 1.5 , emult_gain = 0.5, time_left = 150, max_time = 150, done_for = false} },
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
									local ded = SMODS.add_card({key = "j_aejp_speeddemonded"})
									ded:set_edition(nil, true, true)
									if SMODS.Mods["Cryptid"] then
										ded.ability.cry_absolute = true
									else
										ded:set_eternal(true)
									end
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

SMODS.Joker { --speed demon fucking dies (tragic)
	key = 'speeddemonded',
	rarity = 3,
	atlas = 'temp',
	discovered = true,
	no_doe = true,
	no_aeq = true,
	no_dbl = true,
	immutable = true,
	blueprint_compat = true,
	pos = { x = 1, y = 1 },
	cost = 17,
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

G.aejp_challenge_timer = nil
SMODS.Joker { --speed demon challenge version
	key = 'speeddemon2',
	rarity = "aejp_exclusive",
	atlas = 'temp',
	discovered = true,
	blueprint_compat = true,
	no_doe = true,
	no_aeq = true,
	no_dbl = true,
	immutable = true,
	no_collection = true,
	in_pool = function(self,args)
		return false
	end,
	pos = { x = 0, y = 1 },
	config = { extra = { emult = 1, emult_gain = 0.1, time_left = 600, done_for = false} },
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
									card_eval_status_text(card, "extra", nil, nil, nil, {
										message = localize { type = 'variable', key = 'speed_demon_challenge_over', vars = { } },
										sound = "talisman_eeemult",
										colour = G.ARGS.LOC_COLOURS.full_black
									})
									for _, v in pairs(G.playing_cards) do
										v:start_dissolve(nil, true)
										G.hand:change_size(-1e300)
									end
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
	update = function (self, card, dt)
		if G.GAME.challenge == "c_aejp_speedrun" and G.aejp_challenge_timer == nil and (card.ability.eternal or card.ability.cry_absolute) then
			G.aejp_challenge_timer = card
		end
	end,
	add_to_deck = function (self, card, from_debuff)
		if not from_debuff then
			play_sound("aejp_speeddemon_spawn")
			if G.GAME.challenge == "c_aejp_speedrun" and G.aejp_challenge_timer == nil then
				G.aejp_challenge_timer = card
				if SMODS.Mods["Cryptid"] then
					card.ability.cry_absolute = true
				end
			end
		end
	end,
	calculate = function(self, card, context)
	 	if context.joker_main and not context.debuffed_hand and card.ability.extra.emult > 1 then
			return {
				Emult_mod = card.ability.extra.emult,
				message = localize { type = 'variable', key = 'a_emult', vars = { card.ability.extra.emult } },
				colour = G.C.DARK_EDITION,
			}
		end
		if context.end_of_round and context.cardarea == G.jokers and not context.retrigger_joker and context.main_eval and not context.blueprint then
			if G.GAME.blind:get_type() == "Boss" then
				card.ability.extra.emult = card.ability.extra.emult + card.ability.extra.emult_gain
				card_eval_status_text(card, "extra", nil, nil ,nil, {
					sound = "generic1",
					message = localize('k_upgrade_ex'),
					colour = G.C.DARK_EDITION,
					pitch = 1.0
				})
			end
			return {
				sound = "aejp_speeddemon_spawn",
				message = "["..secondsToMins(card.ability.extra.time_left).."]",
				colour = G.ARGS.LOC_COLOURS.crimson_red,
				pitch = 1.0
			}
	 	end
		if context.skip_blind and not context.retrigger_joker and context.main_eval and not context.blueprint then
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

SMODS.Joker { -- lollipop
	key = 'lollipop',
	rarity = "aejp_lunatic",
	atlas = 'temp',
	discovered = true,
	blueprint_compat = true,
	pos = { x = 2, y = 1 },
	cost = 17,
	config = {extra = {emult = 3}},
	config_decay = {extra = {emult = {
		decay = 0.01,
		threshold = 1,
		has_hit = false,
		callback = function (card)
			local isDone = false
			G.E_MANAGER:add_event(Event({ --tasty (delete self)
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

--[[
------------------------------
### Vouchers
------------------------------
--]]

function v(name)
	return G.GAME.used_vouchers["v_aejp_"..name]
end

SMODS.Voucher { --filtration
	key = "filtration",
	atlas = "vouchertemp",
	order = 1e6 +1,
	pos = { x = 0, y = 0 },
	redeem = function(self, card)
		if not v("v_aejp_distillation") then --do nothing if you already have distillation (ahem doe)
			local rarities = {"Uncommon", "Rare"}
			for _,z in ipairs(rarities) do
				SMODS.Rarity:take_ownership(z, {
					get_weight = function(self, weight, object_type)
						return weight*1.75
					end,
				}, true)
			end
		end
	end,
	unredeem = function(self, card)
		if not v("v_aejp_distillation") then --ditto
			local rarities = {"Uncommon", "Rare"}
			for _,z in ipairs(rarities) do
				SMODS.Rarity:take_ownership(z, {
					get_weight = function(self, weight, object_type)
						return weight
					end,
				}, true)
			end
		end
	end
}

SMODS.Voucher { --distillation
	key = "distillation",
	atlas = "vouchertemp",
	order = 1e6 +2,
	pos = { x = 1, y = 0 },
	redeem = function(self, card)
		local rarities = {"Common", "Uncommon", "Rare"}
		for _,z in pairs(rarities) do
			SMODS.Rarity:take_ownership(z, {
				get_weight = function(self, weight, object_type)
					return 1/#rarities
				end,
			}, true)
		end
		if not v("v_aejp_chromatography") then --do nothing with lunatics if you already have chromatography (ahem doe)
			SMODS.Rarity:take_ownership("aejp_lunatic", {
				default_weight = 0.003 --same rarity as epics
			}, true)
		end
	end,
	unredeem = function(self, card)
		local rarities = {"Common", "Uncommon", "Rare"}
		for _,z in pairs(rarities) do
			SMODS.Rarity:take_ownership(z, {
				get_weight = function(self, weight, object_type)
					return v("v_aejp_distillation") and weight*1.75 or weight
				end,
			}, true)
		end
		if not v("v_aejp_chromatography") then --ditto
			SMODS.Rarity:take_ownership("aejp_lunatic", {
				default_weight = 0
			}, true)
		end
	end,
	requires = {"v_aejp_filtration"}
}

SMODS.Voucher { --tree sapling
	key = "treesapling",
	atlas = "vouchertemp",
	order = 1e6 +3,
	pos = { x = 0, y = 1 },
	redeem = function()
		if not (v("redwood") or v("iluvatar")) then
			G.GAME.interest_factor = 10
		end
	end,
	unredeem = function ()
		if not (v("redwood") or v("iluvatar")) then
			G.GAME.interest_factor = 5
		end
	end
}

SMODS.Voucher { --redwood tree
	key = "redwood",
	atlas = "vouchertemp",
	order = 1e6 +4,
	pos = { x = 1, y = 1 },
	requires = {"v_aejp_treesapling"},
	redeem = function()
		if not v("iluvatar") then
			G.GAME.interest_factor = 8
		end
	end,
	unredeem = function ()
		if not v("iluvatar") then
			G.GAME.interest_factor = v("treesapling") and 10 or 5
		end
	end
}

-- ## T3s

if SMODS.Mods["Cryptid"] then --chromatography
	SMODS.Voucher { 
		key = "chromatography",
		atlas = "vouchertemp",
		order = 1e9 +1,
		pos = { x = 2, y = 0 },
		redeem = function(self, card)
			local rarities = {aejp_lunatic = 0.015, Legendary = 0.01, cry_exotic = 0.005, aejp_unreasonable = 0.0025}
			SMODS.Rarity:take_ownership("cry_epic", { --epic independent of loop because theme sets
				get_weight = function(self, weight, object_type)
					if Cryptid_config["Epic Jokers"] then
						return 0.03
					end return 0
				end,
			}, true)
			for k,z in pairs(rarities) do
				SMODS.Rarity:take_ownership(k, {
					pools = { ["Joker"] = true },
					default_weight = z,
					get_weight = function(self, weight, object_type)
						return z
					end,
				}, true)
			end
		end,
		unredeem = function(self, card)
			SMODS.Rarity:take_ownership("cry_epic", {
				get_weight = function(self, weight, object_type)
					if Cryptid_config["Epic Jokers"] then
						return 0.003
					end return 0
				end,
			}, true)
			local rarities = {Legendary = 0, cry_exotic = 0, aejp_unreasonable = 0}
			for k,z in pairs(rarities) do
				SMODS.Rarity:take_ownership(k, {
					pools = nil,
					default_weight = z,
					get_weight = function(self, weight, object_type)
						return z
					end,
				}, true)
			end
			SMODS.Rarity:take_ownership("aejp_lunatic", {
				default_weight = v("v_aejp_distillation") and 0.003 or 0,
				get_weight = function(self, weight, object_type)
					return z
				end,
			})
		end,
		requires = {"v_aejp_distillation"}
	}
end

if SMODS.Mods["Cryptid"] then --iluvatar
	SMODS.Voucher { 
		key = "iluvatar",
		atlas = "vouchertemp",
		order = 1e9 +2,
		pos = { x = 2, y = 1 },
		requires = {"v_aejp_redwood"},
		redeem = function()
			G.GAME.interest_factor = 2
		end,
		unredeem = function ()
			if not v("treesapling") then
				G.GAME.interest_factor = v("redwood") and 10 or 5
			else
				G.GAME.interest_factor = 8
			end
		end
	}
end

--[[
------------------------------
### Poker Hands (hexacryonic you're an actual genius tysm for this idea)
tba
------------------------------
--]]

-- SMODS.PokerHand({
-- 	key = "perhaps",
-- 	visible = false,
-- 	chips = 160,
-- 	mult = 16,
-- 	l_chips = 60,
-- 	l_mult = 6,
-- 	example = {
-- 		{ "S_A", true, "m_stone" },
-- 		{ "S_A", true, "m_stone" },
-- 		{ "S_A", true, "m_stone" },
-- 		{ "S_A", true, "m_stone" },
-- 		{ "S_A", true, "m_stone" },
-- 	},
-- 	evaluate = function(parts, hand)
-- 		return {}
-- 	end,
-- })

-- SMODS.PokerHand({
-- 	key = "yes",
-- 	visible = false,
-- 	chips = 200,
-- 	mult = 20,
-- 	l_chips = 80,
-- 	l_mult = 8,
-- 	example = {
-- 		{ "S_A", true, "m_stone" },
-- 		{ "S_A", true, "m_stone" },
-- 		{ "S_A", true, "m_stone" },
-- 		{ "S_A", true, "m_stone" },
-- 		{ "S_A", true, "m_stone" },
-- 	},
-- 	evaluate = function(parts, hand)
-- 		return {}
-- 	end,
-- })

-- SMODS.PokerHand({
-- 	key = "abs",
-- 	visible = false,
-- 	chips = 333,
-- 	mult = 33,
-- 	l_chips = 99,
-- 	l_mult = 11,
-- 	example = {
-- 		{ "S_A", true, "m_stone" },
-- 		{ "S_A", true, "m_stone" },
-- 		{ "S_A", true, "m_stone" },
-- 		{ "S_A", true, "m_stone" },
-- 		{ "S_A", true, "m_stone" },
-- 		{ "S_A", true, "m_stone" },
-- 		{ "S_A", true, "m_stone" },
-- 		{ "S_A", true, "m_stone" },
-- 	},
-- 	evaluate = function(parts, hand)
-- 		return {}
-- 	end,
-- })

-- SMODS.Consumable {
-- 	set = "Planet",
-- 	key = "tatooine",
-- 	order = 4,
-- 	config = { hand_type = "aejp_perhaps", softlock = true },
-- 	pos = { x = 0, y = 0 },
-- 	atlas = "planetarytravel",
-- 	aurinko = true,
-- 	loc_vars = function(self, info_queue, center)
-- 		local levelone = G.GAME.hands["aejp_perhaps"].level or 1
-- 		local planetcolourone = G.C.HAND_LEVELS[math.min(levelone, 7)]
-- 		if levelone == 1 then
-- 			planetcolourone = G.C.UI.TEXT_DARK
-- 		end
-- 		return {
-- 			vars = {
-- 				localize("aejp_perhaps"),
-- 				G.GAME.hands["aejp_perhaps"].level,
-- 				G.GAME.hands["aejp_perhaps"].l_mult,
-- 				G.GAME.hands["aejp_perhaps"].l_chips,
-- 				colours = { planetcolourone },
-- 			},
-- 		}
-- 	end,
-- 	generate_ui = 0,
-- }

-- SMODS.Consumable {
-- 	set = "Planet",
-- 	key = "planetpopstar",
-- 	order = 4,
-- 	config = { hand_type = "aejp_yes", softlock = true },
-- 	pos = { x = 1, y = 0 },
-- 	atlas = "planetarytravel",
-- 	set_card_type_badge = function(self, card, badges)
-- 		badges[1] = create_badge(localize("k_planetpopstar", "v_dictionary"), get_type_colour(self or card.config, card), nil, 1.2)
-- 	end,
-- 	aurinko = true,
-- 	loc_vars = function(self, info_queue, center)
-- 		local levelone = G.GAME.hands["aejp_yes"].level or 1
-- 		local planetcolourone = G.C.HAND_LEVELS[math.min(levelone, 7)]
-- 		if levelone == 1 then
-- 			planetcolourone = G.C.UI.TEXT_DARK
-- 		end
-- 		return {
-- 			vars = {
-- 				localize("aejp_yes"),
-- 				G.GAME.hands["aejp_yes"].level,
-- 				G.GAME.hands["aejp_yes"].l_mult,
-- 				G.GAME.hands["aejp_yes"].l_chips,
-- 				colours = { planetcolourone },
-- 			},
-- 		}
-- 	end,
-- 	generate_ui = 0,
-- }

-- SMODS.Consumable {
-- 	set = "Planet",
-- 	key = "krypton",
-- 	order = 4,
-- 	config = { hand_type = "aejp_abs", softlock = true },
-- 	pos = { x = 2, y = 0 },
-- 	atlas = "planetarytravel",
-- 	aurinko = true,
-- 	loc_vars = function(self, info_queue, center)
-- 		local levelone = G.GAME.hands["aejp_abs"].level or 1
-- 		local planetcolourone = G.C.HAND_LEVELS[math.min(levelone, 7)]
-- 		if levelone == 1 then
-- 			planetcolourone = G.C.UI.TEXT_DARK
-- 		end
-- 		return {
-- 			vars = {
-- 				localize("aejp_abs"),
-- 				G.GAME.hands["aejp_abs"].level,
-- 				G.GAME.hands["aejp_abs"].l_mult,
-- 				G.GAME.hands["aejp_abs"].l_chips,
-- 				colours = { planetcolourone },
-- 			},
-- 		}
-- 	end,
-- 	generate_ui = 0,
-- }

-- SMODS.Consumable {
-- 	set = "Planet",
-- 	key = "tietenkin",
-- 	pos = { x = 3, y = 0 },
-- 	config = { hand_types = { "aejp_perhaps", "aejp_yes", "aejp_abs" }, softlock = true },
-- 	cost = 4,
-- 	aurinko = true,
-- 	atlas = "planetarytravel",
-- 	order = 12,
-- 	can_use = function(self, card)
-- 		return true
-- 	end,
-- 	loc_vars = function(self, info_queue, center)
-- 		local levelone = G.GAME.hands["aejp_perhaps"].level or 1
-- 		local leveltwo = G.GAME.hands["aejp_yes"].level or 1
-- 		local levelthree = G.GAME.hands["aejp_abs"].level or 1
-- 		local planetcolourone = G.C.HAND_LEVELS[math.min(levelone, 7)]
-- 		local planetcolourtwo = G.C.HAND_LEVELS[math.min(leveltwo, 7)]
-- 		local planetcolourthree = G.C.HAND_LEVELS[math.min(levelthree, 7)]
-- 		if levelone == 1 or leveltwo == 1 or levelthree == 1 then --Level 1 colour is white (The background), so this sets it to black
-- 			if levelone == 1 then
-- 				planetcolourone = G.C.UI.TEXT_DARK
-- 			end
-- 			if leveltwo == 1 then
-- 				planetcolourtwo = G.C.UI.TEXT_DARK
-- 			end
-- 			if levelthree == 1 then
-- 				planetcolourthree = G.C.UI.TEXT_DARK
-- 			end
-- 		end
-- 		return {
-- 			vars = {
-- 				localize("aejp_perhaps", "poker_hands"),
-- 				localize("aejp_yes", "poker_hands"),
-- 				localize("aejp_abs", "poker_hands"),
-- 				G.GAME.hands["aejp_perhaps"].level,
-- 				G.GAME.hands["aejp_yes"].level,
-- 				G.GAME.hands["aejp_abs"].level,
-- 				colours = { planetcolourone, planetcolourtwo, planetcolourthree },
-- 			},
-- 		}
-- 	end,
-- 	use = function(self, card, area, copier)
-- 		Cryptid.suit_level_up(self, card, area, copier)
-- 	end,
-- 	bulk_use = function(self, card, area, copier, number)
-- 		Cryptid.suit_level_up(self, card, area, copier, number)
-- 	end,
-- 	calculate = function(self, card, context)
-- 		if
-- 			G.GAME.used_vouchers.v_observatory
-- 			and context.joker_main
-- 			and (
-- 				context.scoring_name == "aejp_perhaps"
-- 				or context.scoring_name == "aejp_yes"
-- 				or context.scoring_name == "aejp_abs"
-- 			)
-- 		then
-- 			local value = G.P_CENTERS.v_observatory.config.extra
-- 			return {
-- 				message = localize({ type = "variable", key = "a_xmult", vars = { value } }),
-- 				Xmult_mod = value,
-- 			}
-- 		end
-- 	end,
-- }

--[[
------------------------------
### Functions and hooks
------------------------------
--]]

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

-- colors
local lc = loc_colour
function loc_colour(_c, _default)
	if not G.ARGS.LOC_COLOURS then
		lc()
	end
	G.ARGS.LOC_COLOURS.weird = HEX("a28cff")
	G.ARGS.LOC_COLOURS.full_black = HEX("000000")
	G.ARGS.LOC_COLOURS.full_red = HEX("FF0000")
	G.ARGS.LOC_COLOURS.dark_money = HEX("CD8000")
	G.ARGS.LOC_COLOURS.crimson_red = HEX("AC3232")
	G.ARGS.LOC_COLOURS.lunatic = HEX("ae2701")
	return lc(_c, _default)
end

G.get_interest_num = function(payload)
	local d = G.GAME.interest_amount*math.floor(math.min(G.GAME.dollars/5, G.GAME.interest_cap/5))
	local t = tostring(d)
	local f = 5
	local f2 = G.GAME.interest_amount
	if payload then f2 = G.GAME.interest_amount*(G.GAME.cry_payload or 1) end
	local n = d
	local p = G.GAME.interest_cap
	local c = G.C.MONEY
	local op = ""
	if G.GAME.used_vouchers["v_aejp_iluvatar"] then
		f = 2
		f2 = f2 * 0.01
		p = p*8
		n = f2*math.floor(math.min(G.GAME.dollars, p/5))
		op = "^"
		d = math.floor(G.GAME.dollars^n)
		c = G.C.DARK_EDITION
	elseif G.GAME.used_vouchers["v_aejp_redwood"] then
		f = 8
		f2 = f2 * 0.15
		n = f2*math.floor(math.min(G.GAME.dollars/f, p/5))
		op = "X"
		d = math.floor(G.GAME.dollars*n)
		c = G.C.HAND_LEVELS[5]
	elseif G.GAME.used_vouchers["v_aejp_treesapling"] then
		f = 10
		f2 = f2 * 0.1
		n = f2*math.floor(math.min(G.GAME.dollars/f, p/5))
		op = "X"
		d = math.floor(G.GAME.dollars*n)
		c = G.C.HAND_LEVELS[4]
	end
	t = op..tostring(n)
	if payload then c = G.C.SECONDARY_SET.Code end
	return {
		money = d,
		text = t,
		intQuantize = f,
		intFactor = f2,
		intCap = p,
		operator = op,
		color = c,
	}
end

local sr = Game.start_run
function Game:start_run(args)
	sr(self, args)
	G.GAME.interest_factor = G.GAME.interest_factor or 5
end