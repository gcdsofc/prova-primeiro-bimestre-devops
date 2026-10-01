const express = require('express');
const { Pool } = require('pg');

const app = express();
const PORT = Number(process.env.PORT || 3000);
const DATABASE_URL = process.env.DATABASE_URL;

const pool = DATABASE_URL ? new Pool({ connectionString: DATABASE_URL }) : null;

app.use(express.json());

function exigirBanco(req, res, next) {
  if (!pool) {
    return res.status(503).json({
      erro: 'banco_indisponivel',
      mensagem: 'DATABASE_URL nao configurada'
    });
  }

  return next();
}

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

function parseReservaId(id) {
  const reservaId = Number(id);
  return Number.isInteger(reservaId) && reservaId > 0 ? reservaId : null;
}

async function criarTabelaSeNaoExistir() {
  if (!pool) {
    return;
  }

  await pool.query(`
    CREATE TABLE IF NOT EXISTS reservas (
      id SERIAL PRIMARY KEY,
      cliente VARCHAR(120) NOT NULL,
      data DATE NOT NULL,
      status VARCHAR(30) NOT NULL
    );
  `);
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

app.get('/db-health', exigirBanco, async (req, res, next) => {
  try {
    const result = await pool.query('SELECT NOW() AS now;');

    return res.json({
      status: 'healthy',
      databaseTime: result.rows[0].now
    });
  } catch (error) {
    return next(error);
  }
});

app.post('/reservas', exigirBanco, async (req, res, next) => {
  try {
    const erroValidacao = validarReserva(req.body);

    if (erroValidacao) {
      return res.status(400).json({
        erro: 'payload_invalido',
        mensagem: erroValidacao
      });
    }

    const result = await pool.query(`
      INSERT INTO reservas (cliente, data, status)
      VALUES ($1, $2, $3)
      RETURNING id, cliente, data, status;
    `, [req.body.cliente, req.body.data, req.body.status]);

    return res.status(201).json(result.rows[0]);
  } catch (error) {
    return next(error);
  }
});

app.get('/reservas', exigirBanco, async (req, res, next) => {
  try {
    const result = await pool.query(`
      SELECT id, cliente, data, status
      FROM reservas
      ORDER BY id;
    `);

    return res.json({
      total: result.rows.length,
      reservas: result.rows
    });
  } catch (error) {
    return next(error);
  }
});

app.get('/reservas/:id', exigirBanco, async (req, res, next) => {
  try {
    const reservaId = parseReservaId(req.params.id);

    if (!reservaId) {
      return res.status(400).json({
        erro: 'id_invalido'
      });
    }

    const result = await pool.query(`
      SELECT id, cliente, data, status
      FROM reservas
      WHERE id = $1;
    `, [reservaId]);

    if (result.rows.length === 0) {
      return res.status(404).json({
        erro: 'reserva_nao_encontrada'
      });
    }

    return res.json(result.rows[0]);
  } catch (error) {
    return next(error);
  }
});

app.put('/reservas/:id', exigirBanco, async (req, res, next) => {
  try {
    const reservaId = parseReservaId(req.params.id);

    if (!reservaId) {
      return res.status(400).json({
        erro: 'id_invalido'
      });
    }

    const erroValidacao = validarReserva(req.body);

    if (erroValidacao) {
      return res.status(400).json({
        erro: 'payload_invalido',
        mensagem: erroValidacao
      });
    }

    const result = await pool.query(`
      UPDATE reservas
      SET cliente = $1, data = $2, status = $3
      WHERE id = $4
      RETURNING id, cliente, data, status;
    `, [req.body.cliente, req.body.data, req.body.status, reservaId]);

    if (result.rows.length === 0) {
      return res.status(404).json({
        erro: 'reserva_nao_encontrada'
      });
    }

    return res.json(result.rows[0]);
  } catch (error) {
    return next(error);
  }
});

app.delete('/reservas/:id', exigirBanco, async (req, res, next) => {
  try {
    const reservaId = parseReservaId(req.params.id);

    if (!reservaId) {
      return res.status(400).json({
        erro: 'id_invalido'
      });
    }

    const result = await pool.query(`
      DELETE FROM reservas
      WHERE id = $1
      RETURNING id;
    `, [reservaId]);

    if (result.rows.length === 0) {
      return res.status(404).json({
        erro: 'reserva_nao_encontrada'
      });
    }

    return res.json({
      status: 'removida',
      id: reservaId
    });
  } catch (error) {
    return next(error);
  }
});

app.use((req, res) => {
  return res.status(404).json({
    erro: 'rota_nao_encontrada'
  });
});

app.use((error, req, res, next) => {
  return res.status(500).json({
    erro: 'erro_interno',
    mensagem: error.message
  });
});

criarTabelaSeNaoExistir()
  .then(() => {
    app.listen(PORT, '0.0.0.0', () => {
      console.log(`API de Reservas rodando na porta ${PORT}`);
    });
  })
  .catch((error) => {
    console.error('Erro ao inicializar banco de dados:', error.message);
    process.exit(1);
  });