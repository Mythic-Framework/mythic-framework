export const initialState = {
  hidden: true,
  power: false,
  volume: 100,
  frequency: 0,
  frequencyName: '',
  typeName: 'Radio',
};

const appReducer = (state = initialState, action) => {
  switch (action.type) {
    case 'APP_SHOW':
      return {
        ...state,
        hidden: false,
      };
    case 'APP_HIDE':
      return {
        ...state,
        hidden: true,
      };
    case 'UPDATE_DATA':
      return {
        ...state,
        frequency: action.payload.frequency,
        frequencyName: action.payload.frequencyName,
        power: action.payload.power,
        volume: action.payload.volume,
        typeName: action.payload.typeName,
      }
    default:
      return state;
  }
};

export default appReducer;
