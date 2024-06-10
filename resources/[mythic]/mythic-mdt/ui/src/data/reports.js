export const ReportTypes = [
	{
		label: 'Incident Report',
		value: 0,
        requiredViewPermission: 'MDT_INCIDENT_REPORT_VIEW', // Req. Permission to View
		requiredCreatePermission: 'MDT_INCIDENT_REPORT_CREATE', // Req. Permission to Create
		hasEvidence: true,
	},
	{
		label: 'Investigative Report',
		value: 1,
		requiredViewPermission: 'MDT_INVESTIGATIVE_REPORT_VIEW',
		requiredCreatePermission: 'MDT_INVESTIGATIVE_REPORT_CREATE',
		hasEvidence: true,
	},
	{
		label: 'Civilian Report',
		value: 2,
		requiredViewPermission: 'MDT_CIVILIAN_REPORT_VIEW',
		requiredCreatePermission: 'MDT_CIVILIAN_REPORT_CREATE',
	},
	{
		label: 'PD Field Training Reports',
		value: 3,
		requiredViewPermission: 'MDT_POLICE_FTO_REPORTS',
		requiredCreatePermission: 'MDT_POLICE_FTO_REPORTS',
	},
	{
		label: 'PD Disciplinary Reports',
		value: 4,
		requiredViewPermission: 'MDT_POLICE_DISCIPLINARY_REPORTS',
		requiredCreatePermission: 'MDT_POLICE_DISCIPLINARY_REPORTS',
	},
	{
		label: 'Medical Report',
		value: 10,
		requiredCreatePermission: 'MDT_MEDICAL_REPORTS', // Req. Permission to Create
		requiredViewPermission: 'MDT_MEDICAL_REPORTS',
		officerName: 'Medic',
		officerType: 'ems',
	},
	{
		label: 'Trial Findings',
		value: 20,
		requiredCreatePermission: 'MDT_JUDGE_REPORTS', // Req. Permission to Create
		officerName: 'Judges',
		officerType: 'government',
	},
	{
		label: 'DOJ Documents',
		value: 21,
		requiredViewPermission: 'MDT_JUDGE_REPORTS',
		requiredCreatePermission: 'MDT_JUDGE_REPORTS', // Req. Permission to Create
		officerName: 'Judges',
		officerType: 'government',
	},
	{
		label: 'DA\'s Office Reports',
		value: 25,
		requiredViewPermission: 'MDT_DA_REPORTS',
		requiredCreatePermission: 'MDT_DA_REPORTS', // Req. Permission to Create
		officerName: 'Prosecutors',
		officerType: 'government',
	},
];

export const GetOfficerNameFromReportType = (reportType) => {
	return ReportTypes.find(r => r.value == reportType)?.officerName ?? 'Officers';
}

export const GetOfficerJobFromReportType = (reportType) => {
	return ReportTypes.find(r => r.value == reportType)?.officerType ?? 'police';
}