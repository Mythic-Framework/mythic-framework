const mongodb = require('mongodb');
const utils = require('./db_utils');

let gameDb;
let authDb;

let Database = null;
let Convar = null;

const DATABASE = {
	_protected: true,
	_required: ['Game', 'Auth'],
	//_required: [ 'isConnected', 'insert', 'insertOne', 'find', 'findOne', 'update', 'updateOne', 'delete', 'deleteOne', 'count' ],
	_name: 'base',
	/* THESE METHODS SHOULD BE CONSIDERED DEPRECATED. THEY WILL BE REMOVED BEFORE ANY PRODUCTION RELEASE */
	/* They're being left here to just ensure no issues, but any development going forward need to use specific Auth / Game Dbs */
	isConnected: () => {
		return !!Methods.isConnected(gameDb);
	},
	insert: (t, params, callback) => {
		Log('^9DEPRECATED DATABSE METHOD USED, UPDATE ASAP^7', {
			console: true,
		});
		return Methods.insert(gameDb, params, callback);
	},
	insertOne: (t, params, callback) => {
		Log('^9DEPRECATED DATABSE METHOD USED, UPDATE ASAP^7', {
			console: true,
		});
		return Methods.insertOne(gameDb, params, callback);
	},
	find: (t, params, callback) => {
		Log('^9DEPRECATED DATABSE METHOD USED, UPDATE ASAP^7', {
			console: true,
		});
		return Methods.find(gameDb, params, callback);
	},
	findOne: (t, params, callback) => {
		Log('^9DEPRECATED DATABSE METHOD USED, UPDATE ASAP^7', {
			console: true,
		});
		return Methods.findOne(gameDb, params, callback);
	},
	update: (t, params, callback, isUpdateOne) => {
		Log('^9DEPRECATED DATABSE METHOD USED, UPDATE ASAP^7', {
			console: true,
		});
		return Methods.update(gameDb, params, callback, isUpdateOne);
	},
	updateOne: (t, params, callback) => {
		Log('^9DEPRECATED DATABSE METHOD USED, UPDATE ASAP^7', {
			console: true,
		});
		return Methods.updateOne(gameDb, params, callback);
	},
	delete: (t, params, callback, isDeleteOne) => {
		Log('^9DEPRECATED DATABSE METHOD USED, UPDATE ASAP^7', {
			console: true,
		});
		return Methods.delete(gameDb, params, callback, isDeleteOne);
	},
	deleteOne: (t, params, callback) => {
		Log('^9DEPRECATED DATABSE METHOD USED, UPDATE ASAP^7', {
			console: true,
		});
		return Methods.deleteOne(gameDb, params, callback);
	},
	count: (t, params, callback) => {
		Log('^9DEPRECATED DATABSE METHOD USED, UPDATE ASAP^7', {
			console: true,
		});
		return Methods.count(gameDb, params, callback);
	},
	Game: {
		isConnected: () => {
			return !!Methods.isConnected(gameDb);
		},
		insert: (t, params, callback) => {
			return Methods.insert(gameDb, params, callback);
		},
		insertOne: (t, params, callback) => {
			return Methods.insertOne(gameDb, params, callback);
		},
		find: (t, params, callback) => {
			return Methods.find(gameDb, params, callback);
		},
		findOne: (t, params, callback) => {
			return Methods.findOne(gameDb, params, callback);
		},
		update: (t, params, callback, isUpdateOne) => {
			return Methods.update(gameDb, params, callback, isUpdateOne);
		},
		updateOne: (t, params, callback) => {
			return Methods.updateOne(gameDb, params, callback);
		},
		delete: (t, params, callback, isDeleteOne) => {
			return Methods.delete(gameDb, params, callback, isDeleteOne);
		},
		deleteOne: (t, params, callback) => {
			return Methods.deleteOne(gameDb, params, callback);
		},
		findOneAndUpdate: (t, params, callback) => {
			return Methods.findOneAndUpdate(gameDb, params, callback);
		},
		count: (t, params, callback) => {
			return Methods.count(gameDb, params, callback);
		},
		aggregate: (t, params, callback) => {
			return Methods.aggregate(gameDb, params, callback);
		},
	},
	Auth: {
		isConnected: () => {
			return !!Methods.isConnected(authDb);
		},
		insert: (t, params, callback) => {
			return Methods.insert(authDb, params, callback);
		},
		insertOne: (t, params, callback) => {
			return Methods.insertOne(authDb, params, callback);
		},
		find: (t, params, callback) => {
			return Methods.find(authDb, params, callback);
		},
		findOne: (t, params, callback) => {
			return Methods.findOne(authDb, params, callback);
		},
		update: (t, params, callback, isUpdateOne) => {
			return Methods.update(authDb, params, callback, isUpdateOne);
		},
		updateOne: (t, params, callback) => {
			return Methods.updateOne(authDb, params, callback);
		},
		delete: (t, params, callback, isDeleteOne) => {
			return Methods.delete(authDb, params, callback, isDeleteOne);
		},
		deleteOne: (t, params, callback) => {
			return Methods.deleteOne(authDb, params, callback);
		},
		findOneAndUpdate: (t, params, callback) => {
			return Methods.findOneAndUpdate(authDb, params, callback);
		},
		count: (t, params, callback) => {
			return Methods.count(authDb, params, callback);
		},
		aggregate: (t, params, callback) => {
			return Methods.aggregate(gameDb, params, callback);
		},
	},
};

AddEventHandler('onResourceStop', function (resource) {
	if (resource === GetCurrentResourceName()) {
		gameDb.close();
		gameDb = null;
		authDb.close();
		gameDb = null;
	}
});

AddEventHandler('Database:Shared:DependencyUpdate', RetrieveComponents);

function RetrieveComponents() {
	Convar = exports[GetCurrentResourceName()].FetchComponent('Convar');
	Database = exports[GetCurrentResourceName()].FetchComponent('Database');
}

AddEventHandler('Core:Shared:Ready', () => {
	exports['mythic-base'].RequestDependencies(
		'Database',
		['Convar', 'Database'],
		(error) => {
			if (error.length > 0) return;
			RetrieveComponents();
		},
	);
});

AddEventHandler(
	'Database:Server:Initialize',
	function (a_url, a_db, g_url, g_db) {
		if (
			Database == null ||
			!Database.Game.isConnected() ||
			!Database.Auth.isConnected()
		) {
			mongodb.MongoClient.connect(
				a_url,
				{ useNewUrlParser: true, useUnifiedTopology: true },
				function (err, client) {
					if (err) return Log('Error: ' + err.message);
					authDb = client.db(a_db);
					LogTrace(
						`[^31^7/^22^7] Connected to authentication database "${a_db}".`,
					);
					mongodb.MongoClient.connect(
						g_url,
						{
							useNewUrlParser: true,
							useUnifiedTopology: true,
						},
						function (err, client) {
							if (err) return Log('Error: ' + err.message);
							gameDb = client.db(g_db);
							LogTrace(
								`[^22^7/^22^7] ^7Connected to game database "${g_db}".`,
							);
							emit('Database:Server:Ready', DATABASE);
						},
					);
				},
			);
		} else {
			emit('Database:Server:Ready');
		}
	},
);

function LogTrace(log) {
	emit(`Logger:Trace`, 'Database', log, { console: true });
}

function Log(log, flagOverride = null) {
	emit(
		`Logger:Error`,
		'Database',
		log,
		flagOverride == null
			? {
					console: true,
					database: true,
					file: true,
					discord: { style: 'error' },
			  }
			: flagOverride,
	);
}

function checkDatabaseReady() {
	if (!gameDb || !authDb) {
		Log(`Database is not connected.`, { console: true });
		return false;
	}
	return true;
}

function checkParams(params) {
	return params !== null && typeof params === 'object';
}

function getParamsCollection(db, params) {
	if (!params.collection) return;
	return db.collection(params.collection);
}

const Methods = {
	isConnected: (db) => {
		return !!db;
	},
	insert: (db, params, callback) => {
		if (!checkDatabaseReady()) return;
		if (!checkParams(params)) return Log(`insert: Invalid params object.`);

		let collection = getParamsCollection(db, params);
		if (!collection)
			return Log(`insert: Invalid collection "${params.collection}"`);

		let documents = params.documents;
		if (!documents || !Array.isArray(documents))
			return Log(
				`insert: Invalid 'params.documents' value. Expected object or array of objects.`,
			);

		const options = utils.safeObjectArgument(params.options);

		collection.insertMany(documents, options, (err, result) => {
			if (err) {
				Log(`insert [${params.collection}]: Error "${err.message}".`);
				utils.safeCallback(callback, false, err.message);
				return;
			}
			let arrayOfIds = [];
			// Convert object to an array
			for (let key in result.insertedIds) {
				if (result.insertedIds.hasOwnProperty(key)) {
					arrayOfIds[parseInt(key)] =
						result.insertedIds[key].toString();
				}
			}

			utils.safeCallback(
				callback,
				true,
				result.insertedCount,
				arrayOfIds,
			);
		});
		process._tickCallback();
	},
	insertOne: (db, params, callback) => {
		if (checkParams(params)) {
			params.documents = [params.document];
			params.document = null;
		}
		return Methods.insert(db, params, callback);
	},
	find: (db, params, callback) => {
		if (!checkDatabaseReady()) return;
		if (!checkParams(params)) return Log(`find: Invalid params object.`);

		let collection = getParamsCollection(db, params);
		if (!collection)
			return Log(`find: Invalid collection "${params.collection}"`);

		const query = utils.safeObjectArgument(params.query);
		const options = utils.safeObjectArgument(params.options);

		let cursor = collection.find(query, options);
		if (params.limit) cursor = cursor.limit(params.limit);
		cursor.toArray((err, documents) => {
			if (err) {
				Log(`find [${params.collection}]: Error "${err.message}".`);
				utils.safeCallback(callback, false, err.message);
				return;
			}
			utils.safeCallback(
				callback,
				true,
				utils.exportDocuments(documents),
			);
		});
		process._tickCallback();
	},
	findOne: (db, params, callback) => {
		if (checkParams(params)) params.limit = 1;
		return Methods.find(db, params, callback);
	},
	update: (db, params, callback, isUpdateOne) => {
		if (!checkDatabaseReady()) return;
		if (!checkParams(params)) return Log(`update: Invalid params object.`);

		let collection = getParamsCollection(db, params);
		if (!collection)
			return Log(`update: Invalid collection "${params.collection}"`);

		query = utils.safeObjectArgument(params.query);
		update = utils.safeObjectArgument(params.update);
		options = utils.safeObjectArgument(params.options);

		const cb = (err, res) => {
			if (err) {
				Log(`update [${params.collection}]: Error "${err.message}".`);
				utils.safeCallback(callback, false, err.message);
				return;
			}
			utils.safeCallback(callback, true, res.result.nModified);
		};
		isUpdateOne
			? collection.updateOne(query, update, options, cb)
			: collection.updateMany(query, update, options, cb);
		process._tickCallback();
	},
	updateOne: (db, params, callback) => {
		return Methods.update(db, params, callback, true);
	},
	delete: (db, params, callback, isDeleteOne) => {
		if (!checkDatabaseReady()) return;
		if (!checkParams(params)) return Log(`delete: Invalid params object.`);

		let collection = getParamsCollection(db, params);
		if (!collection)
			return Log(`delete: Invalid collection "${params.collection}"`);

		const query = utils.safeObjectArgument(params.query);
		const options = utils.safeObjectArgument(params.options);

		const cb = (err, res) => {
			if (err) {
				Log(`delete [${params.collection}]: Error "${err.message}".`);
				utils.safeCallback(callback, false, err.message);
				return;
			}
			utils.safeCallback(callback, true, res.result.n);
		};
		isDeleteOne
			? collection.deleteOne(query, options, cb)
			: collection.deleteMany(query, options, cb);
		process._tickCallback();
	},
	deleteOne: (db, params, callback) => {
		return Methods.delete(db, params, callback, true);
	},
	count: (db, params, callback) => {
		if (!checkDatabaseReady()) return;
		if (!checkParams(params)) return Log(`count: Invalid params object.`);

		let collection = getParamsCollection(db, params);
		if (!collection)
			return Log(`count: Invalid collection "${params.collection}"`);

		const query = utils.safeObjectArgument(params.query);
		const options = utils.safeObjectArgument(params.options);

		collection.countDocuments(query, options, (err, count) => {
			if (err) {
				Log(`count [${params.collection}]: Error "${err.message}".`);
				utils.safeCallback(callback, false, err.message);
				return;
			}
			utils.safeCallback(callback, true, count);
		});
		process._tickCallback();
	},
	findOneAndUpdate: (db, params, callback) => {
		if (!checkDatabaseReady()) return;
		if (!checkParams(params)) return Log(`find: Invalid params object.`);

		let collection = getParamsCollection(db, params);
		if (!collection)
			return Log(
				`findOneAndUpdate: Invalid collection "${params.collection}"`,
			);

		query = utils.safeObjectArgument(params.query);
		update = utils.safeObjectArgument(params.update);
		options = utils.safeObjectArgument(params.options);

		const cb = (err, res) => {
			if (err) {
				Log(
					`findOneAndUpdate [${params.collection}]: Error "${err.message}".`,
				);
				utils.safeCallback(callback, false, err.message);
				return;
			}
			utils.safeCallback(callback, true, utils.exportDocument(res.value));
		};

		collection.findOneAndUpdate(query, update, options, cb);
		process._tickCallback();
	},

	aggregate: (db, params, callback) => {
		if (!checkDatabaseReady()) return;
		if (!checkParams(params))
			return Log(`aggregate: Invalid params object.`);

		let collection = getParamsCollection(db, params);
		if (!collection)
			return Log(`aggregate: Invalid collection "${params.collection}"`);
		let cursor = collection.aggregate(params.aggregate);
		cursor.toArray((err, documents) => {
			if (err) {
				Log(
					`aggregate [${params.collection}]: Error "${err.message}".`,
				);
				utils.safeCallback(callback, false, err.message);
				return;
			}
			utils.safeCallback(
				callback,
				true,
				utils.exportDocuments(documents),
			);
		});
		process._tickCallback();
	},
};
