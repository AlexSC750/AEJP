return {
    descriptions = {
        -- this key should match the set ("object type") of your object,
        -- e.g. Voucher, Tarot, or the key of a modded consumable type
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
            -- this should be the full key of your object, including any prefixes
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
					"Retrigger the {C:weird}score calculation process",
					"on the {C:attention}final hand{} of round",
					"{C:inactive,s:0.75}T.B.A" --wakey wakey
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
					"{C:inactive,s:0.75}BTW, stop reading this.",
				},
				text_alt = {
					"{X:dark_edition,C:white}^0.1{} Mult",
					"Reverts back on beating a Boss Blind",
					"{C:inactive,s:0.75}Disappointment.",
				}
            },
			j_aejp_lollipop = {
				name = 'Lollipop',
				text = {
					"{X:dark_edition,C:white}^#1#{} Mult",
					"Lose {X:dark_edition,C:white}^#2#{} Mult every second",
					"{C:inactive,s:0.75}Roughly #3# left"
				},
            },
        },
    },
	misc = {
        v_dictionary={
			a_hand_chipmult="Adding: #1#",
			speed_demon_timeout = ":("
		},
    },
}