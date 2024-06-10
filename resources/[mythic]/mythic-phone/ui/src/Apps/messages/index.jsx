import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import { useHistory } from 'react-router-dom';
import { Fab } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';

import { Modal } from '../../components';
import Message from './message';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		overflowY: 'auto',
		overflowX: 'hidden',
		'&::-webkit-scrollbar': {
			width: 6,
		},
		'&::-webkit-scrollbar-thumb': {
			background: '#ffffff52',
		},
		'&::-webkit-scrollbar-thumb:hover': {
			background: theme.palette.primary.main,
		},
		'&::-webkit-scrollbar-track': {
			background: 'transparent',
		},
	},
	add: {
		position: 'absolute',
		bottom: '12%',
		right: '10%',
		'&:hover': {
			filter: 'brightness(0.75)',
			transition: 'filter ease-in 0.15s',
		},
	},
	or: {
		fontSize: 40,
		color: theme.palette.primary.main,
		textAlign: 'center',
		fontWeight: 'bold',
	},
	contactList: {
		zIndex: '10001 !important',
		maxHeight: 400,
		'& div::-webkit-scrollbar': {
			width: 6,
		},
		'& div::-webkit-scrollbar-thumb': {
			background: '#ffffff52',
		},
		'& div::-webkit-scrollbar-thumb:hover': {
			background: theme.palette.primary.main,
		},
		'& div::-webkit-scrollbar-track': {
			background: 'transparent',
		},
	},
	contactListTrigger: {
		width: '100%',
		height: 60,
		background: 'red',
		textAlign: 'center',
	},
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
}));

export default (props) => {
	const classes = useStyles();
	const history = useHistory();
	const allMsgs = useSelector((state) => state.data.data.messages);
	const [convos, setConvos] = useState([]);

	useEffect(() => {
		let tConv = [];

		if (allMsgs.length > 0) {
			allMsgs
				.sort((a, b) => b.time - a.time)
				.map((message, i) => {
					if (tConv[message.number] != null) {
						if (message.time > tConv[message.number].time) {
							tConv[message.number] = message;
						}
					} else {
						tConv[message.number] = message;
					}
				});

			tConv.sort((a, b) => b.time - a.time);
		}

		setConvos(tConv);
	}, [allMsgs]);

	return (
		<div className={classes.wrapper}>
			{Object.keys(convos).length > 0 ? (
				Object.entries(convos).map(([key, convo]) => {
					return (
						<Message
							key={key}
							message={convo}
							unread={
								allMsgs.filter(
									(m) =>
										m.number === convo.number && m.unread,
								).length
							}
						/>
					);
				})
			) : (
				<div className={classes.emptyMsg}>You Have No Messages</div>
			)}
			<Fab
				className={classes.add}
				color="primary"
				onClick={() => history.push('/apps/messages/new')}
			>
				<FontAwesomeIcon icon={['fas', 'plus']} />
			</Fab>
		</div>
	);
};
