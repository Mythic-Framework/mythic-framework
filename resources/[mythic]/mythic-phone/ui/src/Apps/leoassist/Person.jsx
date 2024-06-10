import React, { useState, useMemo, useEffect } from 'react';
import { connect, useDispatch, useSelector } from 'react-redux';
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

import { Loader } from '../../components';
import Nui from '../../util/Nui';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

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

const testPeoples = Array({
	First: 'Test',
	Last: 'Test',
	Phone: '555-555-5555',
	DOB: '11/18/1994',
	Origin: 'USA',
	Gender: 0,
	Job: {
		job: 'police',
		grade: {
			level: 7,
			id: 'lspd_chief',
			label: 'Chief',
		},
		workplace: {
			id: 1,
			label: 'Los Santos Police Department',
		},
		label: 'Police',
		salary: 700,
	},
	Warrant: null,
	Licenses: {
		Drivers: {
			Active: true,
			Points: 0,
		},
		Hunting: {
			Active: true,
		},
		Fishing: {
			Active: true,
		},
	},
});

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const search = useSelector((state) => state.leo.personSearch);

	const [searched, setSearched] = useState(false);
	const [loading, setLoading] = useState(false);
	const [expanded, setExpanded] = useState(null);

	const onSearchChange = (e) => {
		dispatch({
			type: 'SEARCH_VAL_CHANGE',
			payload: {
				type: 'person',
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
						await Nui.send('SearchPeople', value)
					).json();
					dispatch({
						type: 'SEARCH_RESULTS',
						payload: {
							type: 'person',
							results: res,
						},
					});
					setLoading(false);
					setSearched(true);
				} catch (err) {
					dispatch({
						type: 'SEARCH_RESULTS',
						payload: {
							type: 'person',
							results: testPeoples,
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
						label="Search Name"
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
					search.results.map((p, k) => {
						return (
							<Accordion
								key={`person-${k}`}
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
										{`${p.First} ${p.Last}`}
									</Typography>
								</AccordionSummary>
								<AccordionDetails>
									<List>
										<ListItem>
											<ListItemText
												primary="Name"
												secondary={`${p.First} ${p.Last}`}
											/>
										</ListItem>
										<ListItem>
											<ListItemText
												primary="Sex"
												secondary={
													p.Gender ? 'Female' : 'Male'
												}
											/>
										</ListItem>
										<ListItem>
											<ListItemText
												primary="Date of Birth"
												secondary={p.DOB}
											/>
										</ListItem>
										<ListItem>
											<ListItemText
												primary="Nationality"
												secondary={p.Origin.label}
											/>
										</ListItem>
										<ListItem>
											<ListItemText
												primary="Phone Number"
												secondary={p.Phone}
											/>
										</ListItem>
										<ListItem>
											<ListItemText
												primary="Drivers License"
												secondary={`Active: ${
													p.Licenses?.Drivers?.Active
														? 'True'
														: 'False'
												}, Points: ${
													p?.Licenses?.Drivers?.Points
												}`}
											/>
										</ListItem>
										<ListItem>
											<ListItemText
												primary="Weapons Permit"
												secondary={`Active: ${
													p?.Licenses?.Gun?.Active
														? 'True'
														: 'False'
												}`}
											/>
										</ListItem>
										<ListItem>
											<ListItemText
												primary="Hunting License"
												secondary={`Active: ${
													p?.Licenses?.Hunting?.Active
														? 'True'
														: 'False'
												}`}
											/>
										</ListItem>
										<ListItem>
											<ListItemText
												primary="Fishing License"
												secondary={`Active: ${
													p?.Licenses?.Fishing?.Active
														? 'True'
														: 'False'
												}`}
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
