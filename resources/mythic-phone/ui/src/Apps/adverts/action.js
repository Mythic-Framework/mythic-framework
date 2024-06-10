import Nui from '../../util/Nui';

export const CreateAdvert = (id, advert, cb) => (dispatch) => {
	Nui.send('CreateAdvert', advert)
		.then((res) => {
			cb();
		})
		.catch((err) => {});
};

export const UpdateAdvert = (id, advert, cb) => (dispatch) => {
	Nui.send('UpdateAdvert', advert)
		.then((res) => {
			cb();
		})
		.catch((err) => {});
};

export const DeleteAdvert = (id, cb) => (dispatch) => {
	Nui.send('DeleteAdvert')
		.then((res) => {
			cb();
		})
		.catch((err) => {});
};

export const BumpAdvert = (id, myAd, cb) => (dispatch) => {
	Nui.send('UpdateAdvert', {
		...myAd,
		time: Date.now()
	})
		.then((res) => {
			cb();
		})
		.catch((err) => {
			cb();
		});
};
