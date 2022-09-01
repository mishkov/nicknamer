'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "canvaskit/canvaskit.js": "2bc454a691c631b07a9307ac4ca47797",
"canvaskit/profiling/canvaskit.js": "38164e5a72bdad0faa4ce740c9b8e564",
"canvaskit/profiling/canvaskit.wasm": "95a45378b69e77af5ed2bc72b2209b94",
"canvaskit/canvaskit.wasm": "bf50631470eb967688cca13ee181af62",
"main.dart.js": "b30b10ffe40a0201548da1d793218687",
"assets/AssetManifest.json": "67128db410b85bd3f2cf9fa1e5f5f403",
"assets/fonts/MaterialIcons-Regular.otf": "95db9098c58fd6db106f1116bae85a0b",
"assets/shaders/ink_sparkle.frag": "face5c2f106eecf1dda786745c50b01f",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/NOTICES": "2bf27896baf5a9e06b16d28a2dc76148",
"assets/themes/black_theme_colors.json": "1cf13f2b7996d0ca7c943d397c3093e7",
"assets/themes/white_theme_colors.json": "49aeee09fbd4e6b30d625aa02a478337",
"assets/lang/en.json": "e0d5b8d44728d4d13ed107ea74ddd8b4",
"assets/lang/ru.json": "fcb93f1480c77315e4052d6191bc1466",
"flutter.js": "f85e6fb278b0fd20c349186fb46ae36d",
"index.html": "f4ce98e173c93b37ebbfe3047db9303b",
"/": "f4ce98e173c93b37ebbfe3047db9303b",
"favicon.png": "b552845e1603f4eaf3064e72e314a897",
"version.json": "29ef8529baa057d88547b375ff53562d",
"manifest.json": "b58fcfa7628c9205cb11a1b2c3e8f99a",
"icons/apple-icon-152x152.png": "3090da9b9a9a6b9a0f8a7706a844a0a3",
"icons/apple-icon-120x120.png": "a1de790ef95cc8c87a8640fd6d3bf1f0",
"icons/ms-icon-144x144.png": "cc18082dc2cd26a535d2f5e607f904f2",
"icons/favicon-16x16.png": "aeda6a50e96fc278bf0911774257d2ac",
"icons/apple-icon.png": "4f547626ccf7bf2694bc45d938e345f7",
"icons/ms-icon-70x70.png": "092701c3adb7b7ee5f126da08c566d4b",
"icons/favicon.ico": "60346d8cec01331fd7604624385ffd7a",
"icons/apple-icon-72x72.png": "113663c4d6dc16d4bb0d76dfa991f4eb",
"icons/apple-icon-60x60.png": "d78827cb1051fbcc31f31e8eca109168",
"icons/apple-icon-114x114.png": "d6138de56743e0261c3ad89aa0e5008f",
"icons/android-icon-48x48.png": "c1600da19e18bc01c13a9bdfb9808762",
"icons/apple-icon-144x144.png": "bdf68dc3e84241d4d01064b0ee3dcfea",
"icons/apple-icon-57x57.png": "4bc4fd26477889c93ddb475ec48e9167",
"icons/browserconfig.xml": "653d077300a12f09a69caeea7a8947f8",
"icons/favicon-96x96.png": "5aa4fbdf6bd5f692c9e20eb7ef35827d",
"icons/android-icon-36x36.png": "7f163877ece142f5c14d3a1e42630087",
"icons/ms-icon-310x310.png": "a4eed03b70548f1ee766734a51d3c039",
"icons/apple-icon-180x180.png": "581f581b2f373dd30f67e9b0b377a9f7",
"icons/favicon-32x32.png": "5912c644b55bfa94e72a7a20d6c436e8",
"icons/android-icon-144x144.png": "bdf68dc3e84241d4d01064b0ee3dcfea",
"icons/apple-icon-precomposed.png": "c4c3d785a5f82482ebc82a2a55177031",
"icons/android-icon-72x72.png": "113663c4d6dc16d4bb0d76dfa991f4eb",
"icons/apple-icon-76x76.png": "4bd5d8e4c17627bd9ade39911ce749e4",
"icons/ms-icon-150x150.png": "4e960e79f671e344e5c31220a5f2045c",
"icons/android-icon-96x96.png": "e989c17ab38f6acc0a11f26a2df93e5e",
"icons/android-icon-192x192.png": "6d24e005c09638582e461dec5f205524"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
