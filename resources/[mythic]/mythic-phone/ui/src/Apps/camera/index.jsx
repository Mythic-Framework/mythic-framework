// Create this file directory inside the path above if you haven't already

import React, { useEffect } from 'react';
import Nui from '../../util/Nui';



export default (props) => {
    useEffect(() => {
        Nui.send('OpenCamera');
    }, []);

    return null; 

};