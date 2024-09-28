import React, { useEffect, useState, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles, withStyles } from '@mui/styles';
import {
    Grid,
    TextField,
    FormControlLabel,
    Checkbox,
    Button,
    Alert,
} from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Nui from '../../../util/Nui';
import { useAlert } from '../../../hooks';

const useStyles = makeStyles((theme) => ({
    wrapper: {
        padding: '20px 10px 20px 20px',
        height: '100%',
    },
    editField: {
        marginBottom: 15,
        '&::-webkit-scrollbar': {
            width: 6,
        },
        '&::-webkit-scrollbar-thumb': {
            background: '#ffffff52',
        },
        '&::-webkit-scrollbar-thumb:hover': {
            background: '#1de9b6',
        },
        '&::-webkit-scrollbar-track': {
            background: 'transparent',
        },
    },
    preview: {
        width: 200,
        margin: 'auto',
        display: 'block',
    },
    button: {

    }
}));

export default ({ onNav }) => {
    const classes = useStyles();
    const dispatch = useDispatch();
    const showAlert = useAlert();
    const [state, setState] = useState({
        tweet: '',
        usingImg: false,
        imgLink: '',
    });

    const onStateChange = (e) => {
        setState({
            ...state,
            [e.target.name]: e.target.value,
        });
    };

    const SendTweet = async (tweet) => {
        try {
            let res = await (await Nui.send('SendTweet', tweet)).json();

            if (res) {
                setState({
                    tweet: '',
                    usingImg: false,
                    imgLink: '',
                });
                return true;
            } else {
                return false;
            }
        } catch (err) {
            console.log(err);
            return false;
        }
    };

    const onCreate = async (e) => {
        let res = await SendTweet({
            time: Date.now(),
            content: state.tweet,
            image: {
                using: state.usingImg,
                link: state.imgLink,
            },
            likes: Array(),
        });

        if (res) onNav("Dashboard");

        showAlert(res ? 'Tweet Created' : 'Unable to Create Tweet');
    };

    return (
        <div className={classes.wrapper}>
            <Grid container spacing={1}>
                <Grid item xs={12}>
                    <Alert severity="info">Please use for business purposes only. Abuse of this will have your business permanently banned from using Twitter.</Alert>
                </Grid>
                <Grid item xs={10}>
                    <TextField
                        className={classes.editField}
                        label="Tweet"
                        name="tweet"
                        type="text"
                        fullWidth
                        multiline
                        required
                        helperText={`${state.tweet.length} / 180 Characters`}
                        value={state.tweet}
                        onChange={onStateChange}
                        inputProps={{
                            maxLength: 180,
                        }}
                    />
                </Grid>
                <Grid item xs={2}>
                    <Button variant="outlined" fullWidth onClick={onCreate}>
                        Post Tweet
                    </Button>
                </Grid>
            </Grid>

            <FormControlLabel
                control={
                    <Checkbox
                        checked={state.pinned}
                        onChange={(e) => {
                            setState({ ...state, usingImg: e.target.checked });
                        }}
                        name="pinned"
                        color="primary"
                    />}
                label="Include An Image?"
            />
            {state.usingImg && (
                <>
                    <TextField
                        className={classes.editField}
                        label="Image"
                        name="imgLink"
                        helperText="Imgur Links Only!"
                        type="text"
                        fullWidth
                        required
                        value={state.imgLink}
                        onChange={onStateChange}
                        InputLabelProps={{
                            style: { fontSize: 20 },
                        }}
                    />
                    {state.imgLink != '' && (
                        <img
                            src={state.imgLink}
                            className={classes.preview}
                        />
                    )}
                </>
            )}
        </div>
    );
};