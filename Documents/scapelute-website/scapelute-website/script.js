// ── Scroll reveal ──
const ro = new IntersectionObserver(
  entries => entries.forEach(e => {
    if (e.isIntersecting) { e.target.classList.add('visible'); ro.unobserve(e.target); }
  }),
  { threshold: 0.1 }
);
document.querySelectorAll('.reveal').forEach(el => ro.observe(el));

// ── Sticky navbar ──
const navbar = document.getElementById('navbar');
window.addEventListener('scroll', () => {
  navbar.classList.toggle('scrolled', window.scrollY > 60);
}, { passive: true });

// ── Hamburger ──
const hamburger = document.getElementById('hamburger');
const navLinks  = document.getElementById('navLinks');
let menuOpen = false;

hamburger.addEventListener('click', () => {
  menuOpen = !menuOpen;
  hamburger.setAttribute('aria-expanded', menuOpen);
  hamburger.classList.toggle('open', menuOpen);
  navLinks.classList.toggle('open', menuOpen);
});

// Close menu when a link is tapped
navLinks.querySelectorAll('a').forEach(a => {
  a.addEventListener('click', () => {
    menuOpen = false;
    hamburger.setAttribute('aria-expanded', 'false');
    hamburger.classList.remove('open');
    navLinks.classList.remove('open');
  });
});
