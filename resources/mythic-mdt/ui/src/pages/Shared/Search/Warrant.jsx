import React, { useEffect, useState } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import {
	TextField,
	InputAdornment,
	IconButton,
	Pagination,
	List,
	Alert,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import qs from 'qs';
import { useNavigate, useLocation } from 'react-router';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Nui from '../../../util/Nui';
import { Loader } from '../../../components';
import Item from './components/Warrant';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '20px 10px 20px 20px',
		height: '100%',
	},
	search: {
		height: '10%',
	},
	results: {
		height: '90%',
	},
	items: {
		maxHeight: '95%',
		height: '95%',
		overflowY: 'auto',
		overflowX: 'hidden',
	},
	myReports: {
		height: '100%',
	},
}));

export default () => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const history = useNavigate();
	const location = useLocation();
	const type = 'warrant';
	const PER_PAGE = 6;
	const _ws = useSelector((state) => state.data.data.warrants);
	const searchTerm = useSelector((state) => state.search.searchTerms[type]);
	let qry = qs.parse(location.search.slice(1));

	const [err, setErr] = useState(false);
	const [loading, setLoading] = useState(false);
	const [searched, setSearched] = useState(null);
	const [pages, setPages] = useState(1);
	const [page, setPage] = useState(qry.page ? +qry.page : 1);
	const [results, setResults] = useState(Array());

	useEffect(() => {
		setSearched('');
		fetch('');
	}, []);

	useEffect(() => {
		if (qry.search) {
			dispatch({
				type: 'UPDATE_SEARCH_TERM',
				payload: {
					type: type,
					term: qry.search,
				},
			});
			setSearched(qry.search);
			fetch(qry.search);
		} else fetch(searchTerm);
	}, []);

	useEffect(() => {
		setPages(Math.ceil(results.length / PER_PAGE));
	}, [results]);

	const fetch = async (value) => {
		if (value == '') {
			let s = qs.parse(location.search.slice(1));
			delete s.search;
			delete s.page;
			history({
				path: location.pathname,
				search: qs.stringify(s),
			});
			// setResults(_ws);
		} else {
			let s = qs.parse(location.search.slice(1));
			s.search = value;
			history({
				path: location.pathname,
				search: qs.stringify(s),
			});
			// let rgx = new RegExp(value, 'i');
			// setResults(
			// 	_ws.filter((w) =>
			// 		Boolean(`${w.suspect.First} ${w.suspect.Last}`.match(rgx)),
			// 	),
			// );
		}

		setLoading(true);
		setPage(1);
		setErr(false);

		try {
			let res = await (
				await Nui.send('Search', {
					type: type,
					term: value,
				})
			).json();
			if (res) {
				setResults(res);
			} else throw res;

			setLoading(false);
		} catch (err) {
			console.log(err);
			setErr(true);
			setResults([]);
			setLoading(false);
		}
	};

	const onSearch = (e) => {
		e.preventDefault();
		if (searched == searchTerm) return;
		setSearched(searchTerm);
		if (e.target.search.value == '') {
			let s = qs.parse(location.search.slice(1));
			delete s.search;
			delete s.page;
			history({
				path: location.pathname,
				search: qs.stringify(s),
			});
			dispatch({
				type: 'CLEAR_SEARCH',
				payload: { type },
			});
			setResults(Array());
		} else {
			fetch(e.target.search.value);
		}
	};

	const onSearchChange = (e) => {
		dispatch({
			type: 'UPDATE_SEARCH_TERM',
			payload: {
				type: type,
				term: e.target.value,
			},
		});
	};

	const onClear = () => {
		let s = qs.parse(location.search.slice(1));
		delete s.search;
		delete s.page;
		history({
			path: location.pathname,
			search: qs.stringify(s),
		});
		dispatch({
			type: 'CLEAR_SEARCH',
			payload: { type },
		});
		fetch('');
	};

	const onPagi = (e, p) => {
		let s = qs.parse(location.search.slice(1));
		s.page = p;
		history({
			path: location.pathname,
			search: qs.stringify(s),
		});
		setPage(p);
	};

	return (
		<div className={classes.wrapper}>
			<div className={classes.search}>
				<form onSubmitCapture={onSearch}>
					<TextField
						fullWidth
						variant="outlined"
						name="search"
						value={searchTerm}
						onChange={onSearchChange}
						label="Search Suspect Name or Warrant Number"
						InputProps={{
							endAdornment: (
								<InputAdornment position="end">
									{searchTerm != '' && (
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
										disabled={
											searchTerm == '' ||
											searched == searchTerm
										}
									>
										<FontAwesomeIcon
											icon={['fas', 'magnifying-glass']}
										/>
									</IconButton>
								</InputAdornment>
							),
						}}
					/>
				</form>
			</div>
			<div className={classes.results}>
			{loading ? (
					<Loader text="Loading" />
				) : results?.length > 0 ? (
					<>
						<List className={classes.items}>
							{results
								.sort((a, b) => a.state.localeCompare(b.state))
								.slice((page - 1) * PER_PAGE, page * PER_PAGE)
								.map((result) => {
									return (
										<Item
											key={result._id}
											warrant={result}
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
				) : (
					searchTerm == searched && (
						<Alert variant="filled" severity="error">
							No Matching Results
						</Alert>
					)
				)}
			</div>
		</div>
	);
};
