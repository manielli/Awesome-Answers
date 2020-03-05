import anime from "animejs";

// console.log(anime);

document.addEventListener("DOMContentLoaded", () => {
    anime({
        targets: ".question-list > li",
        // translateX: 100,
        // duration: 10000,
        opacity: 1,
        duration: 100,
        delay: anime.stagger(100)
    })
})