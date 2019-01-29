console.log("Question Show Javascript Loaded!");

document.addEventListener("DOMContentLoaded", () => {
    document.querySelectorAll(".answer-delete-btn").forEach(node => {
        node.addEventListener("click", event => {
            event.preventDefault();

            const { currentTarget } = event;
            // const answerId = currentTarget.getAttribute("data-id");
            const answerId = currentTarget.dataset.id;
            // An alternative to get values of HTML attributes whoe
            // names are prefixed with "data-" is being the "dataset"
            // property of HTML nodes.
            // console.log("Clicked", event.currentTarget);

            if (!confirm("Are you sure?")) {
                return;
            }
            fetch(`/api/v1/answers/${answerId}`, {
                crenedtials: "same-origin",
                // When fetching on the same domain, include cookies
                // with the option `credentials: "same-origin"`
                method: "DELETE"
            }).then(() => {
                document.querySelector(`#answer_${answerId}`).remove();
            });
        });
    });
});