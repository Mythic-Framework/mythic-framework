import React from 'react';
import { makeStyles } from '@material-ui/styles';
import { Fade } from '@material-ui/core';
import { useSelector } from 'react-redux';
import { DigitalDisplay, DirectionDisplay, SettingsIndicator } from '../../components/index';
import RadarBackground from '../../bg.png';
import Nui from '../../util/Nui';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		display: 'flex',
		height: `${215 * theme.scale}px`,
		width: `${550 * theme.scale}px`,
		background: `url(${RadarBackground})`,
		backgroundSize: 'cover',
		color: theme.palette.primary.main,
		borderRadius: '6px',
		border: '4px solid #000',
		padding: '4px 8px',
		fontWeight: 'bold',
		fontSize: 32,
		position: 'absolute',
		top: theme.currentPositioning.top,
		bottom: theme.currentPositioning.bottom,
		right: theme.currentPositioning.right,
		left: theme.currentPositioning.left,
		transition: '0.5s',
		margin: 'auto',
	},
	trafficContainer: {
		height: '100%',
		width: '75%',
	},
	patrolContainer: {
		display: 'flex',
		flexDirection: 'column',
		height: '100%',
		width: '25%',
	},
	label: {
		fontSize: `${13 * theme.scale}px`,
		textAlign: 'center',
		color: theme.palette.text.info,
		margin: 0,
	},
	brand: {
		fontSize: `${18 * theme.scale}px`,
		padding: '10% 0',
		color: theme.palette.text.light,
	},
	rowContainer: {
        display: 'flex',
		flexDirection: 'row',
        height: '100%',
    },
	displayContainer: {
		width: '29.5%',
	},
	settingsContainer: {
		width: '12.5%',
		paddingTop: '1%',
	},
	directionContainer: {
		width: '8%',
		paddingTop: '2%'
	},
	radarBranding: {
		height: '40%',
	},
	patrolSpeed: {
		height: '30%',
		padding: '0 5%',
	},
	patrolSpeedLabel: {
		height: '20%',
	},
}));

export default () => {
	const classes = useStyles();

	const RadarRow = (props) => {
		return (
		  <>
			<div className={classes.settingsContainer}>
            	<SettingsIndicator settings={{
					opp: props.settings?.transmit && !props.settings?.lane,
					same: props.settings?.transmit && props.settings?.lane,
					xmit: props.settings?.transmit
				}} />
			</div>
			<div className={classes.displayContainer}>
				<DigitalDisplay 
					speed={!props.menu}
					value={props.menu ? props.menu.radar : (props.settings?.transmit ? props.radar?.speed : null)} 
					label={props.menu ? 'Menu' : ((props.settings?.transmit && props.radar?.plate) ? props.radar?.plate : 'No Plate')} 
					colour={'orange'} 
				/>
			</div>
			<div className={classes.directionContainer}>
				<DirectionDisplay direction={props.settings?.transmit && props.radar?.direction} />
			</div>

			<div className={classes.settingsContainer}>
				<SettingsIndicator settings={{ 
					fast: props.settings?.transmit && props.fast?.fast,
					lock: props.settings?.transmit && props.fast?.locked,
				}} />
			</div>
			<div className={classes.displayContainer}>
				<DigitalDisplay 
					speed={!props.menu} 
					value={props.menu ? props.menu.fast : (props.settings?.transmit ? props.fast?.speed : null)} 
					label={props.menu ? 'Mode' : ((props.settings?.transmit && props.fast?.plate) ? props.fast?.plate : 'No Plate')}
					colour={'red'} 
				/>
			</div>
			<div className={classes.directionContainer}>
				<DirectionDisplay direction={props.settings?.transmit && props.fast?.direction} />
			</div>
		  </>
		);
	}

	const showingRadar = useSelector(state => state.radar.showingRadar);
	const radarData = useSelector(state => state.radar.data);
	const radarSettings = useSelector(state => state.radar.settings);
	const menuMode = useSelector(state => state.radar.menu.showing);
	const menuSettings = useSelector(state => state.radar.menu);
	
	return <Fade in={showingRadar} duration={2500}>
		<div className={classes.wrapper}>
			<div className={classes.trafficContainer}>
				<div style={{ height: '10%', width: '100%' }}>
					<p className={classes.label}>FRONT ANTENNA</p>
				</div>
				<div className={classes.rowContainer} style={{ height: '37%', width: '100%' }}>
					<RadarRow 
						settings={!menuMode && radarSettings.frontRadar} 
						radar={radarData.frontRadar} 
						fast={radarData.frontFast} 
						menu={menuMode && menuSettings}
					/>
				</div>
				<div style={{ height: '6%', width: '100%' }}></div>
				<div className={classes.rowContainer} style={{ height: '37%', width: '100%' }}>
					<RadarRow 
						settings={!menuMode && radarSettings.rearRadar} 
						radar={radarData.rearRadar} 
						fast={radarData.rearFast} 
					/>
				</div>
				<div style={{ height: '10%', width: '100%' }}>
					<p className={classes.label}>REAR ANTENNA</p>
				</div>
			</div>
			<div className={classes.patrolContainer}>
				<div className={classes.radarBranding}>
					<p className={`${classes.label} ${classes.brand}`}>PROWLER</p>
					<p className={classes.label}>ARP 2X RADAR</p>
				</div>
				<div className={classes.patrolSpeed}>
					<DigitalDisplay speed={!menuMode || typeof(menuSettings.patrol) == 'number'} value={!menuMode ? radarData.patrolSpeed : menuSettings.patrol} colour={'green'} />
				</div>
				<div className={classes.patrolSpeedLabel}>
					<p className={classes.label}>PATROL SPEED</p>
				</div>
			</div>
		</div>
	</Fade>;
};
