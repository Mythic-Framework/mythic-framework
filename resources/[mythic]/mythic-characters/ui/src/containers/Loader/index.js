import React from 'react';
import { connect } from 'react-redux';
import { makeStyles } from '@mui/styles';
import { Dot } from 'react-animated-dots';

import Loader from '../../components/Loader/Loader';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: 'fit-content',
		width: '55%',
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
		textAlign: 'center',
		fontSize: 30,
		color: theme.palette.text.main,
		zIndex: 1000,
		padding: 36,
	},
	dot1: {
		color: theme.palette.primary.main,
	},
	dot2: {
		color: theme.palette.text.main,
	},
	dot3: {
		color: theme.palette.primary.main,
	},
}));

const Splash = (props) => {
	const classes = useStyles();

	return (
		<div className={classes.wrapper}>
			{props.loading ? (
				<div>
					<Loader />
					<div className="label">
						{props.message}
						<Dot className={classes.dot1}>.</Dot>
						<Dot className={classes.dot2}>.</Dot>
						<Dot className={classes.dot3}>.</Dot>
					</div>
				</div>
			) : null}
		</div>
	);
};

const mapStateToProps = (state) => {
	return {
		loading: state.loader.loading,
		message: state.loader.message,
	};
};

export default connect(mapStateToProps)(Splash);
