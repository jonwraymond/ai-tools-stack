(function () {
  const DIAGRAM_SELECTOR = 'img[src*="/assets/diagrams/"], img[src*="assets/diagrams/"]';
  const MAX_SCALE = 6;
  const MIN_SCALE = 0.2;

  function clamp(value, min, max) {
    return Math.min(max, Math.max(min, value));
  }

  function createOverlay() {
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

  function init() {
    const overlay = createOverlay();
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

    document.querySelectorAll(DIAGRAM_SELECTOR).forEach(function (img) {
      img.classList.add('diagram-zoomable');
      img.addEventListener('click', function (event) {
        const link = img.closest('a');
        if (link) {
          event.preventDefault();
        }
        openOverlay(img);
      });
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
