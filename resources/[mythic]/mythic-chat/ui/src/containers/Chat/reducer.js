export const initialState = {
    messages:
        process.env.NODE_ENV != 'production'
            ? Array(
                  {
                      time: 1653589049,
                      type: 'ooc',
                      message: 'TEST',
                      author: {
                          First: 'Fucky',
                          Last: 'Ducky',
                          SID: 1,
                      },
                  },
                  {
                      time: 1653589050,
                      type: 'ooc',
                      message: 'TEST',
                      author: {
                          First: 'Fucky',
                          Last: 'Ducky',
                          SID: 1,
                      },
                  },
                  {
                      time: 1653592894,
                      type: 'dispatch',
                      message: 'TEST\ntest\ndfdf',
                  },
                  {
                      time: 1653589051,
                      type: 'ooc',
                      message: 'TEST',
                      author: {
                          First: 'Fucky',
                          Last: 'Ducky',
                          SID: 1,
                      },
                  },
              )
            : Array(),
    suggestions:
        process.env.NODE_ENV != 'production'
            ? Array(
                  { name: '/ooc', help: 'OOC Chat' },
                  {
                      name: '/ass',
                      help: 'thingy, lol',
                      params: Array({
                          name: 'YEET',
                          help: 'Something something something',
                      }),
                  },
                  {
                      name: '/die',
                      help: 'I Wanna Die',
                      params: Array(
                          {
                              name: 'die1',
                              help: 'I Wanna Die 1',
                          },
                          {
                              name: 'die2',
                              help: 'I Wanna Die 2',
                          },
                      ),
                  },
              )
            : Array(),
    inputs:
        process.env.NODE_ENV != 'production'
            ? Array('/ooc TEST', '/m0', '/911a "FUCK YOU CUNT LOL"')
            : Array(),
};

export default (state = initialState, action) => {
    switch (action.type) {
        case 'ON_MESSAGE':
            return {
                ...state,
                messages: !Boolean(action.payload.message?.message)
                    ? state.messages
                    : [
                          { ...action.payload.message, time: Date.now() },
                          ...state.messages,
                      ],
            };
        case 'ON_SUGGESTION_ADD':
            return {
                ...state,
                suggestions: [...state.suggestions, action.payload.suggestion],
            };
        case 'ON_SUGGESTION_REMOVE':
            return {
                ...state,
            };
        case 'ON_COMMANDS_RESET':
            return {
                ...state,
                suggestions: Array(),
            };
        case 'ON_CLEAR':
            return {
                ...state,
                messages: Array(),
                inputs: Array(),
            };
        case 'ON_SUBMIT':
            return {
                ...state,
                inputs: [action.payload.message, ...state.inputs],
            };
        default:
            return state;
    }
};
