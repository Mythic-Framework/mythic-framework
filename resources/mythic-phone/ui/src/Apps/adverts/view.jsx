import React, { useState, useEffect } from 'react';
import { useSelector } from 'react-redux';
import { useHistory } from 'react-router-dom';
import { AppBar, Grid, Chip, IconButton } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
//const processString = require('react-process-string');
import { CopyToClipboard } from 'react-copy-to-clipboard';
import ReactPlayer from 'react-player';
import Moment from 'react-moment';
import NumberFormat from 'react-number-format';

import JsxParser from 'react-jsx-parser'

import { LightboxImage } from '../../components';

//import { Sanitize } from '../../util/Parser';
import { useAlert } from '../../hooks';
import { Categories } from './data';
import ActionButtons from './ActionButtons';
import Nui from '../../util/Nui';

export default (props) => {
	const history = useHistory();
	const showAlert = useAlert();
	const { id } = props.match.params;
	const myId = useSelector((state) => state.data.data.player.Source);
	const adverts = useSelector((state) => state.data.data.adverts);
	const advert = useSelector((state) => state.data.data.adverts)[+id];

	useEffect(() => {
		if (adverts != null && advert == null) history.replace('/apps/adverts');
	}, [adverts, advert]);

	const cats = Categories.filter((cat) => {
		return advert != null ? advert.categories.includes(cat.label) : Array();
	});
	const callData = useSelector((state) => state.call.call);

	const callAdvert = async () => {
		if (advert.id === myId) return;
		if (callData == null) {
			try {
				let res = await (
					await Nui.send('CreateCall', {
						number: advert.number,
						isAnon: false,
					})
				).json();
				if (res) {
					history.push(`/apps/phone/call/${advert.number}`);
				} else showAlert('Unable To Start Call');
			} catch (err) {
				console.log(err);
				showAlert('Unable To Start Call');
			}
		}
	};

	const textAdvert = () => {
		if (advert.id === myId) return;
		history.push(`/apps/messages/convo/${advert.number}`);
	};

	const useStyles = makeStyles((theme) => ({
		wrapper: {
			height: '100%',
			background: theme.palette.secondary.main,
			overflowY: 'auto',
			overflowX: 'hidden',
		},
		header: {
			background: '#f9a825',
			fontSize: 20,
			padding: 15,
			lineHeight: '45px',
		},
		subHeader: {
			padding: '7px 15px',
			backgroundColor: '#a37225',
		},
		subsubHeader: {
			padding: '7px 15px',
			backgroundColor: theme.palette.secondary.light,
		},
		body: {
			padding: '10px 20px',
			height: '70%',
			overflowX: 'hidden',
			overflowY: 'auto',
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
		priceValue: {
			'&::before': {
				content: '"$"',
				color: theme.palette.success.main,
				marginRight: 2,
			},
			fontSize: 20,
		},
		category: {
			'&:hover': {
				filter: 'brightness(0.8)',
				transition: 'filter ease-in 0.15s',
				cursor: 'pointer',
			},
		},
	}));
	const classes = useStyles();

	const categoryClick = (category) => {
		history.push(`/apps/adverts/category-view/${category}`);
	};

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
		// 	regex: /((https?:\/\/(www\.)?(i\.)?imgur\.com\/[a-zA-Z\d]+)(\.png|\.jpg|\.jpeg|\.gif)?)/gim,
		// 	fn: (key, result) => (
        //         <LightboxImage
        //             key={key}
        //             className={classes.messageImg}
        //             src={result[0]}
        //         />
		// 	),
		// },
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

	let cont = advert?.full ?? '';
    config.forEach(c => {
        cont = cont.replace(c.regex, c.replace);
    });

	return (
		<div className={classes.wrapper}>
			{advert != null && (
				<>
					<AppBar position="static" className={classes.header}>
						{advert.title}
					</AppBar>
					<AppBar position="static" className={classes.subHeader}>
						<Grid container>
							<Grid item xs={6}>
								{advert.author}
							</Grid>
							<Grid item xs={6} style={{ textAlign: 'right' }}>
								<Moment
									className={classes.postedTime}
									interval={60000}
									fromNow
									date={+advert.time}
								/>
							</Grid>
						</Grid>
					</AppBar>
					<AppBar position="static" className={classes.subsubHeader}>
						<Grid container>
							<Grid
								item
								xs={9}
								style={{
									textAlign: 'left',
									lineHeight: '40px',
								}}
							>
								{advert.price != null && advert.price !== '' ? (
									<NumberFormat
										className={classes.priceValue}
										value={advert.price}
										displayType={'text'}
										thousandSeparator={true}
									/>
								) : (
									<span>Price Negotiable</span>
								)}
							</Grid>
							<Grid item xs={3} style={{ textAlign: 'right' }}>
								<IconButton
									onClick={callAdvert}
									disabled={advert.id === myId}
								>
									<FontAwesomeIcon icon={['fas', 'phone']} />
								</IconButton>
								<IconButton
									onClick={textAdvert}
									disabled={advert.id === myId}
								>
									<FontAwesomeIcon
										icon={['fas', 'comment-sms']}
									/>
								</IconButton>
							</Grid>
						</Grid>
					</AppBar>
					<div className={classes.body}>
						{advert.full != null && advert.full != ''
							? <JsxParser
								autoCloseVoidElements
								bindings={{
									classes,
								}}
								components={{ LightboxImage, ReactPlayer, CopyToClipboard }}
								jsx={cont}
								blacklistedTags={['iframe', 'script', 'link', 'applet', 'style']}
							/>
							: advert.short}
					</div>
					<div className={classes.input}>
						<Grid container>
							<Grid
								item
								xs={12}
								style={{ textAlign: 'center', padding: 10 }}
							>
								{cats.map((cat, i) => {
									return (
										<Chip
											key={`advert-cat-${i}`}
											className={classes.category}
											size="small"
											style={{
												margin: 5,
												backgroundColor: cat.color,
											}}
											label={cat.label}
											onClick={() =>
												categoryClick(cat.label)
											}
										/>
									);
								})}
							</Grid>
						</Grid>
					</div>
					{myId === advert.id && <ActionButtons />}
				</>
			)}
		</div>
	);
};
