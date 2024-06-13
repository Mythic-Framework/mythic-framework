import React, { useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Tab, Tabs, ButtonGroup, Button } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { TabPanel, Dialog } from '../../components/UIComponents';
import { CurrencyFormat } from '../../util/Parser';
import { SavePed, CancelEdits } from '../../actions/pedActions';
import Hair from '../../components/Hair/Hair';
import FaceMakeup from '../../components/Face/FaceMakeup/FaceMakeup';
import Wrapper from '../../components/UIComponents/Wrapper/Wrapper';
import Naked from '../../components/PedComponents/Naked';
import Nui from '../../util/Nui';

const useStyles = makeStyles((theme) => ({
	save: {
		position: 'absolute',
		bottom: '1%',
		right: '1%',
		'& svg': {
			marginLeft: 6,
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
	const cost = useSelector((state) => state.app.pricing.BARBER);

	const [cancelling, setCancelling] = useState(false);
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

	const onCancel = () => {
		setCancelling(false);
		dispatch(CancelEdits());
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
						label={<FontAwesomeIcon icon={['fas', 'scissors']} />}
					/>
					<Tab label={<FontAwesomeIcon icon={['fas', 'teeth-open']} />} />
				</Tabs>
			</div>
			<div className={classes.panel}>
				<TabPanel value={value} index={0}>
					<Hair />
				</TabPanel>
				<TabPanel value={value} index={1}>
					<Wrapper>
						<FaceMakeup />
					</Wrapper>
				</TabPanel>
			</div>

			<Naked />
			<ButtonGroup variant="contained" className={classes.save}>
				<Button color="error" onClick={() => setCancelling(true)}>
					Cancel
					<FontAwesomeIcon icon={['fas', 'x']} />
				</Button>
				<Button color="success" onClick={() => setSaving(true)}>
					Save
					<FontAwesomeIcon icon={['fas', 'floppy-disk']} />
				</Button>
			</ButtonGroup>

			<Dialog
				title="Cancel?"
				open={cancelling}
				onAccept={onCancel}
				onDecline={() => setCancelling(false)}
				acceptLang="Yes"
				declineLang="No"
			>
				<p>
					All changes will be discarded, are you sure you want to
					continue?
				</p>
			</Dialog>
			<Dialog
				title="Save Haircut?"
				open={saving}
				onAccept={onSave}
				onDecline={() => setSaving(false)}
			>
				<p>
					You will be charged{' '}
					<span className={classes.highlight}>
						{CurrencyFormat.format(cost)}
					</span>
					?
				</p>
				<p>Are you sure you want to save?</p>
			</Dialog>
		</div>
	);
};
