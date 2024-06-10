import React, { useEffect } from 'react';
import { connect, useSelector } from 'react-redux';
import { Tabs, Tab } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import './editor.css';
import Advert from './components/Advert';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		overflowY: 'auto',
		overflowX: 'hidden',
	},
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
}));

export default ({ del }) => {
	const classes = useStyles();
	const adverts = useSelector((state) => state.data.data.adverts);

	const filtered = Object.keys(adverts).filter((a) => a !== '0');

	return (
		<div className={classes.wrapper}>
			{filtered.length > 0 ? ( filtered
				.sort((a, b) => {
					let aItem = adverts[a];
					let bItem = adverts[b];
					return bItem.time - aItem.time;
				})
				.map((ad, i) => {
					return (
						<Advert
							key={`advert-${i}`}
							advert={adverts[ad]}
							del={del}
						/>
					);
				}) ) : (
                    <div className={classes.emptyMsg}>No Advertisements</div>
                )}
		</div>
	);
};
