const scoreTable = document.getElementById('score-table');
const scoreScreen = document.getElementById('scoreScreen');
const currentScore = document.getElementById('currentScore');

let doingCelebrate = false;
let showingSplash = false;

function clearScoreTable() {
    scoreTable.innerHTML = '';
}

function normalizeScores(firstScore, secondScore) {
    // Strike
    if (firstScore == 10) {
        firstScore = 'X';
        secondScore = null;
    } else {
        if (firstScore && secondScore) {
            // Spare
            if (firstScore + secondScore >= 10) {
                secondScore = '/'
            } else if (secondScore == 0) {
                secondScore = '-'
            }
        }
    }

    if (!firstScore) firstScore = '';
    if (!secondScore) secondScore = '';
    return [firstScore, secondScore];
};

function populateScoreTable(rounds = 5, playerData, currentlyPlaying) {
    let roundHeaders = '';
    for (i = 0; i < rounds; i++) {
        roundHeaders += `<td class="roundHeader">${i + 1}</td>`;
    };

    const currentPlayer = playerData.find(f => f.SID == currentlyPlaying);

    let lazyStuff = `
        <thead>
            <tr class="currentPlayer">
                <td colspan="${rounds + 2}">Next Ball: ${currentPlayer?.name ?? 'Waiting...'}</td>
            </tr>
            <tr>
                <td class="roundHeader">Name</td>
                ${roundHeaders}
                <td class="roundHeader">T</td>
            </tr>
        </thead>
        <tbody>
    `;

    for (const player of playerData) {
        let r = ``;
        for (i = 0; i < rounds; i++) {
            const hasRound = player.scores[i];
            if (hasRound) {
                if (hasRound.second === 0) {
                    hasRound.second = '-';
                } else if (!hasRound.second) {
                    hasRound.second = '';
                };

                const [first, second] = normalizeScores(hasRound.first, hasRound.second);

                r += `
                    <td>
                        <div class="roundScore">
                            <div>
                                <p>${first}</p>
                            </div>
                            <div>
                                <p>${second}</p>
                            </div>
                            <div>
                                <p>${hasRound.total}</p>
                            </div>
                        </div>
                    </td>
                `;
            } else {
                r += '<td></td>';
            }
        };
        lazyStuff += `
            <tr class="${player.SID == currentlyPlaying ? 'current' : ''}">
                <td>${player.name}</td>
                ${r}
                <td class="playerTotal">${player.total}</td>
            </tr>
        `;
    };

    lazyStuff += '</tbody>'

    scoreTable.innerHTML = lazyStuff;
};

function setScoreScreenVisiblity(state = true) {
    const isHidden = scoreScreen.classList.contains('hidden');

    if (state && isHidden) {
        scoreScreen.classList.remove('hidden');
    } else if (!state && !isHidden) {
        scoreScreen.classList.add('hidden');
    }
}

function setScoreCurrentVisiblity(state = true) {
    const isHidden = currentScore.classList.contains('hidden');

    if (state && isHidden) {
        currentScore.classList.remove('hidden');
    } else if (!state && !isHidden) {
        currentScore.classList.add('hidden');
        currentScore.innerHTML = '';
    }
}

function showCelebration(score = 10) {
    if (!doingCelebrate) {
        doingCelebrate = true;

        let timer = 7500;
        setScoreScreenVisiblity(false);
        setScoreCurrentVisiblity(true);
        if (score == 'strike') {
            currentScore.innerHTML = '<img src="./gifs/strike.gif" />';
        } else if (score == 'spare') {
            currentScore.innerHTML = '<img src="./gifs/spare.gif" />';
            timer = 8900;
        } else {
            currentScore.innerHTML = `<div class="bigScore">${score}</div>`;
        }

        setTimeout(() => {
            setScoreScreenVisiblity(true);
            setScoreCurrentVisiblity(false);
            currentScore.innerHTML = '';
            doingCelebrate = false;
        }, timer);
    }
}

// populateScoreTable(5, [
//     {
//         SID: 1,
//         name: 'Billy',
//         scores: [
//             { first: 1, second: 2, total: 3 },
//             { first: 2, second: 0, total: 5 }
//         ],
//         total: 8,
//     },
//     {
//         SID: 2,
//         name: 'Bobson',
//         scores: [
//             { first: 1, second: 2, total: 3 },
//             { first: 8, second: 2, total: 5 }
//         ],
//         total: 7,
//     },
//     {
//         SID: 3,
//         name: 'Dave',
//         scores: [
//             { first: 1, second: 2, total: 3 },
//             { first: 8, second: 2, total: 5 }
//         ],
//         total: 7,
//     },
//     {
//         SID: 4,
//         name: 'Ben',
//         scores: [
//             { first: 1, second: 2, total: 3 },
//             { first: 8, second: 2, total: 5 }
//         ],
//         total: 7,
//     },
//     {
//         SID: 4,
//         name: 'Ben',
//         scores: [
//             { first: 1, second: 2, total: 3 },
//             { first: 8, second: 2, total: 5 }
//         ],
//         total: 7,
//     },
// ], 2);

function showSplashScreen(link) {
    setScoreScreenVisiblity(false);
    setScoreCurrentVisiblity(true);

    let linkUrl = './gifs/homer.gif';
    if (link && link.length > 0) linkUrl = link;

    currentScore.innerHTML = `<img src="${linkUrl}" />`;
    showingSplash = true;
};

function hideSplashScreen() {
    if (showingSplash) {
        setScoreScreenVisiblity(true);
        setScoreCurrentVisiblity(false);
        currentScore.innerHTML = '';
        showingSplash = false;
    }
}

setTimeout(() => {
    showSplashScreen();
    // hideSplashScreen();
    // setScoreScreenVisiblity(true);
    // showCelebration(1)
}, 10);

window.addEventListener('message', e => {
    const item = e.data || e.detail;
    const { event, data } = item;
    if (event) {
        switch(event) {
            case 'showScore':
                showCelebration(data);
                break;
            case 'showSplash':
                showSplashScreen(data);
                break;
            default:
            case 'updateTable':
                hideSplashScreen();
                populateScoreTable(
                    5,
                    data.players,
                    data.currentPlayer,
                );
                break;
        }
    }
}, false);


