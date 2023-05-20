// Fonction utilitaire pour mapper une valeur à une nouvelle plage de valeurs
const mapValue = (value, inputMin, inputMax, outputMin, outputMax) => {
  return (value - inputMin) * (outputMax - outputMin) / (inputMax - inputMin) + outputMin;
}

document.addEventListener("DOMContentLoaded", () => {
  const audio = new Audio("./mb14.mp3");
  audio.volume = 0.1;
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
  const barWidth = 10;
  const barSpacing = 4;
  const maxBarHeight = canvasHeight - 10;

  const numBars = 45;

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
});
