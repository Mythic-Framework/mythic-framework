import React, { useState, useMemo, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import {
	TextField,
	Accordion,
	AccordionDetails,
	AccordionSummary,
	Typography,
	List,
	ListItem,
	ListItemText,
	InputAdornment,
	IconButton,
	Alert,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { debounce } from 'lodash';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { Loader } from '../../components';
import Nui from '../../util/Nui';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		padding: 10,
	},
	content: {
		padding: 10,
	},
	item: {
		background: theme.palette.secondary.dark,
	},
	positive: {
		color: theme.palette.success.main,
		fontWeight: 'bold',
	},
	positive: {
		color: theme.palette.error.main,
		fontWeight: 'bold',
	},
}));

const testProperties = Array();

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const search = useSelector((state) => state.leo.propertySearch);

	const [searched, setSearched] = useState(false);
	const [loading, setLoading] = useState(false);
	const [expanded, setExpanded] = useState(null);

	const onSearchChange = (e) => {
		dispatch({
			type: 'SEARCH_VAL_CHANGE',
			payload: {
				type: 'property',
				term: e.target.value,
			},
		});
		setSearched(false);
	};

	const onSearch = (e) => {
		e.preventDefault();
		setLoading(true);
		fetch(search.term);
	};

	const fetch = useMemo(
		() =>
			debounce(async (value) => {
				try {
					let res = await (
						await Nui.send('SearchProperty', value)
					).json();
					dispatch({
						type: 'SEARCH_RESULTS',
						payload: {
							type: 'property',
							results: res,
						},
					});
					setLoading(false);
					setSearched(true);
				} catch (err) {
					dispatch({
						type: 'SEARCH_RESULTS',
						payload: {
							type: 'property',
							results: testProperties,
						},
					});
					setLoading(false);
					setSearched(true);
				}
			}, 1000),
		[],
	);

	useEffect(() => {
		return () => {
			fetch.cancel();
		};
	}, []);

	return (
		<div className={classes.wrapper}>
			<div className={classes.searchField}>
				<form onSubmit={onSearch}>
					<TextField
						required
						fullWidth
						value={search.term}
						onChange={onSearchChange}
						label="Search Property"
						InputProps={{
							endAdornment: (
								<InputAdornment position="end">
									<IconButton type="submit">
										<FontAwesomeIcon
											icon={['fas', 'search']}
										/>
									</IconButton>
								</InputAdornment>
							),
						}}
					/>
				</form>
			</div>
			<div className={classes.content}>
				{loading ? (
					<Loader text="Loading" />
				) : search.results.length > 0 ? (
					search.results.map((v, k) => {
						return (
							<Accordion
								key={`property-${k}`}
								className={classes.item}
								expanded={expanded === k}
								onChange={
									expanded === k
										? () => setExpanded(null)
										: () => setExpanded(k)
								}
							>
								<AccordionSummary
									expandIcon={
										<FontAwesomeIcon
											icon={['fas', 'chevron-down']}
										/>
									}
								>
									<Typography className={classes.heading}>
										{v.label}
									</Typography>
								</AccordionSummary>
								<AccordionDetails>
									<List>
										<ListItem>
											<ListItemText
												primary="Address"
												secondary={p.label}
											/>
										</ListItem>
										<ListItem>
											<ListItemText
												primary="Sold"
												secondary={
													p.sold ? 'Yes' : 'No'
												}
											/>
										</ListItem>
										<ListItem>
											<ListItemText
												primary="Registered Owner"
												secondary={
													p.owner
														? p.owner
														: 'No Owner'
												}
											/>
										</ListItem>
									</List>
								</AccordionDetails>
							</Accordion>
						);
					})
				) : searched ? (
					<Alert variant="filled" severity="error">
						No Search Results
					</Alert>
				) : null}
			</div>
		</div>
	);
};
