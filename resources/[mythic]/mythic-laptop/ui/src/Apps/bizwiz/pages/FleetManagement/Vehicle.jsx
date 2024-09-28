import React from 'react';
import { ListItem, ListItemText, Grid, ListItemSecondaryAction, IconButton } from '@mui/material';
import { makeStyles } from '@mui/styles';
import Moment from 'react-moment';
import { useSelector } from 'react-redux';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { useAlert } from '../../../../hooks';
import Nui from '../../../../util/Nui';

const useStyles = makeStyles((theme) => ({
  wrapper: {
    padding: '20px 10px 20px 20px',
    borderBottom: `1px solid ${theme.palette.border.divider}`,
    '&:first-of-type': {
      borderTop: `1px solid ${theme.palette.border.divider}`,
    },
  },
}));

export default ({ vehicle }) => {
  const classes = useStyles();
  const alert = useAlert();

  const onDuty = useSelector((state) => state.data.data.onDuty);
  const jobs = useSelector((state) => state.data.data.player.Jobs);
  const jobData = jobs?.find(j => j.Id == onDuty);

  const onClick = () => {

  };

  const onGPSMark = async () => {
    try {
      let res = await (
        await Nui.send('TrackFleetVehicle', {
          vehicle: vehicle.VIN
        })
      ).json();

      if (res) {
        alert('Marked Successfully on GPS');
      } else {
        alert('Error Marking GPS');
      };
    } catch (err) {
      console.log(err);
      alert('Error Marking GPS');
    }
  };

  return (
    <ListItem className={classes.wrapper}>
      <Grid container>
        <Grid item xs={2}>
          <ListItemText
            primary="Reg. Date"
            secondary={vehicle.RegistrationDate ? <Moment date={vehicle.RegistrationDate} unix format="LL" /> : 'Unknown'}
          />
        </Grid>
        <Grid item xs={2}>
          <ListItemText
            primary="VIN"
            secondary={vehicle.VIN}
          />
        </Grid>
        <Grid item xs={2}>
          <ListItemText primary="Plate" secondary={vehicle.RegisteredPlate} />
        </Grid>
        <Grid item xs={3}>
          <ListItemText
            primary="Make / Model"
            secondary={`${vehicle.Make} ${vehicle.Model}`}
          />
        </Grid>
        <Grid item xs={3}>
          <ListItemText
            primary="Storage"
            secondary={vehicle.Storage?.Name ?? "Unknown"}
          />
        </Grid>
      </Grid>
      <ListItemSecondaryAction>
        <IconButton onClick={onGPSMark}>
          <FontAwesomeIcon
            icon={['fas', 'location-crosshairs']}
          />
        </IconButton>
      </ListItemSecondaryAction>
    </ListItem>
  );
};
