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

import Nui from '../../../../util/Nui';
import { Loader } from '../../../../components';

import Item from './components/ReceiptCount';

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

const escapeRegex = (string) => {
    return string.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&');
}

export default () => {
	const classes = useStyles();
	const PER_PAGE = 6;

	const [pages, setPages] = useState(1);
	const [page, setPage] = useState(1);
	const [loading, setLoading] = useState(false);
	const [search, setSearch] = useState('');
	const [err, setErr] = useState(false);
	const [results, setResults] = useState(Array());
	const [filtered, setFiltered] = useState(Array());

	useEffect(() => {
		const escapedSearchTerm = escapeRegex(search ?? '');

		setFiltered(results.filter(s => new RegExp(escapedSearchTerm, 'i').test(`${s.char.First} ${s.char.Last}`)));
	}, [results, search]);

	useEffect(() => {
		setPages(Math.ceil(filtered.length / PER_PAGE));
	}, [filtered]);

	const fetch = useMemo(() => throttle(async () => {
		setLoading(true);
		setPage(1);

		try {
			let res = await (
				await Nui.send('BusinessReceiptSearch', {
					term: '',
				})
			).json();
			if (res) {
				let receiptCounts = {};

				res.sort((a, b) => a.time - b.time).forEach(receipt => {
					if (receipt?.author?.SID) {
						if (!receiptCounts[receipt.author.SID]) {
							receiptCounts[receipt.author.SID] = {
								created: 0,
								assisted: 0,
								char: receipt.author,
								latest: 0,
								types: {},
							}
						}

						receiptCounts[receipt.author.SID].created++
						receiptCounts[receipt.author.SID].latest = receipt.time;

						if (!receiptCounts[receipt.author.SID].types[receipt.type]) {
							receiptCounts[receipt.author.SID].types[receipt.type] = 1
						} else {
							receiptCounts[receipt.author.SID].types[receipt.type] ++
						}
					}

					if (receipt?.workers && receipt.workers.length > 0) {
						receipt.workers.forEach(worker => {
							if (!receiptCounts[worker.SID]) {
								receiptCounts[worker.SID] = {
									created: 0,
									assisted: 0,
									char: worker,
									latest: 0,
									types: {},
								}
							}

							receiptCounts[worker.SID].assisted++
							receiptCounts[worker.SID].latest = receipt.time;

							if (!receiptCounts[worker.SID].types[receipt.type]) {
								receiptCounts[worker.SID].types[receipt.type] = 1
							} else {
								receiptCounts[worker.SID].types[receipt.type] ++
							}
						});
					}
				});

				setResults(Object.values(receiptCounts));
			} else throw res;
			setLoading(false);
		} catch (err) {
			console.log(err);
			setErr(true);
			setLoading(false);
		}
	}, 3000), []);

	useEffect(() => {
		fetch();
	}, []);

	const onSearch = (e) => {
		e.preventDefault();
	};

	const onSearchChange = (e) => {
		setSearch(e.target.value);
	};

	const onPagi = (e, p) => {
		setPage(p);
	};

	return (
		<div className={classes.wrapper}>
			<div className={classes.search}>
				<Grid container spacing={1}>
					<Grid item xs={10}>
						<TextField
							fullWidth
							variant="outlined"
							name="search"
							value={search}
							onChange={onSearchChange}
							error={err}
							helperText={err ? 'Error Performing Search' : null}
							label="Search By Employee"
							InputProps={{
								endAdornment: (
									<InputAdornment position="end">
										{search != '' && (
											<IconButton
												type="button"
												onClick={() => setSearch('')}
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
					<Grid item xs={2}>
						<Button
							variant="outlined"
							fullWidth
							style={{ height: '100%' }}
							onClick={fetch}
						>
							Refresh
						</Button>
					</Grid>
				</Grid>
			</div>
			<div className={classes.results}>
				{loading ? (
					<Loader text="Loading" />
				) : filtered?.length > 0 ? (
					<>
						<List className={classes.items}>
							{filtered
								.slice((page - 1) * PER_PAGE, page * PER_PAGE)
								.map((result) => {
									return (
										<Item
											key={result._id}
											report={result}
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
		</div>
	);
};
