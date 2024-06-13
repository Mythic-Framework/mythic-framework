import React, { useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Tab, Tabs, IconButton, Button } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { TabPanel, Dialog } from '../../components/UIComponents';
import { Face } from '../../components';
import { SavePed } from '../../actions/pedActions';
import Body from '../../components/Body/Body';
import Hair from '../../components/Hair/Hair';
import Clothes from '../../components/Clothes/Clothes';
import Tattoo from '../../components/Tattoos';
import Accessories from '../../components/Accessories/Accessories';
import Naked from '../../components/PedComponents/Naked';
import FaceMakeup from '../../components/Face/FaceMakeup/FaceMakeup';
import Wrapper from '../../components/UIComponents/Wrapper/Wrapper';
import Nui from '../../util/Nui';

const useStyles = makeStyles((theme) => ({
	save: {
		position: 'absolute',
		bottom: '1%',
		right: '1%',
		transition: 'filter ease-in 0.15s',
		'& svg': {
			marginLeft: 6,
		},
		'&:hover': {
			filter: 'brightness(0.7)',
		},
	},
	camBar: {
		background: theme.palette.secondary.dark,
		height: 'fit-content',
		width: '100vw',
	},
	btnBar: {
		background: theme.palette.secondary.dark,
		width: 'fit-content',
		height: '100vh',
	},
	panel: {
		width: 500,
		position: 'absolute',
		left: 90,
		top: 48,
		height: 'calc(100vh - 48px)',
	},
}));

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const camera = useSelector((state) => state.app.camera);
	const state = useSelector((state) => state.app.state);

	const [saving, setSaving] = useState(false);
	const [value, setValue] = useState(0);

	const handleChange = (event, newValue) => {
		setValue(newValue);
	};

	const onCamChange = async (e, newValue) => {
		try {
			let res = await (await Nui.send('ChangeCamera', newValue)).json();

			if (res) {
				dispatch({
					type: 'SET_CAM',
					payload: {
						cam: newValue,
					},
				});
			}
		} catch (err) {}
	};

	const onSave = () => {
		setSaving(false);
		dispatch(SavePed(state));
	};

	return (
		<div>
			<div className={classes.camBar}>
				<Tabs
					centered
					style={{ height: '100%' }}
					value={camera}
					onChange={onCamChange}
					indicatorColor="primary"
					textColor="primary"
				>
					<Tab
						label={
							<FontAwesomeIcon icon={['fas', 'face-grimace']} />
						}
					/>
					<Tab
						label={<FontAwesomeIcon icon={['fas', 'head-side-mask']} />}
					/>
					<Tab
						label={
							<FontAwesomeIcon icon={['fas', 'child-reaching']} />
						}
					/>
					<Tab label={<FontAwesomeIcon icon={['fas', 'person']} />} />
				</Tabs>
			</div>
			<div className={classes.btnBar}>
				<Tabs
					orientation="vertical"
					style={{ height: '100%' }}
					value={value}
					onChange={handleChange}
					indicatorColor="primary"
					textColor="primary"
					variant="scrollable"
				>
					<Tab
						label={
							<FontAwesomeIcon icon={['fas', 'face-grimace']} />
						}
					/>
					<Tab
						label={
							<FontAwesomeIcon icon={['fas', 'child-reaching']} />
						}
					/>
					<Tab
						label={<FontAwesomeIcon icon={['fas', 'scissors']} />}
					/>
					<Tab
						label={<FontAwesomeIcon icon={['fas', 'teeth-open']} />}
					/>
					<Tab label={<FontAwesomeIcon icon={['fas', 'shirt']} />} />
					<Tab label={<FontAwesomeIcon icon={['fas', 'mitten']} />} />
					<Tab label={<FontAwesomeIcon icon={['fas', 'atom']} />} />
				</Tabs>
			</div>
			<div className={classes.panel}>
				<TabPanel value={value} index={0}>
					<Face />
				</TabPanel>
				<TabPanel value={value} index={1}>
					<Body />
				</TabPanel>
				<TabPanel value={value} index={2}>
					<Hair />
				</TabPanel>
				<TabPanel value={value} index={3}>
					<Wrapper>
						<FaceMakeup />
					</Wrapper>
				</TabPanel>
				<TabPanel value={value} index={4}>
					<Clothes />
				</TabPanel>
				<TabPanel value={value} index={5}>
					<Accessories />
				</TabPanel>
				<TabPanel value={value} index={6}>
					<Tattoo />
				</TabPanel>
			</div>

			<Naked />
			<Button
				variant="contained"
				color="success"
				className={classes.save}
				onClick={() => setSaving(true)}
			>
				Save
				<FontAwesomeIcon icon={['fas', 'floppy-disk']} />
			</Button>

			<Dialog
				title="Create Character Ped?"
				open={saving}
				onAccept={onSave}
				onDecline={() => setSaving(false)}
			>
				<p>Are you sure you want to save?</p>
				<p>
					You may not be able to edit some things after this screen,
					ensure you are totally done creating your character before
					you continue!
				</p>
			</Dialog>
		</div>
	);
};
