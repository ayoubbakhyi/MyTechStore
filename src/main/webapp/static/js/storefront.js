(function () {
    var toggle = document.querySelector("[data-nav-toggle]");
    var links = document.querySelector("[data-nav-links]");

    if (toggle && links) {
        toggle.addEventListener("click", function () {
            links.classList.toggle("hidden");
            var isOpen = !links.classList.contains("hidden");
            toggle.setAttribute("aria-expanded", String(isOpen));
        });
    }

    var autoInputs = document.querySelectorAll("[data-submit-on-change]");
    autoInputs.forEach(function (input) {
        input.addEventListener("change", function () {
            if (input.form) {
                input.form.submit();
            }
        });
    });
})();
