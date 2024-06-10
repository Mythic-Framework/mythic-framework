import React, { useEffect, useState, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles } from '@material-ui/styles';
import { throttle } from 'lodash';
import { AppBar, Grid, Tooltip, IconButton, List } from '@material-ui/core';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Vehicle from './components/Vehicle';
import Nui from '../../util/Nui';
import { Loader } from '../../components';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	header: {
		background: '#eb34de',
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
	list: {
		height: '90%',
		//overflow: 'auto',
		overflowX: 'hidden',
		overflowY: 'auto',
	}
}));

// const testVehicles = [
// 	{
// 		_id: '60dda30d73ecfd54401c292c',
// 		Make: 'Chevrolet',
// 		Owner: {
// 			Type: 0,
// 			Id: 3,
// 		},
// 		Properties: {
// 			mods: {
// 				brakes: 2,
// 				archCover: -1,
// 				armor: -1,
// 				rightFender: -1,
// 				engine: 3,
// 				plateHolder: -1,
// 				rearBumper: 0,
// 				turbo: true,
// 				transmission: 2,
// 				seats: -1,
// 				trimB: -1,
// 				fender: -1,
// 				ornaments: -1,
// 				shifterLeavers: -1,
// 				vanityPlate: -1,
// 				speakers: -1,
// 				aerials: -1,
// 				struts: -1,
// 				trimA: -1,
// 				backWheels: -1,
// 				grille: -1,
// 				frontBumper: -1,
// 				steeringWheel: -1,
// 				dial: -1,
// 				exhaust: -1,
// 				sideSkirt: -1,
// 				spoilers: -1,
// 				aPlate: -1,
// 				windows: -1,
// 				airFilter: -1,
// 				horns: -1,
// 				hydrolic: -1,
// 				engineBlock: -1,
// 				dashboard: -1,
// 				hood: -1,
// 				suspension: -1,
// 				xenon: true,
// 				xenonColor: 8,
// 				frontWheels: 74,
// 				doorSpeaker: -1,
// 				roof: -1,
// 				trunk: -1,
// 				tank: -1,
// 				frame: -1,
// 			},
// 			neonColor: {
// 				b: 4,
// 				r: 255,
// 				g: 0,
// 			},
// 			plateIndex: 0,
// 			paintType: [3, 2],
// 			pearlescentColor: 112,
// 			color2: {
// 				b: 5,
// 				r: 5,
// 				g: 5,
// 			},
// 			dirtLevel: 7.000000476837158,
// 			wheelColor: 12,
// 			tyreSmoke: false,
// 			neonEnabled: [true, true, true, true],
// 			extras: {
// 				0: false,
// 				1: true,
// 				2: false,
// 				3: false,
// 				4: false,
// 				5: false,
// 				6: false,
// 				7: false,
// 				8: false,
// 				9: false,
// 				10: false,
// 				11: false,
// 				12: false,
// 			},
// 			windowTint: 1,
// 			color1: {
// 				b: 5,
// 				r: 137,
// 				g: 5,
// 			},
// 			livery: -1,
// 			tyreSmokeColor: {
// 				b: 255,
// 				r: 255,
// 				g: 255,
// 			},
// 			wheels: 0,
// 		},
// 		Storage: {
// 			Type: 1,
// 			Id: 'sa_ave_downtown',
// 		},
// 		Fuel: 100,
// 		FakePlate: false,
// 		RegisteredPlate: 'E6GMK36S',
// 		Class: 'Unknown',
// 		VIN: '9KSPCGRAP7A385723',
// 		Vehicle: 2048139894,
// 		Value: false,
// 		Type: 0,
// 		Model: 'Corvette',
// 		FirstSpawn: false,
// 		DamagedParts: {
// 			Brakes: 95.379,
// 			Axle: 99.562,
// 			Clutch: 96.534,
// 			Electronics: 97.69,
// 			Transmission: 99.687,
// 			FuelInjectors: 98.267,
// 			Radiator: 94.802,
// 		},
// 		Mileage: 301.59,
// 		Damage: {
// 			Engine: 1000,
// 			Body: 1000,
// 		},
// 	},
// 	{
// 		_id: '60dda30d73ecfd54401c292c',
// 		Make: 'Chevrolet',
// 		Owner: {
// 			Type: 0,
// 			Id: 3,
// 		},
// 		Properties: {
// 			tyreSmoke: false,
// 			tyreSmokeColor: {
// 				g: 255,
// 				r: 255,
// 				b: 255,
// 			},
// 			paintType: [3, 2],
// 			wheels: 0,
// 			livery: -1,
// 			color2: {
// 				g: 5,
// 				r: 5,
// 				b: 5,
// 			},
// 			plateIndex: 0,
// 			color1: {
// 				g: 5,
// 				r: 137,
// 				b: 5,
// 			},
// 			neonColor: {
// 				g: 0,
// 				r: 255,
// 				b: 4,
// 			},
// 			pearlescentColor: 112,
// 			dirtLevel: 7.000000476837158,
// 			neonEnabled: [true, true, true, true],
// 			mods: {
// 				plateHolder: -1,
// 				sideSkirt: -1,
// 				hydrolic: -1,
// 				dashboard: -1,
// 				tank: -1,
// 				vanityPlate: -1,
// 				horns: -1,
// 				archCover: -1,
// 				shifterLeavers: -1,
// 				grille: -1,
// 				armor: -1,
// 				engine: 3,
// 				transmission: 2,
// 				roof: -1,
// 				frontBumper: -1,
// 				trimB: -1,
// 				backWheels: -1,
// 				steeringWheel: -1,
// 				rightFender: -1,
// 				spoilers: -1,
// 				rearBumper: 0,
// 				dial: -1,
// 				suspension: -1,
// 				aPlate: -1,
// 				aerials: -1,
// 				doorSpeaker: -1,
// 				engineBlock: -1,
// 				xenonColor: 8,
// 				fender: -1,
// 				windows: -1,
// 				turbo: true,
// 				speakers: -1,
// 				ornaments: -1,
// 				frontWheels: 74,
// 				brakes: 2,
// 				seats: -1,
// 				struts: -1,
// 				trunk: -1,
// 				frame: -1,
// 				trimA: -1,
// 				hood: -1,
// 				airFilter: -1,
// 				exhaust: -1,
// 				xenon: true,
// 			},
// 			windowTint: 1,
// 			extras: {
// 				0: false,
// 				1: true,
// 				2: false,
// 				3: false,
// 				4: false,
// 				5: false,
// 				6: false,
// 				7: false,
// 				8: false,
// 				9: false,
// 				10: false,
// 				11: false,
// 				12: false,
// 			},
// 			wheelColor: 12,
// 		},
// 		Storage: {
// 			Type: 0,
// 			TimeHold: {
// 				ImpoundedAt: 1625774487,
// 				ExpiresAt: 1625817687,
// 				Length: 43200,
// 			},
// 			Fine: 3,
// 			Id: 0,
// 		},
// 		Fuel: 41.18,
// 		FakePlate: false,
// 		RegisteredPlate: 'E6GMK36S',
// 		Class: 'Unknown',
// 		VIN: '9KSPCGRAP7A385732',
// 		Vehicle: 2048139894,
// 		Value: false,
// 		Type: 0,
// 		Model: 'Corvette',
// 		FirstSpawn: false,
// 		DamagedParts: {
// 			Radiator: 87.411,
// 			Electronics: 94.405,
// 			Clutch: 91.607,
// 			Axle: 97.804,
// 			Brakes: 88.81,
// 			Transmission: 98.434,
// 			FuelInjectors: 95.803,
// 		},
// 		Mileage: 322.6,
// 		Damage: {
// 			Engine: 1000,
// 			Body: 991,
// 		},
// 	},
// ];

// const testVehicles = Array(12).fill(	{
// 	_id: '60dda30d73ecfd54401c292c',
// 	Make: 'Chevrolet',
// 	Owner: {
// 		Type: 0,
// 		Id: 3,
// 	},
// 	Properties: {
// 		tyreSmoke: false,
// 		tyreSmokeColor: {
// 			g: 255,
// 			r: 255,
// 			b: 255,
// 		},
// 		paintType: [3, 2],
// 		wheels: 0,
// 		livery: -1,
// 		color2: {
// 			g: 5,
// 			r: 5,
// 			b: 5,
// 		},
// 		plateIndex: 0,
// 		color1: {
// 			g: 5,
// 			r: 137,
// 			b: 5,
// 		},
// 		neonColor: {
// 			g: 0,
// 			r: 255,
// 			b: 4,
// 		},
// 		pearlescentColor: 112,
// 		dirtLevel: 7.000000476837158,
// 		neonEnabled: [true, true, true, true],
// 		mods: {
// 			plateHolder: -1,
// 			sideSkirt: -1,
// 			hydrolic: -1,
// 			dashboard: -1,
// 			tank: -1,
// 			vanityPlate: -1,
// 			horns: -1,
// 			archCover: -1,
// 			shifterLeavers: -1,
// 			grille: -1,
// 			armor: -1,
// 			engine: 3,
// 			transmission: 2,
// 			roof: -1,
// 			frontBumper: -1,
// 			trimB: -1,
// 			backWheels: -1,
// 			steeringWheel: -1,
// 			rightFender: -1,
// 			spoilers: -1,
// 			rearBumper: 0,
// 			dial: -1,
// 			suspension: -1,
// 			aPlate: -1,
// 			aerials: -1,
// 			doorSpeaker: -1,
// 			engineBlock: -1,
// 			xenonColor: 8,
// 			fender: -1,
// 			windows: -1,
// 			turbo: true,
// 			speakers: -1,
// 			ornaments: -1,
// 			frontWheels: 74,
// 			brakes: 2,
// 			seats: -1,
// 			struts: -1,
// 			trunk: -1,
// 			frame: -1,
// 			trimA: -1,
// 			hood: -1,
// 			airFilter: -1,
// 			exhaust: -1,
// 			xenon: true,
// 		},
// 		windowTint: 1,
// 		extras: {
// 			0: false,
// 			1: true,
// 			2: false,
// 			3: false,
// 			4: false,
// 			5: false,
// 			6: false,
// 			7: false,
// 			8: false,
// 			9: false,
// 			10: false,
// 			11: false,
// 			12: false,
// 		},
// 		wheelColor: 12,
// 	},
// 	Storage: {
// 		Type: 0,
// 		TimeHold: {
// 			ImpoundedAt: 1625774487,
// 			ExpiresAt: 1625817687,
// 			Length: 43200,
// 		},
// 		Fine: 3,
// 		Id: 0,
// 	},
// 	Fuel: 41.18,
// 	FakePlate: false,
// 	RegisteredPlate: 'E6GMK36S',
// 	Class: 'Unknown',
// 	VIN: '9KSPCGRAP7A385732',
// 	Vehicle: 2048139894,
// 	Value: false,
// 	Type: 0,
// 	Model: 'Corvette',
// 	FirstSpawn: false,
// 	DamagedParts: {
// 		Radiator: 87.411,
// 		Electronics: 94.405,
// 		Clutch: 91.607,
// 		Axle: 97.804,
// 		Brakes: 88.81,
// 		Transmission: 98.434,
// 		FuelInjectors: 95.803,
// 	},
// 	Mileage: 322.6,
// 	Damage: {
// 		Engine: 1000,
// 		Body: 991,
// 	},
// })

//const testVehicles = Array();

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const cars = useSelector((state) => state.data.data.myVehicles);

	const [loading, setLoading] = useState(false);

	const fetch = useMemo(
		() =>
			throttle(async () => {
				if (loading) return;
				setLoading(true);
				try {
					let res = await (await Nui.send('Garage:GetCars')).json();
					if (res) {
						dispatch({
							type: 'SET_DATA',
							payload: {
								type: 'myVehicles',
								data: res,
							},
						});
					} else {
						dispatch({
							type: 'SET_DATA',
							payload: {
								type: 'myVehicles',
								data: Array(),
							},
						});
					}
				} catch (err) {
					console.log(err);
					dispatch({
						type: 'SET_DATA',
						payload: {
							type: 'myVehicles',
							data: testVehicles,
						},
					});
				}
				setLoading(false);
			}, 1000),
		[],
	);

	useEffect(() => {
		fetch();
	}, []);

	return (
		<div className={classes.wrapper}>
			<AppBar position="static" className={classes.header}>
				<Grid container>
					<Grid item xs={7} style={{ lineHeight: '50px' }}>
						Garage
					</Grid>
					<Grid item xs={5} style={{ textAlign: 'right' }}>
						<Tooltip title="Refresh Garage">
							<span>
								<IconButton
									onClick={fetch}
									disabled={loading}
									className={classes.headerAction}
								>
									<FontAwesomeIcon
										className={`fa ${
											loading ? 'fa-spin' : ''
										}`}
										icon={['fas', 'arrows-rotate']}
									/>
								</IconButton>
							</span>
						</Tooltip>
					</Grid>
				</Grid>
			</AppBar>
			{loading && <Loader static text="Loading Garage" />}
			<List className={classes.list}>
				{cars.map((vehicle, k) => {
					return <Vehicle key={vehicle.VIN} vehicle={vehicle} />;
				})}
			</List>
		</div>
	);
};
