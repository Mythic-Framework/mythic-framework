import React, { useState, useEffect } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { useHistory } from 'react-router-dom';
import { AppBar, Grid, Chip, Select, MenuItem, IconButton, Tooltip, TextField, FormControlLabel, Checkbox } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
//const processString = require('react-process-string');
import { CopyToClipboard } from 'react-copy-to-clipboard';
import ReactPlayer from 'react-player';
import Moment from 'react-moment';
import { Modal } from '../../components';

import { Editor, LightboxImage } from '../../components';

import JsxParser from 'react-jsx-parser'

//import { Sanitize } from '../../util/Parser';
import { useAlert } from '../../hooks';
import Nui from '../../util/Nui';

const useStyles = makeStyles((theme) => ({
    wrapper: {
        height: '100%',
        background: theme.palette.secondary.main,
        overflowY: 'auto',
        overflowX: 'hidden',
    },
	header: {
		background: '#696969',
		fontSize: 20,
		padding: 15,
		lineHeight: '50px',
		height: 78,
	},
    subHeader: {
        padding: '7px 15px',
        backgroundColor: '#414141',
    },
    subsubHeader: {
        padding: '7px 15px',
        backgroundColor: theme.palette.secondary.light,
    },
    container: {
        padding: '10px 20px',
        height: '80%',
        overflow: 'hidden',
        //overflowY: 'auto',
    },
    body: {
        padding: '10px 20px',
        height: '70%',
        overflowX: 'hidden',
        overflowY: 'auto',
    },
    editField: {
		marginTop: 20,
		width: '100%',
	},
    signature: {
        padding: '15px 35px',
        height: '12%',
        overflowX: 'hidden',
        overflowY: 'auto',
        textAlign: 'center',
    },
    input: {
        width: '100%',
        padding: '0 10px',
    },
    messageImg: {
        display: 'block',
        maxWidth: 200,
    },
    copyableText: {
        color: theme.palette.primary.main,
        textDecoration: 'underline',
        '&:hover': {
            transition: 'color ease-in 0.15s',
            color: theme.palette.text.main,
            cursor: 'pointer',
        },
    },
    documentContainer: {
        overflowWrap: 'break-word',
        '& .ql-size-huge': {
            fontSize: '2.5em',
        },
        '& .ql-size-large': {
            fontSize: '1.5em',
        },
        '& .ql-size-small': {
            fontSize: '0.75em',
        },
        '& .ql-font-serif': {
            fontFamily: 'Georgia, Times New Roman, serif',
        },
        '& .ql-font-monospace': {
            fontFamily: 'Monaco, Courier New, monospace',
        },
        '& .ql-align-center': {
            textAlign: 'center',
        },
        '& .ql-align-right': {
            textAlign: 'right',
        },
        '& .ql-align-justify': {
            textAlign: 'justify',
        },
        '& .ql-syntax': {
            color: '#f8f8f2',
            overflow: 'visible',
            backgroundColor: '#23241f !important',
        }
    },
}));

export default (props) => {
    const classes = useStyles();
    const dispatch = useDispatch();
	const history = useHistory();
	const showAlert = useAlert();
	const { id, mode } = props.match.params;
    const docMode = (mode == 'edit' || mode == 'new') ? mode : false;

    const player = useSelector((state) => state.data.data.player);
    const myDocs = useSelector(state => state.data.data.myDocuments);
    const doc = myDocs.find(d => d._id === id);

    const [sharing, setSharing] = useState(null);

    const [reqSignature, setReqSignature] = useState(false);
    const [signed, setSigned] = useState(false);
    const [disableSignature, setDisableSignature] = useState(false);

    const [viewSignatures, setViewSignatures] = useState(false);

    const [document, setDocument] = useState({
        title: doc?.title ?? '',
        content: doc?.content ?? '',
        time: 1645026791,
    });

    useEffect(() => {
        if ((!docMode || docMode === 'edit' && doc)) {
            setDocument(doc);
        }

        if (!docMode) {
            if (doc.signed && doc.signed.length > 0) {
                const hasSigned = doc.signed.find(sig => sig.ID == player.ID);
                setSigned(Boolean(hasSigned));
                setDisableSignature(Boolean(hasSigned));
            } else {
                setSigned(false);
                setDisableSignature(false);
            }

            let reqSig = false
            if (doc.sharedWith && doc.sharedWith.length > 0) {
                const isShared = doc.sharedWith.find(p => p.ID == player.ID);
                if (isShared && isShared.RequireSignature) {
                    reqSig = true
                };
            }

            setReqSignature(reqSig);
        }
    }, [id, mode]);

    const onStartEdit = () => {
        history.push(`/apps/documents/view/${id}/edit`);
    };

    const onEdit = async () => {
        if (docMode === 'edit') {
            if (document.title.length >= 2) {
                try {
                    let res = await(await Nui.send('EditDocument', {
                        id: document._id,
                        data: {
                            title: document.title,
                            content: document.content,
                        }
                    })).json();

                    if (res) {
                        dispatch({
                            type: 'UPDATE_DATA',
                            payload: { type: 'myDocuments', id: document._id, data: document },
                        });

                        history.replace(`/apps/documents/view/${id}/v`);
                        showAlert('Document Edited Successfully');
                    } else {
                        showAlert('Error Editing Document');
                    }
                } catch(err) {
                    console.log(err);
                    showAlert('Error Editing Document');
                }
            } else {
                showAlert('Must Include Title');
            }
        }
    };

    const onDelete = async () => {
        try {
            let res = await(await Nui.send('DeleteDocument', {
                id: document._id,
            })).json();

            if (res) {
                dispatch({
                    type: 'REMOVE_DATA',
                    payload: { type: 'myDocuments', id: document._id },
                });

                history.replace(`/apps/documents/`);
                showAlert('Document Deleted Successfully');
            } else {
                showAlert('Error Deleting Document');
            }
        } catch(err) {
            console.log(err);
            showAlert('Error Deleting Document');
        }
    };

    const onCreate = async () => {
        try {
            let res = await(await Nui.send('CreateDocument', document)).json();

            if (res) {
                dispatch({
                    type: 'ADD_DATA',
                    payload: {
                        type: 'myDocuments',
                        data: res,
                    },
                });

                history.replace(`/apps/documents/view/${res._id}/v`);
                showAlert('Document Created Successfully');
            } else {
                showAlert('Error Creating Document');
            }
        } catch(err) {
            console.log(err);
            showAlert('Error Creating Document');
        }
    };

    const onShare = async (isNearby) => {
        setSharing({
            target: '',
            type: 1,
            nearby: isNearby,
        })
    };

    const onConfirmShare = async () => {
        const sending = {
            ...sharing,
            target: +sharing.target,
            document,
        };

        setSharing(null);

        try {
			let res = await (await Nui.send('ShareDocument', sending)).json();
			showAlert(res ? 'Document Shared' : 'Unable to Share Document');
		} catch (err) {
			console.log(err);
			showAlert('Unable to Share Document');
		}
    };

    const onSignature = async (e) => {
        setDisableSignature(true);

        try {
			let res = await (await Nui.send('SignDocument', document._id)).json();
            if (res) {
                showAlert('Document Signed');
                setSigned(true);
            } else {
                showAlert('Unable to Sign Document');
                setDisableSignature(false);
            }
		} catch (err) {
			console.log(err);
			showAlert('Unable to Sign Document');
            setDisableSignature(false);
		}
    };

    // const onShare = () => {

    // }

	const config = [
		{
			regex: /((https?:\/\/(www\.)?(i\.)?imgur\.com\/[a-zA-Z\d]+)(\.png|\.jpg|\.jpeg|\.gif)?)/gim,
            replace: `<LightboxImage className={classes.messageImg} src={"$1"} />`
		},
        {
			regex: /(http|https):\/\/(\S+)\.([a-z]{2,}?)(.*?)( |\,|$|\.)(mp4)/gim,
            replace: `<div>
    			<ReactPlayer
    				key={key}
    				volume={0.25}
    				width="100%"
    				controls={true}
    				url={"$1"}
    			/>
    		</div>`
		},
		// {
		// 	regex: /(http|https):\/\/(\S+)\.([a-z]{2,}?)(.*?)( |\,|$|\.)(mp4)/gim,
		// 	fn: (key, result) => (
		// 		<div>
		// 			<ReactPlayer
		// 				key={key}
		// 				volume={0.25}
		// 				width="100%"
		// 				controls={true}
		// 				url={`${result[0]}`}
		// 			/>
		// 		</div>
		// 	),
		// },
		// {
		// 	regex: /(http|https):\/\/(\S+)\.([a-z]{2,}?)(.*?)( |\,|$|\.)/gim,
		// 	fn: (key, result) => (
		// 		<CopyToClipboard
		// 			text={result[0]}
		// 			key={key}
		// 			onCopy={() => showAlert('Link Copied To Clipboard')}
		// 		>
		// 			<a className={classes.copyableText}>{result.input}</a>
		// 		</CopyToClipboard>
		// 	),
		// },
		// {
		// 	regex: /(\S+)\.([a-z]{2,}?)(.*?)( |\,|$|\.)/gim,
		// 	fn: (key, result) => (
		// 		<CopyToClipboard
		// 			text={result[0]}
		// 			key={key}
		// 			onCopy={() => showAlert('Link Copied To Clipboard')}
		// 		>
		// 			<a className={classes.copyableText}>{result.input}</a>
		// 		</CopyToClipboard>
		// 	),
		// },
	];

    let cont = document?.content ?? '';
    config.forEach(c => {
        cont = cont.replace(c.regex, c.replace);
    });

	return (
        <>
            <div className={classes.wrapper}>
                <AppBar position="static" className={classes.header}>
                    <Grid container>
                        <Grid item xs={7} style={{ lineHeight: '50px' }}>
                            My Documents
                        </Grid>
                        <Grid item xs={5} style={{ textAlign: 'right' }}>
                            {docMode == 'new' &&
                                <Tooltip title="Create">
                                    <span>
                                        <IconButton
                                            className={classes.headerAction}
                                            onClick={onCreate}
                                        >
                                            <FontAwesomeIcon
                                                className={'fa'}
                                                icon={['fas', 'floppy-disk']}
                                            />
                                        </IconButton>
                                    </span>
                                </Tooltip>
                            }
                            {docMode == 'edit' &&
                                <Tooltip title="Edit & Save">
                                    <span>
                                        <IconButton
                                            className={classes.headerAction}
                                            onClick={onEdit}
                                        >
                                            <FontAwesomeIcon
                                                className={'fa'}
                                                icon={['fas', 'floppy-disk-pen']}
                                            />
                                        </IconButton>
                                    </span>
                                </Tooltip>
                            }
                            {(!docMode && (document.owner == player.ID) && (!document.signed || document?.signed?.length <= 0)) && <>
                                <Tooltip title="Edit">
                                    <span>
                                        <IconButton
                                            className={classes.headerAction}
                                            onClick={onStartEdit}
                                        >
                                            <FontAwesomeIcon
                                                className={'fa'}
                                                icon={['fas', 'pen-to-square']}
                                            />
                                        </IconButton>
                                    </span>
                                </Tooltip>
                            </>}
                            {(!docMode || docMode == 'edit') && <>
                                <Tooltip title="Delete">
                                    <span>
                                        <IconButton
                                            className={classes.headerAction}
                                            onClick={onDelete}
                                        >
                                            <FontAwesomeIcon
                                                className={'fa'}
                                                icon={['fas', 'trash-can-xmark']}
                                            />
                                        </IconButton>
                                    </span>
                                </Tooltip>
                            </>}
                            {!docMode && <>
                                {(document.signed && document.signed.length > 0) && <Tooltip title="View Signatures">
                                    <span>
                                        <IconButton
                                            className={classes.headerAction}
                                            onClick={() => setViewSignatures(true)}
                                        >
                                            <FontAwesomeIcon
                                                className={'fa'}
                                                icon={['fas', 'signature']}
                                            />
                                        </IconButton>
                                    </span>
                                </Tooltip>}
                                <Tooltip title="Share">
                                    <span>
                                        <IconButton
                                            className={classes.headerAction}
                                            onClick={() => onShare(false)}
                                        >
                                            <FontAwesomeIcon
                                                className={'fa'}
                                                icon={['fas', 'share']}
                                            />
                                        </IconButton>
                                    </span>
                                </Tooltip>
                                <Tooltip title="Nearby Share">
                                    <span>
                                        <IconButton
                                            className={classes.headerAction}
                                            onClick={() => onShare(true)}
                                        >
                                            <FontAwesomeIcon
                                                className={'fa'}
                                                icon={['fas', 'tower-broadcast']}
                                            />
                                        </IconButton>
                                    </span>
                                </Tooltip>
                                {/* <Tooltip title="Share">
                                    <span>
                                        <IconButton
                                            className={classes.headerAction}
                                            onClick={() => setSharing('')}
                                        >
                                            <FontAwesomeIcon
                                                className={'fa'}
                                                icon={['fas', 'share']}
                                            />
                                        </IconButton>
                                    </span>
                                </Tooltip> */}
                            </>}
                        </Grid>
                    </Grid>
                </AppBar>
                <AppBar position="static" className={classes.subHeader}>
                    <Grid container>
                        <Grid item xs={6} style={{ maxWidth: '20ch', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                            {document.title}
                        </Grid>
                        <Grid item xs={6} style={{ textAlign: 'right' }}>
                            {(docMode != 'new' && document.time) && <>
                                Edited {' '}
                                <Moment
                                    className={classes.postedTime}
                                    interval={60000}
                                    fromNow
                                    unix
                                >
                                    {+document.time}
                                </Moment>
                            </>}
                        </Grid>
                    </Grid>
                </AppBar>
                {!docMode ?
                    <>
                        <div className={classes.body}>
                            {/* //{JsxParser(document.content)} */}
                            <JsxParser
                                autoCloseVoidElements
                                bindings={{
                                    classes,
                                }}
                                className={classes.documentContainer}
                                components={{ LightboxImage, ReactPlayer, CopyToClipboard }}
                                jsx={cont}
                                blacklistedTags={['iframe', 'script', 'link', 'applet', 'style']}
                            />
                        </div>
                        {reqSignature && <div className={classes.signature}>
                            <FormControlLabel control={<Checkbox disabled={disableSignature} checked={signed} onChange={(e) => onSignature(e)} />} label={`${signed ? 'Document Signed' : 'Sign Document'} (as ${player.First[0]}. ${player.Last})`} />
                        </div>}
                    </>
                    :
                    <div className={classes.container}>
                        <TextField
                            className={classes.creatorInput}
                            fullWidth
                            label="Title"
                            variant="outlined"
                            onChange={(e) => {
                                setDocument({
                                    ...document,
                                    title: e.target.value,
                                })
                            }}
                            value={document.title}
                            inputProps={{
                                maxLength: 100,
                            }}
                        />
                        <Editor
                            value={document.content}
                            onChange={(e) => {
                                setDocument({
                                    ...document,
                                    content: e,
                                })
                            }}
                            placeholder="Write Stuff Here"
                        />
                    </div>
                }
            </div>
            {sharing != null &&
                <Modal
                    open={sharing != null}
                    title="Share This Document"
                    onAccept={onConfirmShare}
                    onClose={() => setSharing(null)}
                    acceptLang="Share"
                    closeLang="Cancel"
                >
                    <div>
                        Sharing without making a copy will allow the recipient to see any changes you make to the document!
                        <Select
                            id="targetType"
                            name="targetType"
                            className={classes.editField}
                            value={sharing.type}
                            onChange={(e) => {
                                setSharing({
                                    ...sharing,
                                    type: e.target.value,
                                })
                            }}
                        >
                            <MenuItem value={1}>Share a Copy</MenuItem>
                            <MenuItem value={2} disabled={document.owner !== player.ID || document.shared}>Share</MenuItem>
                            <MenuItem value={3} disabled={document.owner !== player.ID || document.shared}>Share w/ Signature Request</MenuItem>
                        </Select>
                        {!sharing.nearby && <TextField
                            required
                            fullWidth
                            className={classes.editField}
                            label="State ID"
                            name="target"
                            type="text"
                            value={sharing.target}
                            helperText={'The State ID of who you want to share the document with.'}
                            inputProps={{
                                maxLength: 6,
                            }}
                            onChange={(e) => {
                                setSharing({
                                    ...sharing,
                                    target: e.target.value,
                                })
                            }}
                        />}
                    </div>
                </Modal>
            }
            {viewSignatures &&
                <Modal
                    open={viewSignatures}
                    title="Document Signatures"
                    onClose={() => setViewSignatures(false)}
                    closeLang="Close"
                >
                    <div>
                        {document.signed.map(s => {
                            return <p key={s.ID}>
                                {`${s.First} ${s.Last} (State ID: ${s.SID}) on `}
                                <Moment format="LLL" unix>{+s.Time}</Moment>
                            </p>
                        })}
                    </div>
                </Modal>
            }
        </>
	);
};
