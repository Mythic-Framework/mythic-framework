import React, { useEffect, useMemo } from 'react';
import { useSelector } from 'react-redux';
import { throttle } from 'lodash';

import Nui from '../../util/Nui';

export default (props) => {
	const rotate = useMemo(
		() =>
			throttle((dir) => {
				Nui.send(`Rotate${dir}`);
			}, 50),
		[],
	);

	const handleDown = (event) => {
		if (event.keyCode === 81) {
			rotate('Left');
		} else if (event.keyCode == 69) {
			rotate('Right');
		}
	};

	const handleUp = (event) => {
		if (event.keyCode == 82) {
			Nui.send(`Animation`);
		}
	};

	const handleScroll = (event) => {
		Nui.send(`Zoom`, {
			zoom: event.deltaY / 2000,
		});
	};

	useEffect(() => {
		window.addEventListener('keydown', handleDown);
		window.addEventListener('keyup', handleUp);
		window.addEventListener('wheel', handleScroll);

		return () => {
			window.removeEventListener('keydown', handleDown);
			window.removeEventListener('keyup', handleUp);
			window.removeEventListener('wheel', handleScroll);
		};
	}, []);

	return React.Children.only(props.children);
};
