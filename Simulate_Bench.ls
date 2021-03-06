//:://///////////////////////////////////////////////////////////////////////////////////////////////////////////
/* CREATED BY HAZURL...
Ce script vous permet de simuler une ou plusieurs situation(s), il permet notament de :
	:: Crée des poireaux avec des caractéristiques / puces / armes précises
	:: Simuler un terrain avec des obstacles...
	:: Simuler des actions / des calculs
Tout ceci dans le but d'optimiser ces fonctions tout en gardant la même configuration de terrain/adversaire, le nombre d'opérations est ainsi comparable

NOTE :
	:: Les fonctions de la catégorie "poireau" de la doc peuvent être utilisé avec des poireaux existants cependant une erreur est affiché, si cela étais votre choix, ignorer là.
	:: Dans la même optique, pour créer un poireau à son image les anciennes fonctions sont nécéssaires, en utilisant "CREATMYLEEKFAKEONSTART" vous eviter les erreurs (contrairement à si vous appeler la fonction CreateMyLeekFake, les erreurs s'afficheront).
	:: Pour creer votre poireau, deux fonction s'offre à vous : CreateMyLeekFake qui crée un poireau à votre image (sur la même position) ou MyLeekCustom avec cette fonctions vous avez le choix pour chaque caractéristiques sauf certain qui reste automatique (comme le type ENTITY_LEEK)
*/
//:://///////////////////////////////////////////////////////////////////////////////////////////////////////////
//:: CONSTANTE DE RETOUR, AFIN DE SIMPLIFIER LE CODES ERREURS
global SIM_SUCCESS = @1;

global SIM_ERR_ID = @-1;
global SIM_ERR_PARAMTYPE = @-2;
global SIM_ERR_PARAM_DATARANGE = @-3;

//:: PARAMETRE
//Couleur pour les displays :
global COLOR_MAP_OBSTACLE = @getColor(255, 255, 255); // Obstacle sur la carte
global COLOR_MAP_EMPTY = @getColor(0, 0, 0); // Cellule vide
global COLOR_MAP_MYLEEK = @getColor(0, 150, 255); // cellule de votre poireau
global COLOR_MAP_ENEMY = @COLOR_RED; // Cellules des enemies
global COLOR_MAP_ALLY = @COLOR_BLUE; // Cellules des alliés

global COLOR_TEXT_DESCRIBE = @getColor(150, 0, 150); // Debug pour décrire les poireaux
global COLOR_TEXT_CREATED = @getColor(0, 180, 0); // Debug pour afficher la création d'un poireau'
global COLOR_TEXT_DELETED = @getColor(255, 150, 0); // Debug pour la destruction d'un poireau
global COLOR_TEXT_ERROR = @getColor(200, 0, 0); // Debug pour les erreurs

// Indique le tour ou les fonctions sont initialise
global TURN_TO_INITIALISE = @1;
// Dans le cas où la cellule est occupé par un obstacles, le poireau n'est pas crée
global CREATMYLEEKFAKEONSTART = @false; //True si vous voulez que votre poireau soit crée au lancement de la partie (evite certains msg d'erreur)

global RESETONTURNSTART = @false; //True si vous voulez remetre les TPs/MPs... à leur valeur par défaut (TotalTP/TotalMP...)
global INITIALISEFUNCTION = @true; //True si vous voulez utiliser les fonctions natives de simulations

global SIMULATETP = @false; //True si vous voulez retirer des TPs lors d'actions en necessitant
global SIMULATEMP = @false; //True si vous voulez retirer des MPs lors d'actions en necessitant
global SIMULATEAI = @true;

// Carte des obstacles : Veuillez renseigner : 0 pour une cellule vide / 1 pour un obstacle (les poireaux sont à placer au moment de leur création)
global INITIALISETERRAIN = @true; //True si vous voulez utiliser la map du combat, pas celle généré...
global USETHISMAPGENERATION = @true; //True si vous voulez utiliser ce tableau :
global OBSTACLES; OBSTACLES = @[0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
								  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 
								0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
								  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 
								0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
								  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 
								0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  0,  0,  0,
								  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  0,  0, 
								0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  1,  0,  0,
								  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  0,  1,  1,  0,  0, 
								0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  0,  1,  0,  0,  0,
								  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  0,  0,  0,  0,  0, 
								0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  1,  1,  1,  0,  0,  0,  0,
								  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  1,  0,  0,  0,  0,  0, 
								0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  1,  0,  1,  0,  0,  0,  0,  0,
								  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  1,  0,  0,  0,  0,  0,  0, 
								0,  0,  0,  0,  0,  0,  0,  1,  0,  1,  0,  1,  0,  0,  0,  0,  0,  0,
								  0,  0,  0,  0,  0,  0,  1,  1,  0,  1,  1,  0,  0,  0,  0,  0,  0, 
								0,  0,  0,  0,  0,  0,  1,  0,  0,  0,  1,  0,  0,  0,  0,  0,  0,  0,
								  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0, 
								0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  0,  0,  0,  0,  0,  0,
								  0,  0,  0,  0,  1,  1,  0,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0, 
								0,  0,  0,  0,  0,  0,  1,  0,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,
								  0,  0,  0,  0,  1,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 
								0,  0,  0,  1,  0,  1,  0,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
								  0,  0,  0,  1,  0,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 
								0,  0,  1,  0,  1,  0,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
								  0,  0,  1,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 
								0,  0,  0,  1,  0,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
								  0,  0,  0,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 
								0,  0,  0,  0,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
								  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 
								0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
								  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 
								0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0];
//:://///////////////////////////////////////////////////////////////////////////////////////////////////////////
//:: FONCTIONS CUSTOMS
//		StartOperation() - Demarre le calcul du nombre d'opérations
//		EndOperation() - Retourne le nombre d'opérations depuis le dernier StartOpération
//		DisplayMap() - "mark" les cases tels que les obstacles, les cases vides ainsi que les poireaux, les couleurs sont modifiables dans les paramètres
//		DescribeLeek(id) - Décris le poireau (la couleur du debug est modifiable dans les paramètres), indique son type (poireau/bulbe) sa vie et sa cellule
//		DeleteLeekOnTurn(leek, turn) - Destruis l'entité au tour "turn"
//		getNewID () - Retourne un ID pour un nouveau poireau
//		MyLeekCustom(lvl, cell, life, lifeMax, strength, wisdom, agility, resistance, science, magic, frequency, TP, MP, TPMax, MPMax, currentWeapon, weapons, chips, effects, lauchedEffect) - Crée un nouveau poireau avec les caractéristiques et attributs donné et retourne le poireau
// 		CreateMyLeekFake() - Crée un poireau fake à votre image
//		DefaultMyLeekCreation(cell, TPMax, MPMax, weapon, weapons, chips) - Crée un votre poireau à votre image tout en modifiant les principaux attributs
//		DefaultLeekCreation(cell, TPMax, MPMax, weapon, weapons, chips) - Crée un poireau avec des caractéristiques par défaut, renseigner les principaux attributs du poireau
// 		newLeek (cell, is_Ally, type, summoner, birthTurn, life, lifeMax, strength, wisdom, agility, resistance, science, magic, frequency, TP, MP, currentWeapon, weapons, chips, effects, lauchedEffect) - Crée un nouveau poireau avec les caractéristiques et attributs donné et retourne le poireau
//		deleteLeek(id) - Détruis un poireau
// 		AddEffectTo(leek, type, value, caster_id, turn, critical, item_id, target_id) - Ajoute un effet à un poireau d'ID "leek"
// 		AddLaunchedEffectTo(leek, type, value, caster_id, turn, critical, item_id, target_id) - Ajoute un effet provoqué à un poireau d'ID "leek"
// 		Effect_TotalValue(leek, type_value) - Retourne la valeur total de l'effet "type_value" du poireau d'ID "leek"
//		Generate_Terrain(obstacles) - Génère un terrain avec les obsatcles présent dans le tableau "obstacles"
//		ChangeWeapon (leek, weapon) - Change l'arme courante du poireau (celle-ci dois être dans son inventaire)
//		SetCell (leek, cell) - Modifie la cellule d'un poireau
//		SetLevel (leek, lvl) - Modifie le level d'un poireau
//		SetType_Summoner (leek, type, summoner) - Modifie le type et l'invocateur d'un poireau
//		SetBirthTurn (leek, birthTurn) - Modifie le tour de créaton du poireau d'un poireau
//		SetLife_LifeMax (leek, life, lifeMax) - Modifie la vie ainsi que sa vitalité max d'un poireau
//		SetStrength (leek, strength) - Modifie la force d'un poireau
//		SetWisdom (leek, wisdom) - Modifie la sagesse d'un poireau
//		SetAgility (leek, agility) - Modifie l'agilité d'un poireau
//		SetResistance (leek, resistance) - Modifie la resistance d'un poireau
//		SetScience (leek, science) - Modifie la science d'un poireau
//		SetMagic (leek, magic) - Modifie la magie d'un poireau
//		SetFrequency (leek, frequency)  - Modifie la fréquence d'un poireau
//		SetTP_TPMax (leek, TP, TPMax) - Modifie les TPs d'un poireau
//		SetMP_MPMax (leek, MP, MPMax) - Modifie les MPs d'un poireau
//		canUseChipOnCellFrom (Chip, cell, from)) - Retourne true si votre poireau peut attaquer depuis "from" sur "cell" avec la puce "chip"
//		canUseWeaponOnCellFrom (weapon, cell, from) - Retourne true si votre poireau peut attaquer depuis "from" sur "cell" avec l'arme "weapon"
//:://///////////////////////////////////////////////////////////////////////////////////////////////////////////
//:: GLOBAL
global ID_Leek = @1000;
global _Leek = @[];
global _myID = @null;

global _LastgetLeek 			= @getLeek;
global _LastgetLevel 			= @getLevel;
global _LastgetCell 			= @getCell;
global _LastisAlly 				= @isAlly;
global _LastisEnemy 			= @isEnemy;
global _LastgetLife 			= @getLife;
global _LastgetTotalLife 		= @getTotalLife;
global _LastgetStrength 		= @getStrength;
global _LastgetWisdom 			= @getWisdom;
global _LastgetAgility 			= @getAgility;
global _LastgetResistance 		= @getResistance;
global _LastgetScience 			= @getScience;
global _LastgetMagic 			= @getMagic;
global _LastgetFrequency 		= @getFrequency;
global _LastgetTP 				= @getTP;
global _LastgetMP 				= @getMP;
global _LastgetWeapon 			= @getWeapon;
global _LastgetWeapons 			= @getWeapons;
global _LastgetChips 			= @getChips;
global _LastisDead 				= @isDead;
global _LastgetType 			= @getType;
global _LastisSummon 			= @isSummon;
global _LastgetSummoner 		= @getSummoner;
global _LastgetEffects 			= @getEffects;
global _LastgetLaunchedEffects 	= @getLaunchedEffects;
global _LastgetAbsoluteShield 	= @getAbsoluteShield;
global _LastgetRelativeShield 	= @getRelativeShield;
global _LastgetDamageReturn 	= @getDamageReturn;
global _LastgetBirthTurn 		= @getBirthTurn;

global _TerrainContent = @[]; if (getTurn() == 1) fill(_TerrainContent, CELL_EMPTY, 613);
global _ListObstacles = @[];

global ___OPERATIONS = @0;
global _DeleteAuto = @[];
//:://///////////////////////////////////////////////////////////////////////////////////////////////////////////
//:: DELETE LEEK AUTOMATIQUE
var foo = _DeleteAuto; _DeleteAuto = @[];
for (var delete in foo) { if (delete[0] > getTurn()) continue; delete[1](); push(_DeleteAuto, delete); }
//:: REINITIALISATION TP/MP...
if (RESETONTURNSTART) { //PARAMETRABLE !
	for (var leek in _Leek) {
		leek["TP"] = @leek["TPMax"];
		leek["MP"] = @leek["MPMax"];
		//TODO : EFFETS...
	}
}
//:: INITIALISATION AU TOUR 1
if (getTurn() === TURN_TO_INITIALISE) {		     					//PARAMETRABLE !
//:: INITAILISATION TERRAIN
if (INITIALISETERRAIN) {INIATIALISATION_TERRAIN(); 					//PARAMETRABLE !
//:: CREATION DU TERRAIN
if (USETHISMAPGENERATION) {Generate_Terrain(OBSTACLES);}} 			//PARAMETRABLE !
//:: CREATION DE SON POIREAU AUTOMATIQUEMENT
if (CREATMYLEEKFAKEONSTART) {CreateMyLeekFake(function () {});} 	//PARAMETRABLE !
//:: INITAILISATION TERRAIN
if (INITIALISEFUNCTION) {INIATIALISATION_FONCTIONS();}}				//PARAMETRABLE !
//:://///////////////////////////////////////////////////////////////////////////////////////////////////////////
//:: FONCTION CUSTOM
function _StartOperation () {___OPERATIONS = getOperations();}
function _EndOperation () {return getOperations() - ___OPERATIONS - 4;}

function DisplayMap () {
	for (var i = 0; i < 613; i++) mark(i, COLOR_MAP_EMPTY, 100);
	mark(getObstacles(),COLOR_MAP_OBSTACLE, 100);
	for (var leek in getAliveEnemies()) mark(getCell(leek), COLOR_MAP_ENEMY);
	for (var leek in getAliveAllies()) mark(getCell(leek), COLOR_MAP_ALLY);
	mark(getCell(getLeek()), COLOR_MAP_MYLEEK);
	return @SIM_SUCCESS;
}

function DisplayLeek (@id) {
	if (_Leek[id] === null) return @SIM_ERR_ID;
	debugC("Le "+((getType(id)===ENTITY_BULB)?"bulbe":"poireau")+" d'ID ("+id+") " +((isDead(id))?"est mort":("a " +getLife(id)+" sur "+getTotalLife(id)+" pdv maximum. Il est actuelement sur la cellule : " + getCell(id))), COLOR_TEXT_DESCRIBE);
	return @SIM_SUCCESS;
}

function DeleteLeekOnTurn (@leek, @turn) {
	if (_Leek[leek] === null) return @SIM_ERR_ID; 
	if (!(turn > getTurn)) @SIM_ERR_PARAM_DATARANGE;
	push(_DeleteAuto, [turn, function () { deleteLeek(leek); } ] ); return @SIM_SUCCESS;
}

function getNewID () { return @ID_Leek++; }

function MyLeekCustom (@ai, @lvl, @cell, @life, @lifeMax, @strength, @wisdom, @agility, @resistance, @science, @magic, @frequency, @TP, @MP, @TPMax, @MPMax, @currentWeapon, @weapons, @chips, @effects, @lauchedEffect) {
	return @(_myID = @newLeek(ai, lvl, cell, true, ENTITY_LEEK, null, 1, life, lifeMax, strength, wisdom, agility, resistance, science, magic, frequency, TP, MP, TPMax, MPMax, currentWeapon, weapons, chips, effects, lauchedEffect));
}

function CreateMyLeekFake (@ai) {
	return @(_myID = @newLeek(ai, getLevel(getLeek()), getCell(getLeek()), true, ENTITY_LEEK, null, getTurn(), getLife(getLeek()), getTotalLife(getLeek()), getStrength(getLeek()), getWisdom(getLeek()), getAgility(getLeek()), getResistance(getLeek()), getScience(getLeek()), getMagic(getLeek()), getFrequency(getLeek()), getTP(getLeek()), getMP(getLeek()), getTotalTP(getLeek()), getTotalMP(getLeek()), getWeapon(getLeek()), getWeapons(getLeek()), getChips(getLeek()), getEffects(getLeek()), getLaunchedEffects(getLeek())));
} 

function DefaultMyLeekCreation (@ai, @cell, @TPMax, @MPMax, @weapon, @weapons, @chips) {
	return @MyLeekCustom(ai, 1, cell, 1000, 1000, 0, 0, 0, 0, 0, 0, 100, TPMax, MPMax, TPMax, MPMax, weapon, weapons, chips, [], []);
}

function DefaultLeekCreation (@ai, @cell, @TPMax, @MPMax, @weapon, @weapons, @chips) {
	return @newLeek(ai, 1, cell, false, ENTITY_LEEK, null, getTurn(), 1000, 1000, 0, 0, 0, 0, 0, 0, 100, TPMax, MPMax, TPMax, MPMax, weapon, weapons, chips, [], []);
}

function newLeek (@ai, @lvl, @cell, @teamID, @type, @summoner, @birthTurn, @life, @lifeMax, @strength, @wisdom, @agility, @resistance, @science, @magic, @frequency, @TP, @MP, @TPMax, @MPMax, @currentWeapon, @weapons, @chips, @effects, @lauchedEffect) {

// Première vérification : le type des paramètres
	if (typeOf(ai) != TYPE_FUNCTION || typeOf(lvl) != TYPE_NUMBER || typeOf(cell) != TYPE_NUMBER || typeOf(teamID) != TYPE_NUMBER || typeOf(type) != TYPE_NUMBER || (typeOf(summoner) != TYPE_NUMBER && typeOf(summoner) != TYPE_NULL)  || typeOf(birthTurn) != TYPE_NUMBER || typeOf(life) != TYPE_NUMBER || typeOf(lifeMax) != TYPE_NUMBER || typeOf(strength) != TYPE_NUMBER || typeOf(wisdom) != TYPE_NUMBER || typeOf(agility) != TYPE_NUMBER || typeOf(resistance) != TYPE_NUMBER || typeOf(science) != TYPE_NUMBER || typeOf(magic) != TYPE_NUMBER || typeOf(frequency) != TYPE_NUMBER || typeOf(TP) != TYPE_NUMBER || typeOf(MP) != TYPE_NUMBER || typeOf(TPMax) != TYPE_NUMBER || typeOf(MPMax) != TYPE_NUMBER || (typeOf(currentWeapon) != TYPE_NUMBER && typeOf(currentWeapon) != TYPE_NULL) || typeOf(weapons) != TYPE_ARRAY || typeOf(chips) != TYPE_ARRAY || typeOf(effects) != TYPE_ARRAY || typeOf(lauchedEffect) != TYPE_ARRAY) return @SIM_ERR_PARAMTYPE;

// Seconde vérification : Les plages de données à respecter ainsi que d'autres conditions
	if (lvl < 1 || lvl > 301) { debugC("newLeek - Erreur le level dois être compris entre 1 et 301", COLOR_TEXT_ERROR); return @SIM_ERR_PARAM_DATARANGE; }
	if (cell < 0 || cell > 612 || !isEmptyCell(cell)) { debugC("newLeek - Erreur la cellule dois être comprise entre 0 et 612 inclus et ne dois pas être occupé", COLOR_TEXT_ERROR); return @SIM_ERR_PARAM_DATARANGE;}
	if (teamID < 0) {debugC("TeamID must be a positive number", COLOR_TEXT_ERROR); return @SIM_ERR_PARAM_DATARANGE; }
	if (type !== ENTITY_BULB && type !== ENTITY_LEEK) { debugC("newLeek - Erreur le type dois être au choix : ENTITY_BULB ou ENTITY_LEEK", COLOR_TEXT_ERROR); return @SIM_ERR_PARAM_DATARANGE; }
	if (!(type === ENTITY_BULB && _Leek[summoner] !== null || type === ENTITY_LEEK && summoner === null)) { debugC("newLeek - Erreur l'invocateur (son ID) doit être renseigner si l'entité est un bulbe, sinon reseigner null", COLOR_TEXT_ERROR); return @SIM_ERR_PARAM_DATARANGE; }
	if (birthTurn < 1) { debugC("newLeek - Erreur le birthTurn doit être supérieur ou égale à 1", COLOR_TEXT_ERROR); return @SIM_ERR_PARAM_DATARANGE; }
	if (lifeMax < life || lifeMax < 0) { debugC("newLeek - Erreur la vie du poireau ne peux pas depasser sa vie max", COLOR_TEXT_ERROR); return @SIM_ERR_PARAM_DATARANGE; }
	if (frequency < 0) { debugC("newLeek - Erreur la fréquence du poireau ne peux être inférieur à 0", COLOR_TEXT_ERROR); return @SIM_ERR_PARAM_DATARANGE; }
	if (TPMax < TP || TPMax < 0) { debugC("newLeek - Erreur les TPs du poireau ne peux pas depasser son nombre de TP max", COLOR_TEXT_ERROR); return @SIM_ERR_PARAM_DATARANGE; }
	if (MPMax < MP || MPMax < 0) { debugC("newLeek - Erreur les MPs du poireau ne peux pas depasser son nombre de MP max", COLOR_TEXT_ERROR); return @SIM_ERR_PARAM_DATARANGE; }
	if (currentWeapon !== null && search(weapons, currentWeapon) === null) { debugC("newLeek - Erreur l'arme équipé dans la main n'est pas dans son inventaire", COLOR_TEXT_ERROR); return @SIM_ERR_PARAM_DATARANGE; }
	if ((function (listeW) {for (var w in listeW) if (!isWeapon(w)) return false; return @true;}(weapons)) !== true) { debugC("newLeek - Erreur la liste d'arme dans l'inventaire du poireau ne contient pas seulement des armes", COLOR_TEXT_ERROR); return @SIM_ERR_PARAM_DATARANGE; }
	if ((function (listeC) {for (var c in listeC) if (!isChip(c)) return false; return @true;}(chips)) !== true) { debugC("newLeek - Erreur la liste de puce dans l'inventaire du poireau ne contient pas seulement des puces", COLOR_TEXT_ERROR); return @SIM_ERR_PARAM_DATARANGE; }
	if ((function (arrayE) {for (var E in arrayE) if (typeOf(E) !== TYPE_ARRAY || count(E) != 7) return @false; return @true;}(effects)) !== true) { debugC("newLeek - Erreur les effets du poireau ne sont pas valides", COLOR_TEXT_ERROR); return @SIM_ERR_PARAM_DATARANGE; }
	if ((function (arrayE) {for (var E in arrayE) if (typeOf(E) !== TYPE_ARRAY || count(E) != 7) return @false; return @true;}(lauchedEffect)) !== true) { debugC("newLeek - Erreur les effets provoqués par le poireau ne sont pas valides", COLOR_TEXT_ERROR); return @SIM_ERR_PARAM_DATARANGE; }

	var id = @getNewID();
	_TerrainContent[cell] = @id; // Afin d'optimiser getCellContent
	_Leek[id] = @["ai" : ai, "lvl" : lvl, "cell" : cell, "teamID" : teamID, "type" : type, "birthTurn" : birthTurn, "life" : life, "lifeMax" : lifeMax, "strength" : strength, "wisdom" : wisdom, "agility" : agility, "resistance" : resistance, "science" : science, "magic" : magic, "frequency" : frequency, "TP" : TP, "MP" : MP, "TPMax" : TPMax, "MPMax" : MPMax, "currentWeapon" : currentWeapon, "weapons" : weapons, "chips" : chips, "effects" : effects, "lauchedEffects" : lauchedEffect];
	return @id;
}

function deleteLeek (@id) {
	if (_Leek[id] === null) return @SIM_ERR_ID;
	removeKey(_Leek, id); return @SIM_SUCCESS;
}

function AddEffectTo (@leek, @type, @value, @caster_id, @turn, @critical, @item_id, @target_id) {
	if (typeOf(leek) != TYPE_NUMBER || typeOf(type) != TYPE_NUMBER || typeOf(caster_id) != TYPE_NUMBER || typeOf(turn) != TYPE_NUMBER || typeOf(critical) != TYPE_BOOLEAN || typeOf(item_id) != TYPE_NUMBER || typeOf(target_id) != TYPE_NUMBER) return @SIM_ERR_PARAMTYPE;
	if (_Leek[leek] === null) return @SIM_ERR_ID ;
	push(_Leek[leek]["effects"], [type, value, caster_id, turn, critical, item_id, target_id]); return @SIM_SUCCESS;
}

function AddLaunchedEffectTo (@leek, @type, @value, @caster_id, @turn, @critical, @item_id, @target_id) {
	if (typeOf(leek) != TYPE_NUMBER || typeOf(type) != TYPE_NUMBER || typeOf(caster_id) != TYPE_NUMBER || typeOf(turn) != TYPE_NUMBER || typeOf(critical) != TYPE_BOOLEAN || typeOf(item_id) != TYPE_NUMBER || typeOf(target_id) != TYPE_NUMBER) return @SIM_ERR_PARAMTYPE;
	if (_Leek[leek] === null) return @SIM_ERR_ID ;
	push(_Leek[leek]["lauchedEffects"], [type, value, caster_id, turn, critical, item_id, target_id]); return @SIM_SUCCESS;
}

function Effect_TotalValue (@leek, @type_value) {
	if (_Leek[leek] === null) return @SIM_ERR_ID;
	var tmp = 0;
	for (var effet in getEffects(leek)) if (effet[0] === type_value) tmp += effet[1];
	return @tmp;
}

function Generate_Terrain (@obstacles) {
	if (typeOf(obstacles) !== TYPE_ARRAY) return @SIM_ERR_PARAMTYPE;
	if (count(obstacles) > 613) return @SIM_ERR_PARAM_DATARANGE;
	for (var i = 0; i<count(obstacles); i++) if (obstacles[i] == 1) {_TerrainContent[i] = CELL_OBSTACLE; push(_ListObstacles, i);}
}

function ChangeWeapon (@leek, @weapon) {
	 if (_Leek[leek] === null) return @SIM_ERR_ID;
	 if (!inArray(_Leek[leek]["weapons"], weapon)) return @SIM_ERR_PARAM_DATARANGE;
	 if (!isWeapon(weapon)) return @SIM_ERR_PARAMTYPE;
	 _Leek[leek]["currentWeapon"] = weapon; return SIM_SUCCESS;
}

function SetAI (@leek, @ai) {
	if (_Leek[leek] === null) return @SIM_ERR_ID; 
	if (typeOf(ai) !== TYPE_FUNCTION) return @SIM_ERR_PARAMTYPE;
	_Leek[leek]["ai"] = ai; return @SIM_SUCCESS;
}

function SetCell (@leek, @cell) {
	if (_Leek[leek] === null) return @SIM_ERR_ID; 
	if (typeOf(cell) !== TYPE_NUMBER) return @SIM_ERR_PARAMTYPE;
	if (cell < 0 || cell > 612 || !isEmptyCell(cell)) return @SIM_ERR_PARAM_DATARANGE;
	_Leek[leek]["cell"] = cell; return @SIM_SUCCESS;
}

function SetLevel (@leek, @lvl) {
	if (_Leek[leek] === null) return @SIM_ERR_ID; 
	if (typeOf(lvl) != TYPE_NUMBER)  return @SIM_ERR_PARAMTYPE;
	if (lvl < 0 || lvl > 301) return @SIM_ERR_PARAM_DATARANGE;
	_Leek[leek]["lvl"] = lvl; return @SIM_SUCCESS;
}

function SetType_Summoner (@leek, @type, @summoner) {
	if (_Leek[leek] === null) return @SIM_ERR_ID; 
	if (type !== ENTITY_BULB && type !== ENTITY_LEEK) return @SIM_ERR_PARAMTYPE;
	if (((summoner !== null || _Leek[summoner] === null) && type === ENTITY_LEEK) || (_Leek[summoner] === null && type === ENTITY_BULB)) return @SIM_ERR_PARAM_DATARANGE;
	_Leek[leek]["summoner"] = summoner; _Leek[leek]["type"] = type; return @SIM_SUCCESS;
}

function SetBirthTurn (@leek, @birthTurn) {
	if (_Leek[leek] === null) return @SIM_ERR_ID; 
	if (typeOf(birthTurn) != TYPE_NUMBER)  return @SIM_ERR_PARAMTYPE;
	if (birthTurn < 0) return @SIM_ERR_PARAM_DATARANGE;
	_Leek[leek]["birthTurn"] = birthTurn; return @SIM_SUCCESS;
}

function SetLife_LifeMax (@leek, @life, @lifeMax) {
	if (_Leek[leek] === null) return @SIM_ERR_ID; 
	if (typeOf(life) != TYPE_NUMBER || typeOf(lifeMax) != TYPE_NUMBER) return @SIM_ERR_PARAMTYPE;
	if (lifeMax < life) return @SIM_ERR_PARAM_DATARANGE;
	_Leek[leek]["life"] = life; _Leek[leek]["lifeMax"] = lifeMax; return @SIM_SUCCESS;
}

function SetStrength (@leek, @strength) {
	if (_Leek[leek] === null) return @SIM_ERR_ID; 
	if (typeOf(strength) != TYPE_NUMBER)  return @SIM_ERR_PARAMTYPE;
	if (strength < 0) return @SIM_ERR_PARAM_DATARANGE;
	_Leek[leek]["strength"] = strength; return @SIM_SUCCESS;
}

function SetWisdom (@leek, @wisdom) {
	if (_Leek[leek] === null) return @SIM_ERR_ID; 
	if (typeOf(wisdom) != TYPE_NUMBER)  return @SIM_ERR_PARAMTYPE;
	if (wisdom < 0) return @SIM_ERR_PARAM_DATARANGE;
	_Leek[leek]["wisdom"] = wisdom; return @SIM_SUCCESS;
}

function SetAgility (@leek, @agility) {
	if (_Leek[leek] === null) return @SIM_ERR_ID; 
	if (typeOf(agility) != TYPE_NUMBER)  return @SIM_ERR_PARAMTYPE;
	if (agility < 0) return @SIM_ERR_PARAM_DATARANGE;
	_Leek[leek]["agility"] = agility; return @SIM_SUCCESS;
}

function SetResistance (@leek, @resistance) {
	if (_Leek[leek] === null) return @SIM_ERR_ID; 
	if (typeOf(resistance) != TYPE_NUMBER)  return @SIM_ERR_PARAMTYPE;
	if (resistance < 0) return @SIM_ERR_PARAM_DATARANGE;
	_Leek[leek]["resistance"] = resistance; return @SIM_SUCCESS;
}

function SetScience (@leek, @science) {
	if (_Leek[leek] === null) return @SIM_ERR_ID; 
	if (typeOf(science) != TYPE_NUMBER)  return @SIM_ERR_PARAMTYPE;
	if (science < 0) return @SIM_ERR_PARAM_DATARANGE;
	_Leek[leek]["science"] = science; return @SIM_SUCCESS;
}

function SetMagic (@leek, @magic) {
	if (_Leek[leek] === null) return @SIM_ERR_ID; 
	if (typeOf(magic) != TYPE_NUMBER)  return @SIM_ERR_PARAMTYPE;
	if (magic < 0) return @SIM_ERR_PARAM_DATARANGE;
	_Leek[leek]["magic"] = magic; return @SIM_SUCCESS;
}

function SetFrequency (@leek, @frequency) {
	if (_Leek[leek] === null) return @SIM_ERR_ID; 
	if (typeOf(frequency) != TYPE_NUMBER) return @SIM_ERR_PARAMTYPE;
	if (frequency < 0) return @SIM_ERR_PARAM_DATARANGE;
	_Leek[leek]["frequency"] = frequency;  return @SIM_SUCCESS;
}

function SetTP_TPMax (@leek, @TP, @TPMax) {
	if (_Leek[leek] === null) return @SIM_ERR_ID; 
	if (typeOf(TP) != TYPE_NUMBER || typeOf(TPMax) != TYPE_NUMBER) return  @SIM_ERR_PARAMTYPE;
	if (TP > TPMax || TPMax < 0) return @SIM_ERR_PARAM_DATARANGE;
	_Leek[leek]["TP"] = TP; _Leek[leek]["TPMax"] = TPMax; return @SIM_SUCCESS;
}

function SetMP_MPMax (@leek, @MP, @MPMax) {
	if (_Leek[leek] === null) return @SIM_ERR_ID; 
	if (typeOf(MP) != TYPE_NUMBER || typeOf(MPMax) != TYPE_NUMBER) return @SIM_ERR_PARAMTYPE;
	if (MP > MPMax || MPMax < 0) return @SIM_ERR_PARAM_DATARANGE;
	_Leek[leek]["MP"] = MP; _Leek[leek]["MPMax"] = MPMax; return @SIM_SUCCESS;
}

function  canUseWeaponOnCellFrom (@weapon, @cell, @from) {
	var dist = @getCellDistance(from, cell);
	if (!(dist <= getWeaponMaxRange(weapon) && dist >= getWeaponMinRange(weapon))) return @false;
	if (isInlineWeapon(weapon) && !isOnSameLine(from, cell)) return @false;
	if (!lineOfSight(from,cell, getLeek())) return @false;
	return @true;
}

function canUseChipOnCellFrom (@Chip, @cell, @from) {
	var dist = @getCellDistance(from, cell);
	if (!(dist <= getChipMaxRange(Chip) && dist >= getChipMinRange(Chip))) return @false;
	if (isInlineChip(Chip) && !isOnSameLine(from, cell)) return @false;
	if (chipNeedLos(Chip) && !lineOfSight(getCell(getLeek()),cell, getLeek())) return @false;
	if (getCooldown(Chip, getLeek()) > 0) return @false;
	return @true;
}

function Area (@origine, @rayon) {
	var i = 0, toCheck = [origine], dist = 0, tmp, cells = [];
   	cells[origine] = 0;
   
   	while(dist < rayon) {
	    ++dist;
	    tmp = count(toCheck);
		while(i < tmp) {
			var k = getCellFromXY(getCellX(toCheck[i])+1, getCellY(toCheck[i]));
			if(k !== null && cells[k] === null) {  push(toCheck, k);  cells[k] = dist;  }
			k = getCellFromXY(getCellX(toCheck[i])-1, getCellY(toCheck[i]));
			if(k !== null && cells[k] === null) {  push(toCheck, k);  cells[k] = dist;  }
			k = getCellFromXY(getCellX(toCheck[i]), getCellY(toCheck[i])+1);
			if(k !== null && cells[k] === null) {  push(toCheck, k);  cells[k] = dist;  }
			k = getCellFromXY(getCellX(toCheck[i]), getCellY(toCheck[i])-1);
			if(k !== null && cells[k] === null) {  push(toCheck, k);  cells[k] = dist;  }
			++i;
		}
	}
	tmp = [];
	for (var celltmp : var d in cells) if (!isObstacle(celltmp)) push(tmp, celltmp); // On utilise pas arrayfilter pour ne pas intergrer des cles foireuses...
    return @tmp;
}

function TurnStart (@leek) {
	var eff = @leek["effects"];
	var newEff = @[];
	for(var i = 0; i < count(eff); i++) {
		var cur = @eff[i];
		if ((--cur[3]) > 0)
			push(newEff, cur);
	}
	leek["effects"] = @newEff;
}

function TurnEnd (@leek) {
	leek["TP"] = @leek["TPMax"];
	leek["MP"] = @leek["MPMax"];

	// Baisser cooldowns Chips
}
//:://///////////////////////////////////////////////////////////////////////////////////////////////////////////
//:: FONCTIONS TERRAIN
function INIATIALISATION_TERRAIN () {
_StartOperation();
var nbr = 0;
getCellContent = function (@cell) {
	var content = @_TerrainContent[cell];
	if (content === null) return -1;
	return @((content !== CELL_EMPTY && content !== CELL_OBSTACLE)? CELL_PLAYER : content);
};
nbr++;
getObstacles = function () {
	return @_ListObstacles;
};
nbr++;
isEmptyCell = function (@cell) {
	return @(_TerrainContent[cell] === CELL_EMPTY);
};
nbr++;
isLeek = function (@cell) {
	return @(getCellContent(cell) === CELL_PLAYER);
};
nbr++;
isObstacle = function (@cell) {
	var content = @_TerrainContent[cell];
	return @(content === CELL_OBSTACLE || content === null ? true : false);
};
nbr++;
getLeekOnCell = function (@cell) {
	var content = @_TerrainContent[cell];
	if (content === null) return -1;
	return @((content === CELL_EMPTY  || content === CELL_OBSTACLE || content === null)? -1 : content);
};
nbr++;
debugC("INIATIALISATION_TERRAIN - " + nbr + " fonctions recodées en " + _EndOperation()  + " opérations.", COLOR_TEXT_DESCRIBE);
}
//:://///////////////////////////////////////////////////////////////////////////////////////////////////////////
function INIATIALISATION_FONCTIONS () {
//:: FONCTIONS POIREAUX
_StartOperation();
var nbr = 0;
getLeek = @(function () {
	if (_myID === null) return @SIM_ERR_ID;
	return @_myID;
});
nbr++;
getLevel = @(function (@leek) {
	var tmp = @_Leek[leek];
	return @(tmp === null ? null : tmp["lvl"]);
});
nbr++;
getCell = @(function (@leek) {
	var tmp = @_Leek[leek];
	return @(tmp === null ? null : tmp["cell"]);
});
nbr++;
isAlly = @(function (@leek) {
	var tmp = @_Leek[leek];
	return @(tmp === null ? false : tmp["teamID"] === _Leek[getLeek()]["teamID"]);
});
nbr++;
isEnemy = @(function (@leek) {
	var tmp = @_Leek[leek];
	return @(tmp === null ? false : !tmp["teamID"] === _Leek[getLeek()]["teamID"]);
});
nbr++;
getLife = @(function (@leek) {
	var tmp = @_Leek[leek];
	return @(tmp === null ? null : tmp["life"]);
});
nbr++;
getTotalLife = @(function (@leek) {
	var tmp = @_Leek[leek];
	return @(tmp === null ? null : tmp["lifeMax"]);
});
nbr++;
getStrength = @(function (@leek) {
	var tmp = @_Leek[leek];
	return @(tmp === null ? null : tmp["strength"]);
});
nbr++;
getWisdom = @(function (@leek) {
	var tmp = @_Leek[leek];
	return @(tmp === null ? null : tmp["wisdom"]);
});
nbr++;
getAgility = @(function (@leek) {
	var tmp = @_Leek[leek];
	return @(tmp === null ? null : tmp["agility"]);
});
nbr++;
getResistance = @(function (@leek) {
	var tmp = @_Leek[leek];
	return @(tmp === null ? null : tmp["resistance"]);
});
nbr++;
getScience = @(function (@leek) {
	var tmp = @_Leek[leek];
	return @(tmp === null ? null : tmp["science"]);
});
nbr++;
getMagic = @(function (@leek) {
	var tmp = @_Leek[leek];
	return @(tmp === null ? null : tmp["magic"]);
});
nbr++;
getFrequency = @(function (@leek) {
	var tmp = @_Leek[leek];
	return @(tmp === null ? null : tmp["frequency"]);
});
nbr++;
getTP = @(function (@leek) {
	var tmp = @_Leek[leek];
	return @(tmp === null ? null : tmp["TP"]);
});
nbr++;
getMP = @(function (@leek) {
	var tmp = @_Leek[leek];
	return @(tmp === null ? null : tmp["MP"]);
});
nbr++;
getTotalTP = @(function (@leek) {
	var tmp = @_Leek[leek];
	return @(tmp === null ? null : tmp["TPMax"]);
});
nbr++;
getTotalMP = @(function (@leek) {
	var tmp = @_Leek[leek];
	return @(tmp === null ? null : tmp["MPMax"]);
});
nbr++;
getWeapon = @(function (@leek) {
	var tmp = @_Leek[leek];
	return @(tmp === null ? null : tmp["currentWeapon"]);
});
nbr++;
getWeapons = @(function (@leek) {
	var tmp = @_Leek[leek];
	return @(tmp === null ? null : tmp["weapons"]);
});
nbr++;
getChips = @(function (@leek) {
	var tmp = @_Leek[leek];
	return @(tmp === null ? null : tmp["chips"]);
});
nbr++;
isDead = @(function (@leek) {
	var tmp = @_Leek[leek];
	return @(tmp === null ? null : tmp["life"] <= 0);
});
nbr++;
getType = @(function (@leek) {
	var tmp = @_Leek[leek];
	return @(tmp === null ? null : tmp["type"]);
});
nbr++;
isSummon = @(function (@leek) {
	var tmp = @_Leek[leek];
	return @(tmp === null ? null : tmp["summoner"] !== null);
});
nbr++;
getSummoner = @(function (@leek) {
	var tmp = @_Leek[leek];
	var _tmp = @tmp["summoner"];
	return @(tmp === null ? null : (_tmp === null ? -1 : _tmp));
});
nbr++;
getEffects = @(function (@leek) {
	var tmp = @_Leek[leek];
	return @(tmp === null ? null : tmp["effects"]);
});
nbr++;
getLaunchedEffects = @(function (@leek) {
	var tmp = @_Leek[leek];
	return @(tmp === null ? null : tmp["lauchedEffects"]);
});
nbr++;
getAbsoluteShield = @(function (@leek) {
	var tmp = @_Leek[leek];
	return @(tmp === null ? null : (Effect_TotalValue(leek, EFFECT_ABSOLUTE_SHIELD) * (1 + getResistance(leek)/100)));
});
nbr++;
getRelativeShield = @(function (@leek) {
	var tmp = @_Leek[leek];
	return @(tmp === null ? null : (Effect_TotalValue(leek, EFFECT_RELATIVE_SHIELD) * (1 + getResistance(leek)/100)));
});
nbr++;
getDamageReturn = @(function (@leek) {
	var tmp = @_Leek[leek];
	return @(tmp === null ? null : (Effect_TotalValue(leek, EFFECT_DAMAGE_RETURN) * (1 + getAgility(leek)/100)));
});
nbr++;
getBirthTurn = @(function (@leek) {
	var tmp = @_Leek[leek];
	return @(tmp === null ? null : tmp["birthTurn"]);
});
nbr++;
//:://///////////////////////////////////////////////////////////////////////////////////////////////////////////
//:: FONCTION COMBAT

getAllies = function () {
	if (_Leek === null || _Leek === []) { debugC("getAllies - Erreur, aucun poireau n'est enregistré", COLOR_TEXT_ERROR); return []; }
	var tmp = [];
	var myTeamID = _Leek[getLeek()]["teamID"];
	for (var leek : var carac in _Leek) if (carac["teamID"] === myTeamID) push(tmp, leek);
	return tmp;
};
nbr++;
getEnemies = function () {
	if (_Leek === null || _Leek === []) { debugC("getEnemies - Erreur, aucun poireau n'est enregistré", COLOR_TEXT_ERROR); return []; }
	var tmp = [];
	var myTeamID = _Leek[getLeek()]["teamID"];
	for (var leek : var carac in _Leek) if (!carac["teamID"] === myTeamID) push(tmp, leek);
	return tmp;
};
nbr++;
getAliveAllies = function () {
	if (_Leek === null || _Leek === []) { debugC("getAliveAllies - Erreur, aucun poireau n'est enregistré", COLOR_TEXT_ERROR); return []; }
	var tmp = [];
	for (var ally in getAllies()) if (!isDead(ally)) push(tmp, ally);
	return tmp;
};
nbr++;
getAliveEnemies = function () {
	if (_Leek === null || _Leek === []) { debugC("getAliveEnemies - Erreur, aucun poireau n'est enregistré", COLOR_TEXT_ERROR); return []; }
	var tmp = [];
	for (var enemy in getEnemies()) if (!isDead(enemy)) push(tmp, enemy);
	return tmp;
};
nbr++;
getAliveEnemiesCount = function () {
	if (_Leek === null || _Leek === []) { debugC("getAliveEnemies - Erreur, aucun poireau n'est enregistré", COLOR_TEXT_ERROR); return 0; }
	return count(getAliveEnemies);
};
nbr++;
getEnemiesCount = function () {
	if (_Leek === null || _Leek === []) { debugC("getEnemiesCount - Erreur, aucun poireau n'est enregistré", COLOR_TEXT_ERROR); return 0; }
	return count(getEnemies());
};
nbr++;
getEnemiesLife = function () {
	if (_Leek === null || _Leek === []) { debugC("getEnemiesLife - Erreur, aucun poireau n'est enregistré", COLOR_TEXT_ERROR); return 0; }
	var tmp = 0;
	for (var enemy in getEnemies()) tmp += (_Leek[enemy]["life"] <= 0)? 0 : _Leek[enemy]["life"];
	return tmp;
};
nbr++;
getDeadAllies = function () {
	if (_Leek === null || _Leek === []) { debugC("getDeadAllies - Erreur, aucun poireau n'est enregistré", COLOR_TEXT_ERROR); return []; }
	var tmp = [];
	for (var ally in getAllies()) if (isDead(ally)) push(tmp, ally);
	return tmp;
};
nbr++;
getDeadEnemies = function () {
	if (_Leek === null || _Leek === []) { debugC("getDeadEnemies - Erreur, aucun poireau n'est enregistré", COLOR_TEXT_ERROR); return []; }
	var tmp = [];
	for (var enemy in getEnemies()) if (isDead(enemy)) push(tmp, enemy);
	return tmp;
};
nbr++;
getDeadEnemiesCount = function () {
	if (_Leek === null || _Leek === []) { debugC("getDeadEnemiesCount - Erreur, aucun poireau n'est enregistré", COLOR_TEXT_ERROR); return 0; }
	return count(getDeadEnemies());
};
nbr++;
getAlliesLife = function () {
	if (_Leek === null || _Leek === []) { debugC("getAlliesLife - Erreur, aucun poireau n'est enregistré", COLOR_TEXT_ERROR); return 0; }
	var tmp = 0;
	for (var ally in getAllies()) tmp += (_Leek[ally]["life"] <= 0)? 0 : _Leek[ally]["life"];
	return tmp;
};
nbr++;
getAlliesCount = function () {
	if (_Leek === null || _Leek === []) { debugC("getAlliesCount - Erreur, aucun poireau n'est enregistré", COLOR_TEXT_ERROR); return 0; }
	return count(getAllies());
};
nbr++;
getNearestAllyTo = function (leek) {
	if (_Leek[leek] === null) { debugC("getNearestAllyTo - Erreur de l'ID, aucun poireau n'y est attribué", COLOR_TEXT_ERROR); return null; }
	return getNearestAllyToCell(getCell(leek));
};
nbr++;
getNearestAlly = function () {
	if (_Leek[getLeek()] === null) { debugC("getNearestAlly - Erreur de l'ID, aucun poireau n'y est attribué", COLOR_TEXT_ERROR); return null; }
	return getNearestAllyToCell(getCell(getLeek()));
};
nbr++;
getNearestAllyToCell = function (cell) {
	var NearestCell = null;
	var dist = -1;
	
	for (var ally in getAliveAllies()) {
		var tmp = getCellDistance(getCell(ally), cell);
		if (dist === -1 || tmp < dist) {
			NearestCell = ally;
			dist = tmp;
		}
	} 
	return NearestCell;
};
nbr++;
getFarthestAlly = function () {
	if (_Leek[getLeek()] === null) { debugC("getFarthestAlly - Erreur de l'ID, aucun poireau n'y est attribué", COLOR_TEXT_ERROR); return null; }
	var FarthestCell = null;
	var dist = -1;
	
	for (var ally in getAliveAllies()) {
		var tmp = getCellDistance(getCell(ally), getCell(getLeek()));
		if (dist === -1 || tmp > dist) {
			FarthestCell = ally;
			dist = tmp;
		}
	} 
	return FarthestCell;
};
nbr++;
getNearestEnemyTo = function (leek) {
	if (_Leek[leek] === null) { debugC("getNearestEnemyTo - Erreur de l'ID, aucun poireau n'y est attribué", COLOR_TEXT_ERROR); return null; }
	return getNearestEnemyToCell(getCell(leek));
};
nbr++;
getNearestEnemy = function () {
	if (_Leek[getLeek()] === null) { debugC("getNearestEnemy - Erreur de l'ID, aucun poireau n'y est attribué", COLOR_TEXT_ERROR); return null; }
	return getNearestEnemyToCell(getCell(getLeek()));
};
nbr++;
getNearestEnemyToCell = function (cell) {
	var NearestCell = null;
	var dist = -1;
	
	for (var enemy in getAliveEnemies()) {
		var tmp = getCellDistance(getCell(enemy), cell);
		if (dist === -1 || tmp < dist) {
			NearestCell = enemy;
			dist = tmp;
		}
	} 
	return NearestCell;
};
nbr++;
getFarthestEnemy = function () {
	if (_Leek[getLeek()] === null) { debugC("getFarthestEnemy - Erreur de l'ID, aucun poireau n'y est attribué", COLOR_TEXT_ERROR); return null; }
	var FarthestCell = null;
	var dist = -1;
	
	for (var enemy in getAliveEnemies()) {
		var tmp = getCellDistance(getCell(enemy), getCell(getLeek()));
		if (dist === -1 || tmp > dist) {
			FarthestCell = enemy;
			dist = tmp;
		}
	} 
	return FarthestCell;
};
nbr++;
setWeapon = function (weapon) {
	if (_Leek[getLeek()] === null) { debugC("setWeapon - Erreur de l'ID, aucun poireau n'y est attribué", COLOR_TEXT_ERROR); return null; }
	
	if (search(_Leek[getLeek()]["weapons"], weapon) === null) return ;
	
	if (SIMULATETP) {
		if (_Leek[getLeek()]["TP"] < 1) return ;
		else --_Leek[getLeek()]["TP"];
	}
	_Leek[getLeek()]["currentWeapon"] = weapon;
};
nbr++;
debugC("INIATIALISATION_FUNCTION - " + nbr + " fonctions recodées en " + _EndOperation()  + " opérations.", COLOR_TEXT_DESCRIBE);
}

lineOfSight = function (start, end, leekToIgnore) {
//mark([start,end], getColor(255, 255, 0));
//pause();
	var x1 = getCellX(start);
	var y1 = getCellY(start);
	var x2 = getCellX(end);
	var y2 = getCellY(end);
			
	var a = abs(y1 - y2);
	var b = abs(x1 - x2);
	var dx = x1 > x2 ? -1 : 1;
	var dy = y1 < y2 ? 1 : -1;
	var path = [];
		if (b == 0) {
		push(path, 0);
		push(path, a + 1);
	} else {
		var d = a / b / 2;
		var h = 0;
		for (var i = 0; i < b; ++i) {
			var y = 0.5 + (i * 2 + 1) * d;
			var ry = ceil(y);
			if (ry == y) {
				push(path, h);
				push(path, y - h);
				h = y;
			} else {
				push(path, h);
				push(path, ry - h);
				h = ry - 1;
			}
		}
		push(path, h);
		push(path, a + 1 - h);
	}
	for (var p = 0; p < count(path); p += 2) {
		for (var i = 0; i < path[p + 1]; ++i) {
			var cell = getCellFromXY(x1 + (p / 2) * dx, y1 + (path[p] + i) * dy);
			//mark(cell, COLOR_RED);
			if (isObstacle(cell) || isLeek(cell) && getLeekOnCell(cell) !== leekToIgnore) {
				return false;
			}
		}
	}
	return true;
};

canUseWeapon = function (weapon, leek) {
	if (_Leek[leek] === null) { debugC("canUseWeapon - Erreur de l'ID, aucun poireau n'y est attribué", COLOR_TEXT_ERROR); return null; }
	if (!isWeapon(weapon)) { debugC("canUseWeapon - Erreur de l'arme, celle-ci n'est pas répertorié", COLOR_TEXT_ERROR); return null; }

	return canUseWeaponOnCell(weapon, getCell(leek));
};

canUseWeaponOnCell = function (weapon, cell) {
	if (!isWeapon(weapon)) { debugC("canUseWeaponOnCell - Erreur de l'arme, celle-ci n'est pas répertorié", COLOR_TEXT_ERROR); return null; }
	
	
	var dist = getCellDistance(getCell(getLeek()), cell);
	if (!(dist <= getWeaponMaxRange(weapon) && dist >= getWeaponMinRange(weapon))) return false;
	if (isInlineWeapon(weapon) && !isOnSameLine(getCell(getLeek()), cell)) return false;
	if (!lineOfSight(getCell(getLeek()),cell, getLeek())) return false;
	return true;
};

canUseChip = function (Chip, leek) {
	if (_Leek[leek] === null) { debugC("canUseChip - Erreur de l'ID, aucun poireau n'y est attribué", COLOR_TEXT_ERROR); return null; }
	if (!isChip(Chip)) { debugC("canUseChip - Erreur de l'arme, celle-ci n'est pas répertorié", COLOR_TEXT_ERROR); return null; }

	return canUseWeaponOnCell(Chip, getCell(leek));
};

canUseChipOnCell = function (Chip, cell) {
	if (!isChip(Chip)) { debugC("canUseChipOnCell - Erreur de l'arme, celle-ci n'est pas répertorié", COLOR_TEXT_ERROR); return null; }
	
	
	var dist = getCellDistance(getCell(getLeek()), cell);
	if (!(dist <= getChipMaxRange(Chip) && dist >= getChipMinRange(Chip))) return false;
	if (isInlineChip(Chip) && !isOnSameLine(getCell(getLeek()), cell)) return false;
	if (chipNeedLos(Chip) && !lineOfSight(getCell(getLeek()),cell, getLeek())) return false;
	if (getCooldown(Chip, getLeek()) > 0) return false;
	return true;
};

resurrect = function (entity, cell) {
	if (_Leek[entity] === null) { debugC("resurrect - Erreur de l'ID, aucune entité n'y est attribué", COLOR_TEXT_ERROR); return null; }
	if (!isDead(entity)) { debugC("resurrect - Erreur le poireau dois être mort", COLOR_TEXT_ERROR); return null; }
	if (search(_Leek[getLeek()]["chips"], CHIP_RESURRECTION)) { debugC("resurrect - Erreur la puce n'est pas équipé dans votre inventaire", COLOR_TEXT_ERROR); return null; }
	if (!canUseChipOnCell(CHIP_RESURRECTION, cell)) { debugC("resurrect - Erreur la puce ne peut pas être utilisé sur cette cellule", COLOR_TEXT_ERROR); return null; }
	
	SetCell(entity, cell);
	SetLife_LifeMax(entity, getTotalLife(entity)/4, getTotalLife(entity)/2);
};

summon = function (chip, cell, ai) {
	if (search(_Leek[getLeek()]["chips"], chip)) { debugC("summon - Erreur la puce n'est pas équipé dans votre inventaire", COLOR_TEXT_ERROR); return null; }
	if (!canUseChipOnCell(chip, cell)) { debugC("summon - Erreur la puce ne peut pas être utilisé sur cette cellule", COLOR_TEXT_ERROR); return null; }
	if (typeOf(ai) !== TYPE_FUNCTION) { debugC("summon - Erreur le paramètre ai dois être une fonction", COLOR_TEXT_ERROR); return null; }
	
	if (SIMULATETP) {
		if (_Leek[getLeek()]["TP"] < getChipCost(chip)) return ;
		else _Leek[getLeek()]["TP"] -= getChipCost(chip);
	}
	var lifeMax, strength, wisdom, agility, resistance, science, TPMax, MPMax, chips;
	
	if (chip === CHIP_PUNY_BULB) {
		lifeMax = floor((300 - 50) * getLevel(getLeek())/300 + 50); lifeMax = max(lifeMax, 300);
		strength = floor((100 - 0) * getLevel(getLeek())/300 + 0);
		wisdom = floor((100 - 0) * getLevel(getLeek())/300 + 0);
		agility = floor((100 - 0) * getLevel(getLeek())/300 + 0);
		resistance = floor((100 - 0) * getLevel(getLeek())/300 + 0);
		science = floor((100 - 0) * getLevel(getLeek())/300 + 0);
		TPMax = floor((7 - 4) * getLevel(getLeek())/300 + 4);
		MPMax = floor((5 - 3) * getLevel(getLeek())/300 + 3);
		chips = [CHIP_HELMET, CHIP_PEBBLE, CHIP_BANDAGE, CHIP_PROTEIN];
	} else if (chip === CHIP_ROCKY_BULB) {
		lifeMax = floor((800 - 400) * getLevel(getLeek())/300 + 400);lifeMax = max(lifeMax, 800);
		strength = floor((200 - 0) * getLevel(getLeek())/300 + 0);
		wisdom = 0;
		agility = floor((100 - 0) * getLevel(getLeek())/300 + 0);
		resistance = floor((100 - 0) * getLevel(getLeek())/300 + 0);
		science = 0;
		TPMax = floor((8 - 4) * getLevel(getLeek())/300 + 4);
		MPMax = floor((3 - 2) * getLevel(getLeek())/300 + 2);
		chips = [CHIP_PEBBLE, CHIP_ROCK, CHIP_ROCKFALL, CHIP_HELMET];
	} else if (chip === CHIP_ICED_BULB) {
		lifeMax = floor((700 - 300) * getLevel(getLeek())/300 + 300);lifeMax = max(lifeMax, 700);
		strength = floor((300 - 0) * getLevel(getLeek())/300 + 0);lifeMax = max(lifeMax, 300);
		wisdom = 0;
		agility = floor((100 - 0) * getLevel(getLeek())/300 + 0);
		resistance = 0;
		science = floor((100 - 0) * getLevel(getLeek())/300 + 0);
		TPMax = floor((8 - 5) * getLevel(getLeek())/300 + 5);
		MPMax = floor((4 - 3) * getLevel(getLeek())/300 + 3);
		chips = [CHIP_ICE, CHIP_STALACTITE, CHIP_ICEBERG, CHIP_REFLEXES];
	} else if (chip === CHIP_HEALER_BULB) {
		lifeMax = floor((500 - 400) * getLevel(getLeek())/300 + 400);lifeMax = max(lifeMax, 500);
		strength = 0;
		wisdom = floor((300 - 0) * getLevel(getLeek())/300 + 0);lifeMax = max(lifeMax, 300);
		agility = floor((100 - 0) * getLevel(getLeek())/300 + 0);
		resistance = 0;
		science = 0;
		TPMax = floor((8 - 4) * getLevel(getLeek())/300 + 4);
		MPMax = floor((6 - 3) * getLevel(getLeek())/300 + 3);
		chips = [CHIP_BANDAGE, CHIP_DRIP, CHIP_CURE, CHIP_VACCINE];
	} else if (chip === CHIP_METALLIC_BULB) {
		lifeMax = floor((1500 - 800) * getLevel(getLeek())/300 + 800);lifeMax = max(lifeMax, 1500);
		strength = 0;
		wisdom = 0;
		agility = floor((100 - 0) * getLevel(getLeek())/300 + 0);
		resistance = floor((300 - 0) * getLevel(getLeek())/300 + 0);lifeMax = max(lifeMax, 300);
		science = floor((200 - 0) * getLevel(getLeek())/300 + 0);
		TPMax = floor((9 - 5) * getLevel(getLeek())/300 + 5);
		MPMax = floor((3 - 1) * getLevel(getLeek())/300 + 1);
		chips = [CHIP_SHIELD, CHIP_ARMOR, CHIP_WALL, CHIP_SEVEN_LEAGUE_BOOTS];
	} else if (chip === CHIP_FIRE_BULB) {
		lifeMax = floor((600 - 300) * getLevel(getLeek())/300 + 300);lifeMax = max(lifeMax, 600);
		strength = floor((300 - 0) * getLevel(getLeek())/300 + 0);lifeMax = max(lifeMax, 300);
		wisdom = floor((200 - 0) * getLevel(getLeek())/300 + 0);
		agility = floor((100 - 0) * getLevel(getLeek())/300 + 0);
		resistance = 0;
		science = 0;
		TPMax = floor((10 - 5) * getLevel(getLeek())/300 + 5);
		MPMax = floor((5 - 3) * getLevel(getLeek())/300 + 3);
		chips = [CHIP_SPARK, CHIP_FLAME, CHIP_METEORITE, CHIP_DEVIL_STRIKE];
	} else if (chip === CHIP_LIGHTNING_BULB) {
		lifeMax = floor((800 - 400) * getLevel(getLeek())/300 + 400); lifeMax = max(lifeMax, 800);
		strength = floor((400 - 0) * getLevel(getLeek())/300 + 0);lifeMax = max(lifeMax, 400);
		wisdom = 0;
		agility = floor((100 - 0) * getLevel(getLeek())/300 + 0);
		resistance = 0;
		science = floor((200 - 0) * getLevel(getLeek())/300 + 0);
		TPMax = floor((10 - 6) * getLevel(getLeek())/300 + 6);
		MPMax = floor((6 - 4) * getLevel(getLeek())/300 + 4);
		chips = [CHIP_SHOCK, CHIP_FLASH, CHIP_LIGHTNING, CHIP_DOPING];
	} else { debugC("summon - Erreur la puce renseigner n'est pas un bulbe", COLOR_TEXT_ERROR); return null; }
	
	 return newLeek(ai, getLevel(getLeek()), cell, true, ENTITY_BULB, getLeek(), getTurn(), lifeMax, lifeMax, strength, wisdom, agility, resistance, science, 0, 0, TPMax, MPMax, TPMax, MPMax, null, [], chips, [], []);
};

getWeaponEffectiveArea = function(weapon, cell, from) {
	if (!isWeapon(weapon)) { debugC("getWeaponEffectiveArea - Erreur l'arme donnée n'en est pas une.", COLOR_TEXT_ERROR); return []; }
	if (!canUseWeaponOnCellFrom(weapon, cell, from)) { debugC("getWeaponEffectiveArea - Erreur impossible s'attaquer de puis " + from + " sur " + cell + " avec l'arme " + weapon, COLOR_TEXT_ERROR); return []; }
	
	var areaWeapon = getWeaponArea(weapon);
	
	if (areaWeapon === AREA_POINT) {
		return Area(cell, 0);
	}
	if (areaWeapon === AREA_CIRCLE_1) {
		return Area(cell, 1);
	}
	if (areaWeapon === AREA_CIRCLE_2) {
		return Area(cell, 2);
	}
	if (areaWeapon === AREA_CIRCLE_3) {
		return Area(cell, 3);
	}
	if (areaWeapon === AREA_LASER_LINE) {
		var dx = ((getCellX(cell) < getCellX(from))? -1 : (getCellX(cell) > getCellX(from))? 1 :0);
		var dy =((getCellY(cell) < getCellY(from))? -1 : (getCellY(cell) > getCellY(from))? 1 :0);
		var celltmp = cell;
		var cellstmp = [];
		do {
			push(cellstmp, celltmp);
			celltmp = getCellFromXY(getCellX(celltmp) + dx, getCellY(celltmp) + dy);
		} while (!isObstacle(celltmp));
		
		return cellstmp;
	}
};

getChipEffectiveArea = function(chip, cell, from) {
	if (!isChip(chip)) { debugC("getChipEffectiveArea - Erreur la puce donnée n'en est pas une.", COLOR_TEXT_ERROR); return []; }
	if (!canUseChipOnCellFrom(chip, cell, from)) { debugC("getChipEffectiveArea - Erreur impossible s'attaquer de puis " + from + " sur " + cell + " avec la puce " + chip, COLOR_TEXT_ERROR); return []; }
	var areaChip = getChipArea(chip);
	
	if (areaChip === AREA_POINT) {
		return Area(cell, 0);
	}
	if (areaChip === AREA_CIRCLE_1) {
		return Area(cell, 1);
	}
	if (areaChip === AREA_CIRCLE_2) {
		return Area(cell, 2);
	}
	if (areaChip === AREA_CIRCLE_3) {
		return Area(cell, 3);
	}
	if (areaChip === AREA_LASER_LINE) {
		var dx = ((getCellX(cell) < getCellX(from))? -1 : (getCellX(cell) > getCellX(from))? 1 :0);
		var dy =((getCellY(cell) < getCellY(from))? -1 : (getCellY(cell) > getCellY(from))? 1 :0);
		var celltmp = cell;
		var cellstmp = [];
		do {
			push(cellstmp, celltmp);
			celltmp = getCellFromXY(getCellX(celltmp) + dx, getCellY(celltmp) + dy);
		} while (!isObstacle(celltmp));
		
		return cellstmp;
	}
};

getWeaponTargets = function (weapon, cell) {
	if (!isWeapon(weapon)) { debugC("getWeaponTargets - Erreur l'arme donnée n'en est pas une.", COLOR_TEXT_ERROR); return []; }
	
	var tmp = [];
	for(var celltmp in getWeaponEffectiveArea(weapon, cell, getCell(getLeek()))) {
		var leek = getLeekOnCell(celltmp);
		if (leek !== null) push(tmp, leek);
	}
	
	return tmp;
};

getChipTargets = function (chip, cell) {
	if (!isChip(chip)) { debugC("getChipTargets - Erreur la puce donnée n'en est pas une.", COLOR_TEXT_ERROR); return []; }
	
	var tmp = [];
	for(var celltmp in getChipEffectiveArea(chip, cell, getCell(getLeek()))) {
		var leek = getLeekOnCell(celltmp);
		if (leek !== null) push(tmp, leek);
	}
	
	return tmp;
};

getCellsToUseWeaponOnCell = function (weapon, cell, ignoredCells) {
	var area = Area(cell, getWeaponMaxRange(weapon));
	var retour = [];
	mark(cell, COLOR_GREEN);
	for (var cellIn in area) {
		if (!canUseWeaponOnCellFrom(weapon, cellIn, cell)) continue;
		if (search(ignoredCells, cellIn) !== null) continue;
		push(retour, cellIn);
	}
	return retour;
};

getCellsToUseWeapon = function (weapon, leek, ignoredCells) {
	return getCellsToUseWeaponOnCell(weapon, getCell(leek), ignoredCells);
};

getCellToUseWeapon = function (weapon, leek, ignoredCells) {
	var NearestCell = null;
	var dist = null;
	
	for (var cell in getCellsToUseWeaponOnCell(weapon, getCell(leek), ignoredCells)) {
		var d = getCellDistance(cell, getCell(getLeek()));
		if (NearestCell === null || d < dist) {
			NearestCell = cell;
			dist = d;
		}
	}
	return NearestCell;
};

getCellToUseWeaponOnCell = function (weapon, cell, ignoredCells) {
	var NearestCell = null;
	var dist = null;
	
	for (var celltmp in getCellsToUseWeaponOnCell(weapon, cell, ignoredCells)) {
		var d = getCellDistance(celltmp, getCell(getLeek()));
		if (NearestCell === null || d < dist) {
			NearestCell = celltmp;
			dist = d;
		}
	}
	return NearestCell;
};

getCellsToUseChipOnCell = function (Chip, cell, ignoredCells) {
	var area = Area(cell, getChipMaxRange(Chip));
	var retour = [];
	mark(cell, COLOR_GREEN);
	for (var cellIn in area) {
		if (!canUseChipOnCellFrom(Chip, cellIn, cell)) continue;
		if (search(ignoredCells, cellIn) !== null) continue;
		push(retour, cellIn);
	}
	return retour;
};

getCellsToUseChip = function (Chip, leek, ignoredCells) {
	return getCellsToUseChipOnCell(Chip, getCell(leek), ignoredCells);
};

getCellToUseChip = function (Chip, leek, ignoredCells) {
	var NearestCell = null;
	var dist = null;
	
	for (var cell in getCellsToUseChipOnCell(Chip, getCell(leek), ignoredCells)) {
		var d = getCellDistance(cell, getCell(getLeek()));
		if (NearestCell === null || d < dist) {
			NearestCell = cell;
			dist = d;
		}
	}
	return NearestCell;
};

getCellToUseChipOnCell = function (Chip, cell, ignoredCells) {
	var NearestCell = null;
	var dist = null;
	
	for (var celltmp in getCellsToUseChipOnCell(Chip, cell, ignoredCells)) {
		var d = getCellDistance(celltmp, getCell(getLeek()));
		if (NearestCell === null || d < dist) {
			NearestCell = celltmp;
			dist = d;
		}
	}
	return NearestCell;
};


































