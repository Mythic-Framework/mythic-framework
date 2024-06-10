import React, { Fragment, useEffect } from 'react';
import ElementBox from '../../UIComponents/ElementBox/ElementBox';
import Component from '../../PedComponents/Component/Component';
import { useSelector } from 'react-redux';
import { SetPedHairColor, SetPedHairOverlay } from '../../../actions/pedActions';
import { Ticker } from '../../UIComponents';
import { makeStyles } from '@mui/styles';
import Nui from '../../../util/Nui';

const useStyles = makeStyles(theme => ({
  body: {
    maxHeight: '100%',
    overflowX: 'hidden',
    overflowY: 'auto',
    margin: 25,
    display: 'grid',
    gridGap: 0,
    gridTemplateColumns: '20% 80%',
    justifyContent: 'space-around',
		background: theme.palette.secondary.light,
		border: `2px solid ${theme.palette.border.divider}`,
  },
  body2: {
    maxHeight: '100%',
    overflowX: 'hidden',
    margin: 25,
    display: 'grid',
    gridGap: 0,
		gridTemplateColumns: '49% 49%',
    justifyContent: 'space-around',
		background: theme.palette.secondary.light,
		border: `2px solid ${theme.palette.border.divider}`,
  },
  color: {
    width: '50%',
    height: '50%',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    margin: 'auto',
    position: 'relative',
    border: '2px solid #3e4148',
  },
}));

export default props => {
  const classes = useStyles();
  const ped = useSelector(state => state.app.ped);
  const colorsMax = useSelector(state => state.app.hairColors);
  const overlaysMax = useSelector(state => state.app.hairOverlays);

  useEffect(() => {
    Nui.send("GetPedHairRgbColor", {
      type: 'color1',
      name: 'hair',
      colorId: ped.customization.colors.hair.color1.index
    })
  }, [ped.customization.colors.hair.color1.index]);

  useEffect(() => {
    Nui.send("GetPedHairRgbColor", {
      type: 'color2',
      name: 'hair',
      colorId: ped.customization.colors.hair.color2.index
    })
  }, [ped.customization.colors.hair.color2.index]);


  return <Fragment>
    <Component label={'Hair'} component={ped.customization.components.hair} name={'hair'}/>
    <ElementBox label={'Color'} bodyClass={classes.body}>
      <div className={classes.color} style={{ backgroundColor: ped.customization.colors.hair.color1.rgb }}/>
      <Ticker
        label={'Hair Color'}
        event={SetPedHairColor}
        data={{
          type: 'color1',
          name: 'hair'
        }}
        current={ped.customization.colors.hair.color1.index}
        min={0}
        max={colorsMax ? colorsMax - 1 : 0}
      />
      <div className={classes.color} style={{ backgroundColor: ped.customization.colors.hair.color2.rgb }}/>
      <Ticker
        label={'Highlight Color'}
        event={SetPedHairColor}
        data={{
          type: 'color2',
          name: 'hair'
        }}
        current={ped.customization.colors.hair.color2.index}
        min={0}
        max={colorsMax ? colorsMax - 1 : 0}
      />
    </ElementBox>
    <ElementBox label={'Hair Overlay'} bodyClass={classes.body2}>
      <Ticker
        label={'Custom Hair Overlay'}
        event={SetPedHairOverlay}
        data={{}}
        current={ped.customization.hairOverlay ?? -1}
        min={-1}
        max={overlaysMax}
      />
    </ElementBox>

  </Fragment>;
}
