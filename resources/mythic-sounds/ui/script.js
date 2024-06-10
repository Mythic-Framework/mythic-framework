var AudioPlayers = new Array();

// Listen for NUI Messages.
window.addEventListener('message', function(event) {
    switch (event.data.action) {
        case 'playSound':
            if (AudioPlayers[event.data.source] != null && AudioPlayers[event.data.source][event.data.file] != null) {
                AudioPlayers[event.data.source][event.data.file].volume(event.data.volume);
                //AudioPlayers[event.data.source].stop();
                return;
            }

            if (AudioPlayers[event.data.source] == null) AudioPlayers[event.data.source] = Array();

            AudioPlayers[event.data.source][event.data.file] = new Howl({
                src: ["./sounds/" + event.data.file],
                onend: function() {
                    delete AudioPlayers[event.data.source][event.data.file];
                    $.post('https://mythic-sounds/SoundEnd', JSON.stringify({
                        source: event.data.source,
                        file: event.data.file
                    }))
                }
            });

            AudioPlayers[event.data.source][event.data.file].volume(event.data.volume);
            AudioPlayers[event.data.source][event.data.file].play();
            break;
        case 'loopSound':
            if (AudioPlayers[event.data.source] != null && AudioPlayers[event.data.source][event.data.file] != null) {
                AudioPlayers[event.data.source][event.data.file].volume(event.data.volume);
                //AudioPlayers[event.data.source].stop();
                return;
            }

            if (AudioPlayers[event.data.source] == null) AudioPlayers[event.data.source] = Array();

            AudioPlayers[event.data.source][event.data.file] = new Howl({
                src: ["./sounds/" + event.data.file],
                loop: true,
            });

            AudioPlayers[event.data.source][event.data.file].volume(event.data.volume);
            AudioPlayers[event.data.source][event.data.file].play();
            break;
        case 'stopSound':
            if (Boolean(AudioPlayers[event.data.source]) && Boolean(AudioPlayers[event.data.source][event.data.file])) {
                AudioPlayers[event.data.source][event.data.file].stop();
                delete AudioPlayers[event.data.source][event.data.file];
                // $.post('https://mythic-sounds/SoundEnd', JSON.stringify({
                //     source: event.data.source,
                //     file: event.data.file
                // }))
            }
            break;
        case 'fadeSound':
            if (Boolean(AudioPlayers[event.data.source]) && Boolean(AudioPlayers[event.data.source][event.data.file])) {
                AudioPlayers[event.data.source][event.data.file].fade(AudioPlayers[event.data.source][event.data.file].volume(), 0, 1000);
                AudioPlayers[event.data.source][event.data.file].once('fade', () => {
                    AudioPlayers[event.data.source][event.data.file].stop();
                    delete AudioPlayers[event.data.source][event.data.file];
                });
            }
            break;
        case 'updateVol':
            if (!Boolean(AudioPlayers[event.data.source][event.data.file])) {
                delete AudioPlayers[event.data.source][event.data.file];
                $.post('https://mythic-sounds/SoundEnd', JSON.stringify({
                    source: event.data.source,
                    file: event.data.file
                }))
            }
            AudioPlayers[event.data.source][event.data.file].volume(event.data.volume);
            break;
    }
});