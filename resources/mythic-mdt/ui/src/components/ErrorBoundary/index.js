import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { Fab, Tooltip } from '@mui/material';
import React from 'react';

import { Error } from '../';

export class ErrorBoundary extends React.Component {
	constructor(props) {
		super(props);
		this.props = props;
		this.state = { hasError: false };
		this.refresh = props.onRefresh;
		this.mini = props.mini;
	}

	static getDerivedStateFromError(error) {
		return { hasError: true };
	}

	componentDidCatch(error, errorInfo) {
		console.log('MDT Caught Error', error, errorInfo);
	}

	componentDidUpdate(previousProps, previousState) {
		if (previousProps.children !== this.props.children) this.setState({ hasError: false });
	}

	onClick() {
		this.refresh();
		this.state = { hasError: false };
	}

	render() {
		if (this.state.hasError) {
			if (this.mini) {
				return (
					<div>
						<Error code="500" message="I Crashed 😖" />
						{Boolean(this.refresh) && (
							<Tooltip title="Reload Emergency Alerts">
								<Fab
									color="primary"
									style={{
										display: 'block',
										width: 45,
										height: 45,
										fontSize: 24,
										margin: 'auto',
									}}
									onClick={this.onClick.bind(this)}
								>
									<FontAwesomeIcon icon={['fas', 'retweet']} />
								</Fab>
							</Tooltip>
						)}
					</div>
				);
			} else {
				return <Error code="500" message="Something Went Wrong & I Crashed 😖" />;
			}
		}

		return this.props.children;
	}
}
