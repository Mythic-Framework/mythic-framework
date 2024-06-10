import React, { useState, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';
import { Grid } from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { usePermissions } from '../../../hooks';

const useStyles = makeStyles((theme) => ({
	selectContainer: {
		textAlign: 'center',
		height: 'fit-content',
		width: 'fit-content',
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
	},
	selectBtn: {
		display: 'inline-block',
		padding: 30,
		transition: 'color ease-in 0.15s',
		fontSize: 22,
		'&:hover': {
			color: theme.palette.primary.main,
			cursor: 'pointer',
		},
		'& svg': {
			display: 'block',
			width: 85,
			height: 85,
			fontSize: 85,
			margin: 'auto',
		},
	},
	grid: {
		
	}
}));

export default ({ onClick }) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const hasPerm = usePermissions();

	const user = useSelector((state) => state.data.data.player);

	const [isBuyer, setIsBuyer] = useState(false);
	const [isContractor, setIsContractor] = useState(false);
	const [isAdmin, setIsAdmin] = useState(false);

	useEffect(() => {
		setIsBuyer(hasPerm('supplymate', 'buyer'));
		setIsContractor(hasPerm('supplymate', 'contractor'));
		setIsAdmin(hasPerm('supplymate', 'admin'));
	}, [user]);

	return (
		<Grid container className={classes.selectContainer}>
			<Grid item xs={12} style={{ fontSize: 28 }}>
				Select Role
			</Grid>
			<Grid item xs={12}>
				<div className={classes.grid}>
					{isBuyer && (
						<div
							className={classes.selectBtn}
							onClick={() => onClick(1)}
						>
							<FontAwesomeIcon icon={['fas', 'money-bill-1']} />
							Buyer
						</div>
					)}
					{isContractor && (
						<div
							className={classes.selectBtn}
							onClick={() => onClick(2)}
						>
							<FontAwesomeIcon
								icon={['fas', 'file-invoice-dollar']}
							/>
							Contractor
						</div>
					)}
					{isAdmin && (
						<div
							className={classes.selectBtn}
							onClick={() => onClick(3)}
						>
							<FontAwesomeIcon icon={['fas', 'user-shield']} />
							Admin
						</div>
					)}
				</div>
			</Grid>
		</Grid>
	);
};
