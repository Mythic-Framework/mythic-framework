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

export default ({ boardTitle = 'Notice Board' }) => {
	const classes = useStyles();
	const hasJob = useGovJob();
	const hasPerm = usePermissions();
	const notices = useSelector((state) => state.data.data.businessNotices);
	const PER_PAGE = 6;

	const [pages, setPages] = useState(notices.length / PER_PAGE);
	const [page, setPage] = useState(1);

	useEffect(() => {
		setPages(Math.ceil(notices.length / PER_PAGE));
		setPage(1);
	}, [notices]);

	const onPagi = (e, p) => {
		setPage(p);
	};

	return (
		<Grid item xs={12} className={classes.container}>
			<div className={classes.block}>
				<div className={classes.header}>
					{boardTitle}
					{hasPerm('TABLET_CREATE_NOTICE', false) && (
						<IconButton component={Link} to="business/create/notice" className={classes.create}>
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
