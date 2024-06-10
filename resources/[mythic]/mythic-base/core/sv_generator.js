const faker = require('faker');

const GENERATOR = {
	_protected: true,
	_required: [
		'Color',
		'Name',
		'Job',
		'Address',
		'Finance',
		'Internet',
		'Date',
		'Phone',
		'Vehicle',
		'Data',
		'Image',
		'Hacker',
	],
	_name: 'base',
	Color: (t) => {
		return faker.internet.color();
	},
	Name: {
		First: (t) => {
			return faker.name.firstName();
		},
		Last: (t) => {
			return faker.name.lastName();
		},
		Middle: (t) => {
			return faker.name.middleName();
		},
	},
	Job: (t) => {
		return faker.name.jobTitle();
	},
	Company: (t) => {
		return faker.company.companyName();
	},
	Address: {
		City: (t) => {
			return faker.address.cityName();
		},
		State: (t) => {
			return faker.address.state();
		},
		Street: (t) => {
			return faker.address.streetAddress();
		},
		StreetSecondary: (t) => {
			return faker.address.secondaryAddress();
		},
	},
	Finance: {
		Account: (t) => {
			return faker.finance.account();
		},
		CreditCard: (t) => {
			return faker.finance.creditCardNumber();
		},
		CryptoAddress: (t) => {
			return faker.finance.bitcoinAddress();
		},
	},
	Internet: {
		Email: (t) => {
			return faker.internet.email();
		},
		Avatar: (t) => {
			return faker.internet.avatar();
		},
		Domain: (t) => {
			return faker.internet.domainName();
		},
		IP: (t) => {
			return faker.internet.ip();
		},
		IPv6: (t) => {
			return faker.internet.ipv6();
		},
		MacAddress: (t) => {
			return faker.internet.mac();
		},
	},
	Date: {
		Past: (t) => {
			return faker.date.past();
		},
		Future: (t) => {
			return faker.date.future();
		},
		Recent: (t) => {
			return faker.date.recent();
		},
		Soon: (t) => {
			return faker.date.soon();
		},
	},
	Phone: (t) => {
		return faker.phone.phoneNumber();
	},
	Vehicle: {
		MakeModel: (t) => {
			return faker.vehicle.vehicle();
		},
		Make: (t) => {
			return faker.vehicle.manufacturer();
		},
		Model: (t) => {
			return faker.vehicle.model();
		},
		Color: (t) => {
			return faker.vehicle.color();
		},
		VIN: (t) => {
			return faker.vehicle.vin();
		},
		Plate: (t) => {
			return faker.vehicle.vrm();
		},
	},
	Data: {
		Number: (t) => {
			return faker.datatype.number();
		},
		Float: (t) => {
			return faker.datatype.float();
		},
		String: (t) => {
			return faker.datatype.string();
		},
		UUID: (t) => {
			return faker.datatype.uuid();
		},
	},
	Image: {
		Image: (t) => {
			return faker.image.image();
		},
		Avatar: (t) => {
			return faker.image.avatar();
		},
	},
	Hacker: {
		Abbrevation: (t) => {
			return faker.hacker.abbreviation();
		},
		Adjective: (t) => {
			return faker.hacker.adjective();
		},
		Noun: (t) => {
			return faker.hacker.noun();
		},
		Verb: (t) => {
			return faker.hacker.verb();
		},
		ingVerb: (t) => {
			return faker.hacker.ingverb();
		},
	},
};

AddEventHandler('Proxy:Shared:RegisterReady', () => {
	exports['mythic-base'].RegisterComponent('Generator', GENERATOR);
});
