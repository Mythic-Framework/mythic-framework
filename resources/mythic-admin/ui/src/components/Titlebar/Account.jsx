import React from 'react';
import { useSelector } from 'react-redux';
import { makeStyles } from '@material-ui/styles';

const useStyles = makeStyles((theme) => ({
	callsign: {
		fontSize: 14,
		color: theme.palette.primary.main,
	},
}));

export default () => {
	const classes = useStyles();
	const user = useSelector((state) => state.app.user);
	const permissionName = useSelector(state => state.app.permissionName)

	return (
		<>
			<small>
				{permissionName ?? 'Staff'}
			</small>
			<span>
				{user?.Name} ({user?.AccountID})
			</span>
		</>
	);
};
