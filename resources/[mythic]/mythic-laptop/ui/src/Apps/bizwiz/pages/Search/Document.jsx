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

import Item from './components/Document';

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

export default ({ onNav }) => {
	const classes = useStyles();
	const dispatch = useDispatch();

	const PER_PAGE = 6;

    const [searched, setSearched] = useState('');
	const [pages, setPages] = useState(1);
	const [page, setPage] = useState(1);
	const [loading, setLoading] = useState(false);
	const [err, setErr] = useState(false);
	const [results, setResults] = useState(Array());

	useEffect(() => {
		setPages(Math.ceil(results.length / PER_PAGE));
	}, [results]);

	const fetch = useMemo(() => throttle(async (value) => {
		setLoading(true);
		setPage(1);

		try {
			let res = await (
				await Nui.send('BusinessDocumentSearch', {
					term: value,
				})
			).json();
			if (res) {
				const filteredResults = res?.sort((a, b) => b.time - a.time).sort((a, b) => Number(b.pinned) - Number(a.pinned));

				setResults(filteredResults);
			} else throw res;
			setLoading(false);
		} catch (err) {
			console.log(err);
			setErr(true);
			setResults({
                _id: 1,
            });
			setLoading(false);
		}
	}, 3000), []);

	useEffect(() => {
		fetch('');
	}, []);

	const onSearch = (e) => {
		e.preventDefault();
		fetch(searched);
	};

	const onSearchChange = (e) => {
        setSearched(e.target.value)
	};

	const onClear = () => {
		setResults(Array());
	};

	const onPagi = (e, p) => {
		setPage(p);
	};

	const onCreate = () => {
        onNav('Create/Document');
	};

	return (
		<div className={classes.wrapper}>
			<div className={classes.search}>
				<form onSubmitCapture={onSearch}>
					<Grid container spacing={1}>
						<Grid item xs={10}>
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
						<Grid item xs={2}>
							<Button
								variant="outlined"
								fullWidth
								style={{ height: '100%' }}
								onClick={onCreate}
							>
								Create
							</Button>
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
                                            onNav={onNav}
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
