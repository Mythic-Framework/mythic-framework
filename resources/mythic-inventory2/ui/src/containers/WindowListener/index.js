import React, { useEffect } from 'react';
import { useDispatch } from 'react-redux';
import Nui from '../../util/Nui';

export default ({ children }) => {
	const dispatch = useDispatch();
	const handleEvent = (event) => {
		if (!event.isTrusted) {
			console.log('Untrusted Event Bruv');
			return;
		}
		const { type, data } = event.data;
		if (type != null) dispatch({ type, payload: { ...data } });
	};

	const handleKeyEvent = (event) => {
		if (event.keyCode === 27 || event.keyCode === 113) {
			dispatch({ type: 'SET_SPLIT_ITEM', payload: null });
			dispatch({ type: 'SET_CONTEXT_ITEM', payload: null });
			Nui.send('Close');
		}
	};

	useEffect(() => {
		window.addEventListener('message', handleEvent);
		window.addEventListener('keydown', handleKeyEvent);
		return () => {
			window.removeEventListener('message', handleEvent);
			window.removeEventListener('keydown', handleKeyEvent);
		};
	}, []);

	return React.Children.only(children);
};
