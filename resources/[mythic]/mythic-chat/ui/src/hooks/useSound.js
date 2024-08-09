import _useSound from 'use-sound';
import negativeAudio from '../assets/sounds/negative.mp3';
import positiveAudio from '../assets/sounds/positive.mp3';
import beepAudio from '../assets/sounds/beep.mp3';
import confirmAudio from '../assets/sounds/confirm.mp3';
import backAudio from '../assets/sounds/back.mp3';

export default () => {
	const [negative] = _useSound(negativeAudio, { volume: 0.25 });
	const [positive] = _useSound(positiveAudio, { volume: 0.15 });
	const [beep] = _useSound(beepAudio, { volume: 0.25 });
	const [confirm] = _useSound(confirmAudio, { volume: 0.25 });
	const [back] = _useSound(backAudio, { volume: 0.25 });
	return (effect) => {
		switch (effect) {
            case 'negative':
                negative();
                break;
            case 'positive':
                positive();
                break;
            case 'confirm':
                confirm();
                break;
            case 'back':
                back();
                break;
			default:
				beep();
				break;
		}
	};
};
