import '@babel/polyfill';
import React, { useEffect } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import {
    CssBaseline,
    ThemeProvider,
    createTheme,
    StyledEngineProvider,
} from '@mui/material';
import { library } from '@fortawesome/fontawesome-svg-core';
import { fas } from '@fortawesome/free-solid-svg-icons';
import { fab } from '@fortawesome/free-brands-svg-icons';

import Chat from '../Chat';
import Nui from '../../util/Nui';

library.add(fab, fas);

const App = ({ hidden }) => {
    const mode = 'dark';
    const muiTheme = createTheme({
        typography: {
            fontFamily: ['Oswald'],
        },
        palette: {
            primary: {
                // main: '#00FF96',
                // light: '#96ffd4',
                // dark: '#00b168',
                main: '#ed0919',
                light: '#fb5560',
                dark: '#b3040f',
            },
            secondary: {
                main: mode === 'dark' ? '#191919' : '#ffffff',
                light: mode === 'dark' ? '#202020' : '#F5F6F4',
                dark: mode === 'dark' ? '#121212' : '#EBEBEB',
                contrastText: mode === 'dark' ? '#ffffff' : '#2e2e2e',
            },
            error: {
                main: '#ed0919',
                light: '#fb5560',
                dark: '#b3040f',
            },
            success: {
                main: '#52984a',
                light: '#60eb50',
                dark: '#244a20',
            },
            warning: {
                main: '#f09348',
                light: '#f2b583',
                dark: '#b05d1a',
            },
            info: {
                main: '#247ba5',
                light: '#247ba5',
                dark: '#175878',
            },
            text: {
                main: mode === 'dark' ? '#ffffff' : '#2e2e2e',
                alt: mode === 'dark' ? '#cecece' : '#858585',
                info: mode === 'dark' ? '#919191' : '#919191',
                light: '#ffffff',
                dark: '#000000',
            },
            alt: {
                green: '#008442',
                greenDark: '#064224',
            },
            border: {
                main: mode === 'dark' ? '#e0e0e008' : '#e0e0e008',
                light: '#ffffff',
                dark: '#26292d',
                input:
                    mode === 'dark'
                        ? 'rgba(255, 255, 255, 0.23)'
                        : 'rgba(0, 0, 0, 0.23)',
                divider:
                    mode === 'dark'
                        ? 'rgba(255, 255, 255, 0.12)'
                        : 'rgba(0, 0, 0, 0.12)',
            },
            mode: 'dark',
        },
        components: {
            MuiCssBaseline: {
                styleOverrides: {
                    body: {
                        '.fade-enter': {
                            opacity: 0,
                        },
                        '.fade-exit': {
                            opacity: 1,
                        },
                        '.fade-enter-active': {
                            opacity: 1,
                        },
                        '.fade-exit-active': {
                            opacity: 0,
                        },
                        '.fade-enter-active, .fade-exit-active': {
                            transition: 'opacity 500ms',
                        },
                    },
                    '*': {
                        '&::-webkit-outer-spin-button, &::-webkit-inner-spin-button':
                            {
                                WebkitAppearance: 'none',
                                margin: 0,
                            },
                        '&::-webkit-scrollbar': {
                            width: 6,
                            background: '#121212',
                        },
                        '&::-webkit-scrollbar-track': {
                            background: 'transparent',
                        },
                        '&::-webkit-scrollbar-thumb': {
                            background: '#ed0919',
                        },
                        '&::-webkit-scrollbar-thumb:hover': {
                            background: '#fb5560',
                            Transition: 'background ease-in 0.15s',
                        },
                    },
                    html: {
                        background:
                            process.env.NODE_ENV != 'production'
                                ? '#1e1e1e'
                                : 'transparent',
                        'input::-webkit-outer-spin-button, input::-webkit-inner-spin-button':
                            {
                                WebkitAppearance: 'none',
                                margin: 0,
                            },
                        'textarea:focus, input:focus': {
                            outline: 'none',
                        },
                    },
                    '@keyframes critical': {
                        '0%, 49%': {
                            backgroundColor: '#11121b',
                        },
                        '50%, 100%': {
                            backgroundColor: '#1b1c2c',
                        },
                    },
                    '@keyframes critical-border': {
                        '0%, 49%': {
                            borderColor: '#ffffffc7',
                        },
                        '50%, 100%': {
                            borderColor: `#de3333`,
                        },
                    },
                },
            },
            MuiPaper: {
                styleOverrides: {
                    root: {
                        background: '#11121b',
                    },
                },
            },
        },
    });

    useEffect(() => {
        Nui.send('loaded');
    }, []);

    return (
        <StyledEngineProvider injectFirst>
            <ThemeProvider theme={muiTheme}>
                <CssBaseline />
                <Chat />
            </ThemeProvider>
        </StyledEngineProvider>
    );
};

App.propTypes = {
    hidden: PropTypes.bool.isRequired,
};

const mapStateToProps = (state) => ({ hidden: state.app.hidden });

export default connect(mapStateToProps)(App);
