export const initialState = {
    runningId: 0,
    notifications: Array(),
    // runningId: 6,
    // notifications: Array(
    //     {
    //         _id: 1,
    //         created: 1629674399000,
    //         icon: 'rocket-launch',
    //         message: 'This is a test description, neat',
    //         duration: 5000,
    //         type: 'success',
    //         style: null,
    //     },
    //     {
    //         _id: "fuckme-123",
    //         created: 1629674399000,
    //         icon: 'rocket-launch',
    //         message: 'This is a test description, neat',
    //         duration: 5000,
    //         type: 'success',
    //         style: null,
    //     },
    //     {
    //         _id: 2,
    //         created: 1629674399000,
    //         icon: 'rocket-launch',
    //         message: 'This is a test description, neat',
    //         duration: 6000,
    //         type: 'error',
    //         style: null,
    //     },
    //     {
    //         _id: 3,
    //         created: 1629674399000,
    //         icon: 'rocket-launch',
    //         message: 'This is a test description, neat',
    //         duration: 7000,
    //         type: 'info',
    //         style: null,
    //     },
    //     {
    //         _id: 4,
    //         created: 1629674399000,
    //         icon: 'rocket-launch',
    //         message: 'This is a test description, neat',
    //         duration: 8000,
    //         type: 'warning',
    //         style: null,
    //     },
    //     {
    //         _id: 5,
    //         created: 1629674399000,
    //         icon: 'rocket-launch',
    //         message: 'This is a test description, neat',
    //         duration: 9000,
    //         type: 'custom',
    //         style: {
    //             alert: {
    //                 background: 'pink',
    //                 color: 'black',
    //             },
    //             progressBg: {
    //                 background: 'green',
    //             },
    //             progress: {
    //                 background: 'red',
    //             },
    //         },
    //     },
    //     {
    //         _id: 6,
    //         created: 1629674399000,
    //         icon: 'rocket-launch',
    //         message: 'This is a test description, neat',
    //         duration: -1,
    //     },
    // ),
};

export default (state = initialState, action) => {
    switch (action.type) {
        case 'CLEAR_ALERTS':
            return {
                runningId: 0,
                notifications: Array(),
            };
        case 'ADD_ALERT':
            return {
                ...state,
                notifications:
                    Boolean(action.payload.notification._id) &&
                    state.notifications.filter(
                        (n) => n._id == action.payload.notification._id,
                    ).length > 0
                        ? [
                              ...state.notifications.map((n) => {
                                  if (
                                      n._id == action.payload.notification._id
                                  ) {
                                      return {
                                          ...n,
                                          ...action.payload.notification,
                                      };
                                  } else return n;
                              }),
                          ]
                        : [
                              ...state.notifications,
                              {
                                  _id: state.runningId + 1,
                                  created: Date.now(),
                                  ...action.payload.notification,
                              },
                          ],
                runningId: state.runningId + 1,
            };
        case 'REMOVE_ALERT':
            return {
                ...state,
                notifications: [
                    ...state.notifications.filter(
                        (n) => n._id != action.payload.id,
                    ),
                ],
            };
        case 'HIDE_ALERT':
            return {
                ...state,
                notifications: [
                    ...state.notifications.map((n) => {
                        if (n._id == action.payload.id) {
                            return { ...n, hide: true };
                        } else return n;
                    }),
                ],
            };
        default:
            return state;
    }
};
