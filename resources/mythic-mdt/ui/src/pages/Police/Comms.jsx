import React from 'react';
import { makeStyles } from '@mui/styles';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '20px 10px 20px 20px',
		height: '100%',
	},
}));

export default () => {
	const classes = useStyles();

	return (
		<div className={classes.wrapper}>
			<iframe
				src={process.env.REACT_POLICE_COMMS}
				title="mythic-comms"
				width="100%"
				height="100%"
			></iframe>
		</div>
	);
};
