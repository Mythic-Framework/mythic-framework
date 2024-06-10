import React, { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';
import { useHistory } from 'react-router-dom';
import {
	Grid,
	IconButton,
	List,
	ListItem,
	ListItemText,
	ListItemSecondaryAction,
} from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { throttle } from 'lodash';
import Nui from '../../util/Nui';

import Window from '../../components/Window';
import { Loader } from '../../components';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	heading: {
		padding: 10,
		borderBottom: `1px solid ${theme.palette.border.divider}`,
	},
	actionBtn: {
		fontSize: 18,
		'&:not(:first-of-type)': {
			marginLeft: 15,
		},
	},
}));

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const history = useHistory();

	const myData = useSelector((state) => state.data.data.player);
	const myGroup = useSelector((state) => state.data.data.myGroup);

	const isLeader = myGroup?.Owner?.SID == myData.SID;

	const [loading, setLoading] = useState(false);
	const [requests, setRequests] = useState(Array());

	useEffect(() => {
		onRefresh();
	}, []);

	const onRefresh = async () => {
		try {
			setLoading(true);
			let res = await Nui.send('GetRequests');
			setRequests(res);

			setRequests([
				{
					id: 1,
					event: 'Laptop:Client:AcceptInvite',
					label: 'Group Invite',
					description: 'From Testy McTest',
					data: {
						SID: 2,
						Leader: 1,
					},
				},
				{
					id: 2,
					event: 'Laptop:Client:AcceptJob',
					label: 'Boosting Contract',
					description: 'Lamborghini Aventador (S+)',
					data: {
						Job: 'Boosting',
						Data: 'Retard',
					},
				},
			]);
			setLoading(false);
		} catch (err) {
			console.log(err);
		}
	};

	return (
		<Grid item xs={4} style={{ padding: 10 }}>
			<Grid container>
				<Grid item xs={12}>
					<h3 className={classes.heading}>Incoming Requests</h3>
				</Grid>
				<Grid item xs={12}>
					<List>
						{!loading ? (
							Boolean(requests) && requests.length > 0 ? (
								requests.map((request) => {
									return (
										<ListItem
											divider
											key={`request-${request.id}`}
										>
											<ListItemText
												primary={request.label}
												secondary={request.description}
											/>
											<ListItemSecondaryAction>
												{isLeader && (
													<IconButton
														edge="end"
														className={
															classes.actionBtn
														}
													>
														<FontAwesomeIcon
															icon={[
																'fas',
																'check',
															]}
														/>
													</IconButton>
												)}
												{isLeader && (
													<IconButton
														edge="end"
														className={
															classes.actionBtn
														}
													>
														<FontAwesomeIcon
															icon={['fas', 'x']}
														/>
													</IconButton>
												)}
											</ListItemSecondaryAction>
										</ListItem>
									);
								})
							) : (
								<ListItem>
									<ListItemText primary="No Pending Requests" />
								</ListItem>
							)
						) : (
							<Loader text="Loading" />
						)}
					</List>
				</Grid>
			</Grid>
		</Grid>
	);
};
