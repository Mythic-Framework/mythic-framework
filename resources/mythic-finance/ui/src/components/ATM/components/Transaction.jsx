import React, { useState } from 'react';
import { makeStyles } from '@material-ui/styles';
import {
	List,
	ListItem,
	ListItemText,
	ListItemAvatar,
	Avatar,
    Grid,
} from '@material-ui/core';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Moment from 'react-moment';

import { Modal } from '../../';
import { CurrencyFormat } from '../../../util/Parser';

const useStyles = makeStyles((theme) => ({
	trans: {
		background: theme.palette.info.main,
		'&.transfer': {
			background: theme.palette.warning.main,
		},
		'&.withdraw': {
			color: theme.palette.text.main,
			background: theme.palette.error.main,
		},
		'&.deposit': {
			background: theme.palette.success.main,
		},
		'&.fine': {
			color: theme.palette.text.main,
			background: theme.palette.error.main,
		},
	},
	money: {
		color: theme.palette.success.main,
	},
	type: {
		textTransform: 'capitilize',
	},
}));

export default ({ transaction }) => {
	const classes = useStyles();

	const [viewing, setViewing] = useState(false);

	const getTransIcon = () => {
		switch (transaction.Type) {
			case 'transfer':
				return <FontAwesomeIcon icon={['fas', 'right-left']} />;
			case 'withdraw':
				return <FontAwesomeIcon icon={['fas', 'minus']} />;
			case 'deposit':
				return <FontAwesomeIcon icon={['fas', 'plus']} />;
			case 'fine':
				return <FontAwesomeIcon icon={['fas', 'ticket']} />;
			default:
				return <FontAwesomeIcon icon={['fas', 'question']} />;
		}
	};

	return (
		<>
			<ListItem button onClick={() => setViewing(true)}>
				<Grid container>
					<Grid item xs={2}>
						<ListItemAvatar>
							<Avatar
								className={`${classes.trans} ${transaction.Type}`}
							>
								{getTransIcon()}
							</Avatar>
						</ListItemAvatar>
					</Grid>
					<Grid item xs={2}>
						<ListItemText
							primary="Title"
							secondary={transaction.Title}
						/>
					</Grid>
					<Grid item xs={2}>
						<ListItemText
							primary="Date"
							secondary={
								<Moment
									date={transaction.Timestamp * 1000}
									format="LLLL"
								/>
							}
						/>
					</Grid>
					<Grid item xs={2}>
						<ListItemText
							primary="Amount"
							secondary={
								<span className={classes.money}>
									{CurrencyFormat.format(transaction.Amount)}
								</span>
							}
						/>
					</Grid>
					<Grid item xs={4}>
                        <ListItemText
                            primary="Description"
                            secondary={transaction.Description}
                        />
					</Grid>
				</Grid>
			</ListItem>
			<Modal
				open={viewing}
				title="Transaction Details"
				closeLang="Close"
				onClose={() => setViewing(false)}
			>
				<List>
					<ListItem>
						<ListItemText
							primary="Transaction Title"
							secondary={transaction.Title}
						/>
					</ListItem>
					<ListItem>
						<ListItemText
							primary="Transaction Type"
							secondary={
								<span className={classes.type}>
									{transaction.Type}
								</span>
							}
						/>
					</ListItem>
					<ListItem>
						<ListItemText
							primary="Transaction Description"
							secondary={transaction.Description}
						/>
					</ListItem>
					<ListItem>
						<ListItemText
							primary="Transaction Date"
							secondary={
								<Moment
									date={transaction.Timestamp * 1000}
									format="LLLL"
								/>
							}
						/>
					</ListItem>
					<ListItem>
						<ListItemText
							primary="Transaction Amount"
							secondary={
								<span className={classes.money}>
									{CurrencyFormat.format(transaction.Amount)}
								</span>
							}
						/>
					</ListItem>
				</List>
			</Modal>
		</>
	);
};
