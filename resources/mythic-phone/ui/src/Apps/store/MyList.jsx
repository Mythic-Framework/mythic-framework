import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import { useHistory } from 'react-router-dom';
import { TextField, Grid } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';

import { useMyApps } from '../../hooks';
import App from './App';
import banner from '../../banner2.png';

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
	const history = useHistory();
	const apps = useMyApps();
	const installed = useSelector(
		(state) => state.data.data.player?.Apps?.installed,
	);

	const [searchVal, setSearchVal] = useState('');
	const onSearchChange = (e) => {
		setSearchVal(e.target.value);
	};

	const [filtered, setFiltered] = useState(Array());
	useEffect(() => {
		setFiltered(
			installed
				.filter(
					(k) =>
						apps[k]?.canUninstall &&
						(apps[k]?.label
							.toUpperCase()
							.includes(searchVal.toUpperCase()) ||
							searchVal === ''),
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
				{filtered.length > 0 ? (
					filtered.map((app) => {
						return (
							<App key={app.name} app={app} installed={true} />
						);
					})
				) : (
					<div className={classes.emptyMsg}>
						No Apps Available To Uninstall
					</div>
				)}
			</Grid>
		</div>
	);
};
