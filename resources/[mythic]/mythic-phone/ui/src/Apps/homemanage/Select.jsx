import React from 'react';
import { useSelector } from 'react-redux';
import { List } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';

import Property from './components/Property';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		//position: 'relative',
	},
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
	list: {
		height: '100%',
		//overflow: 'auto',
		overflowX: 'hidden',
		overflowY: 'auto',
	}
}));

export default (props) => {
	const classes = useStyles();
	const myProperties = useSelector((state) => state.data.data.myProperties);

	return (
		<div className={classes.wrapper}>
			{myProperties.length > 0 ? (
				<List className={classes.list}>
					{myProperties.map((property) => {
						return <Property
							key={`prop-${property.id}`}
							property={property}
						/>
					})}
				</List>
			) : (
				<div className={classes.emptyMsg}>
					You Dont Have Access To Any Properties
				</div>
			)}
		</div>
	);
};
