import React, { useEffect } from 'react';
import { connect } from 'react-redux';

const WindowListener = (props) => {
	const handleEvent = (event) => {
		if (!event.isTrusted) {
			console.log('Untrusted Event Bruv');
			return;
		}

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

export default connect(null, null)(WindowListener);
