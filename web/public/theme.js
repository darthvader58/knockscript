const themeToggle = document.getElementById('themeToggle');
const THEME_STORAGE_KEY = 'knockscript_theme';
const MOON_ICON_PATH = 'M21 12.79A9 9 0 1 1 11.21 3a7 7 0 0 0 9.79 9.79z';
const SUN_ICON_PATH = 'M12 3V5M12 19V21M4.22 4.22L5.64 5.64M18.36 18.36L19.78 19.78M3 12H5M19 12H21M4.22 19.78L5.64 18.36M18.36 5.64L19.78 4.22M12 8A4 4 0 1 1 12 16A4 4 0 0 1 12 8z';

function getPreferredTheme() {
    const savedTheme = localStorage.getItem(THEME_STORAGE_KEY);
    if (savedTheme === 'dark' || savedTheme === 'light') {
        return savedTheme;
    }

    return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
}

function applyTheme(theme) {
    const isDark = theme === 'dark';
    document.documentElement.classList.toggle('theme-dark', isDark);
    document.body.classList.toggle('theme-dark', isDark);

    if (!themeToggle) {
        return;
    }

    themeToggle.setAttribute('aria-pressed', String(isDark));
    const iconPath = themeToggle.querySelector('.theme-toggle-icon path');
    if (iconPath) {
        iconPath.setAttribute('d', isDark ? SUN_ICON_PATH : MOON_ICON_PATH);
    }

    themeToggle.setAttribute('aria-label', isDark ? 'Enable light mode' : 'Enable dark mode');
}

applyTheme(getPreferredTheme());

if (themeToggle) {
    themeToggle.addEventListener('click', () => {
        const nextTheme = document.body.classList.contains('theme-dark') ? 'light' : 'dark';
        localStorage.setItem(THEME_STORAGE_KEY, nextTheme);
        applyTheme(nextTheme);
    });
}
