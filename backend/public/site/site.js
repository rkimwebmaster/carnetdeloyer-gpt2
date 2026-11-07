(() => {
    'use strict';
    const root = document.documentElement;
    const themeButton = document.querySelector('[data-theme-toggle]');
    const preference = window.matchMedia('(prefers-color-scheme: dark)');
    let savedTheme = null;
    try { savedTheme = localStorage.getItem('cdl-site-theme'); } catch (_) { /* Stockage facultatif. */ }
    function setTheme(theme) {
        root.dataset.theme = theme;
        themeButton?.setAttribute('aria-label', `Activer le thème ${theme === 'dark' ? 'clair' : 'sombre'}`);
        themeButton?.setAttribute('aria-pressed', String(theme === 'dark'));
    }
    setTheme(savedTheme === 'dark' || savedTheme === 'light' ? savedTheme : (preference.matches ? 'dark' : 'light'));
    themeButton?.addEventListener('click', () => {
        savedTheme = root.dataset.theme === 'dark' ? 'light' : 'dark';
        setTheme(savedTheme);
        try { localStorage.setItem('cdl-site-theme', savedTheme); } catch (_) { /* Pas de blocage si indisponible. */ }
    });
    preference.addEventListener('change', (event) => { if (!savedTheme) setTheme(event.matches ? 'dark' : 'light'); });

    const menu = document.querySelector('.menu-toggle');
    const navigation = document.getElementById('navigation');
    function closeMenu() {
        navigation?.classList.remove('open');
        menu?.setAttribute('aria-expanded', 'false');
        menu?.setAttribute('aria-label', 'Ouvrir le menu');
    }
    menu?.addEventListener('click', () => {
        const open = navigation.classList.toggle('open');
        menu.setAttribute('aria-expanded', String(open));
        menu.setAttribute('aria-label', open ? 'Fermer le menu' : 'Ouvrir le menu');
    });
    navigation?.addEventListener('click', (event) => { if (event.target.closest('a')) closeMenu(); });
    document.addEventListener('keydown', (event) => {
        if (event.key === 'Escape' && navigation?.classList.contains('open')) { closeMenu(); menu.focus(); }
    });

    const rent = document.getElementById('loyer');
    const estimate = document.getElementById('estimation');
    const currency = new Intl.NumberFormat('fr-FR', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    rent?.addEventListener('input', () => {
        const value = rent.valueAsNumber;
        estimate.textContent = rent.validity.valid && Number.isFinite(value) && value >= 0
            ? `${currency.format(Math.round(value * 100 * 0.099) / 100)} USD`
            : 'Indiquez un loyer valide';
    });

    const tabs = [...document.querySelectorAll('[data-tab]')];
    function activateTab(tab) {
        tabs.forEach((item) => {
            const selected = item === tab;
            item.setAttribute('aria-selected', String(selected));
            item.tabIndex = selected ? 0 : -1;
        });
        document.querySelectorAll('[data-panel]').forEach((panel) => { panel.hidden = panel.dataset.panel !== tab.dataset.tab; });
    }
    tabs.forEach((tab, index) => {
        tab.addEventListener('click', () => activateTab(tab));
        tab.addEventListener('keydown', (event) => {
            let next;
            if (event.key === 'ArrowDown' || event.key === 'ArrowRight') next = tabs[(index + 1) % tabs.length];
            if (event.key === 'ArrowUp' || event.key === 'ArrowLeft') next = tabs[(index - 1 + tabs.length) % tabs.length];
            if (event.key === 'Home') next = tabs[0];
            if (event.key === 'End') next = tabs[tabs.length - 1];
            if (next) { event.preventDefault(); activateTab(next); next.focus(); }
        });
    });
})();
