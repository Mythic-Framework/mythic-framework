import React, { useState } from 'react';
import { Grid, Fade, Button, Dialog, DialogTitle, DialogContent } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import Nui from '../../util/Nui';

const useStyles = makeStyles(theme => ({
    div: {
        border: `2px solid ${theme.palette.border.divider}`,
        background: theme.palette.secondary.light,
        color: theme.palette.text.main,
        fontSize: 13,
        height: 42,
        width: '100%',
        textAlign: 'center',
        userSelect: 'none',
        transition: 'filter ease-in 0.15s',
        marginBottom: 5,
        borderRadius: 3,
        '&:hover': {
            background: theme.palette.secondary.light,
            filter: 'brightness(0.7)',
        },
    },
    preview: {
        width: 60,
        height: 25,
        border: `2px solid ${theme.palette.text.main}`,
        transition: 'background 0.15s',
    },
    colorButton: {
        width: '100%',
        display: 'block',
        height: 42,
        fontSize: 16,
        padding: '0 10px',
        fontWeight: 500,
        textAlign: 'center',
        textDecoration: 'none',
        textShadow: 'none',
        whiteSpace: 'nowrap',
        verticalAlign: 'middle',
        borderRadius: 3,
        transition: '0.1s all linear',
        userSelect: 'none',
        marginBottom: 5,
        border: `2px solid ${theme.palette.border.divider}`,
        background: theme.palette.secondary.light,
        color: theme.palette.text.main,
        '&:hover': {
            background: theme.palette.secondary.light,
            filter: 'brightness(0.7)',
            cursor: 'pointer',
        },
    },
}));

export default ({ data }) => {
    const classes = useStyles();
    const [showList, setShowList] = useState(false);
    const [selectedColor, setSelectedColor] = useState(
        data.options.colors[data.options.current],
    );

    const onClick = () => {
        if (!data.options.disabled) {
            setShowList(!showList);
        }
    };

    const changeColor = index => {
        setSelectedColor(data.options.colors[index]);
		setShowList(!showList);
        Nui.send('Selected', {
            id: data.id,
            data: { color: data.options.colors[index] },
        });
    };

    const cssClass = data.options.disabled
        ? `${classes.div} disabled`
        : `${classes.div}${showList ? ' open' : ''}`;
    const style = data.options.disabled ? { opacity: 0.5 } : {};

    return (
        <div>
            <Button className={cssClass} style={style} onClick={onClick}>
                <Grid
                    container
                    style={{
                        alignItems: 'center',
                        height: '100%',
                    }}
                >
                    <Grid item xs={2}>
                        <div
                            className={classes.preview}
                            style={{
                                background:
                                    selectedColor.rgb != null
                                        ? `rgb(${selectedColor.rgb.r}, ${selectedColor.rgb.g}, ${selectedColor.rgb.b})`
                                        : selectedColor.hex,
                            }}
                        />
                    </Grid>
                    <Grid item xs={8}>
                        <span style={{ textShadow: '2px 2px #000' }}>
                            {selectedColor.label}
                        </span>
                    </Grid>
                </Grid>
            </Button>
            <Dialog fullWidth onClose={onClick} open={showList}>
                <DialogTitle onClose={onClick}>
                    Select Color
                </DialogTitle>
                <DialogContent dividers>
                {data.options.colors.map(function(color, i) {
                    return (
                        <div
                            className={classes.colorButton}
                            key={i}
                            onClick={() => {
                                changeColor(i);
                            }}
                        >
                            <Grid
                                container
                                style={{
                                    alignItems: 'center',
                                    height: '100%',
                                }}
                            >
                                <Grid item xs={2}>
                                    <div
                                        className={classes.preview}
                                        style={{
                                            background:
                                                color.rgb != null
                                                    ? `rgb(${color.rgb.r}, ${color.rgb.g}, ${color.rgb.b})`
                                                    : color.hex,
                                        }}
                                    />
                                </Grid>
                                <Grid item xs={8}>
                                    <span
                                        style={{
                                            textShadow: '2px 2px #000',
                                        }}
                                    >
                                        {color.label}
                                    </span>
                                </Grid>
                                <Grid item xs={2}></Grid>
                            </Grid>
                        </div>
                    );
                })}
                </DialogContent>
            </Dialog>
        </div>
    );
};
