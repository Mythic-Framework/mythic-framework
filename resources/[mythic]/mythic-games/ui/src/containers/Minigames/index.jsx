import React from 'react';
import { useSelector } from 'react-redux';

import {
    SkillBar,
    Scanner,
    Sequencer,
    Keypad,
    Scrambler,
    Memory,
    Aim,
    Captcha,
    Keymaster,
    Pattern,
    RoundSkill,
    Icons,
    Tracking,
    //Drill,
} from '../../components';

export default () => {
    const showing = useSelector((state) => state.game.showing);
    const game = useSelector((state) => state.game.game);

    const getGame = () => {
        switch (game?.type) {
            case 'skillbar':
                return <SkillBar game={game} />;
            case 'round':
                return <RoundSkill game={game} />;
            case 'scanner':
                return <Scanner game={game} />;
            case 'sequencer':
                return <Sequencer game={game} />;
            case 'keypad':
                return <Keypad game={game} />;
            case 'scrambler':
                return <Scrambler game={game} />;
            case 'memory':
                return <Memory game={game} />;
            case 'aim':
                return <Aim game={game} />;
            case 'captcha':
                return <Captcha game={game} />;
            case 'keymaster':
                return <Keymaster game={game} />;
            case 'pattern':
                return <Pattern game={game} />;
            case 'icons':
                return <Icons game={game} />;
            case 'tracking':
                return <Tracking game={game} />;
            default:
                return null;
        }
    };

    return <>{showing ? <div>{getGame()}</div> : null}</>;
};
