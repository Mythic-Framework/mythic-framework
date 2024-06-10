import React, { useState } from 'react';
import Lightbox from 'react-image-lightbox';

export default ({ src, alt = '', ...rest }) => {
	const [lbImg, setLbImg] = useState(null);

	return (
		<>
			<img onClick={() => setLbImg(src)} src={src} alt={alt} {...rest} />
			{lbImg != null && (
				<Lightbox
					mainSrc={lbImg}
					onCloseRequest={() => setLbImg(null)}
				/>
			)}
		</>
	);
};
