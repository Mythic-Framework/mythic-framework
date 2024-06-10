import React from 'react';
import { makeStyles } from '@material-ui/styles';
import {
	List,
	AppBar,
	Grid,
	Tooltip,
	IconButton,
} from '@material-ui/core';
import { useDispatch, useSelector } from 'react-redux';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		overflow: 'hidden',
	},
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
	list: {
		position: 'inherit',
	},
}));

import Upgrade from '../components/Upgrade';
import InteriorUpgrade from '../components/InteriorUpgrade';

export default ({ property, onRefresh, setLoading, myKey }) => {
	const classes = useStyles();
	const availableUpgrades = useSelector((state) => state.data.data.propertyUpgrades)[property.type];

	if (!myKey?.Permissions?.upgrade && !myKey?.Owner) {
		return (
			<div className={classes.wrapper}>
				<div className={classes.emptyMsg}>
					Invalid Permissions
				</div>
			</div>
		);
	} else {
		return (
			<div className={classes.wrapper}>
				{availableUpgrades ? (
					<List className={classes.list}>
						<InteriorUpgrade 
							property={property}
							upgrade={availableUpgrades.interior}
							setLoading={setLoading}
							onRefresh={onRefresh}
						/>
						{Object.keys(availableUpgrades).filter(u => u !== "interior").map(upgrade => {
							return (
								<Upgrade 
									key={`upgrade-${upgrade}`}
									property={property}
									type={upgrade}
									upgrade={availableUpgrades[upgrade]}
									setLoading={setLoading}
									onRefresh={onRefresh}
								/>
							);
						})}
					</List>
				) : (
					<div className={classes.emptyMsg}>No Property Upgrades Available</div>
				)}
			</div>
		);
	}
};
