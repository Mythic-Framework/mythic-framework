
const REGEX = {
	_protected: true,
	_required: [
		'Test',
	],
	_name: 'base',
	Test: (t, regex, testString, regexOptions) => {
		return new RegExp(regex, regexOptions).test(testString);
	},
};

AddEventHandler('Proxy:Shared:RegisterReady', () => {
	exports['mythic-base'].RegisterComponent('Regex', REGEX);
});