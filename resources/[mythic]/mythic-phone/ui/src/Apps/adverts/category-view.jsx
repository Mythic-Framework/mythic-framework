import React, { useEffect, useState } from 'react';
import { connect, useSelector } from 'react-redux';
import { Grid } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { Categories } from './data';
import ActionButtons from './ActionButtons';
import Advert from './components/Advert';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	adsWrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		overflowY: 'auto',
		overflowX: 'hidden',
	},
	header: {
		width: '100%',
		padding: 10,
		fontSize: 20,
		height: 50,
		borderBottom: `1px solid ${theme.palette.text.main}`,
	},
	title: {
		width: 'fit-content',
		height: 'fit-content',
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		margin: 'auto',
	},
}));

export default connect()((props) => {
	const classes = useStyles();
	const { category } = props.match.params;
	const catData = Categories.filter((cat) => cat.label === category)[0];
	const adverts = useSelector((state) => state.data.data.adverts);

	const [filtered, setFiltered] = useState(Object());

	useEffect(() => {
		let t = Object();
		Object.keys(adverts).filter(a => a !== '0').map((a) => {
			let ad = adverts[a];
			if (ad.categories.includes(category)) t[a] = ad;
		});
		setFiltered(t);
	}, [adverts]);

	return (
		<div className={classes.wrapper}>
			<Grid
				container
				className={classes.header}
				style={{ backgroundColor: catData.color }}
			>
				<Grid item xs={12} style={{ position: 'relative' }}>
					<div className={classes.title}>{catData.label}</div>
				</Grid>
			</Grid>
			<div className={classes.adsWrapper}>
				{Object.keys(filtered)
					.filter((a) => a !== '0')
					.sort((a, b) => {
						let aItem = filtered[a];
						let bItem = filtered[b];
						return bItem.time - aItem.time;
					})
					.map((ad, i) => {
						return (
							<Advert
								key={`advert-${i}`}
								advert={filtered[ad]}
								del={props.del}
							/>
						);
					})}
			</div>
			<ActionButtons />
		</div>
	);
});
