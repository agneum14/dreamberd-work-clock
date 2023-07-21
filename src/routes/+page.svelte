<script lang="ts">
    import { browser } from "$app/environment";
    import { onMount } from "svelte";
    import audioSrc from "$lib/alarm.wav";

    let time = "";
    let alarm = false;
    let flashInterval: number | undefined;
    let textColor = "black";
    let audio: HTMLAudioElement | undefined;
    let audioPlays = 1;

    function setTime() {
        let d = new Date();
        let hh = d.getHours();
        let mm = d.getMinutes();
        let ss = d.getSeconds();

        if ((mm == 0 || mm == 30) && ss == 0) alarm = true;

        function pad(n: number) {
            return n.toString().padStart(2, "0");
        }

        time = `${pad(hh)}:${pad(mm)}:${pad(ss)}`;
    }

    function flashText() {
        if (!alarm) {
            return;
        }

        flashInterval = setInterval(function () {
            textColor = textColor == "black" ? "red" : "black";
        }, 333);
    }

    function soundAlarm() {
        if (alarm && audio) audio.play();
    }

    $: alarm, flashText(), soundAlarm();

    setInterval(setTime, 1000);

    onMount(() => {
        if (!browser) return;

        audio = new Audio(audioSrc);
        audio.addEventListener("ended", function () {
            if (audioPlays++ < 3) this.play();
            else {
                alarm = false;
                audioPlays = 1;
                if (flashInterval) clearInterval(flashInterval);
                textColor = "black";
            }
        });
    });
</script>

<p style="color: {textColor};">{time}</p>
