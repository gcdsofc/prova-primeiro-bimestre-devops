const express = require('express');

const app = express();
const PORT = Number(process.env.PORT || 3000);

app.use(express.json());

app.get('/health', (req, res) => {
  return res.json({
    status: 'healthy',
    timestamp: new Date().toISOString()
  });
});

app.get('/', (req, res) => {
  return res.json({
    servico: 'API de Reservas',
    status: 'online'
  });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`API de Reservas rodando na porta ${PORT}`);
});
