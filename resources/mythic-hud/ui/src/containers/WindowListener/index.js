import React, { useEffect } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';

const WindowListener = props => {
    const handleEvent = event => {
        const { dispatch } = props;
        const { type, data } = event.data;
        if (type != null) dispatch({ type, payload: { ...data } });
    };

    useEffect(() => {
        window.addEventListener('message', handleEvent);

        // returned function will be called on component unmount
        return () => {
            window.removeEventListener('message', handleEvent);
        };
    }, []);

    return React.Children.only(props.children);
};

WindowListener.propTypes = {
    dispatch: PropTypes.func.isRequired,
    children: PropTypes.element.isRequired,
};

export default connect(null, null)(WindowListener);
