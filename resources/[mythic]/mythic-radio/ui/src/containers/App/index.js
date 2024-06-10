import React, { useState } from 'react';
import { connect, useSelector } from 'react-redux';
import { Slide, Tooltip, TextField, Button } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';

import Nui from '../../util/Nui';
import radioImg from '../../radio.png';

const useStyles = makeStyles(theme => ({
  wrapper: {
    fontFamily: 'Oswald',
    height: 600,
    width: 320,
    position: 'absolute',
    bottom: '0%',
    right: '2%',
    overflow: 'hidden',
  },
  radioImg: {
    zIndex: 100,
    background: `transparent no-repeat center`,
    height: '100%',
    width: '100%',
    position: 'absolute',
    pointerEvents: 'none',
  },
  radio: {
    height: '100%',
    width: '100%',
    padding: '0 69px',
    overflow: 'hidden',
  },
  screen: {
    zIndex: 101,
    width: '55.5%',
    height: '31.2%',
    position: 'absolute',
    top: 384,
    overflow: 'hidden',
  },
  volumeUp: {
    zIndex: 101,
    position: 'absolute',
    top: 205,
    left: 136,
    height: '10%',
    width: '7%',
    cursor: 'pointer',
  },
  volumeDown: {
    zIndex: 101,
    position: 'absolute',
    top: 205,
    left: 157,
    height: '10%',
    width: '7%',
    cursor: 'pointer',
  },
  clickVolumeUp: {
    zIndex: 101,
    position: 'absolute',
    bottom: 0,
    left: 93,
    height: '3%',
    width: '20%',
    cursor: 'pointer',
  },
  clickVolumeDown: {
    zIndex: 101,
    position: 'absolute',
    bottom: 0,
    left: 166,
    height: '3%',
    width: '20%',
    cursor: 'pointer',
  },
  power: {
    zIndex: 101,
    position: 'absolute',
    top: 233,
    left: 240,
    height: '7%',
    width: '25%',
    cursor: 'pointer',
  },
  radioHeaderInfo: {
    textAlign: 'center',
    width: '100%',
    lineHeight: '25px',
    height: 25,
    fontSize: '12px',
  },
  radioChannelNumber: {
    textAlign: 'center',
    width: '100%',
    lineHeight: '35px',
    height: 25,
  },
  inputScreen: {
    position: 'absolute',
    top: 25,
    left: 0,
    height: '100%',
    width: '84%',
    padding: '15px',
  },
  frequencyInput: {
    width: '100%',
    textAlign: 'center',
  },
  fuckingButton: {
    marginTop: '10px !important', // literal aids
    textAlign: 'center',
  },
})); 

const volumeUp = e => {
  Nui.send('VolumeUp', {});
};

const volumeDown = e => {
  Nui.send('VolumeDown', {});
};

const clickVolumeUp = e => {
  Nui.send('ClickVolumeUp', {});
};

const clickVolumeDown = e => {
  Nui.send('ClickVolumeDown', {});
};

const powerToggle = e => {
  Nui.send('TogglePower', {});
};

export default connect()(props => {
  const classes = useStyles();
  const hidden = useSelector(state => state.app.hidden);
  const power = useSelector(state => state.app.power);
  const frequency = useSelector(state => state.app.frequency);
  const volume = useSelector(state => state.app.volume);
  const freqName = useSelector(state => state.app.frequencyName);
  const typeName = useSelector(state => state.app.typeName);
  const [freq, setFreq] = useState(frequency);

  const onChange = e => {
    setFreq(e.target.value);
  }

  const setChannel = e => {
    e.preventDefault();
    Nui.send('SetChannel', {
      frequency: freq,
    });
  };

  return (
    <Slide direction="up" in={!hidden} mountOnEnter unmountOnExit>
      <div className={classes.wrapper}>
        <img className={classes.radioImg} src={radioImg} />
        <div className={classes.radio}>
          <Tooltip title="Volume Up" aria-label="volup" placement="top">
            <div className={classes.volumeUp} onClick={volumeUp}></div>
          </Tooltip>
          <Tooltip title="Volume Down" aria-label="voldown" placement="top">
            <div className={classes.volumeDown} onClick={volumeDown}></div>
          </Tooltip>
          <Tooltip title="Clicks Volume Up" aria-label="volup" placement="top">
            <div className={classes.clickVolumeUp} onClick={clickVolumeUp}></div>
          </Tooltip>
          <Tooltip title="Clicks Volume Down" aria-label="voldown" placement="top">
            <div className={classes.clickVolumeDown} onClick={clickVolumeDown}></div>
          </Tooltip>
          <Tooltip title="Power" aria-label="power" placement="top">
            <div className={classes.power} onClick={powerToggle}></div>
          </Tooltip>
          <div className={classes.screen}>
            <div className={classes.radioHeaderInfo}>
              {typeName} - 
              {`Volume: ${volume}%`}
            </div>

            <div className={classes.inputScreen}>
                <TextField
                  id="frequency"
                  type="number"
                  disabled={!power}
                  InputProps={{ inputProps: { min: 0, max: 2000, style: { textAlign: 'center' } }}}
                  value={freq}
                  className={classes.frequencyInput}
                  onChange={onChange}
                  label="Frequency"
                />
                <Button
                  fullWidth
                  color="primary"
                  disabled={!power}
                  className={classes.fuckingButton}
                  onClick={setChannel}
                >
                  Set Channel
                </Button>
                {/* <Button
                  fullWidth
                  color="primary"
                  disabled={!power}
                  className={classes.fuckingButton}
                  onClick={clearChannel}
                >
                  Clear Channel
                </Button> */}
                <div className={classes.radioChannelNumber}>
                  {power ? (frequency > 0 ? (freqName === '' ? `Channel #${frequency}` : `${freqName}`) : 'No Active Channel') : 'Powered Off'}
                </div>
            </div>

          </div>
        </div>
      </div>
    </Slide>
  );
});
