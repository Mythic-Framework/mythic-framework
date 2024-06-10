import React, { useEffect } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';

const KeyListener = (props) => {
	const handleEvent = (event) => {
		const { dispatch } = props;
		if (event.keyCode === 114 || event.keyCode === 27) {
			dispatch({ type: 'PHONE_NOT_VISIBLE' });
		}
	};

	useEffect(() => {
		window.addEventListener('keydown', handleEvent);

		return () => {
			window.removeEventListener('keydown', handleEvent);
		};
	}, []);

	return React.Children.only(props.children);
};

KeyListener.propTypes = {
	dispatch: PropTypes.func.isRequired,
	children: PropTypes.element.isRequired,
};

export default connect(null, null)(KeyListener);
