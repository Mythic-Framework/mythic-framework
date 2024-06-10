import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import {
	Grid,
	Fade,
	TextField,
	InputAdornment,
	Button,
	IconButton,
	Skeleton,
	MenuItem,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { useLocation } from 'react-router';
import { CSSTransition, TransitionGroup } from 'react-transition-group';
import qs from 'qs';

import Nui from '../../../util/Nui';
import Officer from './components/Officer';
import Panel from './components/Panel';
import HireForm from './components/HireForm';
import { usePermissions } from '../../../hooks';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: 20,
		height: '100%',
	},
	search: {
		padding: '10px 5px',
		height: '20%',
	},
	officers: {
		maxHeight: '80%',
		overflowX: 'hidden',
		overflowY: 'auto',
	},
	hireBtn: {
		height: '100%',
	},
}));

export default () => {
	const classes = useStyles();
	const location = useLocation();
	const hasPerm = usePermissions();
	const myJob = useSelector(state => state.app.govJob);
	const jobData = useSelector(state => state.data.data.governmentJobsData)?.[myJob.Id];
	const isHighCommand = hasPerm('PD_HIGH_COMMAND') || hasPerm('SAFD_HIGH_COMMAND');
	const canHire = hasPerm('MDT_HIRE') || isHighCommand;

	let qry = qs.parse(location.search.slice(1));

	const [loading, setLoading] = useState(false);
	const [officers, setOfficers] = useState(Array());
	const [search, setSearch] = useState('');
	const [workplace, setWorkplace] = useState(false);
	const [filtered, setFiltered] = useState(Array());
	const [selected, setSelected] = useState(null);
	const [panel, setPanel] = useState(null);
	const [hire, setHire] = useState(false);

	const onRender = async () => {
		setLoading(true);
		setPanel(false);

		try {
			let res = await (
				await Nui.send('Search', {
					type: 'job',
					job: myJob.Id,
				})
			).json();

			setOfficers(res);
			setLoading(false);
		} catch (err) {
			console.log(err);
			setLoading(false);
		}
	};

	useEffect(() => {
		onRender();
	}, []);

	useEffect(() => {
		if (selected && selected.SID) {
			onSelect(officers.find(o => o.SID == selected.SID));
		} else if (qry.id) {
			onSelect(officers.find(o => o.SID == qry.id));
		}
	}, [officers]);

	useEffect(() => {
		let rgx = new RegExp(search, 'i');
		setFiltered(
			officers.filter(o => {
				const govJob = o.Jobs?.find(j => j.Id == myJob.Id);
				if (`${o.First} ${o.Last}`.match(rgx) || (o.Callsign && o.Callsign?.toString().match(rgx))) {
					if (govJob && (!workplace || govJob.Workplace.Id === workplace)) {
						return true;
					}
				}
			})
		);
	}, [officers, search, workplace]);

	const onSelect = (officer) => {
		if (Boolean(officer)) {
			setSelected(officer);
			setPanel(true);
		} else {
			setPanel(false);
		}
	};

	const onAnimEnd = () => {
		setSelected(null);
	};

	const onUpdate = () => {
		onRender();
	};

	return (
		<div className={classes.wrapper}>
			{loading ? (
				<Grid container style={{ height: '100%', position: 'relative' }}>
					<Grid item xs={4}>
						<div className={classes.search}>
							<Skeleton
								animation="wave"
								height={56}
								width="100%"
							/>
						</div>
						<div>
							<Skeleton
								animation="wave"
								height={98}
								width="100%"
							/>
							<Skeleton
								animation="wave"
								height={98}
								width="100%"
							/>
							<Skeleton
								animation="wave"
								height={98}
								width="100%"
							/>
							<Skeleton
								animation="wave"
								height={98}
								width="100%"
							/>
							<Skeleton
								animation="wave"
								height={98}
								width="100%"
							/>
							<Skeleton
								animation="wave"
								height={98}
								width="100%"
							/>
						</div>
					</Grid>
				</Grid>
			) : (
				<Grid container style={{ height: '100%' }}>
					<Grid item xs={4} style={{ height: '100%' }}>
						<div className={classes.search}>
							<Grid container spacing={1}>
								<Grid item xs={12}>
									<TextField
										select
										fullWidth
										label="Department"
										className={classes.editorField}
										value={workplace}
										onChange={(e) => setWorkplace(e.target.value)}
									>
										<MenuItem key={false} value={false}>
											All Departments
										</MenuItem>
										{jobData.Workplaces.map(w => (
											<MenuItem key={w.Id} value={w.Id}>
												{w.Name}
											</MenuItem>
										))}
									</TextField>
								</Grid>
								<Grid item xs={10}>
									<TextField
										fullWidth
										label="Search Name or Callsign"
										variant="outlined"
										value={search}
										onChange={(e) =>
											setSearch(e.target.value)
										}
										InputProps={{
											endAdornment: (
												<InputAdornment position="end">
													{search != '' && (
														<IconButton
															type="button"
															onClick={() => setSearch('')}
														>
															<FontAwesomeIcon
																icon={['fas', 'xmark']}
															/>
														</IconButton>
													)}
												</InputAdornment>
											),
										}}
									/>
								</Grid>
								{canHire && (
									<Grid item xs={2}>
										<Button
											className={classes.hireBtn}
											variant="outlined"
											onClick={() => setHire(true)}
										>
											Hire
										</Button>
									</Grid>
								)}
							</Grid>
						</div>
						<TransitionGroup className={classes.officers}>
							{filtered
								.sort((a, b) => a.Callsign - b.Callsign)
								.map((officer, k) => {
									return (
										<CSSTransition
											key={`offcr-${k}`}
											timeout={250}
											classNames="item"
										>
											<Officer
												selected={selected?.SID == officer.SID}
												officer={officer}
												onSelect={onSelect}
											/>
										</CSSTransition>
									);
								})}
						</TransitionGroup>
					</Grid>
					<Grid item xs={8}>
						{Boolean(selected) && (
							<Fade in={panel} onExited={onAnimEnd}>
								<div style={{ height: '100%' }}>
									<Panel officer={selected} onUpdate={onUpdate} />
								</div>
							</Fade>
						)}
					</Grid>
				</Grid>
			)}
			{canHire && (
				<HireForm
					open={hire}
					onUpdate={onUpdate}
					onClose={() => setHire(false)}
				/>
			)}
		</div>
	);
};
