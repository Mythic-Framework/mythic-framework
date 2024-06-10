import React from 'react';
import { Fade, Grid, Paper, Button } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { useSelector, useDispatch } from 'react-redux';
import RemoteBackground from '../../bgr.png';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import RadarMenu from './menu';
import Nui from '../../util/Nui';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		display: 'flex',
		height: `auto`,
		width: '235px',
		background: `url(${RemoteBackground})`,
		backgroundSize: 'cover',
		color: theme.palette.primary.main,
		borderRadius: '6px',
		border: '4px solid #000',
		padding: '4px 8px',
		fontWeight: 'bold',
		fontSize: 32,
		position: 'absolute',
		bottom: '10%',
		right: 0,
		left: 0,
		margin: 'auto',
	},
    label: {
        fontSize: '13px',
		textAlign: 'center',
		color: theme.palette.text.info,
		margin: 0,
    },
    brand: {
		fontSize: '18px',
		padding: '2% 0',
		color: theme.palette.text.light,
	},
    fullHeight: {
        height: '100%',
    },
    coolThing: {
        color: theme.palette.secondary.light,
    }
}));

let currentMenuIndex = 0;
let currentMenuValue;

export default () => {
	const classes = useStyles();
    const dispatch = useDispatch();
    const showingRadar = useSelector(state => state.radar.showingRemote);
	const radarSettings = useSelector(state => state.radar.settings);
    const menuData = useSelector(state => state.radar.menu);


    const ToggleMenu = () => {
        if (menuData.showing) {
            dispatch({
                type: 'MENU_HIDE',
            });
        } else {
            currentMenuIndex = 0;
            const currentMenuData = RadarMenu[currentMenuIndex];
            currentMenuValue = radarSettings[currentMenuData.setting];
            dispatch({
                type: 'MENU_SHOW',
                payload: {
                    radar: currentMenuData.radar,
                    fast: currentMenuData.fast,
                    patrol: currentMenuData.labeledIndex?.[currentMenuValue] ? currentMenuData.labeledIndex[currentMenuValue] : currentMenuValue,
                }
            });
        }
    }

    const NavigateNextMenu = () => {
        if (menuData.showing) {
            currentMenuIndex = currentMenuIndex + 1;
            
            if (currentMenuIndex >= RadarMenu.length) {
                currentMenuIndex = RadarMenu.length - 1;
            }
            
            const currentMenuData = RadarMenu[currentMenuIndex];
            currentMenuValue = radarSettings[currentMenuData.setting];
            dispatch({
                type: 'MENU_SHOW',
                payload: {
                    radar: currentMenuData.radar,
                    fast: currentMenuData.fast,
                    patrol: currentMenuData.labeledIndex?.[currentMenuValue] ? currentMenuData.labeledIndex[currentMenuValue] : currentMenuValue,
                }
            });
        }
    }

    const NavigatePrevMenu = () => {
        if (menuData.showing) {
            currentMenuIndex--;
            
            if (currentMenuIndex < 0) {
                currentMenuIndex = 0;
            }
            
            const currentMenuData = RadarMenu[currentMenuIndex];
            currentMenuValue = radarSettings[currentMenuData.setting];
            dispatch({
                type: 'MENU_SHOW',
                payload: {
                    radar: currentMenuData.radar,
                    fast: currentMenuData.fast,
                    patrol: currentMenuData.labeledIndex?.[currentMenuValue] ? currentMenuData.labeledIndex[currentMenuValue] : currentMenuValue,
                }
            });
        }
    }

    const IncrementMenuValue = () => {
        if (menuData.showing) {
            const currentMenuData = RadarMenu[currentMenuIndex];
            currentMenuValue += currentMenuData.step ?? 1;
            if (currentMenuValue > currentMenuData.max) {
                currentMenuValue = currentMenuData.max;
            }
    
            dispatch({
                type: 'MENU_SHOW',
                payload: {
                    radar: currentMenuData.radar,
                    fast: currentMenuData.fast,
                    patrol: currentMenuData.labeledIndex?.[currentMenuValue] ? currentMenuData.labeledIndex[currentMenuValue] : currentMenuValue,
                }
            });

            Nui.send('UpdateSettings', {
                ...radarSettings,
                [currentMenuData.setting]: currentMenuValue,
            });
        }
    }

    const DecrementMenuValue = () => {
        if (menuData.showing) {
            const currentMenuData = RadarMenu[currentMenuIndex];
            currentMenuValue -= currentMenuData.step ?? 1;
            if (currentMenuValue < currentMenuData.min) {
                currentMenuValue = currentMenuData.min;
            }
    
            dispatch({
                type: 'MENU_SHOW',
                payload: {
                    radar: currentMenuData.radar,
                    fast: currentMenuData.fast,
                    patrol: currentMenuData.labeledIndex?.[currentMenuValue] ? currentMenuData.labeledIndex[currentMenuValue] : currentMenuValue,
                }
            });

            Nui.send('UpdateSettings', {
                ...radarSettings,
                [currentMenuData.setting]: currentMenuValue,
            });
        }
    }

	return <Fade in={showingRadar} duration={2500}>
        <div className={classes.wrapper}>
            <Grid container spacing={1}>
                <Grid item xs={12}>
                    <p className={`${classes.label} ${classes.brand}`}>PROWLER</p>
                    <p className={classes.label}>ARP 2X RADAR REMOTE</p>
                    <br></br>
                </Grid>
                <Grid item xs={12}>
                    <p className={classes.label}>FRONT ANTENNA</p>
                </Grid>
                <Grid item xs={4}>
                    <Button size="small" disabled={!radarSettings.frontRadar.transmit} fullWidth variant="contained" color={!radarSettings.frontRadar.lane ? 'primary' : 'secondary'} onClick={() => {
                        Nui.send('UpdateSettings', {
                            ...radarSettings,
                            frontRadar: {
                                lane: false,
                                transmit: radarSettings.frontRadar.transmit,
                            }
                        });
                    }}>
                        OPP
                    </Button>
                </Grid>
                <Grid item xs={4}>
                    <Button size="small" fullWidth variant="contained" color="secondary" onClick={() => {
                        Nui.send('UpdateSettings', {
                            ...radarSettings,
                            frontRadar: {
                                lane: radarSettings.frontRadar.lane,
                                transmit: !radarSettings.frontRadar.transmit,
                            }
                        });
                    }}>
                        XMIT
                    </Button>
                </Grid>
                <Grid item xs={4}>
                    <Button size="small" disabled={!radarSettings.frontRadar.transmit} fullWidth variant="contained" color={radarSettings.frontRadar.lane ? 'primary' : 'secondary'} onClick={() => {
                        Nui.send('UpdateSettings', {
                            ...radarSettings,
                            frontRadar: {
                                lane: true,
                                transmit: radarSettings.frontRadar.transmit,
                            }
                        });
                    }}>
                        SAME
                    </Button>
                </Grid>


                <Grid item xs={4}>
                    <Button size="small" disabled={!radarSettings.rearRadar.transmit} fullWidth variant="contained" color={!radarSettings.rearRadar.lane ? 'primary' : 'secondary'} onClick={() => {
                        Nui.send('UpdateSettings', {
                            ...radarSettings,
                            rearRadar: {
                                lane: false,
                                transmit: radarSettings.rearRadar.transmit,
                            }
                        });
                    }}>
                        OPP
                    </Button>
                </Grid>
                <Grid item xs={4}>
                    <Button size="small" fullWidth variant="contained" color="secondary" onClick={() => {
                        Nui.send('UpdateSettings', {
                            ...radarSettings,
                            rearRadar: {
                                lane: radarSettings.rearRadar.lane,
                                transmit: !radarSettings.rearRadar.transmit,
                            }
                        });
                    }}>
                        XMIT
                    </Button>
                </Grid>
                <Grid item xs={4}>
                    <Button size="small" disabled={!radarSettings.rearRadar.transmit} fullWidth variant="contained" color={radarSettings.rearRadar.lane ? 'primary' : 'secondary'} onClick={() => {
                        Nui.send('UpdateSettings', {
                            ...radarSettings,
                            rearRadar: {
                                lane: true,
                                transmit: radarSettings.rearRadar.transmit,
                            }
                        });
                    }}>
                        SAME
                    </Button>
                </Grid>

                <Grid item xs={12}>
                    <p className={classes.label}>REAR ANTENNA</p>
                </Grid>

                <br></br>

                <Grid item xs={4}></Grid>
                <Grid item xs={4}>
                    <Button size="small" className={classes.fullHeight} fullWidth variant="contained" color="secondary" disabled={!menuData.showing} onClick={IncrementMenuValue}>
                        <FontAwesomeIcon icon={'fa-solid fa-up'} />
                    </Button>
                </Grid>
                <Grid item xs={4}></Grid>

                <Grid item xs={4}>
                    <Button size="small" className={classes.fullHeight} fullWidth variant="contained" color="secondary" disabled={!menuData.showing} onClick={NavigatePrevMenu}>
                        <FontAwesomeIcon icon={'fa-solid fa-left'} />
                    </Button>
                </Grid>
                <Grid item xs={4}>
                    <Button size="small" className={classes.fullHeight} fullWidth variant="contained" color="secondary" onClick={ToggleMenu}>
                        MENU
                    </Button>
                </Grid>
                <Grid item xs={4}>
                    <Button size="small" className={classes.fullHeight} fullWidth variant="contained" color="secondary" disabled={!menuData.showing} onClick={NavigateNextMenu}>
                        <FontAwesomeIcon icon={'fa-solid fa-right'} />
                    </Button>
                </Grid>

                <Grid item xs={4}></Grid>
                <Grid item xs={4}>
                    <Button size="small" className={classes.fullHeight} fullWidth variant="contained" color="secondary" disabled={!menuData.showing} onClick={DecrementMenuValue}>
                        <FontAwesomeIcon icon={'fa-solid fa-down'} />
                    </Button>
                </Grid>
                <Grid item xs={4}></Grid>

                <Grid item xs={4}></Grid>
                <Grid item xs={4}>
                    <Button size="small" fullWidth variant="contained" color="secondary" onClick={() => {
                        Nui.send('CloseRemote', {});
                    }}>
                        CLOSE
                    </Button>
                </Grid>
                <Grid item xs={4}></Grid>
            </Grid>
        </div>
    </Fade>;
};