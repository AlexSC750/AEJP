return {
    descriptions = {
		Blind={
			bl_aejp_unknown = {
				name = "Umber Unknown",
                text = {
                    "Base Mult is negative level",
					"of the played hand"
                },
			}
		},
        Joker = {
            j_aejp_quasilinear = {
				name = 'Quasilinear',
				text = {
					"{X:weird,C:white}X{X:weird,C:white}log(M)+1{} Mult",
					"{C:inactive}M = current Mult when triggered{}"
				}
            },
			j_aejp_bell = {
				name = 'Tsar Bell',
				text = {
					"Retrigger the {C:weird,E:1}score calculation process{}",
					"on the {C:attention}final hand{} of round",
				}
            },
			j_aejp_dropdown = {
				name = 'Dropdown List',
				text = {
					"Before scoring, add the {C:chips}Chips{} and {C:mult}Mult{}",
					"from all poker hands lower ranked",
					"than the played hand",
					"{C:inactive,s:0.75}Secret hands have to be discovered to count{}"
				}
            },
			j_aejp_speeddemon = {
				name = 'Speed Demon',
				text = {
					"You have {X:full_black,C:full_red,s:1.25}[#1#]{} minutes to finish the Ante,",
					"resets on defeating the Boss Blind",
					"{X:dark_edition,C:white}^#2#{} Mult, increase by {X:dark_edition,C:white}^#3#{} every Ante",
					"Lose {X:dark_edition,C:white}^#3#{} Mult on skipping a blind {C:inactive}(min. of ^1)",
					"On selecting a blind, gain its tag",
				},
            },
			j_aejp_speeddemon2 = {
				name = 'Speed Demon (Challenge)',
				text = {
					"You have {X:full_black,C:full_red,s:1.25}[#1#]{} minutes to finish the run",
					"{X:dark_edition,C:white}^#2#{} Mult, increase by {X:dark_edition,C:white}^#3#{} every Ante",
					"Lose {X:dark_edition,C:white}^#3#{} Mult on skipping a blind {C:inactive}(min. of ^1)",
					"On selecting a blind, gain its tag",
				},
            },
			j_aejp_speeddemonded = {
				name = 'Speed Demon',
				text = {
					"{X:dark_edition,C:white}^0.1{} Mult",
					"Reverts back on beating a Boss Blind",
					"{C:inactive,s:0.75}Disappointment.",
				},
            },
			j_aejp_lollipop = {
				name = 'Lollipop',
				text = {
					"{X:dark_edition,C:white}^#1#{} Mult",
					"Lose {X:dark_edition,C:white}^#2#{} Mult every second",
					"{C:inactive,s:0.75}Roughly #3# left"
				},
            },
			j_aejp_nailcoffin = {
				name = 'Nail in the Coffin',
				text = {
					"On defeating a {C:attention}Boss Blind{},",
					"increase {X:weird,C:white,s:1.1}everything{} by 1",
					"{C:inactive,s:0.5}Hands, Discards, Ante, hand size, card selection limit",
					"{C:inactive,s:0.5}Joker/consumable/shop/booster/voucher slots, reroll cost,",
					"{C:inactive,s:0.5}Joker values, consumable values, playing card values (if possible)",
				},
            },
			--[[ 2^x mult if you play all 2s? ]]
			--[[ heartbleed? like the vulnerability from 2014
				no idea what to do w it
			]]
			--[[ rta joker that gets better with time (no idea what effect tho) ]]
			--[[ consumables
					the messenger: convert 1 card into a wild rank card
					the redundant: convert 3 cards into nothings
					???: create 
					asinine: create a lunatic joker
					unparalleled: create an unreasonable joker, -2 joker slots
			]]
        },
        Planet={
			c_aejp_tatooine = {
				name = "Tatooine",
				text = {
					"{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
					"{C:attention}#2#",
					"{C:mult}+#3#{} Mult and",
					"{C:chips}+#4#{} chip#<s>4#",
				}
			},
			c_aejp_planetpopstar = {
				name = "Planet Popstar",
				text = {
					"{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
					"{C:attention}#2#",
					"{C:mult}+#3#{} Mult and",
					"{C:chips}+#4#{} chip#<s>4#",
				}
			},
			c_aejp_krypton = {
				name = "Krypton",
				text = {
					"{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
					"{C:attention}#2#",
					"{C:mult}+#3#{} Mult and",
					"{C:chips}+#4#{} chip#<s>4#",
				}
			},
			c_aejp_tietenkin = {
				name = "Tietenkin",
				text = {
					"({V:1}lvl.#4#{})({V:2}lvl.#5#{})({V:3}lvl.#6#{})",
					"Level up",
					"{C:attention}#1#{},",
					"{C:attention}#2#{}, and",
					"{C:attention}#3#{}",
				}
			},
		},
		Voucher = {
			-- filtration line
			v_aejp_filtration = {
				name = "Filtration",
				text = {
					"{C:green}Uncommon{} and {C:red}Rare{} Jokers",
					"appear {C:attention}1.75X{} more frequently in the shop"
				}
			},
			v_aejp_distillation = {
				name = "Distillation",
				text = {
					"{C:blue}Common{}, {C:green}Uncommon{} and {C:red}Rare{} Jokers",
					"have the {C:weird}same probability{} of appearing in the shop",
					"{C:lunatic}Lunatic{} Jokers can appear in the shop {C:inactive}(rarely){}",
				}
			},
			v_aejp_chromatography = {
				name = "Chromatography",
				text = {
					"All {C:weird}Joker rarities{} can appear in the shop {C:inactive,s:0.75}T.B.A",
					"{C:lunatic}Lunatic{} and {C:cry_epic}Epic{} Jokers appear",
					"{C:lunatic}5X{} and {C:cry_epic}10X{} more frequently in the shop",
				}
			},
			-- tree sapling line
			v_aejp_treesapling = {
				name = "Tree Sapling",
				text = {
					"Interest becomes {C:dark_money}multiplicative{}",
					"Gain {X:dark_money,C:white}$X0.1{} interest for",
					"every {C:money}$10{} you have per round",
				}
			},
			v_aejp_redwood = {
				name = "Redwood Tree",
				text = {
					"Gain {X:dark_money,C:white}$X0.15{} interest for",
					"every {C:money}$8{} you have per round",
				}
			},
			v_aejp_iluvatar = {
				name = "Iluvatar",
				text = {
					"Interest becomes {X:dark_edition,C:white}exponential{}",
					"Gain {X:dark_edition,C:white}$^0.01{} interest for",
					"every {C:money}$2{} you have per round",
					"{X:dark_money,C:white}X8{} interest cap"
				}
			},
		}
    },
	misc = {
		poker_hands = {
			['aejp_perhaps'] = "Perhaps",
			['aejp_yes'] = "Yes",
			['aejp_abs'] = (SMODS.Mods["Cryptid"] and Cryptid_config.family_mode) and "Absolutely" or "Abso-fucking-lutely",
		},
		poker_hand_descriptions = {
			['aejp_perhaps'] = {
				"5 Wild Rank cards. Counts as every 5-card hand type",
				"except those that contain a Flush."
			},
			['aejp_yes'] = {
				"5 Wild Rank cards of the same suit.",
				"Counts as every 5-card hand type."
			},
			['aejp_abs'] = {
				"8 Wild Rank cards. Counts as every hand type, period."
			},
		},
		challenge_names = {
			c_aejp_speedrun = "Time Attack"
		},
        v_dictionary={
			a_hand_chipmult="Adding: #1#",
			speed_demon_timeout = ":(",
			speed_demon_avenge = ":)",
			a_emult = "^#1# Mult",
			a_emult_minus = "-^#1# Mult",
			full_retrigger = "Do it again...",
			speed_demon_challenge_over = "ggs",

			k_planetpopstar = "Poyo!"
		},
    },
}