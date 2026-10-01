const express = require('express');

const app = express();
const PORT = Number(process.env.PORT || 3000);

app.use(express.json());

let nextId = 1;
const reservas = [];

function validarReserva(payload) {
  const camposObrigatorios = ['cliente', 'data', 'status'];
  const camposFaltando = camposObrigatorios.filter((campo) => !payload[campo]);

  if (camposFaltando.length > 0) {
    return `Campos obrigatorios ausentes: ${camposFaltando.join(', ')}`;
  }

  if (Number.isNaN(Date.parse(payload.data))) {
    return 'Campo data deve ser uma data valida';
  }

  return null;
}

app.get('/', (req, res) => {
  return res.json({
    servico: 'API de Reservas',
    status: 'online'
  });
});

app.get('/health', (req, res) => {
  return res.json({
    status: 'healthy',
    timestamp: new Date().toISOString()
  });
});

app.post('/reservas', (req, res) => {
  const erroValidacao = validarReserva(req.body);

  if (erroValidacao) {
    return res.status(400).json({
      erro: 'payload_invalido',
      mensagem: erroValidacao
    });
  }

  const reserva = {
    id: nextId,
    cliente: req.body.cliente,
    data: req.body.data,
    status: req.body.status
  };

  nextId += 1;
  reservas.push(reserva);

  return res.status(201).json(reserva);
});

app.get('/reservas', (req, res) => {
  return res.json({
    total: reservas.length,
    reservas
  });
});

app.get('/reservas/:id', (req, res) => {
  const id = Number(req.params.id);
  const reserva = reservas.find((item) => item.id === id);

  if (!reserva) {
    return res.status(404).json({
      erro: 'reserva_nao_encontrada'
    });
  }

  return res.json(reserva);
});

app.put('/reservas/:id', (req, res) => {
  const id = Number(req.params.id);
  const reserva = reservas.find((item) => item.id === id);

  if (!reserva) {
    return res.status(404).json({
      erro: 'reserva_nao_encontrada'
    });
  }

  const erroValidacao = validarReserva(req.body);

  if (erroValidacao) {
    return res.status(400).json({
      erro: 'payload_invalido',
      mensagem: erroValidacao
    });
  }

  reserva.cliente = req.body.cliente;
  reserva.data = req.body.data;
  reserva.status = req.body.status;

  return res.json(reserva);
});

app.delete('/reservas/:id', (req, res) => {
  const id = Number(req.params.id);
  const index = reservas.findIndex((item) => item.id === id);

  if (index === -1) {
    return res.status(404).json({
      erro: 'reserva_nao_encontrada'
    });
  }

  reservas.splice(index, 1);

  return res.json({
    status: 'removida',
    id
  });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`API de Reservas rodando na porta ${PORT}`);
});