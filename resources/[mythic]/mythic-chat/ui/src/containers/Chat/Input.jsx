import React, { Fragment, useEffect, useState, useRef } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Fade, List, ListItem, ListItemText } from '@mui/material';
import { makeStyles } from '@mui/styles';

import Nui from '../../util/Nui';
import Suggestion from './components/Suggestion';

const useStyles = makeStyles((theme) => ({
    wrapper: {
        fontSize: '1.65vh',
        position: 'absolute',
        top: 'calc(26% + 25px)',
        left: 25,
        width: '30%',
        maxWidth: 1000,
        boxSizing: 'border-box',
        border: `1px solid ${theme.palette.border.input}`,
    },
    input: {
        position: 'relative',
        display: 'flex',
        alignItems: 'stretch',
        width: '100%',
        backgroundColor: theme.palette.secondary.dark,
    },
    prefix: {
        fontSize: '1.6vh',
        height: '100%',
        verticalAlign: 'middle',
        lineHeight: 'calc(1vh + 1vh + 1.85vh)',
        paddingLeft: '0.5vh',
        textTransform: 'uppercase',
        fontWeight: 'bold',
        display: 'inline-block',
    },
    textarea: {
        fontSize: '1.35vh',
        lineHeight: '1.85vh',
        display: 'block',
        boxSizing: 'content-box',
        padding: '1vh',
        paddingLeft: '0.5vh',
        color: theme.palette.text.main,
        borderWidth: 0,
        height: '3.15%',
        overflow: 'hidden',
        textOverflow: 'ellipsis',
        flex: 1,
        backgroundColor: 'transparent',
        resize: 'none',
    },
    suggestionsWrapper: {
        fontSize: 16,
        position: 'absolute',
        top: 'calc(30% + 25px)',
        left: 25,
        width: '30%',
        maxWidth: 1000,
        boxSizing: 'border-box',
        border: `1px solid ${theme.palette.border.input}`,
        borderTop: 'none',
        backgroundColor: theme.palette.secondary.dark,
    },
}));

export default () => {
    const classes = useStyles();
    const dispatch = useDispatch();
    const hidden = useSelector((state) => state.app.hidden);
    const suggestions = useSelector((state) => state.chat.suggestions);
    const inputs = useSelector((state) => state.chat.inputs);

    const inputRef = useRef();

    const [history, setHistory] = useState(0);
    const [value, setValue] = useState('');
    const [isCommand, setIsCommand] = useState(false);
    const [showSuggs, setShowSuggs] = useState(Array());

    const currentParamIndex =
        value.match(/(| )([^\s"]+|"([^"]*)"| $)/g)?.length - 2;

    useEffect(() => {
        if (!hidden) inputRef.current.focus();
        //else inputRef.current.blur();
    }, [hidden]);

    useEffect(() => {
        setIsCommand(value != '' && value[0] == '/');
    }, [value]);

    useEffect(() => {
        setShowSuggs(
            suggestions.filter((f) => f.name.startsWith(value.split(' ')[0])),
        );
    }, [value]);

    useEffect(() => {
        if (history > 0) setValue(inputs[history - 1]);
        else setValue('');
    }, [history]);

    const onChange = (e) => {
        setValue(e.target.value);
    };

    const onBlur = (e) => {
        e.preventDefault();
        if (!Boolean(inputRef.current)) return;
        inputRef.current.focus();
    };

    const onKeyDown = (e) => {
        if (e.which == 13) {
            e.preventDefault();
            if (value != '') {
                dispatch({
                    type: 'ON_SUBMIT',
                    payload: {
                        message: value,
                    },
                });
                Nui.send('chatResult', { message: value });
                dispatch({
                    type: 'ON_SCREEN_STATE_CHANGE',
                    payload: {
                        shouldHide: true,
                        inputting: false,
                    },
                });
                setValue('');
            } else if (value == '') {
                dispatch({
                    type: 'ON_SCREEN_STATE_CHANGE',
                    payload: {
                        shouldHide: true,
                        inputting: false,
                    },
                });
                Nui.send('chatResult', { cancelled: true });
                setHistory(0);
                setValue('');
            }
        } else if (e.which == 9) {
            e.preventDefault();
            if (isCommand && showSuggs.length > 0) {
                setValue(`${showSuggs[0].name} `);
            }
        } else if (e.which == 27) {
            dispatch({
                type: 'ON_SCREEN_STATE_CHANGE',
                payload: {
                    shouldHide: true,
                    inputting: false,
                },
            });
            Nui.send('chatResult', { cancelled: true });
            setHistory(0);
            setValue('');
        } else if (
            e.code == 'ArrowUp' &&
            inputs.length > 0 &&
            history + 1 <= inputs.length
        ) {
            setHistory(history + 1);
        } else if (e.code == 'ArrowDown' && inputs.length > 0 && history > 0) {
            setHistory(history - 1);
        }
    };

    return (
        <div>
            <div className={classes.wrapper}>
                <div className={classes.input}>
                    <span
                        className={classes.prefix}
                        style={{ color: 'rgb(255, 255, 255)' }}
                    >
                        ➤
                    </span>{' '}
                    <textarea
                        className={classes.textarea}
                        type="text"
                        autoFocus="autofocus"
                        spellCheck="false"
                        rows="1"
                        value={value}
                        ref={inputRef}
                        onKeyDown={onKeyDown}
                        onChange={onChange}
                        onBlur={onBlur}
                    ></textarea>
                </div>
            </div>
            {isCommand && (
                <List className={classes.suggestionsWrapper}>
                    {showSuggs.length > 0 ? (
                        showSuggs
                            .sort((a, b) => a.name.localeCompare(b.name))
                            .slice(0, 6)
                            .map((sugg, i) => {
                                if (i == 0) {
                                    return (
                                        <Suggestion
                                            isFirst
                                            suggestion={sugg}
                                            parameterIndex={currentParamIndex}
                                        />
                                    );
                                } else {
                                    return (
                                        <Suggestion
                                            suggestion={sugg}
                                            parameterIndex={currentParamIndex}
                                        />
                                    );
                                }
                            })
                    ) : (
                        <ListItem dense>
                            <ListItemText primary="No Matching Commands" />
                        </ListItem>
                    )}
                </List>
            )}
        </div>
    );
};
