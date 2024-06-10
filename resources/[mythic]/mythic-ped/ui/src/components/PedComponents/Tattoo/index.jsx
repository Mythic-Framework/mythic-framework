import React, { useEffect, useState } from 'react';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Nui from '../../../util/Nui';
import { Checkbox, Slider, Ticker } from '../../UIComponents';
import { connect, useDispatch } from 'react-redux';
import ElementBox from '../../UIComponents/ElementBox/ElementBox';
import { Tattoos } from '../../Tattoos/Data';
import { Button, IconButton } from '@mui/material';

const useStyles = makeStyles((theme) => ({
	body: {
		maxHeight: '100%',
		overflow: 'hidden',
		margin: 25,
		display: 'grid',
		gridGap: 0,
		gridTemplateColumns: '75% 25%',
		justifyContent: 'space-around',
		background: theme.palette.secondary.light,
		border: `2px solid ${theme.palette.border.divider}`,
	},
	btnWrapper: {
		position: 'relative',
	},
	del: {
		height: 'fit-content',
		width: 'fit-content',
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
	},
	add: {
		marginTop: 0,
        marginBottom: 15,
		padding: 5,
	},
}));

export default connect()((props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const tattoos = Tattoos.filter(
		(t) => t.Zone == props.data.type && Boolean(t),
	);

	const onAdd = () => {
		if (props.current.length >= 25) return;

		let payload = { type: props.data.type };
		Nui.send('AddPedTattoo', payload);
		dispatch({
			type: 'ADD_PED_TATTOO',
			payload,
		});
	};

	const onChange = (value, data, index) => {
		return (d) => {
            if (!Boolean(value) || !Boolean(tattoos[value])) return;
			
            let payload = {
				type: props.data.type,
				data: tattoos[value],
				index,
			};
			Nui.send('SetPedTattoo', payload);
			d({
				type: 'UPDATE_PED_TATTOO',
				payload,
			});
		};
	};

	const onDelete = (index) => {
		let payload = { type: props.data.type, index };
		Nui.send('RemovePedTattoo', payload);
		dispatch({
			type: 'REMOVE_PED_TATTOO',
			payload,
		});
	};

	return (
		<>
			<Button
				fullWidth
				variant="outlined"
				color="primary"
				className={classes.add}
				onClick={onAdd}
				disabled={props.current.length >= 25}
			>
				Add {props.label} Tattoo
			</Button>

			{props.current.map((tattoo, k) => {
                if (tattoo.Zone != props.data.type) return null;
				try {
					let curr =
						tattoo?.Name == ''
							? 0
							: tattoos.findIndex((t) => t?.Name == tattoo?.Name);

					return (
						<ElementBox
							key={`tat-${k}`}
							label={`Tattoo #${k + 1}`}
							bodyClass={classes.body}
						>
							<Ticker
								label={'Type'}
								event={(v, d) => onChange(v, d, k)}
								data={{ ...props.data, extraType: 'index' }}
								current={curr}
								min={0}
								max={tattoos.length - 1}
							/>
							<div style={{ position: 'relative' }}>
								<IconButton
									className={classes.del}
									onClick={() => onDelete(k)}
								>
									<FontAwesomeIcon icon={['fas', 'trash']} />
								</IconButton>
							</div>
						</ElementBox>
					);
				} catch (err) {
					console.log(err);
					return null;
				}
			})}
		</>
	);
});
