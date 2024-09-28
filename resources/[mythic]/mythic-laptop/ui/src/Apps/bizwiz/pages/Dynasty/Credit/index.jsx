import React, { useEffect, useMemo, useState } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import {
	Grid,
	TextField,
	InputAdornment,
	IconButton,
	List,
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

	const [loading, setLoading] = useState(false);
	const [err, setErr] = useState(false);
	const [results, setResults] = useState(null);

    const [searched, setSearched] = useState('');

	const fetch = useMemo(() => throttle(async (value) => {
		setLoading(true);

		try {
			let res = await (
				await Nui.send('Dyn8RunCredit', {
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
            setResults(null);
			// setResults({
            //     SID: 2,
            //     price: 10000,
            //     score: 180,
            //     name: 'John Doe'
            // });
			setLoading(false);
		}
	}, 3000), []);

	const onSearch = (e) => {
		e.preventDefault();
		fetch(searched);
	};

	const onSearchChange = (e) => {
        setSearched(e.target.value);
	};

	const onClear = () => {
		setResults(null);
        setSearched('');
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
				) : results ? (
					<>
						<List className={classes.items}>
                            <Item data={results} />
						</List>
					</>
				) : <p className={classes.noResults}>No Results Found</p>}
			</div>
		</div>
	);
};
