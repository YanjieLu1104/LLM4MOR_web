const searchControls = document.getElementById('report-search');
const search = document.getElementById('report-query');
const count = document.getElementById('report-count');
const catalog = document.getElementById('report-catalog');
const empty = document.getElementById('reports-empty');
const pagination = document.getElementById('report-pagination');
const previous = document.getElementById('report-previous');
const next = document.getElementById('report-next');
const pageNumbers = document.getElementById('report-page-numbers');
const pageLabel = document.getElementById('report-page-label');
const entries = Array.from(catalog.children, (row) => ({
  row,
  name: row.querySelector('.report-name').textContent.toLowerCase(),
}));
const pageSize = 20;
let page = 1;
let matches = entries;

function renderPageNumbers(totalPages) {
  const firstNearby = Math.max(1, Math.min(page - 1, totalPages - 2));
  const visiblePages = new Set([1, totalPages]);
  for (let number = firstNearby; number <= Math.min(firstNearby + 2, totalPages); number++) {
    visiblePages.add(number);
  }

  const controls = [];
  let last = 0;
  for (const number of [...visiblePages].sort((a, b) => a - b)) {
    if (number - last > 1) {
      const gap = document.createElement('span');
      gap.className = 'report-page-gap';
      gap.textContent = '…';
      gap.setAttribute('aria-hidden', 'true');
      controls.push(gap);
    }

    const button = document.createElement('button');
    button.type = 'button';
    button.textContent = number;
    button.setAttribute('aria-label', `Page ${number}`);
    button.setAttribute('aria-controls', 'report-catalog');
    if (number === page) {
      button.setAttribute('aria-current', 'page');
    }
    button.addEventListener('click', () => goToPage(number));
    controls.push(button);
    last = number;
  }
  pageNumbers.replaceChildren(...controls);
}

function renderReports() {
  const totalPages = Math.ceil(matches.length / pageSize);
  const start = (page - 1) * pageSize;
  const end = Math.min(start + pageSize, matches.length);
  const visible = new Set(matches.slice(start, end));
  for (const entry of entries) {
    entry.row.hidden = !visible.has(entry);
  }

  catalog.hidden = matches.length === 0;
  empty.hidden = matches.length > 0;
  count.textContent = matches.length
    ? `${start + 1}–${end} of ${matches.length} ${matches.length === 1 ? 'model' : 'models'}`
    : '0 models';
  pagination.hidden = totalPages < 2;
  previous.disabled = page === 1;
  next.disabled = page >= totalPages;
  if (totalPages > 1) {
    pageLabel.textContent = `Page ${page} of ${totalPages}`;
    renderPageNumbers(totalPages);
  }
}

function goToPage(number) {
  if (number === page) return;
  page = number;
  renderReports();
  catalog.focus({ preventScroll: true });
  catalog.scrollIntoView({ block: 'start' });
}

function filterReports() {
  const query = search.value.trim().toLowerCase();
  matches = entries.filter(({ name }) => name.includes(query));
  page = 1;
  renderReports();
}

search.addEventListener('input', filterReports);
previous.addEventListener('click', () => goToPage(page - 1));
next.addEventListener('click', () => goToPage(page + 1));
searchControls.hidden = false;
filterReports();
