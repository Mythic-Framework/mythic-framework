import React, { useEffect, useState, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';
import { ListItem, ListItemText } from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Moment from 'react-moment';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
}));

export default ({ order }) => {
	const classes = useStyles();
	const items = useSelector((state) => state.data.data.items);

	return (
		<ListItem divider className={classes.wrapper}>
			<ListItemText
				style={{ width: Boolean(order.team) ? '25%' : '33.333%' }}
				primary="Date"
				secondary={<Moment format="L" date={order.date} unix />}
			/>
			<ListItemText
				style={{ width: Boolean(order.team) ? '25%' : '33.333%' }}
				primary="Tier"
				secondary={order.tier}
			/>
			<ListItemText
				style={{ width: Boolean(order.team) ? '25%' : '33.333%' }}
				primary="Payment"
				secondary={
					<span>
						{order.payment.amount} ${order.payment.coin}
					</span>
				}
			/>
			{Boolean(order.team) && (
				<ListItemText
					style={{ width: '25%' }}
					primary="Team"
					secondary={order.team.name}
				/>
			)}
		</ListItem>
	);
};
