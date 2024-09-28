import React, { useEffect, useState, useRef } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';
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
import Nui from '../../util/Nui';

import Window from '../../components/Window';
import { Loader } from '../../components';
import { useAlert } from '../../hooks';

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
	bold: {
		'& span': {
			fontWeight: 700,
		}
	}
}));

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const alert = useAlert();

	const myGroup = useSelector((state) => state.data.data.myGroup);

	const timer = useRef(null);
	const interval = useRef(null);
	const [loading, setLoading] = useState(false);
	const [teams, setTeams] = useState(Array());
	const [cooldown, setCooldown] = useState(false);

	useEffect(() => {
		onRefresh();

		interval.current = setInterval(() => {
			onRefresh();
		}, 120000);

		return () => {
			if (timer?.current) clearTimeout(timer.current);
			if (interval?.current) clearInterval(interval.current);
		}
	}, []);

	const onRefresh = async () => {
		try {
			setLoading(true);
			let res = await (await Nui.send('GetTeams')).json();

			setTeams(res);
		} catch (err) {
			setTeams([
				{
					Name: 'Dick',
					ID: 1,
					Members: Array(
						{
							Leader: true,
							SID: 1,
							First: 'Testy',
							Last: 'McTest',
						},
					),
					State: 0,
				},
			]);

			console.log(err);
		}

		setLoading(false);
	};

	const onRequestInvite = async (team) => {
		try {
			setLoading(true);
			setCooldown(true);
			let res = await (await Nui.send('RequestTeamInvite', team)).json();

			if (res) {
				alert('Invite Requested');
			} else {
				alert('Invite Request Failed');
			}

		} catch (err) {
			console.log(err);
		}

		timer.current = setTimeout(() => setCooldown(false), 20000);
		setLoading(false);
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
											key={`actv-team-${team.ID}`}
										>
											<ListItemText
												className={myGroup?.ID == team?.ID ? classes.bold : null}
												primary={team.Name}
											/>
											<ListItemSecondaryAction>
												{!Boolean(myGroup) && (
													<Tooltip title="Request To Join">
														<span>
															<IconButton
																edge="end"
																onClick={() => onRequestInvite(team.ID)}
																disabled={cooldown || team.Members?.length >= 5}
																className={classes.actionBtn}
															>
																<FontAwesomeIcon
																	icon={[
																		'fas',
																		'user-plus',
																	]}
																/>
															</IconButton>
														</span>
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
