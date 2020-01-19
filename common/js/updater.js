// let newWorker;

// if (navigator.serviceWorker) {
//   navigator.serviceWorker.register('/sw.js', {scope: '/'}).then(reg => {
//     reg.addEventListener('updatefound', () => {
//       newWorker = reg.installing;
//       newWorker.addEventListener('statechange', () => {
//         if (newWorker.state == 'installed') {
//           newWorker.postMessage({ action: 'skipWaiting' });
//         }
//       })
//     })
//   })
//   navigator.serviceWorker.onmessage = (event) => {
//     if(event.data.action == 'reload'){
//       caches.keys().then(function(names) {
//           for (let name of names)
//               caches.delete(name);
//       });
//       window.location.reload();
//     }
//   }
// }