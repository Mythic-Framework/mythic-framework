import React from 'react';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles((theme) => ({}));

export default ({ job, type }) => {
	switch (job) {
		case 'police':
			switch (type) {
				case 'car':
					return <FontAwesomeIcon icon={['fas', 'car-side']} />;
				case 'air1':
					return <FontAwesomeIcon icon={['fas', 'helicopter']} />;
				case 'motorcycle':
					return <FontAwesomeIcon icon={['fas', 'motorcycle']} />;
				default:
					return (
						<FontAwesomeIcon icon={['fas', 'circle-question']} />
					);
			}
		case 'ems':
			switch (type) {
				case 'bus':
					return <FontAwesomeIcon icon={['fas', 'truck-medical']} />;
				case 'car':
					return <FontAwesomeIcon icon={['fas', 'car-side']} />;
				case 'lifeflight':
					return <FontAwesomeIcon icon={['fas', 'helicopter']} />;
				default:
					return (
						<FontAwesomeIcon icon={['fas', 'circle-question']} />
					);
			}
		case 'tow':
			return <FontAwesomeIcon icon={['fas', 'truck-ramp']} />;
		default:
			return <FontAwesomeIcon icon={['fas', 'circle-question']} />;
	}
};
