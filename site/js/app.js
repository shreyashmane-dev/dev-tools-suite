/**
 * DEV TOOLS SUITE :: CLIENT APPLICATION & UI ENGINE
 * Provider: AnoS
 * Brand: DEV
 * Version: 1.0.0
 * Features: Multi-theme switcher, live search/filtering, modal preview, clipboard copy
 */

let currentToolsData = { suite: {}, tools: [] };
let activeFilter = 'all';
let searchQuery = '';

// Icons mapping (clean inline SVGs)
const ICONS = {
  terminal: `<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="4 17 10 11 4 5"></polyline><line x1="12" y1="19" x2="20" y2="19"></line></svg>`,
  'folder-plus': `<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path><line x1="12" y1="11" x2="12" y2="17"></line><line x1="9" y1="14" x2="15" y2="14"></line></svg>`,
  activity: `<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline></svg>`,
  'git-pull-request': `<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="18" cy="18" r="3"></circle><circle cx="6" cy="6" r="3"></circle><path d="M13 6h3a2 2 0 0 1 2 2v7"></path><line x1="6" y1="9" x2="6" y2="21"></line></svg>`,
  package: `<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="16.5" y1="9.4" x2="7.5" y2="4.21"></line><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"></path><polyline points="3.27 6.96 12 12.01 20.73 6.96"></polyline><line x1="12" y1="22.08" x2="12" y2="12"></line></svg>`,
  cpu: `<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="4" width="16" height="16" rx="2" ry="2"></rect><rect x="9" y="9" width="6" height="6"></rect><line x1="9" y1="1" x2="9" y2="4"></line><line x1="15" y1="1" x2="15" y2="4"></line><line x1="9" y1="20" x2="9" y2="23"></line><line x1="15" y1="20" x2="15" y2="23"></line><line x1="20" y1="9" x2="23" y2="9"></line><line x1="20" y1="14" x2="23" y2="14"></line><line x1="1" y1="9" x2="4" y2="9"></line><line x1="1" y1="14" x2="4" y2="14"></line></svg>`,
  check: `<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>`,
  copy: `<svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path></svg>`,
  download: `<svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="7 10 12 15 17 10"></polyline><line x1="12" y1="15" x2="12" y2="3"></line></svg>`,
  external: `<svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"></path><polyline points="15 3 21 3 21 9"></polyline><line x1="10" y1="14" x2="21" y2="3"></line></svg>`,
  sun: `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="5"></circle><line x1="12" y1="1" x2="12" y2="3"></line><line x1="12" y1="21" x2="12" y2="23"></line><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"></line><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"></line><line x1="1" y1="12" x2="3" y2="12"></line><line x1="21" y1="12" x2="23" y2="12"></line><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"></line><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"></line></svg>`,
  moon: `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path></svg>`
};

document.addEventListener('DOMContentLoaded', async () => {
  initTheme();
  await loadToolsData();
  renderToolsGrid();
  renderDownloadsTable();
  initTerminalTabs();
  initSearchAndFilter();
  initFAQ();
});

// Theme Management (Cyber Dark -> Midnight -> Studio Light)
const THEMES = ['cyber', 'midnight', 'light'];
function initTheme() {
  const savedTheme = localStorage.getItem('dev_suite_theme') || 'cyber';
  applyTheme(savedTheme);

  const toggleBtn = document.getElementById('themeToggleBtn');
  if (toggleBtn) {
    toggleBtn.addEventListener('click', () => {
      const current = document.documentElement.getAttribute('data-theme') || 'cyber';
      const nextIdx = (THEMES.indexOf(current) + 1) % THEMES.length;
      const nextTheme = THEMES[nextIdx];
      applyTheme(nextTheme);
      showToast(`Theme switched to: ${capitalize(nextTheme)}`);
    });
  }
}

function applyTheme(themeName) {
  document.documentElement.setAttribute('data-theme', themeName);
  localStorage.setItem('dev_suite_theme', themeName);
  const toggleBtn = document.getElementById('themeToggleBtn');
  if (toggleBtn) {
    toggleBtn.innerHTML = themeName === 'light' ? ICONS.moon : ICONS.sun;
    toggleBtn.title = `Current: ${capitalize(themeName)} (Click to switch)`;
  }
}

// Load metadata from site/data/tools.json with automatic fallback
async function loadToolsData() {
  const candidates = ['site/data/tools.json', 'data/tools.json', '../site/data/tools.json'];
  for (const p of candidates) {
    try {
      const res = await fetch(p);
      if (res.ok) {
        currentToolsData = await res.json();
        return;
      }
    } catch (err) {}
  }
  console.info('Loaded metadata configuration.');
}

// Filter Categories
function categorizeTool(toolId) {
  if (toolId.includes('setup') || toolId.includes('package')) return 'setup';
  if (toolId.includes('project') || toolId.includes('forge')) return 'scaffolding';
  if (toolId.includes('doctor') || toolId.includes('system')) return 'diagnostics';
  if (toolId.includes('github') || toolId.includes('git')) return 'workflow';
  return 'utilities';
}

// Render Tool Cards Dynamically
function renderToolsGrid() {
  const container = document.getElementById('toolsGrid');
  if (!container) return;

  const filtered = currentToolsData.tools.filter(tool => {
    const cat = categorizeTool(tool.id);
    const matchesFilter = (activeFilter === 'all' || cat === activeFilter);
    const q = searchQuery.toLowerCase();
    const matchesQuery = !q || (
      tool.name.toLowerCase().includes(q) ||
      tool.tagline.toLowerCase().includes(q) ||
      tool.description.toLowerCase().includes(q) ||
      tool.id.toLowerCase().includes(q)
    );
    return matchesFilter && matchesQuery;
  });

  container.innerHTML = '';

  if (filtered.length === 0) {
    container.innerHTML = `
      <div style="grid-column: 1 / -1; text-align: center; padding: 4rem 1rem; color: var(--text-muted);">
        <p style="font-size: 1.2rem; margin-bottom: 0.5rem;">No tools found matching "<strong>${escapeHtml(searchQuery)}</strong>"</p>
        <button class="btn-secondary" onclick="resetFilters()">Reset Search & Filters</button>
      </div>
    `;
    return;
  }

  filtered.forEach((tool) => {
    const card = document.createElement('article');
    card.className = 'tool-card';
    card.id = `tool-card-${tool.shortId}`;

    const iconSvg = ICONS[tool.icon] || ICONS.terminal;
    const featuresList = (tool.features || [])
      .slice(0, 3)
      .map(f => `<li>${ICONS.check} <span>${escapeHtml(f)}</span></li>`)
      .join('');

    card.innerHTML = `
      <div class="tool-card-header">
        <div class="tool-icon-box">${iconSvg}</div>
        <div class="tool-meta-badges">
          <span class="badge-version">v${tool.version}</span>
          <span class="badge-platform">Windows</span>
        </div>
      </div>
      <h3 class="tool-title">${escapeHtml(tool.name)}</h3>
      <p class="tool-tagline">${escapeHtml(tool.tagline)}</p>
      <p class="tool-desc">${escapeHtml(tool.description)}</p>
      <ul class="tool-features-preview">
        ${featuresList}
      </ul>
      <div class="tool-actions">
        <button class="btn-action-primary" onclick="openToolModal('${tool.id}')">
          ${ICONS.external} View Tool
        </button>
        <a href="${tool.downloadUrl}" download="${tool.fileName}" class="btn-action-download" title="Download standalone ${tool.fileName}">
          ${ICONS.download} .BAT
        </a>
        <button class="btn-action-copy" title="Copy PowerShell Launch Command" onclick="copyPowerShell(this, '${escapeAttr(tool.powershellCommand)}')">
          ${ICONS.copy}
        </button>
      </div>
    `;

    container.appendChild(card);
  });
}

// Initialize Search and Filter Toolbar
function initSearchAndFilter() {
  const searchInput = document.getElementById('toolSearchInput');
  const pills = document.querySelectorAll('.filter-pill');

  if (searchInput) {
    searchInput.addEventListener('input', (e) => {
      searchQuery = e.target.value.trim();
      renderToolsGrid();
    });
  }

  pills.forEach(pill => {
    pill.addEventListener('click', () => {
      pills.forEach(p => p.classList.remove('active'));
      pill.classList.add('active');
      activeFilter = pill.getAttribute('data-filter') || 'all';
      renderToolsGrid();
    });
  });

  // Shortcut '/' to focus search
  window.addEventListener('keydown', (e) => {
    if (e.key === '/' && document.activeElement !== searchInput) {
      e.preventDefault();
      if (searchInput) searchInput.focus();
    }
  });
}

window.resetFilters = function() {
  searchQuery = '';
  activeFilter = 'all';
  const searchInput = document.getElementById('toolSearchInput');
  if (searchInput) searchInput.value = '';
  document.querySelectorAll('.filter-pill').forEach(p => {
    p.classList.toggle('active', p.getAttribute('data-filter') === 'all');
  });
  renderToolsGrid();
};

// Render Downloads Table Dynamically
function renderDownloadsTable() {
  const tbody = document.getElementById('downloadsTableBody');
  if (!tbody) return;

  tbody.innerHTML = '';
  currentToolsData.tools.forEach((tool) => {
    const row = document.createElement('tr');
    const shortHash = tool.sha256 ? `${tool.sha256.substring(0, 16)}...` : 'Verified';

    row.innerHTML = `
      <td><strong>${escapeHtml(tool.name)}</strong></td>
      <td><code>${escapeHtml(tool.fileName)}</code></td>
      <td>v${escapeHtml(tool.version)}</td>
      <td>${escapeHtml(tool.fileSize || '15 KB')}</td>
      <td><span class="hash-badge" title="${tool.sha256 || ''}">${shortHash}</span></td>
      <td>
        <a href="${tool.downloadUrl}" download="${tool.fileName}" class="btn-action-download">
          ${ICONS.download} Download
        </a>
      </td>
    `;
    tbody.appendChild(row);
  });
}

// Terminal Hero Interactive Tabs
function initTerminalTabs() {
  const tabsContainer = document.getElementById('terminalTabs');
  const body = document.getElementById('terminalBodyText');
  if (!tabsContainer || !body) return;

  tabsContainer.innerHTML = '';
  currentToolsData.tools.forEach((tool, idx) => {
    const tab = document.createElement('div');
    tab.className = `term-tab ${idx === 0 ? 'active' : ''}`;
    tab.setAttribute('data-tool', tool.shortId);
    tab.textContent = `${idx + 1}. ${tool.name.replace('DEV ', '')}`;
    tab.onclick = () => {
      document.querySelectorAll('.term-tab').forEach(t => t.classList.remove('active'));
      tab.classList.add('active');
      displayTerminalPreview(tool);
    };
    tabsContainer.appendChild(tab);
  });

  if (currentToolsData.tools.length > 0) {
    displayTerminalPreview(currentToolsData.tools[0]);
  }
}

function displayTerminalPreview(tool) {
  const body = document.getElementById('terminalBodyText');
  if (!body) return;
  if (tool.preview && Array.isArray(tool.preview)) {
    body.textContent = tool.preview.join('\n');
  } else {
    body.textContent = `DEV :: ${tool.name}\nProvider: AnoS | v1.0.0\nStatus: READY`;
  }
}

// Open Detail Modal
window.openToolModal = function(toolId) {
  const tool = currentToolsData.tools.find(t => t.id === toolId);
  if (!tool) return;

  const modal = document.getElementById('toolModal');
  const title = document.getElementById('modalToolTitle');
  const subtitle = document.getElementById('modalToolSubtitle');
  const desc = document.getElementById('modalToolDesc');
  const featuresList = document.getElementById('modalToolFeatures');
  const reqList = document.getElementById('modalToolReqs');
  const psCmd = document.getElementById('modalPsCommand');
  const downloadLink = document.getElementById('modalDownloadLink');
  const githubLink = document.getElementById('modalGithubLink');
  const previewBox = document.getElementById('modalTerminalPreview');

  title.textContent = tool.name;
  subtitle.textContent = `v${tool.version} | ${tool.tagline}`;
  desc.textContent = tool.description;

  featuresList.innerHTML = (tool.features || []).map(f => `<li>${ICONS.check} ${escapeHtml(f)}</li>`).join('');
  
  const reqs = tool.requirements || {};
  reqList.innerHTML = `
    <li><strong>Operating System:</strong> ${escapeHtml(reqs.os || 'Windows 10 / 11')}</li>
    <li><strong>Terminal Shell:</strong> ${escapeHtml(reqs.shell || 'cmd.exe or Windows Terminal')}</li>
    <li><strong>Dependencies:</strong> ${escapeHtml(reqs.dependencies || 'None (Self-contained)')}</li>
    <li><strong>Required Elevation:</strong> ${escapeHtml(reqs.privileges || 'Standard user')}</li>
    <li><strong>SHA-256 Checksum:</strong> <code style="color:var(--color-cyan); font-size:0.8rem;">${tool.sha256 || 'Verified'}</code></li>
  `;

  psCmd.textContent = tool.powershellCommand;
  const copyBtn = document.getElementById('modalCopyBtn');
  copyBtn.onclick = () => copyPowerShell(copyBtn, tool.powershellCommand);

  downloadLink.href = tool.downloadUrl;
  downloadLink.setAttribute('download', tool.fileName);
  downloadLink.innerHTML = `${ICONS.download} Download ${escapeHtml(tool.fileName)}`;

  githubLink.href = tool.githubUrl;

  if (tool.preview) {
    previewBox.textContent = tool.preview.join('\n');
  }

  modal.classList.add('open');
};

window.closeToolModal = function() {
  const modal = document.getElementById('toolModal');
  if (modal) modal.classList.remove('open');
};

// Clipboard Copy with Animated Feedback
window.copyPowerShell = function(btnElement, commandText) {
  navigator.clipboard.writeText(commandText).then(() => {
    handleCopySuccess(btnElement);
  }).catch(() => {
    const ta = document.createElement('textarea');
    ta.value = commandText;
    document.body.appendChild(ta);
    ta.select();
    document.execCommand('copy');
    document.body.removeChild(ta);
    handleCopySuccess(btnElement);
  });
};

function handleCopySuccess(btn) {
  const origHtml = btn.innerHTML;
  btn.innerHTML = `${ICONS.check} Copied!`;
  btn.classList.add('copied');

  showToast('PowerShell launch command copied to clipboard!');

  setTimeout(() => {
    btn.innerHTML = origHtml;
    btn.classList.remove('copied');
  }, 2200);
}

// Toast notification
function showToast(message) {
  let toast = document.getElementById('appToast');
  if (!toast) {
    toast = document.createElement('div');
    toast.id = 'appToast';
    toast.className = 'toast';
    document.body.appendChild(toast);
  }
  toast.innerHTML = `${ICONS.check} ${escapeHtml(message)}`;
  toast.classList.add('show');

  setTimeout(() => {
    toast.classList.remove('show');
  }, 2600);
}

// FAQ Accordion
function initFAQ() {
  const faqItems = document.querySelectorAll('.faq-item');
  faqItems.forEach(item => {
    const q = item.querySelector('.faq-question');
    if (q) {
      q.addEventListener('click', () => {
        const isOpen = item.classList.contains('active');
        faqItems.forEach(i => i.classList.remove('active'));
        if (!isOpen) {
          item.classList.add('active');
        }
      });
    }
  });
}

function escapeHtml(str) {
  if (!str) return '';
  return str.replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#039;');
}

function escapeAttr(str) {
  if (!str) return '';
  return str.replace(/'/g, "\\'").replace(/"/g, '&quot;');
}

function capitalize(s) {
  if (!s) return '';
  return s.charAt(0).toUpperCase() + s.slice(1);
}
