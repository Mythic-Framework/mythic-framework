import Nui from '../util/Nui';
import { STATE_CHARACTERS } from '../util/States';
import { LOADING_SHOW, SET_STATE, UPDATE_PLAYED, SELECT_SPAWN, DESELECT_CHARACTER, DESELECT_SPAWN } from './types';
import { STATE_CREATE } from '../util/States';
import { CreateCharacter, DeleteCharacter, SelectCharacter, PlayCharacter, SelectSpawn } from '../util/NuiEvents';

export const showCreator = () => (dispatch) => {
	dispatch({
		type: SET_STATE,
		payload: { state: STATE_CREATE },
	});
};

export const createCharacter = (data, dispatch) => {
	Nui.send(CreateCharacter, data);
	dispatch({
		type: LOADING_SHOW,
		payload: { message: 'Creating Character' },
	});
};

export const deleteCharacter = (charId) => (dispatch) => {
	Nui.send(DeleteCharacter, { id: charId });
	dispatch({
		type: LOADING_SHOW,
		payload: { message: 'Deleting Character' },
	});
};

export const getCharacterSpawns = (character) => (dispatch) => {
	Nui.send(SelectCharacter, { id: character.ID });
	dispatch({
		type: LOADING_SHOW,
		payload: { message: 'Getting Spawn Points' },
	});
};

export const selectSpawn = (spawn) => (dispatch) => {
	Nui.send(SelectSpawn, { spawn });
	dispatch({
		type: SELECT_SPAWN,
		payload: spawn,
	});
};

export const deselectCharacter = () => (dispatch) => {
	dispatch({ type: DESELECT_CHARACTER });
	dispatch({ type: DESELECT_SPAWN });
	dispatch({
		type: SET_STATE,
		payload: { state: STATE_CHARACTERS },
	});
};

export const spawnToWorld = (spawn, character) => (dispatch) => {
	Nui.send(PlayCharacter, { spawn, character });
	dispatch({
		type: LOADING_SHOW,
		payload: { message: 'Spawning' },
	});
	dispatch({
		type: UPDATE_PLAYED,
	});
	dispatch({ type: DESELECT_CHARACTER });
	dispatch({ type: DESELECT_SPAWN });
};
