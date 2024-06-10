import React, { useEffect } from 'react';
//import { useSelector } from 'react-redux';
import Nui from '../../util/Nui';

export default (props) => {

	const handleEvent = (event) => {
		if (event.keyCode === 27) {
			Nui.send('Close');
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
