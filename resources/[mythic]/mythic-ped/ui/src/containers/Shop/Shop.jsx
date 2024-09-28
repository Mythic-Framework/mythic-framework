import React, { useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Tab, Tabs, ButtonGroup, Button, TextField } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { TabPanel, Dialog } from '../../components/UIComponents';
import { CurrencyFormat } from '../../util/Parser';
import { SavePed, CancelEdits, SaveImport } from '../../actions/pedActions';
import Clothes from '../../components/Clothes/Clothes';
import Accessories from '../../components/Accessories/Accessories';
import Body from '../../components/Body/Body';
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
  const cost = useSelector((state) => state.app.pricing.SHOP);

  const [cancelling, setCancelling] = useState(false);
  const [saving, setSaving] = useState(false);
  const [value, setValue] = useState(0);
  const [importCode, setImportCode] = useState('');
  const [outfitName, setOutfitName] = useState('');

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

  const handleImport = () => {
    setImportCode('');
    setOpenImportDialog(true);
  };

  const handleCancelImport = () => {
    setOpenImportDialog(false);
    setCancelling(true);
  };

  const handleImportDialogClose = () => {
    setOpenImportDialog(false);
  };

  const handleImportCodeChange = (event) => {
    setImportCode(event.target.value);
  };

  const handleOutfitNameChange = (event) => {
    setOutfitName(event.target.value);
  };

  const handleImportConfirm = () => {
    setOpenImportDialog(false);
    dispatch(SaveImport(outfitName, importCode));
  };

  const [openImportDialog, setOpenImportDialog] = useState(false);

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
            label={<FontAwesomeIcon icon={['fas', 'person']} />}
          />
          <Tab
            label={<FontAwesomeIcon icon={['fas', 'face-smile']} />}
          />
          <Tab
            label={<FontAwesomeIcon icon={['fas', 'shirt']} />}
          />
          <Tab label={<FontAwesomeIcon icon={['fas', 'shoe-prints']} />} />
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
            label={<FontAwesomeIcon icon={['fas', 'shirt']} />}
          />
          <Tab label={<FontAwesomeIcon icon={['fas', 'hat-cowboy-side']} />} />
          <Tab label={<FontAwesomeIcon icon={['fas', 'mitten']} />} />
        </Tabs>
      </div>
      <div className={classes.panel}>
        <TabPanel value={value} index={0}>
          <Clothes />
        </TabPanel>
        <TabPanel value={value} index={1}>
          <Accessories />
        </TabPanel>
        <TabPanel value={value} index={2}>
          <Body armsOnly />
        </TabPanel>
      </div>

      <Naked />
      <ButtonGroup variant="contained" className={classes.save}>
        <Button color="primary" onClick={handleImport}>
          Import
          <FontAwesomeIcon icon={['fas', 'file-import']} />
        </Button>
        <Button color="error" onClick={() => setCancelling(true)}>
          Cancel
          <FontAwesomeIcon icon={['fas', 'x']} />
        </Button>
        <Button color="success" onClick={() => setSaving(true)}>
          Save
          <FontAwesomeIcon icon={['fas', 'save']} />
        </Button>
      </ButtonGroup>

      <Dialog
        open={openImportDialog}
        onClose={handleImportDialogClose}
        title="Import Code"
        onAccept={handleImportConfirm}
		    onDecline={handleImportDialogClose}
        acceptText="Import"
        declineText="Cancel"
      >
        <TextField
          autoFocus
          margin="dense"
          id="outfit-name"
          label="Input Outfit Name"
          type="text"
          fullWidth
          value={outfitName}
          onChange={handleOutfitNameChange}
        />
        <TextField
          autoFocus
          margin="dense"
          id="import-code"
          label="Input Outfit Code"
          type="text"
          fullWidth
          value={importCode}
          onChange={handleImportCodeChange}
        />
      </Dialog>

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
        title="Save Outfit?"
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