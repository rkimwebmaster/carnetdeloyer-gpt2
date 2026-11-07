(() => {
    'use strict';
    const body = document.body;
    const base = body.dataset.apiUrl;
    const key = 'cdl-web-session';
    let refreshing;
    function session() {
        try { return JSON.parse(sessionStorage.getItem(key) || 'null'); } catch (_) { return null; }
    }
    function store(tokens) {
        try { sessionStorage.setItem(key, JSON.stringify({ token: tokens.token, refresh_token: tokens.refresh_token })); }
        catch (_) { throw new Error('Autorisez le stockage de session dans votre navigateur pour vous connecter.'); }
    }
    function clear() { try { sessionStorage.removeItem(key); } catch (_) { /* Facultatif. */ } }
    async function request(path, data, authenticated = false, retry = true) {
        const abort = new AbortController();
        const timer = setTimeout(() => abort.abort(), 20000);
        const headers = { Accept: 'application/json', 'Content-Type': 'application/json' };
        if (authenticated && session()?.token) headers.Authorization = `Bearer ${session().token}`;
        let response;
        try {
            response = await fetch(base + path, { method: data === undefined ? 'GET' : 'POST', headers, body: data === undefined ? undefined : JSON.stringify(data), signal: abort.signal, credentials: 'same-origin' });
        } catch (_) { throw new Error('Le serveur ne répond pas. Vérifiez la connexion et réessayez.'); }
        finally { clearTimeout(timer); }
        let result;
        try { result = await response.json(); } catch (_) { throw new Error(`Réponse inattendue du serveur (HTTP ${response.status}).`); }
        if (response.status === 401 && authenticated && retry && session()?.refresh_token) {
            refreshing ??= request('/auth/token/rafraichir', { refresh_token: session().refresh_token }).then(store).finally(() => { refreshing = null; });
            try { await refreshing; } catch (error) { clear(); throw error; }
            return request(path, data, true, false);
        }
        if (!response.ok) {
            if (response.status === 401 && authenticated) clear();
            throw new Error(result.message || `L’opération a échoué (HTTP ${response.status}). Réessayez.`);
        }
        return result;
    }
    if (session()?.token) {
        const link = document.querySelector('.login-link');
        if (link) { link.textContent = 'Mon espace'; link.href = body.dataset.espaceUrl; }
    }
    const auth = document.querySelector('[data-auth]');
    if (auth) {
        const phoneForm = auth.querySelector('[data-auth-phone]');
        const codeForm = auth.querySelector('[data-auth-code]');
        const profileForm = auth.querySelector('[data-auth-profile]');
        const errorBox = auth.querySelector('[data-auth-error]');
        const status = auth.querySelector('[data-auth-status]');
        let telephone = '';
        let registrationToken = '';
        let busy = false;
        function show(form, title, description, step) {
            [phoneForm, codeForm, profileForm].forEach((item) => { item.hidden = item !== form; });
            auth.querySelector('[data-auth-title]').textContent = title;
            auth.querySelector('[data-auth-description]').textContent = description;
            auth.querySelector('[data-auth-step]').textContent = step;
            status.hidden = true;
            errorBox.hidden = true;
            form.querySelector('input')?.focus();
        }
        async function perform(operation) {
            if (busy) return;
            busy = true;
            errorBox.hidden = true;
            status.hidden = true;
            auth.setAttribute('aria-busy', 'true');
            auth.querySelectorAll('button').forEach((button) => { button.disabled = true; });
            try { await operation(); }
            catch (error) { errorBox.textContent = error.message; errorBox.hidden = false; }
            finally {
                busy = false;
                auth.setAttribute('aria-busy', 'false');
                auth.querySelectorAll('button').forEach((button) => { button.disabled = false; });
            }
        }
        phoneForm.addEventListener('submit', (event) => {
            event.preventDefault();
            perform(async () => {
                telephone = new FormData(phoneForm).get('telephone').trim();
                await request('/auth/otp', { telephone });
                codeForm.reset();
                show(codeForm, 'Vérifions votre numéro.', `Saisissez le code pour ${telephone}.`, 'ÉTAPE 2 SUR 2');
            });
        });
        codeForm.addEventListener('submit', (event) => {
            event.preventDefault();
            perform(async () => {
                const result = await request('/auth/otp/verification', { telephone, code: new FormData(codeForm).get('code') });
                if (result.inscriptionRequise) {
                    registrationToken = result.jetonInscription;
                    show(profileForm, 'Faisons connaissance.', 'Votre numéro est vérifié. Il reste à personnaliser votre espace.', 'DERNIÈRE ÉTAPE');
                } else { store(result); window.location.assign(body.dataset.espaceUrl); }
            });
        });
        profileForm.addEventListener('submit', (event) => {
            event.preventDefault();
            perform(async () => {
                const values = new FormData(profileForm);
                const tokens = await request('/auth/inscription', { telephone, jetonInscription: registrationToken, nom: values.get('nom').trim(), codeParrain: values.get('codeParrain').trim() || null });
                store(tokens);
                window.location.assign(body.dataset.espaceUrl);
            });
        });
        auth.querySelector('[data-auth-change]').addEventListener('click', () => {
            codeForm.reset(); registrationToken = '';
            show(phoneForm, 'Votre numéro de téléphone.', 'Utilisez votre numéro au format international.', 'ÉTAPE 1 SUR 2');
        });
        auth.querySelector('[data-auth-resend]').addEventListener('click', () => perform(async () => {
            await request('/auth/otp', { telephone });
            codeForm.reset();
            status.textContent = 'Une nouvelle demande de code a été créée.';
            status.hidden = false;
            codeForm.querySelector('input').focus();
        }));
    }
    const account = document.querySelector('[data-account]');
    if (account) {
        account.querySelector('[data-logout]').addEventListener('click', () => { clear(); window.location.assign(body.dataset.connexionUrl); });
        if (!session()?.token) { window.location.replace(body.dataset.connexionUrl); return; }
        (async () => {
            const error = account.querySelector('[data-account-error]');
            try {
                const profile = await request('/moi', undefined, true);
                account.querySelector('[data-account-name]').textContent = profile.nom;
                account.querySelector('[data-account-phone]').textContent = profile.telephone;
                const stats = await request('/tableau-de-bord', undefined, true);
                account.querySelector('[data-account-unites]').textContent = stats.unites;
                account.querySelector('[data-account-louees]').textContent = stats.unitesLouees;
                account.querySelector('[data-account-vacantes]').textContent = stats.unitesVacantes;
                account.querySelector('[data-account-content]').hidden = false;
            } catch (failure) {
                if (!session()?.token) { window.location.replace(body.dataset.connexionUrl); return; }
                error.textContent = failure.message;
                error.hidden = false;
            } finally { account.querySelector('[data-account-loading]').hidden = true; }
        })();
    }
})();
