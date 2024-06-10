import React, { useState } from 'react';
import { makeStyles } from '@mui/styles';
import { Button, Grid } from '@mui/material';

import { Loader, Modal } from '../../components';
import Nui from '../../util/Nui';
import Reputation from './component/Reputation';
import MyContract from './component/MyContract';
import { usePermissions } from '../../hooks';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		position: 'relative',
		height: '100%',
		background: theme.palette.secondary.main,
		overflow: 'auto',
	},
	body: {
		padding: 10,
		height: '100%',
	},
	contractGrid: {
		overflow: 'auto',
		height: '100%',
	},
}));

export default ({ items }) => {
	const classes = useStyles();
	const hasPerm = usePermissions();

	const [myContracts, setMyContracts] = useState(
		[...Array(3).keys()].map((i) => {
			return {
				id: i,
				owner: {
					SID: 1,
					Alias: 'MeFast',
				},
				vehicle: {
					model: 'drafter',
					label: 'Drafter',
					class: 'A+',
				},
				prices: {
					standard: {
						price: 25,
						coin: 'VRM',
					},
					scratch: {
						price: 50,
						coin: 'VRM',
					},
				},
				expires: 1659553001000,
			};
		}),
	);

	return (
		<div className={classes.wrapper}>
			<Grid container style={{ height: '100%', overflow: 'hidden' }}>
				{hasPerm('lsunderground', 'admin') && (
					<Grid item xs={1} style={{ padding: 4 }}>
						<Button
							fullWidth
							color="success"
							style={{ height: '100%' }}
						>
							<FontAwesomeIcon icon={['fas', 'user-shield']} />
						</Button>
					</Grid>
				)}
				<Grid item xs={hasPerm('lsunderground', 'admin') ? 10 : 11}>
					<Reputation
						rep={{
							id: 'Boosting',
							label: 'Boosting',
							value: 25000,
							current: {
								value: 20000,
								label: 'B',
							},
							next: {
								value: 50000,
								label: 'C',
							},
						}}
					/>
				</Grid>
				<Grid item xs={1} style={{ padding: 4 }}>
					<Button
						fullWidth
						color="success"
						style={{ height: '100%' }}
					>
						Enter Queue
					</Button>
				</Grid>
				<Grid
					item
					xs={12}
					style={{ padding: 10, height: 'calc(100% - 82px)' }}
				>
					<Grid
						container
						spacing={2}
						className={classes.contractGrid}
					>
						{myContracts.length > 0 &&
							myContracts.map((contract) => {
								return (
									<MyContract
										key={`contract-${contract.id}`}
										contract={contract}
									/>
								);
							})}
					</Grid>
				</Grid>
			</Grid>
		</div>
	);
};
