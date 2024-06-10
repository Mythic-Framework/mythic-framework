import _useSound from 'use-sound';
import negativeAudio from '../assets/sounds/negative.mp3';
import positiveAudio from '../assets/sounds/positive.mp3';
import beepAudio from '../assets/sounds/beep.mp3';
import confirmAudio from '../assets/sounds/confirm.mp3';
import backAudio from '../assets/sounds/back.mp3';
import tickAudio from '../assets/sounds/ticking.ogg';

export default () => {
    const [negative, { stop: stopNegative }] = _useSound(negativeAudio, {
        volume: 0.25,
    });
    const [positive, { stop: stopPositive }] = _useSound(positiveAudio, {
        volume: 0.15,
    });
    const [beep, { stop: stopBeep }] = _useSound(beepAudio, { volume: 0.25 });
    const [confirm, { stop: stopConfirm }] = _useSound(confirmAudio, {
        volume: 0.25,
    });
    const [back, { stop: stopBack }] = _useSound(backAudio, { volume: 0.25 });
    const [tick, { stop: stopTick }] = _useSound(tickAudio, {
        volume: 0.25,
        loop: true,
    });
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
            case 'tick':
                tick();
                break;
            case 'stop':
                stopNegative();
                stopPositive();
                stopBeep();
                stopConfirm();
                stopBack();
                stopTick();
                break;
            default:
                beep();
                break;
        }
    };
};
