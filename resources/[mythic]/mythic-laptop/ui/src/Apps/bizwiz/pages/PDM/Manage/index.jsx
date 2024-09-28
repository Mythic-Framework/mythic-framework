import React, { useEffect, useMemo, useState } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import {
	Grid,
	TextField,
	InputAdornment,
	IconButton,
	List,
	Button,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { throttle } from 'lodash';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Nui from '../../../../../util/Nui';
import { Loader } from '../../../../../components';

import Item from './Item';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '20px 10px 20px 20px',
		height: '100%',
	},
	search: {
		//height: '10%',
	},
	results: {
		//height: '65%',
	},
	noResults: {
		margin: '15% 0',
		textAlign: 'center',
		fontSize: 22,
		color: theme.palette.text.main,
	},
	items: {
		maxHeight: '95%',
		height: '95%',
		overflowY: 'auto',
		overflowX: 'hidden',
	},
	searchButton: {
		height: '90%',
		// marginBottom: 10,
	},
}));

export default () => {
	const classes = useStyles();

	const [loading, setLoading] = useState(false);
	const [err, setErr] = useState(false);
	const [results, setResults] = useState(null);

	const fetch = async () => {
		setLoading(true);

		try {
			let res = await (await Nui.send('PDMGetDealerData', {})).json();
			if (res) {
				setResults(res);
			} else throw res;
			setLoading(false);
		} catch (err) {
			console.log(err);
			setErr(true);
			//setResults(null);
			setResults({
				profitPercentage: 15,
				commission: 15,
			});
			setLoading(false);
		}
	};

	const onSave = async () => {
		setLoading(true);

		try {
			let res = await (
				await Nui.send('PDMSaveDealerData', {
					data: results,
				})
			).json();
			if (res) {
				setResults(res);
			} else throw res;
			setLoading(false);
		} catch (err) {
			console.log(err);
			setLoading(false);
		}
	};

	useEffect(() => {
		fetch();
	}, []);

	return (
		<div className={classes.wrapper}>
			<div className={classes.search}>
				<Grid container spacing={1}>
					<Grid item xs={12}>
						<Button
							variant="outlined"
							fullWidth
							style={{ height: '100%' }}
							onClick={onSave}
						>
							Save Changes
						</Button>
					</Grid>
				</Grid>
			</div>
			<div className={classes.results}>
				{loading ? (
					<Loader text="Loading" />
				) : results ? (
					<>
						<List className={classes.items}>
							<Item
								name={'Dealership Profit %'}
								min={5}
								max={15}
								current={results.profitPercentage}
								onChange={(e) =>
									setResults({
										...results,
										profitPercentage: e.target.value,
									})
								}
							/>
							<Item
								name={'Employee Earned Commission %'}
								min={5}
								max={15}
								current={results.commission}
								onChange={(e) =>
									setResults({
										...results,
										commission: e.target.value,
									})
								}
							/>
						</List>
					</>
				) : (
					<p className={classes.noResults}>No Results Found</p>
				)}
			</div>
		</div>
	);
};
