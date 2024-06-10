import { useSelector } from 'react-redux';

export default () => {
	const myStates = useSelector((state) => state.data.data.player.States);
	return (state) => {
		if (Boolean(myStates) && Boolean(state)) {
			return myStates.includes(state);
		} else return false;
	};
};
