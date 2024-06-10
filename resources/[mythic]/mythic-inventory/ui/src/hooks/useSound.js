import _useSound from 'use-sound';
import dragAudio from '../assets/drag.mp3';

export default () => {
	const [drag] = _useSound(dragAudio, { volume: 0.25 });
	return (effect) => {
		switch (effect) {
			default:
				drag();
				break;
		}
	};
};
