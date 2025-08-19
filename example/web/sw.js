// Enhanced service worker for flutter_rough web app
// Implements intelligent caching strategies for optimal performance

const CACHE_NAME = 'flutter-rough-v2';
const DYNAMIC_CACHE = 'flutter-rough-dynamic-v2';

// Resources to cache immediately
const STATIC_CACHE_URLS = [
  '/',
  '/main.dart.js',
  '/flutter.js',
  '/flutter_bootstrap.js',
  '/manifest.json',
  '/assets/FontManifest.json',
  '/assets/AssetManifest.json',
  '/canvaskit/canvaskit.js',
  '/canvaskit/canvaskit.wasm',
  '/canvaskit/chromium/canvaskit.js',
  '/canvaskit/chromium/canvaskit.wasm',
];

// Resources that can be cached dynamically
const DYNAMIC_CACHE_PATTERNS = [
  /\/assets\//,
  /\/icons\//,
  /\.js$/,
  /\.wasm$/,
  /\.json$/,
];

// Resources that should never be cached
const NO_CACHE_PATTERNS = [
  /\/api\//,
  /sockjs/,
  /hot-reload/,
];

self.addEventListener('install', (event) => {
  console.log('Service Worker: Installing flutter_rough SW v2');
  
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then((cache) => {
        console.log('Service Worker: Caching static assets');
        return cache.addAll(STATIC_CACHE_URLS.map(url => new Request(url, {
          credentials: 'same-origin'
        })));
      })
      .catch((error) => {
        console.error('Service Worker: Failed to cache static assets:', error);
      })
  );
});

self.addEventListener('activate', (event) => {
  console.log('Service Worker: Activating flutter_rough SW v2');
  
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames
          .filter(cacheName => {
            return cacheName.startsWith('flutter-rough-') && 
                   cacheName !== CACHE_NAME &&
                   cacheName !== DYNAMIC_CACHE;
          })
          .map(cacheName => {
            console.log('Service Worker: Removing old cache:', cacheName);
            return caches.delete(cacheName);
          })
      );
    })
  );
});

self.addEventListener('fetch', (event) => {
  const request = event.request;
  const url = new URL(request.url);
  
  // Skip caching for certain patterns
  if (NO_CACHE_PATTERNS.some(pattern => pattern.test(url.pathname))) {
    return;
  }
  
  // Handle different types of requests
  if (request.method === 'GET') {
    event.respondWith(
      handleGetRequest(request)
    );
  }
});

async function handleGetRequest(request) {
  const url = new URL(request.url);
  
  try {
    // Try cache first (cache-first strategy for static assets)
    if (isStaticAsset(url.pathname)) {
      return await cacheFirstStrategy(request);
    }
    
    // Network first for dynamic content
    if (isDynamicAsset(url.pathname)) {
      return await networkFirstStrategy(request);
    }
    
    // Default to cache first for everything else
    return await cacheFirstStrategy(request);
    
  } catch (error) {
    console.error('Service Worker: Fetch error:', error);
    
    // Try to serve from cache as fallback
    const cachedResponse = await caches.match(request);
    if (cachedResponse) {
      return cachedResponse;
    }
    
    // Return offline page or error response
    return new Response('Offline - flutter_rough app not available', {
      status: 503,
      statusText: 'Service Unavailable',
      headers: new Headers({
        'Content-Type': 'text/plain',
      }),
    });
  }
}

async function cacheFirstStrategy(request) {
  // Check cache first
  const cachedResponse = await caches.match(request);
  if (cachedResponse) {
    // Update cache in background if it's stale (older than 1 hour)
    const cacheDate = new Date(cachedResponse.headers.get('date') || 0);
    const now = new Date();
    const staleThreshold = 60 * 60 * 1000; // 1 hour
    
    if (now - cacheDate > staleThreshold) {
      updateCacheInBackground(request);
    }
    
    return cachedResponse;
  }
  
  // Not in cache, fetch from network
  const networkResponse = await fetch(request);
  
  // Cache successful responses
  if (networkResponse.ok) {
    const cache = await caches.open(CACHE_NAME);
    cache.put(request, networkResponse.clone());
  }
  
  return networkResponse;
}

async function networkFirstStrategy(request) {
  try {
    // Try network first
    const networkResponse = await fetch(request);
    
    if (networkResponse.ok) {
      // Cache successful responses
      const cache = await caches.open(DYNAMIC_CACHE);
      cache.put(request, networkResponse.clone());
    }
    
    return networkResponse;
  } catch (error) {
    // Network failed, try cache
    const cachedResponse = await caches.match(request);
    if (cachedResponse) {
      return cachedResponse;
    }
    
    throw error;
  }
}

function updateCacheInBackground(request) {
  // Update cache in background without blocking the response
  fetch(request)
    .then(response => {
      if (response.ok) {
        return caches.open(CACHE_NAME).then(cache => {
          cache.put(request, response);
        });
      }
    })
    .catch(error => {
      console.log('Background cache update failed:', error);
    });
}

function isStaticAsset(pathname) {
  return STATIC_CACHE_URLS.includes(pathname) ||
         pathname.includes('/canvaskit/') ||
         pathname.endsWith('.js') ||
         pathname.endsWith('.wasm');
}

function isDynamicAsset(pathname) {
  return DYNAMIC_CACHE_PATTERNS.some(pattern => pattern.test(pathname));
}

// Handle service worker messages
self.addEventListener('message', (event) => {
  if (event.data && event.data.type) {
    switch (event.data.type) {
      case 'CACHE_STATS':
        getCacheStats().then(stats => {
          event.ports[0].postMessage({
            type: 'CACHE_STATS_RESPONSE',
            data: stats
          });
        });
        break;
        
      case 'CLEAR_CACHE':
        clearAllCaches().then(() => {
          event.ports[0].postMessage({
            type: 'CACHE_CLEARED'
          });
        });
        break;
        
      case 'PRELOAD_RESOURCES':
        preloadResources(event.data.urls).then(() => {
          event.ports[0].postMessage({
            type: 'RESOURCES_PRELOADED'
          });
        });
        break;
    }
  }
});

async function getCacheStats() {
  const cacheNames = await caches.keys();
  const stats = {};
  
  for (const cacheName of cacheNames) {
    const cache = await caches.open(cacheName);
    const keys = await cache.keys();
    stats[cacheName] = {
      count: keys.length,
      urls: keys.map(req => req.url)
    };
  }
  
  return stats;
}

async function clearAllCaches() {
  const cacheNames = await caches.keys();
  return Promise.all(
    cacheNames.map(cacheName => caches.delete(cacheName))
  );
}

async function preloadResources(urls) {
  const cache = await caches.open(CACHE_NAME);
  return Promise.all(
    urls.map(async (url) => {
      try {
        const response = await fetch(url);
        if (response.ok) {
          await cache.put(url, response);
        }
      } catch (error) {
        console.log('Failed to preload:', url, error);
      }
    })
  );
}

console.log('Service Worker: flutter_rough SW v2 loaded');