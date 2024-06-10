import React, { useEffect } from 'react';
import { makeStyles } from '@mui/styles';
import Nui from '../../../util/Nui';

import { Ticker } from '../../UIComponents';
import { SetPedHeadOverlay } from '../../../actions/pedActions';
import { connect, useSelector } from 'react-redux';
import ElementBox from '../../UIComponents/ElementBox/ElementBox';

const useStyles = makeStyles((theme) => ({
	body: {
		maxHeight: '100%',
        overflow: 'hidden',
		margin: 25,
		display: 'grid',
		gridGap: 0,
		gridTemplateColumns: '49% 49%',
		justifyContent: 'space-around',
		background: theme.palette.secondary.light,
		border: `2px solid ${theme.palette.border.divider}`,
	},
}));

export default connect()((props) => {
	const classes = useStyles();
    const ped = useSelector(state => state.app.ped);

	return (
        <ElementBox label={props.label} bodyClass={classes.body}>
            <Ticker
                label={'Primary Color'}
                event={SetPedHeadOverlay}
                data={{ ...props.data, extraType: 'color1' }}
                current={props.current?.color1 ?? 0}
                disabled={props.current.disabled}
                min={0}
                max={63}
            />
            {props.secondary && <Ticker
                label={'Secondary Color'}
                event={SetPedHeadOverlay}
                data={{ ...props.data, extraType: 'color2' }}
                current={props.current?.color2 ?? 0}
                disabled={props.current.disabled}
                min={0}
                max={63}
            />}
        </ElementBox>
	);
});
