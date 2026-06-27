/* Digital Notice Board v9 — site.js */
(function () {
  'use strict';

  /* ── Dark / Light mode ────────────────────────────────────── */
  var saved = localStorage.getItem('dnb-theme') || 'dark';
  document.documentElement.setAttribute('data-theme', saved);

  var modeBtn = document.getElementById('modeToggle');
  if (modeBtn) {
    updateToggleIcon(saved);
    modeBtn.addEventListener('click', function () {
      var cur = document.documentElement.getAttribute('data-theme');
      var next = cur === 'dark' ? 'light' : 'dark';
      document.documentElement.setAttribute('data-theme', next);
      localStorage.setItem('dnb-theme', next);
      updateToggleIcon(next);
    });
  }
  function updateToggleIcon(theme) {
    if (!modeBtn) return;
    modeBtn.innerHTML = theme === 'dark'
      ? '<i class="fas fa-sun"></i>'
      : '<i class="fas fa-moon"></i>';
    modeBtn.title = theme === 'dark' ? 'Switch to Light Mode' : 'Switch to Dark Mode';
  }

  /* ── Live clock ───────────────────────────────────────────── */
  var clockEl = document.querySelector('.time-chip') || document.getElementById('adminClock');
  if (clockEl) {
    function updateClock() {
      var now = new Date();
      var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      var d = months[now.getMonth()] + ' ' + String(now.getDate()).padStart(2,'0') + ', ' + now.getFullYear();
      var t = String(now.getHours()).padStart(2,'0') + ':' + String(now.getMinutes()).padStart(2,'0') + ':' + String(now.getSeconds()).padStart(2,'0');
      clockEl.innerHTML = '<i class="fas fa-clock me-1"></i>' + d + ' &nbsp;' + t;
    }
    updateClock();
    setInterval(updateClock, 1000);
  }

  /* ── Mobile sidebar ───────────────────────────────────────── */
  document.querySelectorAll('.sidebar-toggle').forEach(function (btn) {
    btn.addEventListener('click', function (e) {
      e.preventDefault();
      var sb = document.getElementById('sidebar');
      if (sb) sb.classList.toggle('open');
    });
  });
  document.addEventListener('click', function (e) {
    var sb = document.getElementById('sidebar');
    if (!sb) return;
    if (sb.classList.contains('open') && !sb.contains(e.target) && !e.target.closest('.sidebar-toggle')) {
      sb.classList.remove('open');
    }
  });

  /* ── Auto-dismiss alerts ──────────────────────────────────── */
  document.querySelectorAll('.alert-box.alert-ok').forEach(function (el) {
    setTimeout(function () {
      el.style.transition = 'opacity .6s, transform .6s';
      el.style.opacity = '0'; el.style.transform = 'translateY(-8px)';
      setTimeout(function () { el.style.display = 'none'; }, 600);
    }, 6000);
  });

  /* ── Filter active state ──────────────────────────────────── */
  document.querySelectorAll('.filter-btn').forEach(function (btn) {
    btn.addEventListener('click', function () {
      document.querySelectorAll('.filter-btn').forEach(function (b) { b.classList.remove('active'); });
      this.classList.add('active');
    });
  });

  /* ── Staggered card entrance ──────────────────────────────── */
  var cards = document.querySelectorAll('.notice-card, .stat-tile, .feat-card, .msg-card, .reply-card, .stat-card, .quick-action-card');
  if ('IntersectionObserver' in window) {
    var i = 0;
    var obs = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          var delay = (i++ % 12) * 65;
          setTimeout(function () {
            entry.target.style.opacity = '1';
            entry.target.style.transform = 'translateY(0)';
          }, delay);
          obs.unobserve(entry.target);
        }
      });
    }, { threshold: 0.06 });
    cards.forEach(function (c) {
      c.style.opacity = '0';
      c.style.transform = 'translateY(20px)';
      c.style.transition = 'opacity .42s ease, transform .42s ease';
      obs.observe(c);
    });
  }

  /* ── Animated stat counters ───────────────────────────────── */
  function animateCount(el) {
    var target = parseInt(el.textContent);
    if (isNaN(target) || target <= 0) return;
    var start = 0, steps = 30;
    var inc = Math.ceil(target / steps);
    var id = setInterval(function () {
      start = Math.min(start + inc, target);
      el.textContent = start;
      if (start >= target) clearInterval(id);
    }, 28);
  }
  if ('IntersectionObserver' in window) {
    document.querySelectorAll('.st-num, .stat-num, .stu-num').forEach(function (el) {
      var once = new IntersectionObserver(function (entries) {
        entries.forEach(function (e) {
          if (e.isIntersecting) { animateCount(el); once.unobserve(el); }
        });
      });
      once.observe(el);
    });
  }

  /* ── Keyboard shortcuts ───────────────────────────────────── */
  document.addEventListener('keydown', function (e) {
    var tag = document.activeElement.tagName;
    if (e.key === '/' && tag !== 'INPUT' && tag !== 'TEXTAREA') {
      e.preventDefault();
      var si = document.querySelector('.search-inp');
      if (si) { si.focus(); si.select(); }
    }
    if (e.key === 'Escape') {
      var sb = document.getElementById('sidebar');
      if (sb && sb.classList.contains('open')) sb.classList.remove('open');
    }
  });

  /* ── Image preview ────────────────────────────────────────── */
  var fu = document.querySelector('[id$="fuImage"]');
  var prev = document.getElementById('imgPreview');
  if (fu && prev) {
    fu.addEventListener('change', function () {
      var f = this.files[0]; if (!f) return;
      var r = new FileReader();
      r.onload = function (e) { prev.src = e.target.result; prev.style.display = 'block'; };
      r.readAsDataURL(f);
    });
  }

})();
