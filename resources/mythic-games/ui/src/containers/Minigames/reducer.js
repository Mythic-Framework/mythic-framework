import Nui from '../../util/Nui';
import keymap from './keymap';
import keysets from './keysets';
import charsets from './charsets';

const getRandomChance = (type, difficulty, extra = null) => {
    switch (type) {
        case 'skillbar': {
            return Math.floor(Math.random() * difficulty) + 35;
        }
        case 'scanner': {
            let min = difficulty == 0 ? 1 : 1 + difficulty;
            let max = extra - difficulty;
            let c =
                Math.floor(Math.random() * (max - min + 1 - difficulty)) + min;
            return c;
        }
        case 'sequencer': {
            let c = Array();
            while (c.length < difficulty) {
                var r = Math.floor(Math.random() * 12) + 1;
                if (c[c.length - 1] !== r) c.push(r);
            }
            return c;
        }
        case 'memory': {
            let c = Array();
            while (c.length < difficulty) {
                var r = Math.floor(Math.random() * extra) + 1;
                if (c.indexOf(r) === -1) c.push(r);
            }
            return c;
        }
        case 'keypad':
            return extra
                .split('')
                .filter((c) => Boolean(c))
                .map((c) => +c);
        case 'pattern':
            let index = Math.floor(
                Math.random() * Object.keys(charsets).length,
            );
            return charsets[
                Boolean(extra) ? extra : Object.keys(charsets)[index]
            ];
        default:
            return extra;
    }
};

const getRandomKey = (type) => {
    switch (type) {
        case 'skillbar': {
            return ['e', 'E'];
        }
        case 'round': {
            const keys = ['1', '2', '3'];
            let k = Math.floor(Math.random() * keys.length);
            return [keys[k]];
        }
        case 'scanner': {
            let k = Math.floor(Math.random() * keymap.length);
            return [keymap[k].toLowerCase(), keymap[k].toUpperCase()];
        }
        case 'keymaster': {
            let k = Math.floor(Math.random() * keysets.length);
            return [
                ...keysets[k].map((set) => {
                    return [set.toLowerCase(), set.toUpperCase()];
                }),
            ];
        }
    }
};

export const initialState = {
    showing: false,
    game: null,
    // game: {
    //     type: 'scanner',
    //     timer: 40,
    //     total: 20,
    //     chance: getRandomChance('scanner', 2, 20),
    //     difficulty: 2,
    //     limit: 25000,
    //     key: [...getRandomKey('scanner')],
    //     randomKey: true,
    //     events: {
    //         onFail: '',
    //         onSuccess: '',
    //         onPerfect: 'asdf',
    //     },
    // },
    // game: {
    //     type: 'skillbar',
    //     timer: 3000,
    //     chance: getRandomChance('skillbar', 10),
    //     difficulty: 10,
    //     key: 'e',
    //     randomKey: false,
    //     events: {
    //         onFail: '',
    //         onSuccess: '',
    //     },
    // },
    // game: {
    //     type: 'round',
    //     rate: 0.5,
    //     difficulty: 4,
    //     key: [...getRandomKey('round')],
    //     randomKey: false,
    //     events: {
    //         onFail: '',
    //         onSuccess: '',
    //     },
    // },
    // game: {
    //     type: 'sequencer',
    //     limit: 5000,
    //     timer: 250,
    //     countdown: 10,
    //     chance: getRandomChance('sequencer', 4),
    //     mask: true,
    //     difficulty: 4,
    //     events: {
    //         onFail: '',
    //         onSuccess: '',
    //     },
    // },
    // game: {
    //     type: 'keypad',
    //     limit: 10000,
    //     countdown: 3,
    //     chance: [1, 2, 3, 4],
    //     mask: true,
    //     events: {
    //         onFail: '',
    //         onSuccess: '',
    //     },
    // },
    // game: {
    //     type: 'scrambler',
    //     limit: 25000,
    //     timer: 3000,
    //     chance: 2,
    //     difficulty: 20,
    //     countdown: 5,
    //     events: {
    //         onFail: '',
    //         onSuccess: '',
    //     },
    // },
    // game: {
    //     type: 'memory',
    //     limit: 25000,
    //     timer: 3000,
    //     cols: 3,
    //     rows: 3,
    //     errors: 3,
    //     chance: getRandomChance('memory', 2, 9),
    //     difficulty: 2,
    //     total: 9,
    //     countdown: 5,
    //     events: {
    //         onFail: '',
    //         onSuccess: '',
    //     },
    // },
    // game: {
    //     type: 'drill',
    //     limit: 25000,
    //     timer: 500,
    //     errors: 3,
    //     chance: getRandomChance('drill', 12, 4),
    //     difficulty: 12,
    //     countdown: 3,
    //     events: {
    //         onFail: '',
    //         onSuccess: '',
    //     },
    // },
    // game: {
    //     type: 'aim',
    //     countdown: 3,
    //     limit: 5000,
    //     timer: 1000,
    //     size: 25,
    //     maxSize: 75,
    //     difficulty: 25,
    //     accuracy: 25,
    //     isMoving: true,
    //     events: {
    //         onFail: '',
    //         onSuccess: '',
    //     },
    // },
    // game: {
    //     type: 'captcha',
    //     countdown: 3,
    //     timer: 5000,
    //     limit: 30000,
    //     difficulty: 5,
    //     difficulty2: 2,
    //     events: {
    //         onFail: '',
    //         onSuccess: '',
    //     },
    // },
    // game: {
    //     type: 'keymaster',
    //     countdown: 3,
    //     timer: [3500, 3500],
    //     limit: 35000,
    //     difficulty: 4,
    //     chances: 10,
    //     shuffled: false,
    //     key: [...getRandomKey('keymaster')],
    //     events: {
    //         onFail: '',
    //         onSuccess: '',
    //     },
    // },
    // game: {
    //     type: 'pattern',
    //     countdown: 3,
    //     timer: 3000,
    //     limit: 350000,
    //     size: 6,
    //     difficulty: 4,
    //     difficulty2: 2,
    //     chance: getRandomChance('pattern'),
    //     events: {
    //         onFail: '',
    //         onSuccess: '',
    //     },
    // },
    // game: {
    //     type: 'icons',
    //     countdown: 3,
    //     timer: 5,
    //     delay: 1500,
    //     limit: 15000,
    //     difficulty: 8,
    //     difficulty2: 8,
    //     events: {
    //         onFail: '',
    //         onSuccess: '',
    //     },
    // },
    // game: {
    //     type: 'tracking',
    //     countdown: 3,
    //     delay: 1500,
    //     limit: 15000,
    //     difficulty: 3,
    //     events: {
    //         onFail: '',
    //         onSuccess: '',
    //     },
    // },
    started: null,
    failed: false,
    finished: false,
};

export default (state = initialState, action) => {
    switch (action.type) {
        case 'SHOW_GAME':
            return {
                ...state,
                showing: true,
                game: {
                    ...action.payload.game,
                    chance: getRandomChance(
                        action.payload.game.type,
                        action.payload.game.difficulty,
                        action.payload.game.total,
                    ),
                    key: action.payload.game.randomKey
                        ? [...getRandomKey(action.payload.game.type)]
                        : ['e', 'E'],
                },
                started: Date.now(),
                failed: false,
                finished: false,
            };
        case 'HIDE_GAME':
            Nui.send('Minigame:End');
            return {
                ...state,
                showing: false,
                game: null,
                failed: false,
                finished: false,
            };
        case 'FINISH_GAME':
            return {
                ...state,
                finished: true,
                failed: false,
            };
        case 'FAIL_GAME':
            return {
                ...state,
                failed: true,
                finished: false,
            };
        default:
            return state;
    }
};
