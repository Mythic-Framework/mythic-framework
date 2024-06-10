import React from 'react';

import { Modal } from '../../../components';

export default ({ open, onCancel, onConfirm }) => {
	return (
		<Modal
			open={open}
			maxWidth="sm"
			title={`Clear Receipts`}
			submitLang="Clear All"
			onSubmit={onConfirm}
			closeLang="Cancel"
			onClose={onCancel}
		>
			<p>Are you sure you want to clear <strong>ALL</strong> receipts? This is not reversible!</p>
		</Modal>
	);
};
