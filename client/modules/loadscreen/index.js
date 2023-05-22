/**
 * AUTHOR: SUP2Ak#3755
 * DATE: 21/05/2023
 * VERSION: 1.1.0 (Stable but not clean)
 * LICENSE: GNU V3
 * GITHUB: https://github.com/SUP2Ak
 * DISCORD: https://discord.com/invite/B6Z5VbA5wd
 * WEBSITE: https://sup2ak.github.io/
 * 
 * FAIT POUR: SUBLiME (https://github.com/SUBLiME-Association)
 * MADE FOR: SUBLiME (https://github.com/SUBLiME-Association)
 * 
 * Fait en collaboration avec: Wood#6472 pour la création des logos
 * Made in collaboration with: Wood#6472 for the logos creation
 * 
 * +: 
 *  -  FR: Le code est fait pour être le plus simple possible, il est donc possible de l'améliorer, n'est au moins il a été fait des cette façon et n'est pas inclue dans la partie `web` en React car il est plus simple de le faire en JS Vanilla & surtout que les gens qui utiliseront ce code ne sont pas forcément des développeurs à l'aise avec React & Typescript et aussi car en général les gens ont leur loadingscreen personnalisé pour eux donc plus simple a retirer un module.
 * 
 *  -  EN: The code is made to be as simple as possible, so it is possible to improve it, at least it was done in this way and is not included in the `web` part in React because it is easier to do it in JS Vanilla & especially that people who will use this code are not necessarily developers comfortable with React & Typescript and also because in general people have their own custom loadingscreen for them so easier to remove this module.
*/

// Fonction utilitaire pour mapper une valeur à une nouvelle plage de valeurs
/*const mapValue = (value, inputMin, inputMax, outputMin, outputMax) => {
  return (value - inputMin) * (outputMax - outputMin) / (inputMax - inputMin) + outputMin;
}*/

// Promsie pour mettre le code en pause avant que l'animation commence (pour pas quel'animation bogue au début)
const delay = (ms) => {
  return new Promise((resolve) => setTimeout(resolve, ms));
}
// #12b886, #82c91e
const getColor = (average) => {
  const color1 = [130, 201, 30];;
  const color2 = [18, 184, 134];

  const t = average / 255;

  const r = Math.round((1 - t) * color1[0] + t * color2[0]);
  const g = Math.round((1 - t) * color1[1] + t * color2[1]);
  const b = Math.round((1 - t) * color1[2] + t * color2[2]);

  return `rgb(${r}, ${g}, ${b})`;
};

let turnOff = false;

document.addEventListener("DOMContentLoaded", () => {

  // 1. Audio + Equalizer
  // Créer l'objet audio
  const audio = new Audio("./resistancia.mp3");
  audio.volume = 0.1;

  const playButton = document.getElementById('playButton');

  playButton.addEventListener('click', () => {
    if (audio.paused) {
      audio.play();
      playButton.innerHTML = '<i class="fas fa-pause"></i>'; // Icône de pause
    } else {
      audio.pause();
      playButton.innerHTML = '<i class="fas fa-play"></i>'; // Icône de lecture
    }
  });

  const volumeSlider = document.getElementById('volumeSlider');

  volumeSlider.addEventListener('input', () => {
    const volume = volumeSlider.value / 100; // Convertir la valeur en pourcentage en décimale
    audio.volume = volume;
  });

  // Créer le canvas
  const canvas = document.getElementById('equalizerCanvas');
  const ctx = canvas.getContext('2d');

  // Créer le contexte audio
  const audioContext = new (window.AudioContext || window.webkitAudioContext)();
  const source = audioContext.createMediaElementSource(audio);

  // Créer l'analyseur audio
  const analyser = audioContext.createAnalyser();
  analyser.fftSize = 256;
  const bufferLength = analyser.frequencyBinCount;
  const dataArray = new Uint8Array(bufferLength);

  // Connecter l'analyseur audio à la source audio
  source.connect(analyser);
  analyser.connect(audioContext.destination);

  // Configuration le canvas
  const canvasWidth = canvas.width;
  const canvasHeight = canvas.height;
  const barWidth = 2;
  const barSpacing = 4;
  const maxBarHeight = canvasHeight - 100;

  const numBars = 45;

  // Fonction pour mettre à jour l'equalizer (animation, partie casse couille)
  const updateEqualizer = () => {
    requestAnimationFrame(updateEqualizer);

    analyser.getByteFrequencyData(dataArray);

    ctx.clearRect(0, 0, canvasWidth, canvasHeight);

    const binSize = Math.floor(bufferLength / numBars);

    for (let i = 0; i < numBars; i++) {
      let sum = 0;
      for (let j = 0; j < binSize; j++) {
        sum += dataArray[i * binSize + j];
      }
      const average = sum / binSize;
      const barHeight = (average / 255) * maxBarHeight;

      const x = (barWidth + barSpacing) * i;
      const y = canvasHeight - barHeight;

      const gradient = ctx.createLinearGradient(x, y, x, y + barHeight);
      gradient.addColorStop(0, getColor(average));
      gradient.addColorStop(1, getColor(average));

      ctx.fillStyle = gradient;
      ctx.fillRect(x, y, barWidth, barHeight);
    }
  };

  // Lancé l'animation + Musique synchronisée
  audio.play();
  updateEqualizer(); 

  // 2. Images
  
  const im1 = document.getElementById('im1');
  const im2 = document.getElementById('im2');

  // Invisible au début (avant animation)
  im1.style.visibility = 'hidden';
  im2.style.visibility = 'hidden';

  // Animation des images (loop rotation)
  const animateImages = () => {
    setTimeout(() => {
      im2.style.animation = 'rotate 2.0s';
      im1.style.animation = 'rotate 2.0s';
    }, 1000);
  };
  
  // Délai asynchrone avant l'animation
  async function getImages() {
    await delay(2350);
  }
  
  // Lancer l'animation une fois le delais passé
  getImages()
    .then(() => {
      // Afficher les images
      im1.style.visibility = 'visible';
      im2.style.visibility = 'visible';

      // Centrer les images (Il faut forcer)
      im1.style.top = '50%';
      im1.style.left = '50%';
      im2.style.top = '50%';
      im2.style.left = '50%';
  
      // Lancer l'animation de départ
      im1.style.animation = 'slide-in-top 2.0s';
      im2.style.animation = 'slide-in-bottom 2.0s';
      im1.style.transform = 'translate(-50%, -50%)';
      im2.style.transform = 'translate(-50%, -50%)';
  
      // Lancer l'animation (Rotation loop)
      setInterval(() => {
        if (turnOff) return;
        // Reset l'animation
        im2.style.animation = '';
        im1.style.animation = '';

        // Forcer le centrage
        im1.style.transform = 'translate(-50%, -50%)';
        im2.style.transform = 'translate(-50%, -50%)';

        // Lancer l'animation (Rotation loop)
        animateImages();
      }, 3000);
    })
  .catch((error) => {
    console.error(error); // Afficher les erreurs même si il y en a âs :eyes:
  });
  const bg = document.getElementById('bg');
  const soundBloc = document.getElementById('soundBlocs');
  window.addEventListener('message', (e) => {
    // This is the shutdown message that is sent by client script
    if (e.data.fullyLoaded) {
      console.log('fullyLoaded');
      bg.style.animation = 'slide-out-bottom 2.0s';
      setTimeout(() => {
        bg.style.display = 'none';
      }, 2000);
    } 
    if (e.data.loginOpen) {
      console.log('loginOpen');
      soundBloc.style.animation = 'fadeOut 2.0s';
      setTimeout(() => {
        soundBloc.style.display = 'none';
        audio.pause();
      }, 2000);
    }
  })
});