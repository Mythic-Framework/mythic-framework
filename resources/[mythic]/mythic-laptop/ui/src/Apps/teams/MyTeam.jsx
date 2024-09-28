import React, { useEffect, useState, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles, withStyles } from '@mui/styles';
import {
	AppBar,
	Grid,
	Button,
	List,
	ListItem,
	ListItemText,
	ListItemSecondaryAction,
	IconButton,
	TextField,
} from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { Modal } from '../../components';
import { throttle } from 'lodash';

import NumberFormat from 'react-number-format';

import Window from '../../components/Window';
import Nui from '../../util/Nui';
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
	},
	editorField: {
		marginBottom: 15,
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

	const myData = useSelector((state) => state.data.data.player);
	const myGroup = useSelector((state) => state.data.data.myGroup);
	const myGroupLeader = myGroup?.Members?.find(m => m.Leader);

	const [creatingGroup, setCreatingGroup] = useState(null);

	const onStartCreatingGroup = () => {
		setCreatingGroup({
			Name: "",
		});
	}

	const onCreateGroup = async (e) => {
		e.preventDefault();

		try {
			const res = await (await Nui.send("CreateTeam", creatingGroup)).json();

			if (res?.success) {
				alert('Team Created');
			} else {
				if (res?.message) {
					alert('Team Name Already Taken');
				} else {
					alert('Failed to Create Team');
				}
			}
		} catch (e) {
			console.log(e)
		}

		setCreatingGroup(null);
	};

	const [invitingMember, setInvitingMember] = useState(null);
	const onStartInvitingMember = () => {
		setInvitingMember({
			SID: "",
		});
	};

	const onInviteMember = async (e) => {
		e.preventDefault();

		try {
			const res = await (await Nui.send("InviteTeamMember", {
				SID: parseInt(invitingMember?.SID) ?? 0
			})).json();

			if (res?.success) {
				alert('Member Invited');
			} else {
				alert('Member Invite Failed');
			}
		} catch (e) {
			console.log(e)
		}

		setInvitingMember(null);
	};

	const [removingMember, setRemovingMember] = useState(null);
	const onStartRemovingMember = (member) => {
		setRemovingMember(member);
	};

	const onRemovingMember = async (e) => {
		e.preventDefault();

		try {
			const res = await (await Nui.send("RemoveTeamMember", removingMember)).json();

			if (res) {
				alert('Member Removed');
			} else {
				alert('Member Removal Failed');
			}
		} catch (e) {
			console.log(e)
		}

		setRemovingMember(null);
	};

	const [deleting, setDeleting] = useState(false);
	const onStartDeleting = () => {
		setDeleting(true);
	};

	const onDelete = async (e) => {
		e.preventDefault();

		try {
			const res = await (await Nui.send("DeleteTeam")).json();

			if (res) {
				alert('Team Deleted');
			} else {
				alert('Failed to Delete Team');
			}
		} catch (e) {
			console.log(e)
		}

		setDeleting(false);
	};

	return (
		<Grid item xs={4} style={{ padding: 10 }}>
			<Grid container>
				<Grid item xs={12}>
					<h3 className={classes.heading}>My Team</h3>
				</Grid>
				<Grid item xs={12}>
					{(!Boolean(myGroup) || !Boolean(myGroupLeader)) ? (
						<Button
							color="success"
							variant="outlined"
							onClick={onStartCreatingGroup}
						>
							Create Team
						</Button>
					) : (
						<List>
							<ListItem divider>
								<ListItemText
									primary="Name"
									secondary={myGroup.Name}
								/>
								<ListItemSecondaryAction>
									{myGroupLeader.SID == myData.SID &&
										<IconButton
											edge="end"
											className={classes.actionBtn}
											onClick={onStartDeleting}
											disabled={myGroup.State !== 0}
										>
											<FontAwesomeIcon
												icon={['fas', 'trash']}
											/>
										</IconButton>
									}
								</ListItemSecondaryAction>
							</ListItem>
							<ListItem divider>
								<ListItemText
									primary="State"
									secondary={myGroup.StateName}
								/>
							</ListItem>
							<ListItem divider>
								<ListItemText
									primary="Team Leader"
									secondary={`${myGroupLeader?.First} ${myGroupLeader?.Last} (${myGroupLeader?.SID})`}
								/>
							</ListItem>
							<ListItem divider>
								<ListItemText
									primary={`Team Members (${myGroup.Members.length})`}
								/>
								<ListItemSecondaryAction>
									{myGroupLeader.SID == myData.SID &&
										myGroup.Members.length < 5 && (
											<IconButton
												edge="end"
												color="success"
												className={classes.actionBtn}
												onClick={onStartInvitingMember}
												disabled={myGroup.State !== 0}
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
										(m) => !m.Leader,
									).length > 0 ? (
										myGroup.Members.filter(
											(m) => !m.Leader,
										).map((member) => {
											return (
												<ListItem
													key={`member-${member?.SID}`}
													divider
												>
													<ListItemText
														className={myData.SID == member?.SID && classes.bold}
														primary={`${member?.First} ${member?.Last} (${member?.SID})`}
													/>
													{(myGroupLeader.SID == myData.SID || myData.SID == member.SID) && <ListItemSecondaryAction>
														<IconButton
															edge="end"
															color="error"
															className={classes.actionBtn}
															onClick={() => onStartRemovingMember(member)}
															disabled={myGroup.State !== 0}
														>
															<FontAwesomeIcon
																icon={[
																	'fas',
																	'minus',
																]}
															/>
														</IconButton>
													</ListItemSecondaryAction>}
												</ListItem>
											);
										})
									) : (
										<ListItem>
											<ListItemText primary="No Other Members In Team" />
										</ListItem>
									)}
								</List>
							</ListItem>
						</List>
					)}
				</Grid>
			</Grid>
			<Modal
				open={Boolean(creatingGroup)}
				title="Create Team"
				closeLang="Close"
				maxWidth="md"
				submitLang="Create Team"
				onSubmit={onCreateGroup}
				submitColor="success"
				onClose={() => setCreatingGroup(null)}
			>
				{Boolean(creatingGroup) && <>
					<TextField
						fullWidth
						required
						label="Team Name"
						name="Name"
						className={classes.editorField}
						value={creatingGroup.Name}
						onChange={(e) =>
							setCreatingGroup({
								...creatingGroup,
								Name: e.target.value.replace(/[^a-zA-Z0-9_. -]+/g, '').replace(/\s\s+/g, ' '),
							})
						}
					/>
				</>}
			</Modal>

			<Modal
				open={Boolean(invitingMember)}
				title="Invite Member"
				closeLang="Close"
				maxWidth="md"
				submitLang="Invite"
				onSubmit={onInviteMember}
				submitColor="success"
				onClose={() => setInvitingMember(null)}
			>
				{Boolean(invitingMember) && <>
					<NumberFormat
						fullWidth
						required
						label="State ID"
						name="SID"
						className={classes.editorField}
						value={invitingMember.SID}
						onChange={(e) =>
							setInvitingMember({
								...invitingMember,
								SID: e.target.value,
							})
						}
						type="tel"
						isNumericString
						customInput={TextField}
					/>
				</>}
			</Modal>
			<Modal
				open={Boolean(removingMember)}
				title="Remove Member"
				closeLang="Close"
				maxWidth="md"
				submitLang="Remove"
				onSubmit={onRemovingMember}
				submitColor="error"
				onClose={() => setRemovingMember(null)}
			>
				{removingMember?.SID != myData.SID ?
					<p>Are you sure you want to remove {removingMember?.First} {removingMember?.Last}?</p>
					: <p>Are you sure you want to leave the group?</p>
				}
			</Modal>
			<Modal
				open={deleting}
				title="Delete Team"
				closeLang="Close"
				maxWidth="md"
				submitLang="Delete"
				onSubmit={onDelete}
				submitColor="error"
				onClose={() => setDeleting(false)}
			>
				<p>Are you sure you want to delete your team?</p>
			</Modal>
		</Grid>
	);
};
