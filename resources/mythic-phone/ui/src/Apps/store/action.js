import Nui from '../../util/Nui';

function failedInstall(dispatch, app) {
    dispatch({
        type: 'ALERT_SHOW',
        payload: { alert: 'App Install Failed' }
    });
    
    dispatch({
        type: 'FAILED_INSTALL',
        payload: { app: app }
    });

    setTimeout(() => {
        dispatch({
            type: 'END_INSTALL',
            payload: { app: app }
        });

    }, 2000);
}
function failedUninstall(dispatch, app) {
    dispatch({
        type: 'ALERT_SHOW',
        payload: { alert: 'App Uninstall Failed' }
    });
    
    dispatch({
        type: 'FAILED_UNINSTALL',
        payload: { app: app }
    });

    setTimeout(() => {
        dispatch({
            type: 'END_UNINSTALL',
            payload: { app: app }
        });

    }, 2000);
}

export const checkInstall = () => (dispatch) => {
    return false;
}

export const install = (app) => (dispatch) => {
    dispatch({
        type: 'PENDING_INSTALL',
        payload: { app: app }
    });
    Nui.send('Install', {
        app: app,
        check: true
    }).then((res) => {
        if (res) {
            dispatch({
                type: 'START_INSTALL',
                payload: { app: app }
            });

            let t = Math.floor(Math.random() * 10001);
            setTimeout(() => {
                Nui.send('Install', {
                    app: app
                }).then((res) => {
                    if (res) {
                        dispatch({
                            type: 'ADD_DATA',
                            payload: { type: 'installed', data: app }
                        });
                        dispatch({ type: 'END_INSTALL', payload: { app: app} });
                    } else {
                        failedInstall(dispatch, app);
                    }
                }).catch((err) => {
                    failedInstall(dispatch, app);
                });
            }, t);
        } else {
            failedInstall(dispatch, app);
        }
    }).catch((err) => {
        failedInstall(dispatch, app);
    })
}

export const uninstall = (app) => (dispatch) => {
    dispatch({
        type: 'PENDING_UNINSTALL',
        payload: { app: app }
    });
    Nui.send('Uninstall', {
        app: app,
        check: true
    }).then((res) => {
        if (res) {
            dispatch({
                type: 'START_UNINSTALL',
                payload: { app: app }
            });

            let t = Math.floor(Math.random() * 5001);
            setTimeout(() => {
                Nui.send('Uninstall', {
                    app: app
                }).then((res) => {
                    if (res) {
                        dispatch({
                            type: 'REMOVE_DATA',
                            payload: { type: 'installed', id: app }
                        });
                        dispatch({
                            type: 'REMOVE_DATA',
                            payload: { type: 'home', id: app }
                        });
                        dispatch({
                            type: 'REMOVE_DATA',
                            payload: { type: 'dock', id: app }
                        });
                        dispatch({ type: 'END_UNINSTALL', payload: { app: app} });
                        dispatch({ type: 'ALERT_SHOW', payload: { alert: 'App Uninstalled Successfully' }});
                    } else {
                        failedInstall(dispatch, app);
                    }
                }).catch((err) => {
                    failedUninstall(dispatch, app);
                });
            }, t);
        } else {
            failedUninstall(dispatch, app);
        }
    }).catch((err) => {
        failedUninstall(dispatch, app);
    })
}