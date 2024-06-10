import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import { TextField, Grid } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';

import { useMyApps } from '../../hooks';
import App from './App';
import banner from '../../banner.png';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	search: {
		height: '10%',
	},
	searchInput: {
		width: '100%',
		height: '100%',
	},
	appList: {
		maxHeight: '90%',
		padding: '0 10px',
	},
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
}));

export default (props) => {
	const classes = useStyles();
	const apps = useMyApps();
	const installed = useSelector(
		(state) => state.data.data.player?.Apps?.installed,
	);

	const [searchVal, setSearchVal] = useState('');
	const onSearchChange = (e) => {
		setSearchVal(e.target.value);
	};

	const [available, setAvailable] = useState(Array());
	useEffect(() => {
		setAvailable(
			Object.keys(apps)
				.filter(
					(k) =>
						!apps[k].hidden &&
						(apps[k].label
							.toUpperCase()
							.includes(searchVal.toUpperCase()) ||
							searchVal === '') &&
						!installed.includes(k),
				)
				.map((k) => apps[k]),
		);
	}, [searchVal]);

	return (
		<div className={classes.wrapper}>
			<img className={classes.phoneImg} src={banner} />
			<div className={classes.search}>
				<TextField
					variant="standard"
					className={classes.searchInput}
					label="Search For App"
					value={searchVal}
					onChange={onSearchChange}
				/>
			</div>
			<Grid
				className={classes.appList}
				container
				spacing={2}
				justify="flex-start"
			>
				{available.length > 0 ? (
					available.map((app, i) => {
						return <App key={app.name} app={app} />;
					})
				) : (
					<div className={classes.emptyMsg}>
						No Apps Available To Download
					</div>
				)}
			</Grid>
		</div>
	);
};
