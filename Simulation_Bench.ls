include("102_Debug");

/*
include("104_SimulateFight");
MyLeekCustom(function () {}, 139, 1, 874, 874, 300, 0, 0, 300, 0, 0, 100, 10, 4, 10, 4, null, [109, 43], [8, 18, 20, 21, 22, 29, 32, 33, 34], [], []);
*/

global debugMapFunction = false;
global debugLeekFunction = true;

if (debugMapFunction) {
	debugNotImportant('Map Function');
	debugEvent('getCellContent');
	bench_verify(ToFr_1(getCellContent)(0), CELL_EMPTY, 'Cellule 0');
	bench_verify(ToFr_1(getCellContent)(getCell(getLeek())), CELL_PLAYER,'Cellule with leek');
	bench_verify(ToFr_1(getCellContent)(getObstacles()[0]), CELL_OBSTACLE,'Cellule with obstacle');
	bench_verify(ToFr_1(getCellContent)(-1), -1,'Cellule null');

	debugEvent('isEmptyCell');
	bench_verify(ToFr_1(isEmptyCell)(0), true, 'Cellule 0');
	bench_verify(ToFr_1(isEmptyCell)(getCell(getLeek())), false,'Cellule with leek');
	bench_verify(ToFr_1(isEmptyCell)(getObstacles()[0]), false,'Cellule with obstacle');
	bench_verify(ToFr_1(isEmptyCell)(-1), false,'Cellule null');

	debugEvent('isLeek');
	bench_verify(ToFr_1(isLeek)(0), false, 'Cellule 0');
	bench_verify(ToFr_1(isLeek)(getCell(getLeek())), true, 'Cellule with leek');
	bench_verify(ToFr_1(isLeek)(getObstacles()[0]), false, 'Cellule with obstacle');
	bench_verify(ToFr_1(isLeek)(-1), false,'Cellule null');

	debugEvent('isObstacle');
	bench_verify(ToFr_1(isObstacle)(0), false, 'Cellule 0');
	bench_verify(ToFr_1(isObstacle)(getCell(getLeek())), false, 'Cellule with leek');
	bench_verify(ToFr_1(isObstacle)(getObstacles()[0]), true, 'Cellule with obstacle');
	bench_verify(ToFr_1(isObstacle)(-1), true, 'Cellule null');

	debugEvent('getLeekOnCell');
	bench_verify(ToFr_1(getLeekOnCell)(0), -1,'Cellule 0');
	bench_verify(ToFr_1(getLeekOnCell)(getCell(getLeek())), getLeek(),'Cellule with leek');
	bench_verify(ToFr_1(getLeekOnCell)(getObstacles()[0]), -1, 'Cellule with obstacle');
	bench_verify(ToFr_1(getLeekOnCell)(-1), -1, 'Cellule null');
}

if (debugLeekFunction) {
	debugNotImportant('Leek Function');

	bench_verify(ToFr_0(getLeek)(), getLeek(), 'getLeek');

	bench_verify(ToFr_0(getLevel)(), 139, 'getLevel');

	bench_verify(ToFr_0(getStrength)(), 300, 'getStrength');

	bench_verify(ToFr_0(getLife)(), 874, 'getLife');

	bench_verify(ToFr_0(getTotalLife)(), 874, 'getTotalLife');

	bench_verify(ToFr_0(getWisdom)(), 0, 'getWisdom');

	bench_verify(ToFr_0(getAgility)(), 0, 'getAgility');

	bench_verify(ToFr_0(getResistance)(), 300, 'getResistance');

	bench_verify(ToFr_0(getScience)(), 0, 'getScience');

	bench_verify(ToFr_0(getMagic)(), 0, 'getMagic');

	bench_verify(ToFr_0(getFrequency)(), 100, 'getFrequency');

	bench_verify(ToFr_0(getTP)(), 10, 'getTP');

	bench_verify(ToFr_0(getTotalTP)(), 10, 'getTotalTP');

	bench_verify(ToFr_0(getMP)(), 4, 'getMP');

	bench_verify(ToFr_0(getWeapon)(), null, 'getWeapon');

	bench_verify(ToFr_0(getWeapons)(), [109, 43], 'getWeapons');

	bench_verify(ToFr_0(getChips)(), [8, 18, 20, 21, 22, 29, 32, 33, 34], 'getChips');

	bench_verify(ToFr_0(getSummoner)(), -1, 'getSummoner');

	bench_verify(ToFr_0(getEffects)(), [], 'getEffects');

	bench_verify(ToFr_0(getLaunchedEffects)(), [], 'getLaunchedEffects');

	bench_verify(ToFr_0(getBirthTurn)(), 1, 'getBirthTurn');

	bench_verify(ToFr_0(isSummon)(), false, 'isSummon');

	bench_verify(ToFr_0(getType)(), ENTITY_LEEK, 'getType');

	bench_verify(ToFr_1(isAlly)(getLeek()), true, 'isAlly');

	bench_verify(ToFr_1(isEnemy)(getLeek()), false, 'isEnemy');
}