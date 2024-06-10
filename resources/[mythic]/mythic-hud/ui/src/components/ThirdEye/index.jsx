import React, { Fragment, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { Fade, Button } from '@mui/material';
import { makeStyles } from '@mui/styles';
import useKeypress from 'react-use-keypress';
import Nui from '../../util/Nui';

const useStyles = makeStyles((theme) => ({
    outer: {
        width: '100%',
        position: 'absolute',
        bottom: '50%',
        textAlign: 'center',
        transform: 'translateY(50%)',
    },
    menuOuter: {
        display: 'flex',
        justifyContent: 'center',
        alignContent: 'center',
    },
    menuList: {
        listStyle: 'none',
        width: 'fit-content',
        height: 'fit-content',
        position: 'absolute',
        left: 0,
        right: 0,
        top: 35,
        margin: 'auto',
        textAlign: 'left',
        transform: 'translateX(25%)',
        fontSize: 18,
    },
    menuItem: {
        color: theme.palette.text.main,
        marginBottom: 5,
        transition: 'color ease-in 0.15s',
        fontWeight: 'bold',
        textShadow: '0 0 5px #000',
        '&:hover': {
            color: theme.palette.primary.light,
            cursor: 'pointer',
        },
        '& svg': {
            marginRight: 5,
        },
    },
    icon: {
        fontSize: '0.5rem',
        transition: '.5s',
        color: theme.palette.text.main,
    },
    focused: {
        fontSize: '2rem',
        color: theme.palette.primary.dark,
    },
}));

export default () => {
    const classes = useStyles();
    const dispatch = useDispatch();
    const showing = useSelector((state) => state.thirdEye.showing);
    const icon = useSelector((state) => state.thirdEye.icon);
    const menuOpen = useSelector((state) => state.thirdEye.menuOpen);
    const menu = useSelector((state) => state.thirdEye.menu);

    const menuButtonClick = (e, event, data) => {
        e.stopPropagation();
        Nui.send('targetingAction', {
            event,
            data,
        });
    };

    const closeMenu = () => {
        Nui.send('targetingAction', false);
    };

    useKeypress(['Escape', 'Backspace'], () => {
        if (!showing) return;
        else closeMenu();
    });

    const menuElements = menu.map((button, i) => {
        return (
            <li
                key={i}
                color="secondary"
                onClick={(e) => menuButtonClick(e, button.event, button.data)}
                variant="contained"
                className={classes.menuItem}
            >
                {button.icon && <FontAwesomeIcon icon={button.icon} />}
                {button.text}
            </li>
        );
    });

    if (menuElements.length <= 1) {
        menuElements.push(<div className={classes.menuButton} key={'x'}></div>);
        menuElements.reverse();
    }

    let menuRadius = 50 + menuElements.length * 1.8 * 10;

    if (menuRadius < 80) {
        menuRadius = 80;
    } else if (menuRadius > 900) {
        menuRadius = 900;
    }

    return (
        <Fragment>
            <Fade in={showing} duration={1500}>
                <div className={classes.outer}>
                    <FontAwesomeIcon
                        className={`${icon && classes.focused} ${classes.icon}`}
                        icon={icon ? icon : 'circle'}
                    />
                    <Fade
                        in={menuOpen && menuElements.length > 0}
                        duration={1500}
                    >
                        <ul className={classes.menuList}>{menuElements}</ul>
                    </Fade>
                </div>
            </Fade>
        </Fragment>
    );
};
