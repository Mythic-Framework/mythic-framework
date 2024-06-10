import Nui from '../util/Nui';
import { LOADING_SHOW } from './types';
import { GetData } from '../util/NuiEvents';


export const login = () => {
    return (dispatch) => {
        Nui.send(GetData);
        dispatch({
            type: LOADING_SHOW,
            payload: { message: 'Loading Server Data' }
        });
      };
}