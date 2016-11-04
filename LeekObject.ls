//The 'Check' parameter need to be at true if you are not sure about you argument passed in parameter

function new_Leek (@check, @ai, @lvl, @cell, @teamID, @type, @summoner, @birthTurn, @life, @lifeMax, @strength, @wisdom, @agility, @resistance, @science, @magic,
 @frequency, @TP, @MP, @TPMax, @MPMax, @currentWeapon, @weapons, @chips, @effects, @lauchedEffect) {
	return function (@cmd) {
		return @(
			cmd < 16 ?
				cmd <  8 ?
					cmd < 4 ?
						cmd < 2 ?
							cmd < 1 ?
								ai 				// 0
							:	lvl 			// 1
						:	cmd < 3 ?
								cell 			// 2 
							:	teamID 			// 3
					:	cmd < 6 ?
							cmd < 5 ? 
								type 			// 4
							:	summoner 		// 5 
						:	cmd < 7 ?
								birthTurn 		// 6
							:	life 			// 7
				:	cmd < 12 ?
						cmd < 10 ?
							cmd < 9 ?
								lifeMax 		// 8
							:	strength 		// 9
						:	cmd < 11 ?
								wisdom 			// 10
							:	agility 		// 11
					:	cmd < 14 ?
							cmd < 13 ? 
								resistance 		// 12
							:	science 		// 13
						:	cmd < 15 ?
								magic 			// 14
							:	frequency 		// 15
			:   cmd <  24 ?
					cmd < 20 ?
						cmd < 18 ?
							cmd < 17 ?
								TP 				// 16
							:	TPMax 			// 17
						:	cmd < 19 ?
								MP 				// 18
							:	MPMax 			// 19
					:	cmd < 22 ?
							cmd < 21 ? 
								currentWeapon 	// 20
							:	weapons 		// 21
						:	cmd < 23 ?
								chips 			// 22
							:	effects 		// 23
				:	cmd < 28 ?
						cmd < 26 ?
							cmd < 25 ?
								lauchedEffect 	// 24
							:	null 			// 25
						:	null /*cmd < 27 ?
								cell 			// 26
							:	teamID*/ 		// 27
					:	null /*cmd < 30 ?
							cmd < 29 ? 
								lvl 			// 28
							:	cell 			// 29 
						:	cmd < 31 ?
								cell 			// 30
							:	teamID 	*/		// 31
		)
	};
}

global runAI = 0,
	   gtLevel = 1,
	   gtCell = 2,
	   gtTeam = 3,
	   gtType = 4,
	   gtSummoner = 5,
	   gtBirthTurn = 6,
	   gtLife = 7,
	   gtTotalLife = 8,
	   gtStrenght = 9,
	   gtWisdom = 10,
	   gtAgility = 11,
	   gtResistance = 12,
	   gtScience = 13,
	   gtMagic = 14,
	   gtFrequency = 15,
	   gtTP = 16,
	   getTotalTP = 17,
	   gtMP = 18,
	   gtTotalMP = 19,
	   gtWeapon = 20,
	   gtWeapons = 21,
	   gtChips = 22,
	   gtEffects = 23,
	   gtLaunchedEffects = 21;

var l = new_Leek(false, function () {}, 139, 1, 0, ENTITY_LEEK, "gtSummoner", 0, 873, 874, 300, 100, 0, 300, 2000, 50, 100, 10, 4, 12, 6, null, [109, 43], [8, 18, 20, 21, 22, 29, 32, 33, 34], ["gtEffects"], ["gtLaunchedEffects"]);
include("102_Debug");

bench_verify(ToFr_1(l)(runAI), function () {}, "runAI");
bench_verify(ToFr_1(l)(gtLevel), 139, "gtLevel");
bench_verify(ToFr_1(l)(gtCell), 1, "gtCell");
bench_verify(ToFr_1(l)(gtTeam), 0, "gtTeam");
bench_verify(ToFr_1(l)(gtType), ENTITY_LEEK, "gtType");
bench_verify(ToFr_1(l)(gtSummoner), "gtSummoner", "gtSummoner");
bench_verify(ToFr_1(l)(gtBirthTurn), 0, "gtBirthTurn");
bench_verify(ToFr_1(l)(gtLife), 873, "gtLife");
bench_verify(ToFr_1(l)(gtTotalLife), 874, "gtTotalLife");
bench_verify(ToFr_1(l)(gtStrenght), 300, "gtStrenght");
bench_verify(ToFr_1(l)(gtWisdom), 100, "gtWisdom");
bench_verify(ToFr_1(l)(gtAgility), 0, "gtAgility");
bench_verify(ToFr_1(l)(gtResistance), 300, "gtResistance");
bench_verify(ToFr_1(l)(gtScience), 2000, "gtScience");
bench_verify(ToFr_1(l)(gtMagic), 50, "gtMagic");
bench_verify(ToFr_1(l)(gtFrequency), 100, "gtFrequency");
bench_verify(ToFr_1(l)(gtTP), 10, "gtTP");
bench_verify(ToFr_1(l)(getTotalTP), 12, "getTotalTP");
bench_verify(ToFr_1(l)(gtMP), 4, "gtMP");
bench_verify(ToFr_1(l)(gtTotalMP), 6, "gtTotalMP");
bench_verify(ToFr_1(l)(gtWeapon), null, "gtWeapon");
bench_verify(ToFr_1(l)(gtWeapons), [109, 43], "gtWeapons");
bench_verify(ToFr_1(l)(gtChips), [8, 18, 20, 21, 22, 29, 32, 33, 34], "gtChips");
bench_verify(ToFr_1(l)(gtEffects), ["gtEffects"], "gtEffects");
bench_verify(ToFr_1(l)(gtLaunchedEffects), ["gtLaunchedEffects"], "gtLaunchedEffects");