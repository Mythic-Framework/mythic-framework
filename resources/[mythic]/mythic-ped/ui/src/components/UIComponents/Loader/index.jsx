import React from 'react';
import { makeStyles } from '@mui/styles'
import './style.css';

const useStyles = makeStyles(theme => ({
  loader: {
    width: '100%',
    height: '100%',
    position: 'relative',
    transform: 'translateZ(0) scale(0.75)',
    backfaceVisibility: 'hidden',
    '& div': {
      position: 'absolute',
      width: 40,
      height: 40,
      background: theme.palette.primary.main,
      animation: 'loader 1s linear infinite',
      boxSizing: 'content-box',
    },
  },
  loaderBlocks: {
    width: 200,
    height: 200,
    display: 'inline-block',
    overflow: 'hidden',
    background: 'transparent',
  },
}));

export default () => {
  const classes = useStyles();

  return (
    <div className={classes.loaderBlocks}>
      <div className={classes.loader}>
        <div style={{ left: 38, top: 38, animationDelay: '0s' }}></div>
        <div style={{ left: 80, top: 38, animationDelay: '0.125s' }}></div>
        <div style={{ left: 122, top: 38, animationDelay: '0.25s' }}></div>
        <div style={{ left: 38, top: 80, animationDelay: '0.875s' }}></div>
        <div style={{ left: 80, top: 80, animation: 'none' }}></div>
        <div style={{ left: 122, top: 80, animationDelay: '0.375s' }}></div>
        <div style={{ left: 38, top: 122, animationDelay: '0.75s' }}></div>
        <div style={{ left: 80, top: 122, animationDelay: '0.625s' }}></div>
        <div style={{ left: 122, top: 122, animationDelay: '0.5s' }}></div>
      </div>
    </div>
  );
};
