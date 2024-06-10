import { useSelector } from 'react-redux';
import _useSound from 'use-sound';
import dragAudio from '../assets/drag.mp3';

export default () => {
	const settings = useSelector((state) => state.app.settings);

	const [drag] = _useSound(dragAudio, { volume: 0.25 });
	return (effect) => {
		if (settings.muted) return;
		switch (effect) {
			default:
				drag();
				break;
		}
	};
};
