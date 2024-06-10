export const initialState = {
    showing: true,
    matchInfo: {
        matchEnd: Date.now() + 1000 * 60 * 30,
        matchLabel: 'Team Deathmatch',
    },
    team1: {
        current: 0,
        max: 25,
    },
    team2: {
        current: 0,
        max: 25,
    },
};

export default (state = initialState, action) => {
    switch (action.type) {
        case 'ARCADE_START_MATCH':
            return {
                ...state,
                matchInfo: {
                    matchEnd: action.payload.end,
                    matchLabel: action.payload.gamemode,
                },
                team1: {
                    current: 0,
                    max: action.payload.objectiveMax,
                },
                team2: {
                    current: 0,
                    max: action.payload.objectiveMax,
                },
            };
        case 'TEAM_1_ADD_OBJ':
            return {
                ...state,
                team1: {
                    ...state.team1,
                    current: state.team1.current + action.payload.amt,
                },
            };
        case 'TEAM_2_ADD_OBJ':
            return {
                ...state,
                team2: {
                    ...state.team2,
                    current: state.team2.current + action.payload.amt,
                },
            };
        default:
            return state;
    }
};
