import React, { useEffect, useMemo, useState } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import {
	Grid,
	TextField,
	InputAdornment,
	IconButton,
	Pagination,
	List,
	Button,
	MenuItem,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { throttle } from 'lodash';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Nui from '../../../../../util/Nui';
import { Loader } from '../../../../../components';
import { useAlert } from '../../../../../hooks';

import Item from './components/Vehicle';
import { vehicleCategories } from './data';
import SaleForm from './SaleForm';
import OwnerForm from './OwnerForm';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '20px 10px 20px 20px',
		height: '100%',
	},
	search: {
		//height: '10%',
	},
	results: {
		//height: '',
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
	const alert = useAlert();
	const PER_PAGE = 6;

	const [searched, setSearched] = useState('');
	const [pages, setPages] = useState(1);
	const [page, setPage] = useState(1);
	const [loading, setLoading] = useState(false);
	const [err, setErr] = useState(false);
	const [results, setResults] = useState(Array());
	const [cat, setCat] = useState('all');

	const [sellingOpen, setSellingOpen] = useState(false);
	const [selling, setSelling] = useState(null);

	const [ownerViewOpen, setOwnerViewOpen] = useState(false);
	const [owner, setOwner] = useState(null);

	useEffect(() => {
		setResults(Array());
		setPages(1);

		fetch(searched, cat, 1);
	}, [cat, searched]);

	const fetch = useMemo(() => throttle(async (value, category, page) => {
		setLoading(true);
		setPage(page);

		try {
			let res = await (
				await Nui.send('PDMGetHistory', {
					value,
					category,
					page,
				})
			).json();

			if (res) {
				setResults(res.data);

				if (res.more) {
					setPages(page + 1);
				}
			} else throw res;
			setLoading(false);
		} catch (err) {
			console.log(err);
			setErr(true);

			setLoading(false);
		}
	}, 1500), []);

	useEffect(() => {
		fetch("", "all", 1);
	}, []);

	const onSearch = (e) => {
		e.preventDefault();
	};

	const onSearchChange = (e) => {
		setSearched(e.target.value);
	};

	const onClear = () => {
		setSearched('');
		setResults(Array());
	};

	const onPagi = (e, p) => {
		fetch(searched, cat, p);
	};

	const sellVehicle = (vehicle) => {
		setSelling(vehicle);
	};

	const lookupOwner = async (vin) => {
		setLoading(true);

		try {
			let res = await (
				await Nui.send('PDMGetOwner', { VIN: vin })
			).json();

			if (res) {
				setOwner(res);
				setOwnerViewOpen(true);
			} else throw res;
			setLoading(false);
		} catch (err) {
			console.log(err);
			alert('Error');

			setLoading(false);
		}
	};

	return (
		<div className={classes.wrapper}>
			<div className={classes.search}>
				<form onSubmitCapture={onSearch}>
					<Grid container spacing={1}>
						<Grid item xs={3}>
							<TextField
								select
								fullWidth
								label="Category"
								name="type"
								className={classes.editorField}
								value={cat}
								onChange={(e) => setCat(e.target.value)}
							>
								{vehicleCategories.map(option => (
									<MenuItem key={option.value} value={option.value}>
										{option.label}
									</MenuItem>
								))}
							</TextField>
						</Grid>
						<Grid item xs={9}>
							<TextField
								fullWidth
								variant="outlined"
								name="search"
								value={searched}
								onChange={onSearchChange}
								error={err}
								helperText={err ? 'Error Performing Search' : null}
								label="Search"
								InputProps={{
									endAdornment: (
										<InputAdornment position="end">
											{searched != '' && (
												<IconButton
													type="button"
													onClick={onClear}
												>
													<FontAwesomeIcon
														icon={['fas', 'xmark']}
													/>
												</IconButton>
											)}
											<IconButton
												type="submit"
												disabled={loading}
											>
												<FontAwesomeIcon
													icon={['fas', 'magnifying-glass']}
												/>
											</IconButton>
										</InputAdornment>
									),
								}}
							/>
						</Grid>
					</Grid>
				</form>
			</div>
			<div className={classes.results}>
				{loading ? (
					<Loader text="Loading" />
				) : results?.length > 0 ? (
					<>
						<List className={classes.items}>
							{results
								.sort((a, b) => b.time - a.time)
								.map((result) => {
									return (
										<Item
											key={result._id}
											vehicle={result}
											onClick={() => {
												setSellingOpen(true);
												sellVehicle(result);
											}}
											onSecondary={lookupOwner}
										/>
									);
								})}
						</List>
						{pages > 1 && (
							<Pagination
								variant="outlined"
								shape="rounded"
								color="primary"
								page={page}
								count={pages}
								onChange={onPagi}
							/>
						)}
					</>
				) : <p className={classes.noResults}>No Results Found</p>}
			</div>
			<SaleForm
				open={sellingOpen}
				vehicle={selling}
				onClose={() => setSellingOpen(false)}
				onSubmit={() => setSellingOpen(false)}
				dealerData={results.dealerData}
				interest={results.interest}
			/>
			<OwnerForm
				open={ownerViewOpen}
				vehicle={owner}
				onClose={() => setOwnerViewOpen(false)}
				onSubmit={() => setOwnerViewOpen(false)}
			/>
		</div>
	);
};
