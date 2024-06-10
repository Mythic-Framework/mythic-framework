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
	Tooltip,
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
			marginLeft: 10,
		},
	},
}));

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const history = useHistory();

	const myGroup = useSelector((state) => state.data.data.myGroup);

	const [loading, setLoading] = useState(false);
	const [teams, setTeams] = useState(Array());

	useEffect(() => {
		onRefresh();
	}, []);

	const onRefresh = async () => {
		try {
			setLoading(true);
			let res = await Nui.send('GetTeams');
			setTeams(res);
			setTeams([
				{
					Owner: {
						SID: 1,
						First: 'Testy',
						Last: 'McTest',
					},
					Members: Array(),
					State: 0,
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
					<h3 className={classes.heading}>Active Teams</h3>
				</Grid>
				<Grid item xs={12}>
					<List>
						{!loading ? (
							Boolean(teams) && teams.length > 0 ? (
								teams.map((team) => {
									return (
										<ListItem
											divider
											key={`actv-team-${team.Owner.SID}`}
										>
											<ListItemText
												primary={`${team.Owner.First} ${team.Owner.Last}`}
											/>
											<ListItemSecondaryAction>
												{!Boolean(myGroup) && (
													<Tooltip title="Request To Join">
														<IconButton
															edge="end"
															className={
																classes.actionBtn
															}
														>
															<FontAwesomeIcon
																icon={[
																	'fas',
																	'user-plus',
																]}
															/>
														</IconButton>
													</Tooltip>
												)}
											</ListItemSecondaryAction>
										</ListItem>
									);
								})
							) : (
								<ListItem>
									<ListItemText primary="No Available Teams" />
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
