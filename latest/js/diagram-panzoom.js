(function () {
  const DIAGRAM_SELECTOR = 'img[src*="/assets/diagrams/"], img[src*="assets/diagrams/"]';
  const MERMAID_SELECTOR = '.mermaid svg';
  const MAX_SCALE = 6;
  const MIN_SCALE = 0.2;
  let overlay;
  let overlayBound = false;

  function clamp(value, min, max) {
    return Math.min(max, Math.max(min, value));
  }

  function createOverlay() {
    const existing = document.getElementById('diagram-zoom-overlay');
    if (existing) {
      return existing;
    }
    const overlay = document.createElement('div');
    overlay.id = 'diagram-zoom-overlay';
    overlay.setAttribute('role', 'dialog');
    overlay.setAttribute('aria-modal', 'true');
    overlay.innerHTML = [
      '<div class="diagram-zoom-backdrop"></div>',
      '<div class="diagram-zoom-container">',
      '  <button class="diagram-zoom-close" aria-label="Close diagram">×</button>',
      '  <img class="diagram-zoom-image" alt="">',
      '</div>'
    ].join('');
    document.body.appendChild(overlay);
    return overlay;
  }

  function ensureOverlay() {
    if (!overlay) {
      overlay = createOverlay();
    }
    return overlay;
  }

  function bindOverlay() {
    if (overlayBound) return;
    const overlay = ensureOverlay();
    const backdrop = overlay.querySelector('.diagram-zoom-backdrop');
    const container = overlay.querySelector('.diagram-zoom-container');
    const closeBtn = overlay.querySelector('.diagram-zoom-close');
    const zoomImg = overlay.querySelector('.diagram-zoom-image');

    let scale = 1;
    let translateX = 0;
    let translateY = 0;
    let panning = false;
    let startX = 0;
    let startY = 0;

    function applyTransform() {
      zoomImg.style.transform = 'translate(' + translateX + 'px, ' + translateY + 'px) scale(' + scale + ')';
    }

    function resetTransform() {
      scale = 1;
      translateX = 0;
      translateY = 0;
      zoomImg.style.transformOrigin = '0 0';
      applyTransform();
    }

    function openOverlay(img) {
      zoomImg.src = img.src;
      zoomImg.alt = img.alt || 'Diagram';
      zoomImg.setAttribute('draggable', 'false');
      resetTransform();
      overlay.classList.add('is-visible');
      document.body.classList.add('diagram-zoom-open');
    }

    function openOverlaySvg(svg) {
      const serializer = new XMLSerializer();
      const svgString = serializer.serializeToString(svg);
      const encoded = encodeURIComponent(svgString);
      zoomImg.src = 'data:image/svg+xml;charset=utf-8,' + encoded;
      const title = svg.querySelector('title');
      zoomImg.alt = svg.getAttribute('aria-label') || (title ? title.textContent : 'Diagram');
      zoomImg.setAttribute('draggable', 'false');
      resetTransform();
      overlay.classList.add('is-visible');
      document.body.classList.add('diagram-zoom-open');
    }

    function closeOverlay() {
      overlay.classList.remove('is-visible');
      document.body.classList.remove('diagram-zoom-open');
    }

    function onWheel(event) {
      event.preventDefault();
      const zoomFactor = event.deltaY < 0 ? 1.1 : 0.9;
      scale = clamp(scale * zoomFactor, MIN_SCALE, MAX_SCALE);
      applyTransform();
    }

    function onPointerDown(event) {
      panning = true;
      startX = event.clientX - translateX;
      startY = event.clientY - translateY;
      zoomImg.setPointerCapture(event.pointerId);
      zoomImg.classList.add('is-panning');
    }

    function onPointerMove(event) {
      if (!panning) return;
      translateX = event.clientX - startX;
      translateY = event.clientY - startY;
      applyTransform();
    }

    function onPointerUp(event) {
      if (!panning) return;
      panning = false;
      zoomImg.releasePointerCapture(event.pointerId);
      zoomImg.classList.remove('is-panning');
    }

    closeBtn.addEventListener('click', closeOverlay);
    backdrop.addEventListener('click', closeOverlay);
    overlay.addEventListener('wheel', onWheel, { passive: false });
    zoomImg.addEventListener('pointerdown', onPointerDown);
    zoomImg.addEventListener('pointermove', onPointerMove);
    zoomImg.addEventListener('pointerup', onPointerUp);
    zoomImg.addEventListener('pointercancel', onPointerUp);

    document.addEventListener('keydown', function (event) {
      if (event.key === 'Escape') {
        closeOverlay();
      }
    });

    overlayBound = true;
    return {
      openOverlay: openOverlay,
      openOverlaySvg: openOverlaySvg,
    };
  }

  function bindDiagrams(root) {
    const overlayApi = bindOverlay();
    root.querySelectorAll(DIAGRAM_SELECTOR).forEach(function (img) {
      if (img.dataset.diagramZoomBound === 'true') return;
      img.dataset.diagramZoomBound = 'true';
      img.classList.add('diagram-zoomable');
      img.addEventListener('click', function (event) {
        const link = img.closest('a');
        if (link) {
          event.preventDefault();
        }
        overlayApi.openOverlay(img);
      });
    });

    root.querySelectorAll(MERMAID_SELECTOR).forEach(function (svg) {
      if (svg.dataset.diagramZoomBound === 'true') return;
      svg.dataset.diagramZoomBound = 'true';
      svg.classList.add('diagram-zoomable');
      svg.style.cursor = 'zoom-in';
      svg.addEventListener('click', function (event) {
        const link = svg.closest('a');
        if (link) {
          event.preventDefault();
        }
        overlayApi.openOverlaySvg(svg);
      });
    });
  }

  function init(root) {
    bindDiagrams(root || document);
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', function () {
      init(document);
    });
  } else {
    init(document);
  }

  if (window.document$ && typeof window.document$.subscribe === 'function') {
    window.document$.subscribe(function () {
      init(document);
    });
  }
})();
