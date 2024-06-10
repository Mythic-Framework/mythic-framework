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
import qs from 'qs';
import { useNavigate, useLocation } from 'react-router';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { usePermissions } from '../../../hooks';

import Nui from '../../../util/Nui';
import { Loader } from '../../../components';
import Item from './components/Report';
import Tags from '../Create/components/Tags';

import { ReportTypes } from '../../../data';

import {Report} from './testdata';

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
	const dispatch = useDispatch();
	const hasPermission = usePermissions();
	const history = useNavigate();
	const location = useLocation();
	const type = 'report-evidence';
	const PER_PAGE = 6;
	const availableTags = useSelector(state => state.data.data.tags);
	const searchTerm = useSelector((state) => state.search.searchTerms[type]);
	let qry = qs.parse(location.search.slice(1));

	const [searched, setSearched] = useState(null);
	const [pages, setPages] = useState(1);
	const [page, setPage] = useState(qry.page ? +qry.page : 1);
	const [loading, setLoading] = useState(false);
	const [err, setErr] = useState(false);
	const [results, setResults] = useState(Array());

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
			fetch(qry.search, false, []);
		} else if (searchTerm && searchTerm != '') {
			fetch(searchTerm);
		}
	}, []);

	// useEffect(() => {
	// 	console.log('here')
	// 	fetch(searched);
	// }, [tags])

	useEffect(() => {
		setPages(Math.ceil(results.length / PER_PAGE));
	}, [results]);

	const fetch = useMemo(() => throttle(async (value, rType, rTags) => {
		let s = qs.parse(location.search.slice(1));
		s.search = value;
		history({
			path: location.pathname,
			search: qs.stringify(s),
		});

		setLoading(true);
		setPage(1);

		try {
			let res = await (
				await Nui.send('Search', {
					type: type,
					term: value,
				})
			).json();
			if (res) {
				const filteredResults = res?.filter(report => {
					const invalidPermission = report.tags?.some(t => {
						const tag = availableTags.find(tag => tag._id == t);
						if (tag.restrictViewing && !hasPermission(tag.requiredPermission)) {
							return true;
						}
					});

					let hasTypePermissions = !rType;
					if (rType) {
						const reportTypeData = ReportTypes.find(r => r.value == report.type);
						hasTypePermissions = hasPermission(reportTypeData?.requiredViewPermission);
					};
			
					return (!invalidPermission && hasTypePermissions);
				}).sort((a, b) => b.time - a.time);

				setResults(filteredResults);
			} else throw res;
			setLoading(false);
		} catch (err) {
			console.log(err);
			setErr(true);
			setResults(Report);
			setLoading(false);
		}
	}, 3000), []);

	const onSearch = (e) => {
		e.preventDefault();
		setSearched(searchTerm);
		fetch(searchTerm);
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

		setResults(Array());
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
					<Grid container spacing={1}>
						<Grid item xs={12}>
							<TextField
								fullWidth
								variant="outlined"
								name="search"
								value={searchTerm}
								onChange={onSearchChange}
								error={err}
								helperText={err ? 'Error Performing Search' : null}
								label="Search Reports By Evidence Identifier"
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
