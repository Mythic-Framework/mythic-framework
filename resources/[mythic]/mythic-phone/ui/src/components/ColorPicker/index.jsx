import React from 'react';
import { Button, DialogActions } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { TwitterPicker } from 'react-color';

import {
	lightGreen,
	green,
	purple,
	blue,
	orange,
	red,
	teal,
	grey,
	amber,
	pink,
	indigo,
	lightBlue,
	deepOrange,
	deepPurple,
} from '@material-ui/core/colors';

const colors = [
	grey[500],
	grey[600],
	grey[700],
	grey[800],
	grey[900],
	grey['A400'],
	grey['A700'],
	lightGreen[500],
	lightGreen[600],
	lightGreen[700],
	lightGreen[800],
	lightGreen[900],
	lightGreen['A400'],
	lightGreen['A700'],
	green[500],
	green[600],
	green[700],
	green[800],
	green[900],
	green['A400'],
	green['A700'],
	purple[500],
	purple[600],
	purple[700],
	purple[800],
	purple[900],
	purple['A400'],
	purple['A700'],
	deepPurple[500],
	deepPurple[600],
	deepPurple[700],
	deepPurple[800],
	deepPurple[900],
	deepPurple['A400'],
	deepPurple['A700'],
	indigo[500],
	indigo[600],
	indigo[700],
	indigo[800],
	indigo[900],
	indigo['A400'],
	indigo['A700'],
	lightBlue[500],
	lightBlue[600],
	lightBlue[700],
	lightBlue[800],
	lightBlue[900],
	lightBlue['A400'],
	lightBlue['A700'],
	blue[500],
	blue[600],
	blue[700],
	blue[800],
	blue[900],
	blue['A400'],
	blue['A700'],
	teal[500],
	teal[600],
	teal[700],
	teal[800],
	teal[900],
	teal['A400'],
	teal['A700'],
	orange[500],
	orange[600],
	orange[700],
	orange[800],
	orange[900],
	orange['A400'],
	orange['A700'],
	red[500],
	red[600],
	red[700],
	red[800],
	red[900],
	red['A400'],
	red['A700'],
	deepOrange[500],
	deepOrange[600],
	deepOrange[700],
	deepOrange[800],
	deepOrange[900],
	deepOrange['A400'],
	deepOrange['A700'],
	amber[500],
	amber[600],
	amber[700],
	amber[800],
	amber[900],
	amber['A400'],
	amber['A700'],
	pink[500],
	pink[600],
	pink[700],
	pink[800],
	pink[900],
	pink['A400'],
	pink['A700'],
];

const useStyles = makeStyles((theme) => ({
	buttons: {
		width: '100%',
		display: 'flex',
		margin: 'auto',
	},
	buttonPos: {
		width: '-webkit-fill-available',
		padding: 20,
		color: theme.palette.success.main,
		'&:hover': {
			backgroundColor: `${theme.palette.success.main}14`,
		},
	},
}));

export default (props) => {
	const classes = useStyles();

	return (
		<>
			<div
				style={{
					width: 'fit-content',
					margin: 'auto',
				}}
			>
				<TwitterPicker
					color={props.color}
					onChange={props.onChange}
					colors={colors}
					disableAlpha
					width="100%"
				/>
			</div>
		</>
	);
};
