import React, { Fragment, useEffect, useState } from 'react';
import { connect, useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';
import { library } from '@fortawesome/fontawesome-svg-core';
import { fas } from '@fortawesome/free-solid-svg-icons';
import { far } from '@fortawesome/free-regular-svg-icons';
import { fab } from '@fortawesome/free-brands-svg-icons';
import { Fade } from '@mui/material';

import { Loader } from '../../components/UIComponents';
import Creator from '../Creator';
import Shop from '../Shop/Shop';
import Surgery from '../Surgery/Surgery';
import Tip from '../Tip';
import Barber from '../Barber';
import Tattoo from '../Tattoo';

library.add(fab, fas, far);

const useStyles = makeStyles((theme) => ({
	content: {
		position: 'relative',
		height: '100%',
		width: '100%',
		overflow: 'hidden',
	},
}));

export default connect()((props) => {
	const classes = useStyles();
	const hidden = useSelector((state) => state.app.hidden);
	const state = useSelector((state) => state.app.state);
	const loading = useSelector((state) => state.app.loading);
	const [display, setDisplay] = useState(<Fragment />);

	useEffect(() => {
		switch (state) {
			case 'CREATOR':
				setDisplay(<Creator />);
				break;
			case 'SHOP':
				setDisplay(<Shop />);
				break;
			case 'BARBER':
				setDisplay(<Barber />);
				break;
			case 'TATTOO':
				setDisplay(<Tattoo />);
				break;
			case 'SURGERY':
				setDisplay(<Surgery />);
				break;
			default:
				setDisplay(<Fragment />);
				break;
		}
	}, [state]);

	return (
		<Fade in={!hidden}>
			<div className="App">
				{loading ? <Loader /> : display}
				<Tip />
			</div>
		</Fade>
	);
});
