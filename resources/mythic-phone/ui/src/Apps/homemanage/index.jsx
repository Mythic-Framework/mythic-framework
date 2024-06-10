import React, { useEffect, useState, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { AppBar, Grid, Tooltip, IconButton } from '@material-ui/core';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { makeStyles } from '@material-ui/styles';
import { throttle } from 'lodash';
import Truncate from 'react-truncate';

import Nui from '../../util/Nui';
import { Loader, Confirm } from '../../components';
import MyHouse from './MyHouse';
import Select from './Select';
import { useAlert } from '../../hooks';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	header: {
		background: '#30518c',
		fontSize: 20,
		padding: 15,
		lineHeight: '50px',
		height: 78,
	},
	headerAction: {},
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
}));

const testProps = [
	{
		type: "house",
		id: '60af7d605716b35d64c6c4a1',
		label: '1 Grove St',
		sold: true,
		price: 100000,
		default: true,
		interior: 1,
		location: {
			front: {
				z: 26.679443359375,
				y: -1847.235107421875,
				x: -33.92966842651367,
			},
			backdoor: {
				z: 26.197219848633,
				y: -1859.2385253906,
				x: -42.875373840332,
				h: 139.80822753906,
			},
		},
		owner: '6088b90c93a7b379e0c83ef2',
		keys: {
			'6088b90c93a7b379e0c83ef2': {
				First: 'Test',
				Last: 'Test',
				Type: 'Owner',
				Owner: true,
				SID: 1,
			},
			541: {
				First: 'Test',
				Last: 'Test',
				Type: 'Keyholder',
				Owner: false,
				SID: 2,
			},
		},
		upgrades: {
			interior: "house_apartment1",
		}
	},
];

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const showAlert = useAlert();
	const selected = useSelector((state) => state.home.selected);
	const myProperties = useSelector((state) => state.data.data.myProperties);
	const charId = useSelector((state) => state.data.data.player.ID);

	const [loading, setLoading] = useState(false);

	const [removing, setRemoving] = useState(false);
	const [isValid, setIsValid] = useState(null);
	const [myKey, setMyKey] = useState(null);

	useEffect(() => {
		if (Boolean(isValid)) {
			setMyKey(isValid.keys[charId]);
		}
	}, [isValid]);

	useEffect(() => {
		if (Boolean(selected) && Boolean(myProperties)) {
			setIsValid(myProperties.filter((p) => p.id == selected)[0]);
		} else setIsValid(null);
	}, [selected, myProperties]);

	const fetch = useMemo(
		() =>
			throttle(async () => {
				if (loading) return;
				setLoading(true);
				try {
					let res = await (
						await Nui.send('Home:GetMyProperties')
					).json();
					if (res) {
						dispatch({
							type: 'SET_DATA',
							payload: {
								type: 'myProperties',
								data: res.properties,
							},
						});

						dispatch({
							type: 'SET_DATA',
							payload: {
								type: 'propertyUpgrades',
								data: res.upgrades,
							},
						});
					} else {
						dispatch({
							type: 'SET_DATA',
							payload: {
								type: 'myProperties',
								data: Array(),
							},
						});
					}
				} catch (err) {
					console.log(err);
					dispatch({
						type: 'SET_DATA',
						payload: {
							type: 'myProperties',
							data: testProps,
						},
					});
				}
				setLoading(false);
			}, 1000),
		[],
	);

	const lockProperty = useMemo(
		() =>
			throttle(async (property) => {
				if (loading) return;
				setLoading(true);
				try {
					let res = await (await Nui.send('Home:LockProperty'),
					{
						id: property.id,
					}).json();
					if (res) {
						showAlert('Property Locked');
						dispatch({
							type: 'UPDATE_DATA',
							payload: {
								type: 'myProperties',
								id: property.id,
								data: {
									...property,
									locked: true,
								},
							},
						});
					} else showAlert('Unable to Lock Property');
				} catch (err) {
					console.log(err);
					showAlert('Unable to Lock Property');
				}
				setLoading(false);
			}, 1000),
		[],
	);

	useEffect(() => {
		fetch();
	}, []);

	const onBack = () => {
		dispatch({
			type: 'SET_SELECTED_PROPERTY',
			payload: null,
		});
	};

	const onRemove = async () => {
		setLoading(true);
		try {
			let res = await (
				await Nui.send('Home:RemoveMyKey', {
					id: isValid.id,
				})
			).json();
			if (res) {
				onBack();
				showAlert('Removed DigiKey');
			} else showAlert('Unable to Remove DigiKey');
		} catch (err) {
			console.log(err);
			setRemoving(false);
			showAlert('Unable to Remove DigiKey');
		}
		setLoading(false);
	};

	return (
		<div className={classes.wrapper}>
			<AppBar position="static" className={classes.header}>
				<Grid container>
					<Grid item xs={2} style={{ textAlign: 'center' }}>
						{Boolean(isValid) ? (
							<IconButton onClick={onBack}>
								<FontAwesomeIcon
									icon={['fas', 'chevron-left']}
								/>
							</IconButton>
						) : (
							<IconButton disabled>
								<FontAwesomeIcon
									icon={['fas', 'house-signal']}
								/>
							</IconButton>
						)}
					</Grid>
					<Grid item xs={5} style={{ lineHeight: '50px' }}>
						<Truncate lines={1}>
							{Boolean(isValid) ? isValid.label : 'Smart Home'}
						</Truncate>
					</Grid>
					<Grid item xs={5} style={{ textAlign: 'right' }}>
						{Boolean(isValid) && (
							<>
								{Boolean(myKey) && !myKey.Owner && (
									<Tooltip title="Remove DigiKey">
										<IconButton
											onClick={() => setRemoving(true)}
											disabled={loading}
											className={classes.headerAction}
										>
											<FontAwesomeIcon
												icon={['fas', 'trash-can-xmark']}
											/>
										</IconButton>
									</Tooltip>
								)}
								{!isValid.locked && (
									<Tooltip title="Lock Property">
										<IconButton
											onClick={() =>
												lockProperty(isValid)
											}
											disabled={loading}
											className={classes.headerAction}
										>
											<FontAwesomeIcon
												icon={['fas', 'lock']}
											/>
										</IconButton>
									</Tooltip>
								)}
							</>
						)}
						<Tooltip title="Refresh Properties">
							<IconButton
								onClick={fetch}
								disabled={loading}
								className={classes.headerAction}
							>
								<FontAwesomeIcon
									className={`fa ${loading ? 'fa-spin' : ''}`}
									icon={['fas', 'arrows-rotate']}
								/>
							</IconButton>
						</Tooltip>
					</Grid>
				</Grid>
			</AppBar>
			{loading ? (
				<Loader static text="Loading" />
			) : Boolean(isValid) ? (
				<MyHouse property={isValid} onRefresh={fetch} setLoading={setLoading} />
			) : (
				<Select />
			)}
			{Boolean(isValid) && (
				<>
					{Boolean(myKey) && !myKey.Owner && (
						<Confirm
							title="Remove DigiKey?"
							open={removing}
							confirm="Yes"
							decline="No"
							onConfirm={onRemove}
							onDecline={() => setRemoving(false)}
						>
							<p>
								Removing the DigiKey will revoke access to this
								property and shared assets. Are you sure?
							</p>
						</Confirm>
					)}
				</>
			)}
		</div>
	);
};
