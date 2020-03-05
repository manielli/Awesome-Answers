import anime from "animejs";

// console.log(anime);

document.addEventListener("DOMContentLoaded", () => {
    anime({
        targets: ".question-list > li",
        // translateX: 100,
        // duration: 1000,
        opacity: 1,
        // duration: 10,
        delay: anime.stagger(50)
    })
})