_governmentJobs = { -- In order of "importance"
	'government',
	'police',
	'ems'
}

_permissions = {
	["police_alerts"] = {
		name = "Police Alerts",
		restrict = false,
	},
	["ems_alerts"] = {
		name = "Medical Alerts",
		restrict = false,
	},

	["impound"] = {
		name = "Regular Impound",
		restrict = {
			job = 'police',
		},
	},
	["impound_police"] = {
		name = "Police Impound",
		restrict = {
			job = 'police',
		},
	},

	["PD_RAID"] = {
		name = "Raid Property Storage",
		restrict = {
			job = 'police',
		},
	},

	["JOB_STORAGE"] = {
		name = "Access Storage",
		restrict = false,
	},


	["BANK_ACCOUNT_MANAGE"] = {
		name = "Bank Account - Manage",
		restrict = false,
	},
	["BANK_ACCOUNT_BILL"] = {
		name = "Bank Account - Bill",
		restrict = false
	},
	["BANK_ACCOUNT_WITHDRAW"] = {
		name = "Bank Account - Withdraw",
		restrict = false,
	},
	["BANK_ACCOUNT_DEPOSIT"] = {
		name = "Bank Account - Deposit",
		restrict = false,
	},
	["BANK_ACCOUNT_TRANSACTIONS"] = {
		name = "Bank Account - View Transactions",
		restrict = false,
	},
	["BANK_ACCOUNT_BALANCE"] = {
		name = "Bank Account - View Balance",
		restrict = false,
	},

	["FLEET_VEHICLES_0"] = {
		name = "Fleet Vehicles Level 1",
		restrict = false,
	},
	["FLEET_VEHICLES_1"] = {
		name = "Fleet Vehicles Level 2",
		restrict = false,
	},
	["FLEET_VEHICLES_2"] = {
		name = "Fleet Vehicles Level 3",
		restrict = false,
	},
	["FLEET_VEHICLES_3"] = {
		name = "Fleet Vehicles Level 4",
		restrict = false,
	},
	["FLEET_VEHICLES_4"] = {
		name = "Fleet Vehicles Level 5",
		restrict = false,
	},
	["FLEET_MANAGEMENT"] = {
		name = "Manage Vehicle Fleet",
		restrict = false,
	},
	['PD_HIGH_COMMAND'] = {
		name = "PD High Command",
		restrict = {
			job = 'police',
		}
	},
	['PD_COMMAND'] = {
		name = "PD Command",
		restrict = {
			job = 'police',
		}
	},
	['MDT_HIRE'] = {
		name = "Hire Employees",
		restrict = false
	},
	['MDT_FIRE'] = {
		name = "Fire Employees",
		restrict = false
	},
	['MDT_PROMOTE'] = {
		name = "Demote/Promote",
		restrict = false
	},
	['MDT_EDIT_EMPLOYEE'] = {
		name = "Edit Employees",
		restrict = false
	},

	['SAFD_HIGH_COMMAND'] = {
		name = "EMS High Command",
		restrict = {
			job = 'ems',
			workplace = 'safd',
		}
	},

	['USE_PD_TAGS'] = {
		name = "Use Police Tags",
		restrict = {
			job = 'police',
		}
	},
	['USE_EMS_TAGS'] = {
		name = "Use EMS Tags",
		restrict = {
			job = 'ems',
		}
	},
	['USE_DOJ_TAGS'] = {
		name = "Use DOJ Tags",
		restrict = {
			job = 'government',
			workplace = 'doj',
		}
	},

	-- Report Permissions
	['MDT_INCIDENT_REPORT_VIEW'] = {
		name = "View Incident Reports",
		restrict = false,
	},
	['MDT_INCIDENT_REPORT_CREATE'] = {
		name = "Create Incident Reports",
		restrict = {
			job = 'police',
		}
	},
	['MDT_INVESTIGATIVE_REPORT_CREATE'] = {
		name = "Create Investigation Reports",
		restrict = {
			job = 'police',
		}
	},
	['MDT_INVESTIGATIVE_REPORT_VIEW'] = {
		name = "View Investigations",
		restrict = {
			job = 'police',
		}
	},
	['MDT_CIVILIAN_REPORT_CREATE'] = {
		name = "Create Civilian Reports",
		restrict = {
			job = 'police',
		}
	},
	['MDT_CIVILIAN_REPORT_VIEW'] = {
		name = "View Civilian Report",
		restrict = {
			job = 'police',
		}
	},
	['MDT_POLICE_FTO_REPORTS'] = {
		name = "Create/View Field Training Reports",
		restrict = {
			job = 'police',
		}
	},
	['MDT_POLICE_DISCIPLINARY_REPORTS'] = {
		name = "Create/View Disciplinary Reports",
		restrict = {
			job = 'police',
		}
	},
	['MDT_JUDGE_REPORTS'] = {
		name = "Judge Reports/Documents",
		restrict = {
			job = 'government',
		}
	},
	['MDT_DA_REPORTS'] = {
		name = "DA's Office Reports",
		restrict = {
			job = 'government',
			workplace = 'dattorney',
		}
	},
	['MDT_MEDICAL_REPORTS'] = {
		name = "Medical Reports",
		restrict = {
			job = 'ems',
		}
	},

	["STATE_ACCOUNT_MANAGE"] = {
		name = "State Gov. - Manage",
		restrict = {
			job = 'government'
		},
	},
	["STATE_ACCOUNT_WITHDRAW"] = {
		name = "State Gov. - Withdraw",
		restrict = {
			job = 'government'
		},
	},
	["STATE_ACCOUNT_DEPOSIT"] = {
		name = "State Gov. - Deposit",
		restrict = {
			job = 'government'
		},
	},
	["STATE_ACCOUNT_TRANSACTIONS"] = {
		name = "State Gov. - View Transactions",
		restrict = {
			job = 'government'
		},
	},
	["STATE_ACCOUNT_BILL"] = {
		name = "State Gov. Account - View Balance",
		restrict = {
			job = 'government'
		},
	},
	["ATTORNEY_PENDING_EVIDENCE"] = {
		name = "Attorney - View Report",
		restrict = false,
	},
	["PD_SECURED_ARMORY"] = {
		name = "Access Secured Armory",
		restrict = {
			job = 'police',
		}
	},
	['DOJ_JUDGE'] = {
		name = "DOJ Judge",
		restrict = {
			job = 'government',
			workplace = 'doj',
		}
	},
	['PD_MANAGE_TRIALS'] = {
		name = "Manage Interceptor Trials",
		restrict = {
			job = 'police',
			workplace = 'sasp',
		}
	},
}

_qualifications = {
	['PD_FTO'] = {
		name = "PD FTO",
		restrict = {
			job = 'police',
		}
	},
	['PD_AIR'] = {
		name = "PD Air Cert.",
		restrict = {
			job = 'police',
		}
	},
	['PD_BOAT'] = {
		name = "PD Boating Cert.",
		restrict = {
			job = 'police',
		}
	},
	['PD_INTERCEPTOR'] = {
		name = "PD Interceptor Cert.",
		restrict = {
			job = 'police',
			workplace = 'sasp',
		}
	},
	['PD_BIKE'] = {
		name = "PD Bike Cert.",
		restrict = {
			job = 'police',
			workplace = 'sasp',
		}
	},
	['PD_SWAT'] = {
		name = "SWAT",
		restrict = {
			job = 'police',
		}
	},
	['PD_BEANBAG'] = {
		name = "PD Beanbag",
		restrict = {
			job = 'police',
		}
	},
	['PD_SMG'] = {
		name = "PD SMG",
		restrict = {
			job = 'police',
		}
	},
	['PD_AR'] = {
		name = "PD AR",
		restrict = {
			job = 'police',
		}
	},

	['EMS_LIFEFLIGHT'] = {
		name = 'Lifeflight Air Cert.',
		restrict = {
			job = 'ems',
			workplace = 'safd',
		}
	},
	['EMS_DIVING'] = {
		name = 'Scuba Cert.',
		restrict = {
			job = 'ems',
			workplace = 'safd',
		}
	},
	['EMS_FTO'] = {
		name = 'Diving Cert.',
		restrict = {
			job = 'ems',
			workplace = 'safd',
		}
	},
	['EMS_SURGEON'] = {
		name = 'Surgery Cert.',
		restrict = {
			job = 'ems',
			workplace = 'safd',
		}
	},
	['EMS_MH'] = {
		name = 'Mental Health Cert.',
		restrict = {
			job = 'ems',
			workplace = 'safd',
		}
	},
}
