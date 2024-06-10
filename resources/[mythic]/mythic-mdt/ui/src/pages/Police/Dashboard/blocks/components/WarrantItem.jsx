import React from 'react';
import { useDispatch } from 'react-redux';
import {
	Avatar,
	ListItem,
	ListItemAvatar,
	ListItemText,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { toast } from 'react-toastify';
import Moment from 'react-moment';
import Truncate from '@nosferatu500/react-truncate';
import { Link } from 'react-router-dom';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		userSelect: 'none',
		transition: 'background ease-in 0.15s',
		'&:hover': {
			cursor: 'pointer',
			background: theme.palette.secondary.dark,
		},
	},
	time: {
		fontSize: 14,
		color: theme.palette.text.alt,
	},
}));

export default ({ warrant }) => {
	const classes = useStyles();
	const dispatch = useDispatch();

	return (
		<>
			<ListItem
				button
				className={classes.wrapper}
				component={Link}
				to={`/warrants/${warrant._id}`}
			>
				<ListItemAvatar>
					<Avatar
						src={warrant.suspect.Mugshot}
						alt={warrant.suspect.First}
					/>
				</ListItemAvatar>
				<ListItemText
					primary={
						<Truncate
							lines={1}
						>{`${warrant.suspect.First} ${warrant.suspect.Last}`}</Truncate>
					}
					secondary={
						<Truncate lines={1}>
							Expires:{' '}
							<Moment
								date={warrant.expires}
								fromNow
								withTitle
								titleFormat="LLLL"
								interval={60000}
							/>
						</Truncate>
					}
				/>
			</ListItem>
		</>
	);
};
