import React from 'react';
import { useSelector } from 'react-redux';
import { Paper, Slide } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { ToastContainer, Flip } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';

import { Public, Police, DOJ, Medical, DA, Attorney, PublicDefenders } from '../Jobs';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		width: '100%',
		border: `10px solid #000`,
		transition: 'opacity 500ms',
	},
	inner: {
		position: 'relative',
		height: '100%',
	},
}));

export default () => {
	const classes = useStyles();
	const hidden = useSelector((state) => state.app.hidden);
	const job = useSelector((state) => state.app.govJob);
	const opacityMode = useSelector((state) => state.app.opacity);
	const attorney = useSelector((state) => state.app.attorney);

	const getPanel = () => {
		switch (job?.Id) {
			case 'police':
				return <Police />;
			case 'government':
				switch (job?.Workplace?.Id) {
					case 'doj':
						return <DOJ />;
					case 'dattorney':
						return <DA />;
					case 'publicdefenders':
						return <PublicDefenders />
					default:
						return <Public />;
				}
			case 'ems':
				return <Medical />;
			default:
				if (attorney) {
					return <Attorney />;
				} else {
					return <Public />;
				}
		}
	};

	return (
		<Slide direction="up" in={!hidden}>
			<Paper elevation={20} className={classes.wrapper} style={{ opacity: opacityMode ? '60%' : null }}>
				<div className={classes.inner}>
					<ToastContainer
						theme="dark"
						position="bottom-right"
						newestOnTop={false}
						closeOnClick
						rtl={false}
						draggable
						transition={Flip}
						pauseOnHover={false}
					/>
					{getPanel()}
				</div>
			</Paper>
		</Slide>
	);
};
