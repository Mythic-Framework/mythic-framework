import React from 'react';
import { Grid, Tooltip } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles((theme) => ({
	div: {
		width: '100%',
		fontSize: 13,
		fontWeight: 500,
		textDecoration: 'none',
		textShadow: 'none',
		whiteSpace: 'nowrap',
		display: 'inline-block',
		verticalAlign: 'middle',
		borderRadius: 3,
		transition: '0.1s all linear',
		userSelect: 'none',
		color: '#ffffff',
		margin: 'auto',
		lineHeight: '84px',
		height: '100%',
		textAlign: 'center',
	},
	disabled: {
		fontSize: 20,
		color: theme.palette.primary.main,
	},
	enabled: {
		fontSize: 20,
		color: theme.palette.success.main,
	},
}));

const Checkbox = (props) => {
	const classes = useStyles();

	return (
		<div className={classes.div} onClick={props.onClick}>
			<Grid container>
				<Grid item xs={12}>
					{props.disabled ? (
						<Tooltip title="Enable">
							<FontAwesomeIcon
								icon={['far', 'square']}
								className={classes.disabled}
							/>
						</Tooltip>
					) : (
						<Tooltip title="Disable">
							<FontAwesomeIcon
								icon={['far', 'square-check']}
								className={classes.enabled}
							/>
						</Tooltip>
					)}
				</Grid>
			</Grid>
		</div>
	);
};

export default Checkbox;
