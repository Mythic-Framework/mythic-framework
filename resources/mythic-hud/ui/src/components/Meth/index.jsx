import React from 'react';
import { useSelector } from 'react-redux';
import {
    Dialog,
    DialogActions,
    DialogContent,
    DialogTitle,
    Button,
    Grid,
    Slider,
    Typography,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import useKeypress from 'react-use-keypress';

import Nui from '../../util/Nui';
import { Sanitize } from '../../util/Parser';
import { useState } from 'react';

const useStyles = makeStyles((theme) => ({
    wrapper: {},
    input: {
        marginTop: 15,
    },
}));

const IngredientLabel = [
    'Acetone',
    'Battery Acid',
    'Iodine Crystals',
    'Sulfuric Acid',
    'Phosphorous',
    'Gasoline',
    'Lithium',
    'Anhydrous Ammonia',
];

export default () => {
    const classes = useStyles();
    const config = useSelector((state) => state.meth.config);

    const onClose = () => {
        Nui.send('Meth:Cancel');
    };

    const onSubmit = (e) => {
        e.preventDefault();

        let vals = {
            tableId: config.tableId,
            ingredients: Array(),
            cookTime: +e.target.cooktime.value,
        };

        for (var i = 0; i < config.ingredients; i++) {
            vals.ingredients.push(+(e.target[`ingredient${i}`].value || 0));
        }

        Nui.send('Meth:Start', vals);
    };

    useKeypress(['Escape'], () => {
        onClose();
    });

    const createIngredientSliders = () => {
        let arr = Array();
        for (var i = 0; i < config.ingredients; i++) {
            arr.push(
                <Grid key={`ing-${i}`} item xs={12}>
                    <Typography id={`ingredient${i}-label`} gutterBottom>
                        {IngredientLabel[i]}
                    </Typography>
                    <Slider
                        step={1}
                        defaultValue={0}
                        valueLabelDisplay="auto"
                        name={`ingredient${i}`}
                        getAriaValueText={(v) => `${v}`}
                        aria-labelledby={`ingredient${i}-label`}
                    />
                </Grid>,
            );
        }
        return arr;
    };

    return (
        <Dialog fullWidth maxWidth="sm" open={true} onClose={onClose}>
            <form onSubmit={onSubmit}>
                <DialogTitle>Select Ingredient Mixture</DialogTitle>
                <DialogContent style={{ paddingTop: 15, overflow: 'hidden' }}>
                    <Grid container spacing={2}>
                        {createIngredientSliders()}
                        <Grid item xs={12}>
                            <Typography id={`cooktime-label`} gutterBottom>
                                Cook Time (Minutes)
                            </Typography>
                            <Slider
                                step={1}
                                min={1}
                                max={config.cookTimeMax}
                                defaultValue={1}
                                valueLabelDisplay="auto"
                                name="cooktime"
                                aria-labelledby={`cooktime-label`}
                            />
                        </Grid>
                    </Grid>
                </DialogContent>
                <DialogActions>
                    <Button onClick={onClose} color="error">
                        Cancel
                    </Button>
                    <Button type="submit" color="success">
                        Submit
                    </Button>
                </DialogActions>
            </form>
        </Dialog>
    );
};
