import { useSelector } from 'react-redux';

export default () => {
	const myReps = useSelector((state) => state.data.data.player?.Reputations);
	return (rep, value = 0) => {
		return Boolean(myReps) && Boolean(myReps[rep]) && myReps[rep] >= value;
	};
};
