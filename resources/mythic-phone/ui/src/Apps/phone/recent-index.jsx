import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import { useHistory } from 'react-router-dom';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Recent from './recent';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
}));

export default (props) => {
	const classes = useStyles();
	const calls = useSelector((state) => state.data.data.calls);
	const [expanded, setExpanded] = useState(-1);

	const handleClick = (index) => (event, newExpanded) => {
		setExpanded(newExpanded ? index : -1);
	};

	return (
		<div className={classes.wrapper}>
			{calls.filter((c) => Boolean(c)).length > 0 ? (
				calls
					.filter((c) => Boolean(c))
					.sort((a, b) => b.time - a.time)
					.map((call, key) => {
						return (
							<Recent
								key={key}
								expanded={expanded}
								index={key}
								call={call}
								onClick={handleClick(key)}
							/>
						);
					})
			) : (
				<div className={classes.emptyMsg}>You Have No Recent Calls</div>
			)}
		</div>
	);
};
