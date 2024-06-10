import React, { useState } from 'react';
import { makeStyles } from '@mui/styles';
import { CKEditor } from '@ckeditor/ckeditor5-react';
import ClassicEditor from 'mythic-ckeditor';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: 10,
		borderRadius: 4,
		border: `1px solid ${theme.palette.border.divider}`,
		margin: 0,
		marginBottom: 10,
		display: 'inline-flex',
		minWidth: '100%',
		width: '100%',
		position: 'relative',
		flexDirection: 'column',
		verticalAlign: 'top',
		boxShadow: 'inset 0 0 14px 0 rgba(0,0,0,.3), inset 0 2px 0 rgba(0,0,0,.2)',

		'&.error': {
			borderColor: theme.palette.error.main,
		},
	},
	label: {
		transform: 'translate(11px, -10px) scale(0.75)',
		top: 0,
		left: 0,
		position: 'absolute',
		transformOrigin: 'top left',
		color: 'rgba(255, 255, 255, 0.5)',
		fontSize: '1rem',
		padding: '0 4px',

		'&.error': {
			color: theme.palette.error.main,
		},
	},
	labelDark: {
		transform: 'translate(11px, -10px) scale(0.75)',
		top: 0,
		left: 0,
		position: 'absolute',
		transformOrigin: 'top left',
		color: 'rgba(255, 255, 255, 0.5)',
		fontSize: '1rem',
		padding: '0 4px',
		background: 'rgba(0, 0, 0, 0.6)',

		'&.error': {
			color: theme.palette.error.main,
		},
	},
	requiredWords: {
		color: theme.palette.text.alt,
		fontSize: '80%',

		'&.success': {
			color: theme.palette.success.main,
		},
		'&.error': {
			color: theme.palette.error.main,
		},
	},
	errorText: {
		color: theme.palette.error.main,
		fontSize: '80%',
	},
	wordCount: {
		padding: 5,
		background: theme.palette.secondary.light,
		border: `1px solid ${theme.palette.border.input}`,
		borderTop: 'none',
		fontSize: '85%',
		color: theme.palette.text.alt,

		'& svg': {
			marginLeft: 6,
		},
	},
	positive: {
		color: theme.palette.success.main,
	},
	negative: {
		color: theme.palette.error.main,
	},
}));

const _globalBtns = [];

export default ({
	onChange,
	required = false,
	name = 'editor',
	value = '',
	title = 'Editor',
	onNewMention = null,
	error = null,
	placeholder = 'Enter Your Text...',
	wordCount = 0,
	allowMedia = true,
	dark = false,
	...rest
}) => {
	const classes = useStyles();

	const [currChars, setCurrChars] = useState(0);
	const [currWords, setCurrWords] = useState(0);

	const getFeedItems = (queryText) => {
		return Array();
	};

	const onEditorChange = (_, editor) => {
		let value = editor.getData();
		onChange({ target: { name: name, value: value } });
	};

	const config = {
		placeholder,
		removePlugins: ['Title', 'MediaEmbedToolbar'],
		toolbar: allowMedia
			? [
					'heading',
					'highlight',
					'|',
					'bold',
					'italic',
					'underline',
					'strikethrough',
					'|',
					'bulletedList',
					'numberedList',
					'blockquote',
					'codeblock',
					'|',
					'link',
					'mediaEmbed',
			  ]
			: [
					'heading',
					'highlight',
					'|',
					'bold',
					'italic',
					'underline',
					'strikethrough',
					'|',
					'bulletedList',
					'numberedList',
					'blockquote',
					'codeblock',
					'|',
					'link',
			  ],
		mention: {
			feeds: [
				{
					marker: '@',
					feed: getFeedItems,
					minimumCharacters: 1,
				},
			],
		},
		wordCount: {
			onUpdate: (stats) => {
				setCurrChars(stats.characters);
				setCurrWords(stats.words);
			},
		},
	};

	return (
		<div className={`${classes.wrapper}${Boolean(error) ? ' error' : ''}`}>
			<div className={`${Boolean(dark) ? classes.labelDark : classes.label}${Boolean(error) ? ' error' : ''}`}>
				{title}
				{Boolean(required) && <span> *</span>}
			</div>
			<CKEditor
				ignoreEmptyParagraph
				config={config}
				editor={ClassicEditor}
				data={value}
				onChange={onEditorChange}
			/>
			<div className={classes.wordCount}>
				{wordCount > 0 ? (
					<span>
						{`${currChars} Characters ${currWords}/${wordCount} Words`}
						{currWords >= wordCount ? (
							<FontAwesomeIcon className={classes.positive} icon={['fas', 'check']} />
						) : (
							<FontAwesomeIcon className={classes.negative} icon={['fas', 'x']} />
						)}
					</span>
				) : (
					<span>{`${currChars} Characters ${currWords} Words`}</span>
				)}
			</div>
			{Boolean(error) && <div className={classes.errorText}>{error}</div>}
		</div>
	);
};
