import React from 'react';
import { useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: 'fit-content',
		width: 'fit-content',
		background: theme.palette.secondary.dark,
		position: 'absolute',
		top: 48,
		right: 0,
		padding: 10,
		fontSize: 22,
		border: `1px solid ${theme.palette.border.divider}`,
		borderRight: 'none',
	},
	text: {
		color: theme.palette.text.main,
		padding: 14,
		fontSize: 16,
		letterSpacing: 1,
		textTransform: 'uppercase',
		whiteSpace: 'nowrap',
		textAlign: 'left',
	},
	key: {
		color: theme.palette.primary.main,
		fontWeight: 'bold',
	},
}));

export default (props) => {
	const classes = useStyles();

	return (
		<div className={classes.wrapper}>
			<div className={classes.text}>
				<div>
					<span className={classes.key}>Q</span>
					<span>{` / `}</span>
					<span className={classes.key}>E</span>: Rotate
				</div>
				<div>
					<span className={classes.key}>Mousewheel</span>: Zoom
				</div>
				<div>
					<span className={classes.key}>R</span>: Animation
				</div>
			</div>
		</div>
	);
};
