import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import { Alert, Grid, List, ListItem, IconButton, Pagination } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { Link } from 'react-router-dom';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { useGovJob, usePermissions } from '../../hooks';
import Item from './NBItem';

const useStyles = makeStyles((theme) => ({
	container: {
		padding: 10,
	},
	block: {
		padding: 10,
		background: theme.palette.secondary.main,
		border: `1px solid ${theme.palette.border.divider}`,
	},
	header: {
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		color: theme.palette.primary.main,
		fontSize: 18,
		marginBottom: 10,
		position: 'relative',
	},
	create: {
		float: 'right',
		fontSize: 16,
		height: 32,
		width: 32,
		position: 'absolute',
		top: 0,
		right: 0,
	},
}));

export default ({ boardTitle = 'Notice Board', perPage = 3 }) => {
	const classes = useStyles();
	const hasJob = useGovJob();
	const hasPerm = usePermissions();
	const myJob = useSelector((state) => state.app.govJob);
	const governmentJobs = useSelector((state) => state.data.data.governmentJobs);
	const notices = useSelector((state) => state.data.data.notices);
	const PER_PAGE = perPage;
	const [filtered, setFiltered] = useState(Array());
	const [pages, setPages] = useState(1);
	const [page, setPage] = useState(1);

	const isHighCommand = hasPerm('PD_HIGH_COMMAND') || hasPerm('SAFD_HIGH_COMMAND');

	useEffect(() => {
		setPages(Math.ceil(notices.length / PER_PAGE));
		setPage(1);
		setFiltered(
			filtered.filter(
				(n) =>
					!n.job ||
					(typeof n.job == 'boolean' && governmentJobs.includes(myJob?.Id)) ||
					hasJob(n.job, n.workplace) ||
					hasPerm(true),
			),
		);
	}, [notices]);

	useEffect(() => {
		setPages(Math.ceil(notices.length / PER_PAGE));
		setPage(1);
	}, [filtered]);

	const onPagi = (e, p) => {
		setPage(p);
	};

	return (
		<Grid item xs={12} className={classes.container}>
			<div className={classes.block}>
				<div className={classes.header}>
					{boardTitle}
					{isHighCommand && (
						<IconButton component={Link} to="create/notice" className={classes.create}>
							<FontAwesomeIcon icon={['fas', 'plus']} />
						</IconButton>
					)}
				</div>
				<List>
					{notices && notices.length > 0 ? (
						notices
							.slice((page - 1) * PER_PAGE, page * PER_PAGE)
							.sort((a, b) => b.time - a.time)
							.map((notice, k) => {
								return <Item key={`notices-${k}`} notice={notice} />;
							})
					) : (
						<ListItem>
							<Alert variant="outlined" severity="info">
								No Notices
							</Alert>
						</ListItem>
					)}
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
			</div>
		</Grid>
	);
};
