document.addEventListener("DOMContentLoaded", () => {

    // ========================
    //  SCROLL REVEAL
    // ========================
    const revealElements = document.querySelectorAll('.reveal, .reveal-delay');
    const revealObserver = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('active');
                observer.unobserve(entry.target);
            }
        });
    }, { threshold: 0.12, rootMargin: "0px 0px -40px 0px" });

    revealElements.forEach(el => revealObserver.observe(el));

    // ========================
    //  MOBILE MENU TOGGLE
    // ========================
    const menuBtn = document.getElementById('mobileMenuBtn');
    const mobileMenu = document.getElementById('mobileMenu');
    if (menuBtn && mobileMenu) {
        menuBtn.addEventListener('click', () => {
            mobileMenu.classList.toggle('active');
        });
        // Close menu when a link is clicked
        mobileMenu.querySelectorAll('a').forEach(link => {
            link.addEventListener('click', () => {
                mobileMenu.classList.remove('active');
            });
        });
    }

    // ========================
    //  NAVBAR SCROLL EFFECT
    // ========================
    const navbar = document.querySelector('.navbar');
    window.addEventListener('scroll', () => {
        if (window.scrollY > 50) {
            navbar.style.background = 'rgba(0, 0, 0, 0.55)';
        } else {
            navbar.style.background = 'rgba(0, 0, 0, 0.25)';
        }
    });
});
