import React, { useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { TextField, AppBar, IconButton, Grid, Pagination } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Nui from '../../util/Nui';
import { Confirm, Modal } from '../../components';
import { useAlert } from '../../hooks';
import Tweet from './Tweet';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
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
	inner: {
		position: 'relative',
		height: '100%',
	},
	tweetlist: {
		height: '89%',
		overflowX: 'hidden',
		overflowY: 'auto',
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
	header: {
		background: '#00aced',
		fontSize: 20,
		padding: 15,
		lineHeight: '45px',
		height: 78,
	},
}));

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const showAlert = useAlert();
	const tweets = useSelector((state) => state.data.data.tweets);
	const player = useSelector((state) => state.data.data.player);

	const pages = tweets ? Math.ceil(tweets.length / 20) : 0;
	const [page, setPage] = useState(1);

	const [open, setOpen] = useState(false);
	const [state, setState] = useState({
		tweet: '',
		usingImg: false,
		imgLink: '',
	});
	const [pendingRetweet, setPendingRetweet] = useState(null);

	const onStateChange = (e) => {
		setState({
			...state,
			[e.target.name]: e.target.value,
		});
	};

	const toggleImage = () => {
		setState({
			...state,
			imgLink: '',
			usingImg: !state.usingImg,
		});
	};

	const onReply = (name) => {
		setState({
			...state,
			tweet: `@${name} `,
		});
		setOpen(true);
	};

	const confirmRetweet = (tweet) => {
		setPendingRetweet(tweet);
	};
	const onRetweet = async () => {
		let res = await sendTweet({
			...pendingRetweet,
			author: player.Alias.twitter,
			content: `<b>RETWEET</b> @${pendingRetweet.author.name} "${pendingRetweet.content}"`,
			time: Date.now(),
			retweet: pendingRetweet._id,
			likes: Array(),
			// image: {
			// 	using: false,
			// 	link: null,
			// },
		});
		setPendingRetweet(null);
		showAlert(res ? 'Retweeted' : 'Unable to Retweet');
	};

	const sendTweet = async (tweet) => {
		try {
			let res = await (await Nui.send('SendTweet', tweet)).json();

			if (res) {
				setOpen(false);
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
		let res = await sendTweet({
			time: Date.now(),
			content: state.tweet,
			image: {
				using: state.usingImg,
				link: state.imgLink,
			},
			likes: Array(),
		});
		setState({
			tweet: '',
			usingImg: false,
			imgLink: '',
		});
		setOpen(false);
		showAlert(res ? 'Tweet Created' : 'Unable to Create Tweet');
	};

	return (
		<div className={classes.wrapper}>
			<div className={classes.inner}>
				<AppBar position="static" className={classes.header}>
					<Grid container>
						<Grid item xs={8} style={{ lineHeight: '50px' }}>
							Twitter
						</Grid>
						<Grid item xs={4} style={{ textAlign: 'right' }}>
							<IconButton
								onClick={() => setOpen(true)}
								disabled={player.Alias.twitter == null}
								className={classes.headerAction}
							>
								<FontAwesomeIcon icon={['fas', 'plus']} />
							</IconButton>
						</Grid>
					</Grid>
				</AppBar>
				<div className={classes.tweetlist}>
					{tweets
						.sort((a, b) => b.time - a.time)
						.slice(0, 200)
						.slice((page - 1) * 20, page * 20)
						.map((tweet) => {
							return (
								<Tweet
									key={tweet._id}
									tweet={tweet}
									rtcount={
										tweets.filter(
											(t) => t.retweet == tweet._id,
										).length
									}
									onReply={onReply}
									onRetweet={confirmRetweet}
								/>
							);
						})}
					{pages > 1 && (
							<Pagination
								count={pages}
								page={page}
								onChange={(_, value) => setPage(value)}
								variant="outlined"
								color="primary"
								style={{ padding: '5%' }}
							/>
						)}
				</div>
			</div>
			<Modal
				form
				open={open}
				title="Send New Tweet"
				onClose={() => setOpen(false)}
				onAccept={onCreate}
				onDelete={toggleImage}
				submitLang="Send Tweet"
				deleteLang={state.usingImg ? 'Remove Image' : 'Attach Image'}
				closeLang="Cancel"
			>
				<>
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
						InputLabelProps={{
							style: { fontSize: 20 },
						}}
					/>
					{state.usingImg && (
						<>
							{state.imgLink != '' && (
								<img
									src={state.imgLink}
									className={classes.preview}
								/>
							)}
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
						</>
					)}
				</>
			</Modal>
			<Confirm
				title="Retweet?"
				open={pendingRetweet != null}
				confirm="Retweet"
				decline="Cancel"
				onConfirm={onRetweet}
				onDecline={() => setPendingRetweet(null)}
			/>
		</div>
	);
};
