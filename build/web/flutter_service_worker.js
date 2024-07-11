'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "3f5c20164100b07254d86c831bac9754",
"assets/AssetManifest.bin.json": "f84507aae627eb3f0f0a709fbe939f58",
"assets/AssetManifest.json": "da89a06ec07784d83c71a83f6ce20d5e",
"assets/assets/icons/home/2.0x/home_icon.png": "6812649c309a51527f97ef55272ff1ce",
"assets/assets/icons/home/2.0x/inProgress.png": "1b55d870b504eb608466303bc8c04534",
"assets/assets/icons/home/2.0x/progress.png": "e46e41f4871663765978154477802118",
"assets/assets/icons/home/2.0x/settings_icon.png": "cb7cefbf8c5252bda6afc5017fc01ffa",
"assets/assets/icons/home/2.0x/time.png": "59b688618f9fb1ee883e02a8708f3ca6",
"assets/assets/icons/home/2.0x/workouts_icon.png": "9d88cc29ad4928ee5f0c76ecc6284691",
"assets/assets/icons/home/3.0x/home_icon.png": "ae73f1cf5b726a239cee275b62cc272a",
"assets/assets/icons/home/3.0x/inProgress.png": "058dbed33e7cf4eba16e12dc53c4a588",
"assets/assets/icons/home/3.0x/progress.png": "d0db2f6e99d4e9c554f13a4a496d7fe6",
"assets/assets/icons/home/3.0x/settings_icon.png": "39c0ae9050671b32b5302faf78576c0b",
"assets/assets/icons/home/3.0x/time.png": "966752a5b099a5790866edb65ae0b6da",
"assets/assets/icons/home/3.0x/workouts_icon.png": "feb4e8ab70657fc2f303c6afb637c8b6",
"assets/assets/icons/home/home_icon.png": "b9021c08a0547dafca119f7764c12d3b",
"assets/assets/icons/home/inProgress.png": "03fd5850788a92b32d7d7ed6a3e8a6a9",
"assets/assets/icons/home/progress.png": "19fe22baeac1bda1abac33e757aeb416",
"assets/assets/icons/home/settings_icon.png": "3bb53bdb31aee739f81dc93c75937298",
"assets/assets/icons/home/time.png": "b486e38de8aff1f49c126663f500dbcc",
"assets/assets/icons/home/workouts_icon.png": "18981687c530f60ead3d44c94e596b21",
"assets/assets/icons/social_networks/2.0x/facebook.png": "426caa400f5455fc132aa20e38dc68e6",
"assets/assets/icons/social_networks/2.0x/instagram.png": "255dc31488d13512ff3616bd16126e28",
"assets/assets/icons/social_networks/2.0x/twitter.png": "62d37edad3eb41e13cd2f59b487324c1",
"assets/assets/icons/social_networks/3.0x/facebook.png": "284d783122d4095d474ec3b7a1718442",
"assets/assets/icons/social_networks/3.0x/instagram.png": "ffb02b2ced5fb54ff4089b51d159e01a",
"assets/assets/icons/social_networks/3.0x/twitter.png": "11149a6aae573bf84c7b5a17f72d6f73",
"assets/assets/icons/social_networks/facebook.png": "d63f4acc8b70f8f75ba2f499e6f061ce",
"assets/assets/icons/social_networks/instagram.png": "cb6566e0535b9c58673d1c540096ab98",
"assets/assets/icons/social_networks/twitter.png": "6c14ca04ef1a68661fd43dd44661af52",
"assets/assets/icons/workouts/2.0x/back.png": "bb82cbe9f303cb5929513097025b9432",
"assets/assets/icons/workouts/2.0x/exercise.png": "10b60826445a5f2a7f3fac6e11a31be0",
"assets/assets/icons/workouts/2.0x/full_body.png": "419d3470e8ef5f6a721fc89863f7a8d6",
"assets/assets/icons/workouts/2.0x/pilates.png": "8951115d6e632ae2a39a14b4e4c56188",
"assets/assets/icons/workouts/2.0x/rectangle.png": "e7f4d1f0dccdba90cc19f7b766d55832",
"assets/assets/icons/workouts/2.0x/stretching.png": "c5a60f567e668dc85fefe34399d05a95",
"assets/assets/icons/workouts/2.0x/yoga.png": "93f82715a7c5f9d40765eb48dd55fd1d",
"assets/assets/icons/workouts/3.0x/back.png": "55ee34cade0e0c0f2adbf3cc33f0b534",
"assets/assets/icons/workouts/3.0x/exercise.png": "18bb5107bb43fc00accad0562d7554da",
"assets/assets/icons/workouts/3.0x/full_body.png": "4f142f7377f203a59fbd00cd23efe619",
"assets/assets/icons/workouts/3.0x/pilates.png": "1f25fac266ed12ed37c0c09c9101b6e8",
"assets/assets/icons/workouts/3.0x/rectangle.png": "aa3442634289ed2e4782451340c04131",
"assets/assets/icons/workouts/3.0x/stretching.png": "641117ce9b91038ff6cfd4e3355edada",
"assets/assets/icons/workouts/3.0x/yoga.png": "675c921cbef84158e36d287643b18d0b",
"assets/assets/icons/workouts/back.png": "794ed6d6aa03fdbbcfa926d2f322a5ec",
"assets/assets/icons/workouts/exercise.png": "48993240a1d85bbad49c893c7e7d7724",
"assets/assets/icons/workouts/full_body.png": "320dd768acf81703fb94bd24f400b1bb",
"assets/assets/icons/workouts/pilates.png": "38302443fa6cb4939b21eaac2a96a155",
"assets/assets/icons/workouts/rectangle.png": "2ca601d5d7be3e3695cefb991a718e28",
"assets/assets/icons/workouts/stretching.png": "9e915c75b3bbd95ba8002c5c7658049a",
"assets/assets/icons/workouts/time.png": "0fccfd3c359666171a848b1f6e2bada6",
"assets/assets/icons/workouts/yoga.png": "6df38c97fc74962a41f2834569d6c777",
"assets/assets/images/auth/2.0x/eye_icon.png": "f8e414f52965e64e19dffca1db5cc138",
"assets/assets/images/auth/3.0x/eye_icon.png": "c19e7612c5fef90894bb2f828fdb9c95",
"assets/assets/images/auth/eye_icon.png": "4f1f3a6e3fc5d674b13b9d2444471b42",
"assets/assets/images/exercises/2.0x/recicling.png": "1dd3908946c3d41399152c9837c3e93c",
"assets/assets/images/exercises/3.0x/recicling.png": "b04c07d0653a1fe72dc43d971dfbd0de",
"assets/assets/images/exercises/recicling.png": "e85f504095b138f9493c4254197cd745",
"assets/assets/images/home/2.0x/arms.png": "51a2ef2d0c4d49943ec070c3b48c41e5",
"assets/assets/images/home/2.0x/cardio.png": "f1421ceefdb343647a552e9c874cb9f9",
"assets/assets/images/home/2.0x/finished.png": "f92b94313e0439bf6a1c4285fea0db41",
"assets/assets/images/home/3.0x/arms.png": "dec8861bcc1a6084119929697b5e4ba1",
"assets/assets/images/home/3.0x/cardio.png": "29e0c5464dce201e4471fb441d553858",
"assets/assets/images/home/3.0x/finished.png": "c770a2b10507a2a4279026e85e58ddcf",
"assets/assets/images/home/4.0x/cardio.png": "5386dd5e8ca4f61ab40fa06b14fc5f34",
"assets/assets/images/home/arms.png": "ff8728e3495ac93eac6ff18613a05ccd",
"assets/assets/images/home/cardio.png": "141d4c5a848e98404253d1ec17df1b9e",
"assets/assets/images/home/finished.png": "8a6cd8779c6ced97cca61513d696e41f",
"assets/assets/images/home/profile.png": "59d15ac2384f36e534aedde85a155ea2",
"assets/assets/images/ia/ectomorfa.webp": "cefd9f8f14b1d9d3122b1f805759d71f",
"assets/assets/images/ia/endomorfo.webp": "414e1eb4a07f9a3e1c272e93c20b2a74",
"assets/assets/images/ia/example1.jpg": "c7423c638a0e8a2837ce7e7679cb7231",
"assets/assets/images/ia/mesomorfica.webp": "73a14bf353df0b52cca6df5eb13818e8",
"assets/assets/images/onboarding/2.0x/onboarding.png": "1d19a2811f25912a628d7ad0289c5833",
"assets/assets/images/onboarding/2.0x/onboarding_2.png": "17e2c121de0853b02f6b9380be2190cc",
"assets/assets/images/onboarding/2.0x/onboarding_3.png": "bb10224b843367ec824df77ea3a79b1a",
"assets/assets/images/onboarding/3.0x/onboarding.png": "81a814ab5910a6d63fc026937bf5b084",
"assets/assets/images/onboarding/3.0x/onboarding_2.png": "bf4308bbba12a433eb43b32f14d8279f",
"assets/assets/images/onboarding/3.0x/onboarding_3.png": "d98e9fcbf18d4c8ca9d668507662cb6e",
"assets/assets/images/onboarding/onboarding.png": "d3e4b497fc1fc2576b91ed33144d71a4",
"assets/assets/images/onboarding/onboarding_2.png": "95ac123206396f22ebfd21300bf7f5e2",
"assets/assets/images/onboarding/onboarding_3.png": "59a73242f2254e6e7c4c51cc4b1fd6e5",
"assets/assets/videos/workouts/cow.mp4": "4db53655718e2623a341e03fc1d1533f",
"assets/assets/videos/workouts/reclining.mp4": "a7736127c8b3eba9fbf24ab303253dd6",
"assets/assets/videos/workouts/warriorII.mp4": "93ed5d687efca40821263f1778b8ac5f",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "f86b4b08086fb8d6d0926f29043316ba",
"assets/NOTICES": "63fc2de90d45d1364f9a1e5e78b163e4",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "391ff5f9f24097f4f6e4406690a06243",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.css": "5a8d0222407e388155d7d1395a75d5b9",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.html": "16911fcc170c8af1c5457940bd0bf055",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/youtube_player_flutter/assets/speedometer.webp": "50448630e948b5b3998ae5a5d112622b",
"assets/packages/youtube_player_iframe/assets/player.html": "ea69af402f26127fa4991b611d4f2596",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "738255d00768497e86aa4ca510cce1e1",
"canvaskit/canvaskit.js.symbols": "74a84c23f5ada42fe063514c587968c6",
"canvaskit/canvaskit.wasm": "9251bb81ae8464c4df3b072f84aa969b",
"canvaskit/chromium/canvaskit.js": "901bb9e28fac643b7da75ecfd3339f3f",
"canvaskit/chromium/canvaskit.js.symbols": "ee7e331f7f5bbf5ec937737542112372",
"canvaskit/chromium/canvaskit.wasm": "399e2344480862e2dfa26f12fa5891d7",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/skwasm.js.symbols": "c3c05bd50bdf59da8626bbe446ce65a3",
"canvaskit/skwasm.wasm": "4051bfc27ba29bf420d17aa0c3a98bce",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c",
"flutter_bootstrap.js": "d910cd07feacfefd33fc1460984d475b",
"gym_logo.png": "62b1d93fcd77973b32832dc7ffc8df7c",
"icons/Icon-192.png": "4b0d0c6c19a09766ba94f6c4e75bc3b1",
"icons/Icon-512.png": "8ef79b0129a9cdc05f62993d8cce42a3",
"icons/Icon-maskable-192.png": "c61487d81a9d12194d78ff8bb3c786a8",
"icons/Icon-maskable-512.png": "b9fa0404cea347adc907e051639dff78",
"index.html": "cd7b4a8084fb3d158ebef92ae94822de",
"/": "cd7b4a8084fb3d158ebef92ae94822de",
"main.dart.js": "0e1f1c554b3b1876e96c98fd36de978d",
"manifest.json": "1ee70ae3a1705fba9b289a1df0a615a9",
"version.json": "fd0b57130f85266e68e60a50fbd08008"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
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
        // Claim client to enable caching on first launch
        self.clients.claim();
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
      // Claim client to enable caching on first launch
      self.clients.claim();
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
