import React, { useEffect, useState, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles } from '@material-ui/styles';
import { Alert, AppBar, Button, Grid, TextField } from '@material-ui/core';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import NumberFormat from 'react-number-format';

import Nui from '../../util/Nui';
import { useAlert, useMyStates } from '../../hooks';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		//background: theme.palette.secondary.main,
		background:
			'linear-gradient( rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.65) ), url(https://www.gtaboom.com/wp-content/uploads/2014/09/GTA-V-map-scale-768x950.webp)',
		backgroundPosition: 'center',
	},
	content: {
		position: 'absolute',
		width: '75%',
		height: 'fit-content',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
		padding: 10,
		background: theme.palette.secondary.dark,
		border: `1px solid ${theme.palette.border.divider}`,
	},
	alert: {
		backgroundColor: '#8E1467',
		marginBottom: 15,
	},
	primary: {
		backgroundColor: '#8E1467',
		'&:hover': {
			backgroundColor: '#8E1467a3',
		},
	},
	editorField: {
		marginBottom: 15,
	},
	icon: {
		marginRight: 5,
	},
}));

export default (props) => {
	const classes = useStyles();
	const hasState = useMyStates();
	const showAlert = useAlert();

	const [target, setTarget] = useState('');

	const onChange = (e) => {
		setTarget(+e.target.value);
	};

	const onPing = async () => {
		try {
			let res = await (
				await Nui.send('PingEm:Send', {
					target,
					type: false,
				})
			).json();
			if (res) {
				showAlert('Sent Ping');
			} else showAlert('Unable To Send Ping');
		} catch (err) {
			showAlert('Unable To Send Ping');
		}
	};

	const onAnonPing = async () => {
		try {
			let res = await (
				await Nui.send('PingEm:Send', {
					target,
					type: true,
				})
			).json();
			if (res) {
				showAlert('Sent Ping');
			} else showAlert('Unable To Send Ping');
		} catch (err) {
			showAlert('Unable To Send Ping');
		}
	};

	return (
		<div className={classes.wrapper}>
			<div className={classes.content}>
				<NumberFormat
					fullWidth
					required
					label="Target State ID"
					name="target"
					className={classes.editorField}
					type="tel"
					isNumericString
					customInput={TextField}
					value={target}
					onChange={onChange}
				/>
				<Button
					fullWidth
					className={classes.primary}
					variant="contained"
					onClick={onPing}
				>
					Send Ping
				</Button>
				{hasState('PHONE_VPN') && (
					<Button
						style={{ marginTop: 15 }}
						fullWidth
						variant="outlined"
						color="warning"
						onClick={onAnonPing}
					>
						<FontAwesomeIcon
							className={classes.icon}
							icon={['fas', 'user-secret']}
						/>
						Send Anonymous Ping
					</Button>
				)}
			</div>
		</div>
	);
};
