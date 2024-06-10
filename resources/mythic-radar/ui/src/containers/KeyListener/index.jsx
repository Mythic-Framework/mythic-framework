import React, { useEffect } from 'react';
import Nui from '../../util/Nui';

export default (props) => {
	const handleEvent = (event) => {
		if (event.keyCode === 27) {
			Nui.send('CloseRemote');
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