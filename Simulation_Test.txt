global __OPERATIONS = 0;

function _StartOperation () {__OPERATIONS = getOperations();}
function _EndOperation () {return getOperations() - __OPERATIONS - 4;}
debugC("Opérations nécéssaire aux fonctions natives : ", getColor(6, 165, 67));
var result = 0;
var obs = [];
var me = 0;
var myCell = 0;

_StartOperation();
	getLeek();
debug((_EndOperation()) + " opérations pour getLeek() -> " + (((me = getLeek()) === 1000)?("TRUE") : (me + " should be " + 1000)));

_StartOperation();
	getCell(me);
debug((_EndOperation()) + " opérations pour getCell() -> " + (((myCell = getCell(me)) === 306)?("TRUE") : (myCell + " should be " + 306)));

_StartOperation();
	getObstacles();
debug((_EndOperation()) + " opérations pour getObstacles() -> " + ((typeOf((obs = getObstacles())) === TYPE_ARRAY)?("TRUE") : (typeOf(obs) + " should be " + TYPE_ARRAY))); mark(obs, COLOR_RED);

_StartOperation();
	getCellContent(0);
debug((_EndOperation()) + " opérations pour getCellContent(0) -> " + (((result = getCellContent(0)) === CELL_EMPTY)?("TRUE") : (result + " should be " + CELL_EMPTY)));

_StartOperation();
	getCellContent(obs[0]);
debug((_EndOperation() - 5) + " opérations pour getCellContent(obs[0]) -> " + (((result = getCellContent(obs[0])) === CELL_OBSTACLE)?("TRUE") : (result + " should be " + CELL_OBSTACLE)));

_StartOperation();
	getCellContent(306);
debug((_EndOperation()) + " opérations pour getCellContent(306) -> " + (((result = getCellContent(306))  === CELL_PLAYER)?("TRUE") : (result + " should be " + CELL_PLAYER)));

_StartOperation();
	getCellContent(getCell(getLeek()));
debug((_EndOperation() - 8) + " opérations pour getCellContent(myCell) -> " + (((result = getCellContent(myCell)) === CELL_PLAYER)?("TRUE") : (result + " should be " + CELL_PLAYER)));

_StartOperation();
	isLeek(getCell(getLeek()));
debug((_EndOperation()) + " opérations pour isLeek(myCell) -> " + (((result = isLeek(myCell)) === true)?("TRUE") : (result + " should be " + true)));

_StartOperation();
	isObstacle(obs[0]);
debug((_EndOperation()) + " opérations pour isObstacle(obs[0])) -> " + (((result = isObstacle(obs[0])) === true)?("TRUE") : (result + " should be " + true)));

_StartOperation();
	isEmptyCell(0);
debug((_EndOperation()) + " opérations pour isEmptyCell(0) -> " + (((result = isEmptyCell(0)) === true)?("TRUE") : (result + " should be " + true)));

_StartOperation();
	getLeekOnCell(getCell(getLeek()));
debug((_EndOperation()) + " opérations pour getLeekOnCell(myCell) -> " + (((result = getLeekOnCell(myCell)) === getLeek())?("TRUE") : (result + " should be " + me)));

// Penser à inclure le bon fichier sur LW ...
include("Sim_01");

DefaultMyLeekCreation(306, 12, 10, null, [], []);
debugC("Opérations nécéssaire aux fonctions natives recodés : ", getColor(6, 165, 67));
var _result = 0;
var _obstacles = [];
var _me = 0;
var _myCell = 0;

_StartOperation();
	getLeek();
debug((_EndOperation()) + " opérations pour getLeek() -> " + (((_me = getLeek()) === 1000)?("TRUE") : (_me + " should be " + 1000)));

_StartOperation();
	getCell(_me);
debug((_EndOperation()) + " opérations pour getCell() -> " + (((_myCell = getCell(_me)) === 306)?("TRUE") : (_myCell + " should be " + 306)));

_StartOperation();
	getObstacles();
debug((_EndOperation()) + " opérations pour getObstacles() -> " + ((typeOf((_obstacles = getObstacles())) === TYPE_ARRAY)?("TRUE") : (typeOf(_obstacles) + " should be " + TYPE_ARRAY))); mark(_obstacles, COLOR_RED);

_StartOperation();
	getCellContent(0);
debug((_EndOperation()) + " opérations pour getCellContent(0) -> " + (((_result = getCellContent(0)) === CELL_EMPTY)?("TRUE") : (_result + " should be " + CELL_EMPTY)));

_StartOperation();
	getCellContent(_obstacles[0]);
debug((_EndOperation() - 5) + " opérations pour getCellContent(_obstacles[0]) -> " + (((_result = getCellContent(_obstacles[0])) === CELL_OBSTACLE)?("TRUE") : (_result + " should be " + CELL_OBSTACLE)));

_StartOperation();
	getCellContent(306);
debug((_EndOperation()) + " opérations pour getCellContent(306) -> " + (((_result = getCellContent(306))  === CELL_PLAYER)?("TRUE") : (_result + " should be " + CELL_PLAYER)));

_StartOperation();
	getCellContent(_myCell);
debug((_EndOperation() - 8) + " opérations pour getCellContent(_myCell) -> " + (((_result = getCellContent(_myCell)) === CELL_PLAYER)?("TRUE") : (_result + " should be " + CELL_PLAYER)));

_StartOperation();
	isLeek(_myCell);
debug((_EndOperation()) + " opérations pour isLeek(_myCell) -> " + (((_result = isLeek(_myCell)) === true)?("TRUE") : (_result + " should be " + true)));

_StartOperation();
	isObstacle(_obstacles[0]);
debug((_EndOperation()) + " opérations pour isObstacle(_obstacles[0])) -> " + (((_result = isObstacle(_obstacles[0])) === true)?("TRUE") : (_result + " should be " + true)));

_StartOperation();
	isEmptyCell(0);
debug((_EndOperation()) + " opérations pour isEmptyCell(0) -> " + (((_result = isEmptyCell(0)) === true)?("TRUE") : (_result + " should be " + true)));

_StartOperation();
	getLeekOnCell(_myCell);
debug((_EndOperation()) + " opérations pour getLeekOnCell(_myCell) -> " + (((_result = getLeekOnCell(_myCell)) === getLeek())?("TRUE") : (_result + " should be " + _me)));