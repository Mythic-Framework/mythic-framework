import { useSelector } from 'react-redux';

import SASeal from '../assets/img/seals/seal.webp';
import DOJSeal from '../assets/img/seals/doj_seal.webp';
import MayorSeal from '../assets/img/seals/mayor_seal.webp';
import LSSeal from '../assets/img/seals/ls_seal.webp';

import StateBadge from '../assets/img/seals/sasp_seal.webp';

import FibSeal from '../assets/img/seals/fib_seal.webp';
import IaaSeal from '../assets/img/seals/iaa_seal.webp';

import SheriffBadgeBC from '../assets/img/seals/bcso_seal.webp';
import SheriffBadgeLS from '../assets/img/seals/lssd_seal.webp';

//import StarOfLife from '../assets/img/seals/StarOfLife.webp';
import MedicalServices from '../assets/img/seals/MedicalServices.webp';

import Business from '../assets/img/seals/business.webp';

export default () => {
	const govJob = useSelector(state => state.app.govJob);
	const attorney = useSelector(state => state.app.attorney);
	const tabletData = useSelector((state) => state.app.tabletData);

	return () => {
		if (attorney && !govJob) {
			return DOJSeal;
		};

		if (tabletData) {
			return tabletData?.logo ?? Business;
		};

		switch (govJob?.Id) {
			case 'police':
				switch (govJob?.Workplace?.Id) {
					case 'lspd':
						return LSSeal;
					case 'lscso':
						return SheriffBadgeLS;
					case 'bcso':
						return SheriffBadgeBC;
					case 'sasp':
						return StateBadge;
					case 'fib':
						return FibSeal;
					case 'iaa':
						return IaaSeal;
					default:
						return SASeal;
				}
			case 'government':
				switch (govJob?.Workplace?.Id) {
					case 'mayoroffice':
						return MayorSeal;
					default:
						return DOJSeal;
				}
			case 'ems':
				return MedicalServices;
			default:
				return SASeal;
		}
	};
};