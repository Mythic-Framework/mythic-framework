import React, { useEffect, useState, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles, withStyles } from '@mui/styles';
import { useHistory } from 'react-router-dom';
import {
	AppBar,
	Grid,
	Button,
	List,
	ListItem,
	ListItemText,
	ListItemSecondaryAction,
	IconButton,
} from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { throttle } from 'lodash';

import Window from '../../components/Window';

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
	},
}));

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const history = useHistory();

	const myData = useSelector((state) => state.data.data.player);
	const myGroup = useSelector((state) => state.data.data.myGroup);

	return (
		<Grid item xs={4} style={{ padding: 10 }}>
			<Grid container>
				<Grid item xs={12}>
					<h3 className={classes.heading}>My Team</h3>
				</Grid>
				<Grid item xs={12}>
					{!Boolean(myGroup) ? (
						<Button>Create Team</Button>
					) : (
						<List>
							<ListItem divider>
								<ListItemText
									primary="State"
									secondary={myGroup.State}
								/>
							</ListItem>
							<ListItem divider>
								<ListItemText
									primary="Group Leader"
									secondary={`${myGroup.Owner.First} ${myGroup.Owner.Last}`}
								/>
							</ListItem>
							<ListItem divider>
								<ListItemText
									primary={`Group Members (${myGroup.Members.length})`}
								/>
								<ListItemSecondaryAction>
									{myGroup.Owner.SID == myData.SID &&
										myGroup.Members.length < 4 && (
											<IconButton
												edge="end"
												className={classes.actionBtn}
											>
												<FontAwesomeIcon
													icon={['fas', 'plus']}
												/>
											</IconButton>
										)}
								</ListItemSecondaryAction>
							</ListItem>
							<ListItem dense>
								<List dense style={{ width: '100%' }}>
									{myGroup.Members.filter(
										(m) => m.SID != myGroup.Owner.SID,
									).length > 0 ? (
										myGroup.Members.filter(
											(m) => m.SID != myGroup.Owner.SID,
										).map((member) => {
											return (
												<ListItem
													key={`member-${member.SID}`}
													divider
												>
													<ListItemText
														primary={`${member.First} ${member.Last} (${member.SID})`}
													/>
													<ListItemSecondaryAction>
														<IconButton
															edge="end"
															className={
																classes.actionBtn
															}
														>
															<FontAwesomeIcon
																icon={[
																	'fas',
																	'minus',
																]}
															/>
														</IconButton>
													</ListItemSecondaryAction>
												</ListItem>
											);
										})
									) : (
										<ListItem>
											<ListItemText primary="No Members In Team" />
										</ListItem>
									)}
								</List>
							</ListItem>
						</List>
					)}
				</Grid>
			</Grid>
		</Grid>
	);
};
