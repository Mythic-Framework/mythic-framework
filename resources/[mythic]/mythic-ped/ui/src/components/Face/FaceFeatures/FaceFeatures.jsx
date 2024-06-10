import React, { Fragment } from 'react';
import { useSelector } from 'react-redux';

import { FaceFeature, EyeColor } from '../../PedComponents';

export default (props) => {
	const ped = useSelector((state) => state.app.ped);

	return (
		<div style={{ height: '100%' }}>
			<EyeColor
				label={'Eye Color'}
				component={ped.customization.eyeColor}
			/>
			<FaceFeature
				label={'Nose'}
				data={{
					items: [
						{
							label: 'Width',
							index: 0,
							current: ped.customization.face.features[0],
						},
						{
							label: 'Peak Height',
							index: 1,
							current: ped.customization.face.features[1],
						},
						{
							label: 'Peak Length',
							index: 2,
							current: ped.customization.face.features[2],
						},
						{
							label: 'Bone Height',
							index: 3,
							current: ped.customization.face.features[3],
						},
						{
							label: 'Peak Lowering',
							index: 4,
							current: ped.customization.face.features[4],
						},
						{
							label: 'Bone Twist',
							index: 5,
							current: ped.customization.face.features[5],
						},
					],
				}}
			/>
			<FaceFeature
				label={'Eyebrows'}
				data={{
					items: [
						{
							label: 'Height',
							index: 6,
							current: ped.customization.face.features[6],
						},
						{
							label: 'Length',
							index: 7,
							current: ped.customization.face.features[7],
						},
					],
				}}
			/>
			<FaceFeature
				label={'Cheeks'}
				data={{
					items: [
						{
							label: 'Bone Height',
							index: 8,
							current: ped.customization.face.features[8],
						},
						{
							label: 'Bone Width',
							index: 9,
							current: ped.customization.face.features[9],
						},
						{
							label: 'Cheek Width',
							index: 10,
							current: ped.customization.face.features[10],
						},
					],
				}}
			/>
			<FaceFeature
				label={'Jaw'}
				data={{
					items: [
						{
							label: 'Width',
							index: 13,
							current: ped.customization.face.features[13],
						},
						{
							label: 'Length',
							index: 14,
							current: ped.customization.face.features[14],
						},
					],
				}}
			/>
			<FaceFeature
				label={'Chin'}
				data={{
					items: [
						{
							label: 'Height',
							index: 15,
							current: ped.customization.face.features[15],
						},
						{
							label: 'Length',
							index: 16,
							current: ped.customization.face.features[16],
						},
						{
							label: 'Width',
							index: 17,
							current: ped.customization.face.features[17],
						},
						{
							label: 'Dimple',
							index: 18,
							current: ped.customization.face.features[18],
						},
					],
				}}
			/>
			<FaceFeature
				label={'Other'}
				data={{
					items: [
						{
							label: 'Eye Opening',
							index: 11,
							current: ped.customization.face.features[11],
						},
						{
							label: 'Lip Thickness',
							index: 12,
							current: ped.customization.face.features[12],
						},
						{
							label: 'Neck Thickness',
							index: 19,
							current: ped.customization.face.features[19],
						},
					],
				}}
			/>
		</div>
	);
};
