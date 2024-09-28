import { useSelector } from 'react-redux';

import SASeal from '../assets/img/seals/seal.webp';
import DOJSeal from '../assets/img/seals/doj_seal.webp';
import LSSeal from '../assets/img/seals/ls_seal.webp';

import StateBadge from '../assets/img/seals/sasp_seal.webp';
import SheriffBadge from '../assets/img/seals/bcso_seal.webp';

//import StarOfLife from '../assets/img/seals/StarOfLife.webp';
import MedicalServices from '../assets/img/seals/MedicalServices.webp';

export default () => {
	const govJob = useSelector(state => state.app.govJob);
	const attorney = useSelector(state => state.app.attorney);

	return () => {
		if (attorney && !govJob) {
			return DOJSeal;
		};

		switch (govJob?.Id) {
			case 'police':
				switch (govJob?.Workplace?.Id) {
					case 'lspd':
						return LSSeal;
					case 'lscso':
						return SheriffBadge;
					case 'sasp':
						return StateBadge;
					default:
						return SASeal;
				}
			case 'government':
				return DOJSeal;
			case 'ems':
				return MedicalServices;
			default:
				return SASeal;
		}
	};
};