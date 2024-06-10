export default (cJob, isAttorney, tabletData) => {
	if (isAttorney && !cJob) {
		return {
			primary: 'Electronic Records System',
			secondary: 'San Andreas Department of Justice',
		};
	};

	if (tabletData) {
		return {
			primary: cJob?.Name,
			secondary: 'Business Management System',
		};
	};

	switch (cJob?.Id) {
		case 'police':
			return {
				primary: 'Electronic Records System',
				secondary: cJob?.Workplace?.Name,
			};
		case 'government':
			switch(cJob?.Workplace?.Id) {
				case 'doj':
					return {
						primary: 'Electronic Records System',
						secondary: 'San Andreas Department of Justice',
					}
				default:
					return {
						primary: 'State of San Andreas',
						secondary: 'Public Records Repository',
					};
			}
		case 'ems':
			return {
				primary: 'State of San Andreas Medical Services',
				secondary: 'Electronic Records System',
			};
		default:
			return {
				primary: 'State of San Andreas',
				secondary: 'Public Records Repository',
			};
	}
};
