/**
 * AUTHOR: SUP2Ak#3755
 * DATE: 21/05/2023
 * VERSION: 1.0.0
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
const mapValue = (value, inputMin, inputMax, outputMin, outputMax) => {
  return (value - inputMin) * (outputMax - outputMin) / (inputMax - inputMin) + outputMin;
}

document.addEventListener("DOMContentLoaded", () => {
  
  // 1. Audio + Equalizer

  // Créer l'objet audio
  const audio = new Audio("./resistancia.mp3");
  audio.volume = 0.1;

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

      const hue = mapValue(average, 0, 255, 0, 360);
      const color = `hsl(${hue}, 100%, 50%)`;

      ctx.fillStyle = color;
      ctx.fillRect(x, y, barWidth, barHeight);
    }
  }

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

  // Promsie pour mettre le code en pause avant que l'animation commence (pour pas que l'animation bogue au début)
  const delay = (ms) => {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }
  
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
});
