'use strict';
(function () {
  const tabs = Array.from(document.querySelectorAll('[role="tab"]'));
  function activate(tab, focus) {
    const group = tab.closest('[role="tablist"]');
    group.querySelectorAll('[role="tab"]').forEach(function (item) {
      const selected = item === tab;
      item.setAttribute('aria-selected', String(selected));
      item.tabIndex = selected ? 0 : -1;
      const panel = document.getElementById(item.getAttribute('aria-controls'));
      if (panel) panel.hidden = !selected;
    });
    if (focus) tab.focus();
  }
  tabs.forEach(function (tab) {
    tab.tabIndex = tab.getAttribute('aria-selected') === 'true' ? 0 : -1;
    tab.addEventListener('click', function () { activate(tab, false); });
    tab.addEventListener('keydown', function (event) {
      const peers = Array.from(tab.closest('[role="tablist"]').querySelectorAll('[role="tab"]'));
      let next;
      if (event.key === 'ArrowRight') next = peers[(peers.indexOf(tab) + 1) % peers.length];
      if (event.key === 'ArrowLeft') next = peers[(peers.indexOf(tab) - 1 + peers.length) % peers.length];
      if (event.key === 'Home') next = peers[0];
      if (event.key === 'End') next = peers[peers.length - 1];
      if (next) { event.preventDefault(); activate(next, true); }
    });
  });
  const status = document.createElement('span');
  status.className = 'sr-status';
  status.setAttribute('role', 'status');
  status.style.cssText = 'position:absolute;width:1px;height:1px;overflow:hidden;clip-path:inset(50%)';
  document.body.appendChild(status);
  async function copyText(text) {
    if (navigator.clipboard && window.isSecureContext) {
      try { await navigator.clipboard.writeText(text); return; } catch (_) { /* local-file fallback */ }
    }
    const field = document.createElement('textarea');
    field.value = text;
    field.setAttribute('readonly', '');
    field.style.cssText = 'position:fixed;left:-9999px;top:0';
    document.body.appendChild(field);
    field.select();
    const ok = document.execCommand('copy');
    field.remove();
    if (!ok) throw new Error('Clipboard unavailable');
  }
  document.querySelectorAll('[data-copy], [data-copy-active]').forEach(function (button) {
    const label = button.textContent;
    let reset;
    button.addEventListener('click', async function () {
      const target = button.hasAttribute('data-copy-active')
        ? document.querySelector('[role="tabpanel"]:not([hidden]) pre')
        : document.getElementById(button.dataset.copy);
      if (!target) return;
      window.clearTimeout(reset);
      try {
        await copyText(target.textContent);
        button.textContent = 'Copied';
        status.textContent = 'Copied to clipboard.';
      } catch (_) {
        button.textContent = 'Select text to copy';
        status.textContent = 'Clipboard unavailable. Select and copy the text manually.';
      }
      reset = window.setTimeout(function () { button.textContent = label; }, 2000);
    });
  });
})();
